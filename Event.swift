//
//  Event.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//
import Foundation
import FirebaseDatabase

// Struct representing an event
struct Event: Identifiable {
    var id: String
    var name: String
    var type: String
    var description: String
    var address: String
    var date: Date
    var attendees: [String]

    // Initializer for creating an Event object
    init(id: String, name: String, type: String, description: String, address: String, date: Date, attendees: [String]) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.address = address
        self.date = date
        self.attendees = attendees
    }

    // Initializer for creating an Event object from a Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let name = value["name"] as? String,
              let type = value["type"] as? String,
              let description = value["description"] as? String,
              let address = value["address"] as? String,
              let timestamp = value["date"] as? TimeInterval, // Timestamp for the date
              let attendees = value["attendees"] as? [String] else {
            return nil 
        }

        self.id = snapshot.key // Set the event ID from the snapshot key
        self.name = name
        self.type = type
        self.description = description
        self.address = address
        self.date = Date(timeIntervalSince1970: timestamp) // Convert timestamp to Date
        self.attendees = attendees
    }

    // Convert the Event object to a dictionary for Firebase
    func toAnyObject() -> Any {
        return [
            "name": name,
            "type": type,
            "description": description,
            "address": address,
            "date": date.timeIntervalSince1970, // Convert Date to timestamp
            "attendees": attendees
        ]
    }
}
