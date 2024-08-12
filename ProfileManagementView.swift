//
//  ProfileManagementView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/9/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileManagementView: View {
    @State private var email: String = ""
    @State private var uid: String = ""

    var body: some View {
        VStack {
            Spacer().frame(height: 100)
            
            Text("Profile Management")
                .font(.largeTitle)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Email: \(email)")
                    .font(.title2)
                    .foregroundColor(.black)
                
                Text("User ID: \(uid)")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                logout()
            }) {
                Text("Log Out")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            loadUserProfile()
        }
    }

    private func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            email = user.email ?? "No email"
            uid = user.uid
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct ProfileManagementView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileManagementView()
    }
}
