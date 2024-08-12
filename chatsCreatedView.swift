//
//  chatsCreatedView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct chatsCreatedView: View {
    @State private var createdGroupChats: [GroupChat] = [] // State variable to hold the created group chats
    @State private var joinedGroupChats: [GroupChat] = [] // State variable to hold the joined group chats

    var body: some View {
        List {
            // Section to display created neighborhood groups
            Section(header: Text("Created Neighborhood Groups")) {
                ForEach(createdGroupChats) { groupChat in
                    NavigationLink(destination: GroupChatOptionsView(groupChat: groupChat)) {
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

            // Section to display joined neighborhood groups
            Section(header: Text("Joined Neighborhood Groups")) {
                ForEach(joinedGroupChats) { groupChat in
                    NavigationLink(destination: GroupChatOptionsView(groupChat: groupChat)) {
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
        }
        .onAppear(perform: fetchGroupChats) // Fetch group chats when the view appears
        .navigationTitle("Neighborhood Groups") // Set the navigation title
    }

    // Function to fetch group chats from Firebase
    private func fetchGroupChats() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("Unable to get current user email.")
            return
        }

        let ref = Database.database().reference().child("groupChats")
        ref.observe(.value) { snapshot in
            var newCreatedGroupChats: [GroupChat] = []
            var newJoinedGroupChats: [GroupChat] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let groupChat = GroupChat(snapshot: snapshot) {
                    if groupChat.users.contains(currentUserEmail) {
                        if groupChat.creatorEmail == currentUserEmail {
                            newCreatedGroupChats.append(groupChat)
                        } else {
                            newJoinedGroupChats.append(groupChat)
                        }
                    }
                }
            }

            self.createdGroupChats = newCreatedGroupChats
            self.joinedGroupChats = newJoinedGroupChats
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        chatsCreatedView()
    }
}

// Model for GroupChat
struct GroupChat: Identifiable {
    var id: String // Unique identifier for the group chat
    var groupName: String // Name of the group chat
    var ageRange: String // Age range for the group chat
    var zipCode: String // ZIP code for the group chat
    var users: [String] // List of users in the group chat
    var creatorEmail: String // Email of the creator of the group chat

    // Initializer for GroupChat
    init(id: String, groupName: String, ageRange: String, zipCode: String, users: [String], creatorEmail: String) {
        self.id = id
        self.groupName = groupName
        self.ageRange = ageRange
        self.zipCode = zipCode
        self.users = users
        self.creatorEmail = creatorEmail
    }

    // Initializer for GroupChat from a DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let groupName = value["groupName"] as? String,
              let ageRange = value["ageRange"] as? String,
              let zipCode = value["zipCode"] as? String,
              let users = value["users"] as? [String],
              let creatorEmail = value["creatorEmail"] as? String else {
            return nil
        }

        self.id = snapshot.key
        self.groupName = groupName
        self.ageRange = ageRange
        self.zipCode = zipCode
        self.users = users
        self.creatorEmail = creatorEmail
    }

    // Function to convert GroupChat to a dictionary
    func toAnyObject() -> Any {
        return [
            "groupName": groupName,
            "ageRange": ageRange,
            "zipCode": zipCode,
            "users": users,
            "creatorEmail": creatorEmail
        ]
    }
}
