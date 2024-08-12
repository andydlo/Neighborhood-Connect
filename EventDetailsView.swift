//
//  EventDetailsView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import MapKit

struct EventDetailsView: View {
    var event: Event
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default coordinates (San Francisco), to be updated with actual event coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Zoom level of the map
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Display the event name
                Text(event.name)
                    .font(.largeTitle)
                    .bold()

                // Display the event type
                Text("Type: \(event.type)")
                    .font(.title2)

                // Display the event description
                Text("Description: \(event.description)")
                    .font(.title2)

                // Display the event address
                Text("Address: \(event.address)")
                    .font(.title2)

                // Display the event date and time
                Text("Date: \(event.date, formatter: eventDateFormatter)")
                    .font(.title2)

                // Display the number of attendees
                Text("Attendees: \(event.attendees.count)")
                    .font(.title2)

                // List of attendees
                List(event.attendees, id: \.self) { attendee in
                    Text(attendee)
                }
                .frame(height: 150)

                // Map view showing the event address
                Map(coordinateRegion: $region, interactionModes: [])
                    .frame(height: 200) // Fixed height for the map
                    .cornerRadius(10)
            }
            .padding() // Add padding around the content
        }
        .navigationTitle("Event Details") // Title for the navigation bar
        .onAppear {
            geocodeAddress(event.address) // Geocode the event address to update map coordinates when the view appears
        }
    }

    // Function to convert address to coordinates using geocoding
    private func geocodeAddress(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                region.center = location.coordinate // Update the map region center to the event location
            }
        }
    }
}

// Date formatter for displaying event date and time
private let eventDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short 
    return formatter
}()

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEvent = Event(
            id: "1",
            name: "Sample Event",
            type: "Party",
            description: "This is a sample event description.",
            address: "123 Main St, San Francisco, CA",
            date: Date(),
            attendees: ["user1@example.com", "user2@example.com"]
        )
        EventDetailsView(event: sampleEvent)
    }
}
