//
//  GroupChatOptionView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI

struct GroupChatOptionsView: View {
    var groupChat: GroupChat

    var body: some View {
        VStack {
            Group {
                // Navigation link to the chat view
                NavigationLink(destination: chatView(groupChat: groupChat)) {
                    HStack {
                        Image(systemName: "message.fill") // Chat icon
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Chat")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)

                // Navigation link to create event view
                NavigationLink(destination: CreateEventView()) {
                    HStack {
                        Image(systemName: "calendar.badge.plus") // Create event icon
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Create Event")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)

                // Navigation link to sign up for event view
                NavigationLink(destination: SignUpForEventView()) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill") // Sign up for event icon
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Sign Up for Event")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)

                // Navigation link to view user events
                NavigationLink(destination: UserEventsView()) {
                    HStack {
                        Image(systemName: "eye.fill") // View events icon
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("View Events")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 15) // Background rounded rectangle
                    .fill(Color(.systemGray6))
                    .shadow(radius: 5)
            )
            .padding(.vertical, 20)

            Spacer()
        }
        .navigationTitle(groupChat.groupName) // Navigation title with group chat name
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct GroupChatOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatOptionsView(groupChat: GroupChat(id: "1", groupName: "Test Group", ageRange: "18-25", zipCode: "12345", users: ["testUser"], creatorEmail: "test@example.com"))
    }
}
