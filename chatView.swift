//
//  chatView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct chatView: View {
    var groupChat: GroupChat
    @State private var messages: [Message] = [] // State variable to hold the list of messages
    @State private var messageText: String = "" // State variable to hold the text of the new message

    var body: some View {
        VStack {
            // List to display messages
            List(messages) { message in
                VStack(alignment: .leading) {
                    Text(message.userID) // Display user ID of the message sender
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(message.text) // Display the text of the message
                }
            }

            // Input field and send button for new messages
            HStack {
                TextField("Enter message", text: $messageText) // TextField for entering new message
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage) { // Send button
                    Text("Send")
                }
            }
            .padding()
        }
        .onAppear(perform: fetchMessages) // Fetch messages when the view appears
        .navigationTitle(groupChat.groupName) // Set navigation title to the group chat name
    }

    // Function to fetch messages from Firebase
    private func fetchMessages() {
        let ref = Database.database().reference().child("groupChats/\(groupChat.id)/messages")
        ref.observe(.value) { snapshot in
            var newMessages: [Message] = [] // Temporary array to hold fetched messages
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let message = Message(snapshot: snapshot) {
                    newMessages.append(message) // Add each message to the temporary array
                }
            }
            self.messages = newMessages // Update the state variable with the fetched messages
        }
    }

    // Function to send a new message
    private func sendMessage() {
        guard !messageText.isEmpty, let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        let ref = Database.database().reference().child("groupChats/\(groupChat.id)/messages").childByAutoId()
        let message = Message(id: ref.key ?? UUID().uuidString, text: messageText, userID: currentUserEmail)
        ref.setValue(message.toAnyObject()) // Save the new message to Firebase
        messageText = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        chatView(groupChat: GroupChat(id: "1", groupName: "Test Group", ageRange: "18-25", zipCode: "12345", users: ["testUser"], creatorEmail: "test@example.com"))
    }
}

struct Message: Identifiable {
    var id: String
    var text: String
    var userID: String

    init(id: String, text: String, userID: String) {
        self.id = id
        self.text = text
        self.userID = userID
    }

    // Initializer to create a Message instance from a Firebase snapshot
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let text = value["text"] as? String,
              let userID = value["userID"] as? String else {
            return nil 
        }

        self.id = snapshot.key
        self.text = text
        self.userID = userID
    }

    // Convert the Message instance to a dictionary
    func toAnyObject() -> Any {
        return [
            "text": text,
            "userID": userID
        ]
    }
}
