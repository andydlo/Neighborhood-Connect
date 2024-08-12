//
//  SignUpForEventView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct SignUpForEventView: View {
    @State private var availableEvents: [Event] = []
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            List(availableEvents) { event in
                // Create a row for each event with a sign-up action
                EventRow2(event: event, onSignUp: {
                    signUpForEvent(event)
                })
            }
            .onAppear(perform: fetchEvents) // Fetch events when the view appears
            .navigationTitle("Sign Up for Events")
        }
    }

    // Function to fetch events from Firebase
    private func fetchEvents() {
        let ref = Database.database().reference().child("events") // Reference to the "events" node in Firebase
        ref.observe(.value) { snapshot in
            var newEvents: [Event] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let event = Event(snapshot: snapshot) {
                    newEvents.append(event) // Add each event to the list
                }
            }
            self.availableEvents = newEvents // Update the state with the fetched events
        }
    }

    // Function to sign up for a specific event
    private func signUpForEvent(_ event: Event) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            errorMessage = "Unable to get current user email." // Error message if email is not available
            return
        }

        let ref = Database.database().reference().child("events").child(event.id).child("attendees") // Reference to the event's attendees in Firebase
        ref.observeSingleEvent(of: .value) { snapshot in
            var attendees = event.attendees
            if !attendees.contains(currentUserEmail) {
                attendees.append(currentUserEmail) // Add the current user's email to the list of attendees
                ref.setValue(attendees) { error, _ in
                    if let error = error {
                        errorMessage = error.localizedDescription // Set error message if there is an error
                    } else {
                        errorMessage = "Successfully signed up for the event!"
                        fetchEvents() // Refresh the list of events
                    }
                }
            } else {
                errorMessage = "You are already signed up for this event." // Error message if user is already signed up
            }
        }
    }
}

struct EventRow2: View {
    var event: Event
    var onSignUp: () -> Void // Closure to handle sign-up action

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name)
                .font(.headline) // Display event name
            Text("Type: \(event.type)")
                .font(.subheadline)
                .foregroundColor(.gray) // Display event type
            Text("Address: \(event.address)")
                .font(.subheadline)
                .foregroundColor(.gray) // Display event address
            Text("Attendees: \(event.attendees.count)")
                .font(.subheadline)
                .foregroundColor(.gray) // Display number of attendees

            HStack {
            // Display "Signed Up" text if the user is already signed up
                if event.attendees.contains(Auth.auth().currentUser?.email ?? "") {
                    Text("Signed Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mint)
                        .cornerRadius(10)
                } else {
                    // Button to sign up for the event
                    Button(action: onSignUp) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle()) // Ensure the button does not expand its touch area
                }

                // Navigation link to event details view
                NavigationLink(destination: EventDetailsView(event: event)) {
                    Text("Details")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle()) // Ensure the button does not expand its touch area
            }
        }
        .padding(.vertical, 5) // Vertical padding for the row
    }
}

struct SignUpForEventView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpForEventView()
    }
}
