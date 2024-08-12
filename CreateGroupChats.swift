//
//  CreateGroupChats.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct CreateGroupChats: View {
    @State private var zipCode: String = ""
    @State private var age: String = ""
    @State private var availableGroupChats: [GroupChat] = []
    @State private var errorMessage: String = "" 
    
    var body: some View {
        VStack {
            // TextField for ZIP Code input
            TextField("Enter ZIP Code", text: $zipCode)
                .padding()
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)

            // TextField for Age input
            TextField("Enter Age", text: $age)
                .padding()
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)

            // Button to find group chats
            Button(action: {
                findGroupChats()
            }) {
                Text("Find Neighborhood Group")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
            }

            // Display error message if any
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // List to display available group chats
            List(availableGroupChats) { groupChat in
                Button(action: {
                    joinGroupChat(groupChat)
                }) {
                    VStack(alignment: .leading) {
                        Text(groupChat.groupName)
                            .font(.headline)
                        Text("ZIP Code: \(groupChat.zipCode)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Join Neighborhood Group")
    }

    // Function to find group chats based on ZIP code and age
    private func findGroupChats() {
        guard let ageInt = Int(age) else {
            errorMessage = "Please enter a valid age."
            return
        }

        let ref = Database.database().reference().child("groupChats")
        ref.observeSingleEvent(of: .value) { snapshot in
            var matches: [GroupChat] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let groupChat = GroupChat(snapshot: snapshot) {
                    if groupChat.zipCode == zipCode && isValidAgeRange(for: groupChat.ageRange, age: ageInt) {
                        matches.append(groupChat)
                    }
                }
            }

            if matches.isEmpty {
                errorMessage = "No group chats found for the entered ZIP code and age."
            } else {
                errorMessage = ""
                availableGroupChats = matches
            }
        }
    }

    // Function to check if age is within the age range of the group chat
    private func isValidAgeRange(for ageRange: String, age: Int) -> Bool {
        let ageComponents = ageRange.split(separator: "-")
        if ageComponents.count == 2,
           let minAge = Int(ageComponents[0]),
           let maxAge = Int(ageComponents[1]) {
            return age >= minAge && age <= maxAge
        }
        return false
    }

    // Function to join a group chat
    private func joinGroupChat(_ groupChat: GroupChat) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            errorMessage = "Unable to get current user email."
            return
        }

        let ref = Database.database().reference().child("groupChats").child(groupChat.id).child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
            var users = groupChat.users
            if !users.contains(currentUserEmail) {
                users.append(currentUserEmail)
                ref.setValue(users) { error, _ in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        errorMessage = "Successfully joined the group chat!"
                        fetchJoinedGroupChats()
                    }
                }
            } else {
                errorMessage = "You are already a member of this group chat."
            }
        }
    }

    // Function to fetch the group chats the user has joined
    private func fetchJoinedGroupChats() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("Unable to get current user email.")
            return
        }

        let ref = Database.database().reference().child("groupChats")
        ref.observeSingleEvent(of: .value) { snapshot in
            var newJoinedGroupChats: [GroupChat] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let groupChat = GroupChat(snapshot: snapshot) {
                    if groupChat.users.contains(currentUserEmail) && groupChat.creatorEmail != currentUserEmail {
                        newJoinedGroupChats.append(groupChat)
                    }
                }
            }

            // Notify the main view to update the joined group chats
            NotificationCenter.default.post(name: Notification.Name("JoinedGroupChatsUpdated"), object: nil, userInfo: ["joinedGroupChats": newJoinedGroupChats])
        }
    }
}

struct CreateGroupChats_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupChats()
    }
}
