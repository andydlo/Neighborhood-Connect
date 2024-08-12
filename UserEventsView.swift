//
//  UserEventsView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct UserEventsView: View {
    @State private var signedUpEvents: [Event] = []
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            List(signedUpEvents) { event in
                // Create a row for each signed-up event with an unsubscribe action
                EventRow(event: event, onUnsubscribe: {
                    unsubscribeFromEvent(event)
                })
            }
            .onAppear(perform: fetchSignedUpEvents) // Fetch signed-up events when the view appears
            .navigationTitle("My Events")
        }
    }

    // Function to fetch events the user is signed up for
    private func fetchSignedUpEvents() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            errorMessage = "Unable to get current user email." // Error message if email is not available
            return
        }

        let ref = Database.database().reference().child("events") // Reference to the "events" node in Firebase
        ref.observe(.value) { snapshot in
            var newEvents: [Event] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let event = Event(snapshot: snapshot) {
                    if event.attendees.contains(currentUserEmail) {
                        newEvents.append(event) // Add the event if the user is an attendee
                    }
                }
            }
            self.signedUpEvents = newEvents // Update the state with the fetched events
        }
    }

    // Function to unsubscribe from a specific event
    private func unsubscribeFromEvent(_ event: Event) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            errorMessage = "Unable to get current user email." // Error message if email is not available
            return
        }

        let ref = Database.database().reference().child("events").child(event.id).child("attendees") // Reference to the event's attendees in Firebase
        ref.observeSingleEvent(of: .value) { snapshot in
            var attendees = event.attendees
            if let index = attendees.firstIndex(of: currentUserEmail) {
                attendees.remove(at: index) // Remove the current user's email from the list of attendees
                ref.setValue(attendees) { error, _ in
                    if let error = error {
                        errorMessage = error.localizedDescription // Set error message if there is an error
                    } else {
                        errorMessage = "Successfully unsubscribed from the event!"
                        fetchSignedUpEvents() // Refresh the list of signed-up events
                    }
                }
            } else {
                errorMessage = "You are not signed up for this event." // Error message if the user is not signed up
            }
        }
    }
}

struct EventRow: View {
    var event: Event
    var onUnsubscribe: () -> Void // Closure to handle unsubscribe action

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
                // Button to unsubscribe from the event
                Button(action: onUnsubscribe) {
                    Text("Unsubscribe")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle()) // Ensure the button does not expand its touch area

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
        .padding(.vertical, 5)
    }
}

struct UserEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UserEventsView() 
    }
}
