//
//  settingsView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct settingsView: View {
    @State private var user: User? = Auth.auth().currentUser
    @State private var userID: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            
            // Check if user is available
            if let user = user {
                VStack(alignment: .leading, spacing: 20) {
                    // Display the user ID
                    Text("User ID: \(userID.isEmpty ? "Loading..." : userID)")
                        .font(.title2)
                        .foregroundColor(.black)
                    
                    // Display the user email
                    Text("Email: \(user.email ?? "Unknown")")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .padding()
                .onAppear {
                    fetchUserID() // Fetch user ID when view appears
                }
            } else {
                // Display message if no user information is available
                Text("No user information available.")
                    .font(.title2)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            // Sign Out Button
            Button(action: {
                signOut()
            }) {
                Text("Sign Out")
                    .font(Font.custom("Inter", size: 24).weight(.medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.red))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.25), lineWidth: 0.5)
                    )
            }
            .padding(.horizontal, 15)
            .frame(width: 360, height: 60)
            
            // Display error message if any
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarTitle("Profile Details", displayMode: .inline) // Set the navigation title
        .onAppear {
            user = Auth.auth().currentUser // Update the current user when view appears
        }
    }
    
    // Function to fetch user ID from Firebase
    private func fetchUserID() {
        guard let user = user else { return }
        let ref = Database.database().reference() // Get reference to the Firebase database
        ref.child("users").child(user.uid).observeSingleEvent(of: .value) { snapshot in
            // Get user data from snapshot
            if let userData = snapshot.value as? [String: Any], let userID = userData["userID"] as? String {
                self.userID = userID // Update userID state variable
            } else {
                self.errorMessage = "Failed to load user ID" // Set error message if user ID fetch fails
            }
        } withCancel: { error in
            self.errorMessage = error.localizedDescription // Set error message if there's a cancellation error
        }
    }
    
    // Function to sign out the user
    private func signOut() {
        do {
            try Auth.auth().signOut() // Try to sign out the user
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: ContentView()) // Redirect to ContentView after sign out
                window.makeKeyAndVisible() // Make the window key and visible
            }
        } catch {
            errorMessage = error.localizedDescription // Set error message if sign out fails
        }
    }
}

struct settingsView_Previews: PreviewProvider {
    static var previews: some View {
        settingsView() 
    }
}
