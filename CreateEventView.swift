//
//  CreateEventView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct CreateEventView: View {
    @State private var eventName: String = ""
    @State private var selectedEventType: String = "Gathering"
    @State private var eventDescription: String = ""
    @State private var eventAddress: String = ""
    @State private var eventDate: Date = Date()
    @State private var errorMessage: String = ""

    let eventTypes = ["Gathering", "Sporting", "Party", "Workshop", "Concert"] // List of event types

    var body: some View {
        VStack {
            // Input field for event name
            TextField("Event Name", text: $eventName)
                .padding()
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .cornerRadius(10)
                .padding(.horizontal, 15)
            
            // Picker for selecting the event type
            Picker("Event Type", selection: $selectedEventType) {
                ForEach(eventTypes, id: \.self) {
                    Text($0)
                }
            }
            .padding()
            .background(Color(red: 0.93, green: 0.93, blue: 0.93))
            .cornerRadius(10)
            .padding(.horizontal, 15)
            
            // Input field for event description
            TextField("Event Description", text: $eventDescription)
                .padding()
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .cornerRadius(10)
                .padding(.horizontal, 15)
            
            // Input field for event address
            TextField("Event Address", text: $eventAddress)
                .padding()
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .cornerRadius(10)
                .padding(.horizontal, 15)
            
            // DatePicker for selecting the event date and time
            DatePicker("Event Date and Time", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                .padding()
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .cornerRadius(10)
                .padding(.horizontal, 15)
            
            // Button to create the event
            Button(action: {
                createEvent()
            }) {
                Text("Create Event")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
            }
            
            // Display error message if any
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Create Event")
    }

    // Function to create a new event
    private func createEvent() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            errorMessage = "Unable to get current user email." // Error if unable to get user email
            return
        }

        let ref = Database.database().reference().child("events").childByAutoId() // Reference to the Firebase database
        let event = Event(id: ref.key ?? UUID().uuidString, name: eventName, type: selectedEventType, description: eventDescription, address: eventAddress, date: eventDate, attendees: [currentUserEmail])
        ref.setValue(event.toAnyObject()) { error, _ in
            if let error = error {
                errorMessage = error.localizedDescription // Set error message if there is an error
            } else {
                errorMessage = "Event created successfully!"
            }
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView() 
    }
}
