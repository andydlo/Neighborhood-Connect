//
//  createGcView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct createGcView: View {
    @State private var groupName: String = ""
    @State private var selectedAgeRange: String = "18-25"
    @State private var zipCode: String = ""
    @State private var errorMessage: String = ""
    @State private var successMessage: String = ""

    let ageRanges = ["18-25", "26-35", "36-45", "46-55", "56+"]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Create Neighborhood Group")
                    .font(.headline)
                    .padding()
                Spacer()
            }
            .padding(.top, 50) // Adjust the top padding as needed
            .padding(.horizontal)

            Spacer().frame(height: 20)
            
            // Display the logo image
            Image("Designer (1)")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
            Spacer().frame(height: 80)

            // Group Name Input Field
            VStack(alignment: .leading, spacing: 5) {
                Text("Group Name")
                    .font(Font.custom("Inter", size: 24))
                    .foregroundColor(.black)
                    .opacity(0.50)
                TextField("Enter group name", text: $groupName)
                    .padding()
                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.25), lineWidth: 0.5)
                    )
            }
            .padding(.horizontal, 15)
            .frame(width: 360, height: 60)

            Spacer().frame(height: 30)

            // Age Range Picker
            VStack(alignment: .leading, spacing: 5) {
                Text("Age Range")
                    .font(Font.custom("Inter", size: 24))
                    .foregroundColor(.black)
                    .opacity(0.50)
                Picker("Select Age Range", selection: $selectedAgeRange) {
                    ForEach(ageRanges, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 60)
                .clipped()
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.25), lineWidth: 0.5)
                )
            }
            .padding(.horizontal, 15)
            .frame(width: 360)

            Spacer().frame(height: 30)

            // Zip Code Input Field
            VStack(alignment: .leading, spacing: 5) {
                Text("ZIP Code")
                    .font(Font.custom("Inter", size: 24))
                    .foregroundColor(.black)
                    .opacity(0.50)
                TextField("Enter ZIP code", text: $zipCode)
                    .padding()
                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.25), lineWidth: 0.5)
                    )
            }
            .padding(.horizontal, 15)
            .frame(width: 360, height: 60)

            Spacer().frame(height: 30)

            // Create Group Button
            Button(action: {
                createGroupChat()
            }) {
                Text("Create Group")
                    .font(Font.custom("Inter", size: 24).weight(.medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.25), lineWidth: 0.5)
                    )
            }
            .padding(.horizontal, 15)
            .frame(width: 360, height: 60)

            Spacer().frame(height: 20)

            // Display error or success message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }

            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }

    // Function to create a new group chat
    private func createGroupChat() {
        // Ensure that all fields are filled out
        guard !groupName.isEmpty, !zipCode.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        // Ensure that the user is authenticated
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not authenticated."
            return
        }

        // Reference to the database
        let ref = Database.database().reference()
        let groupData: [String: Any] = [
            "groupName": groupName,
            "ageRange": selectedAgeRange,
            "zipCode": zipCode,
            "users": [user.email!],
            "creatorEmail": user.email!,
            "timestamp": ServerValue.timestamp()
        ]

        // Save the group data to the database
        ref.child("groupChats").childByAutoId().setValue(groupData) { error, _ in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                successMessage = "Group chat created successfully!"
                groupName = ""
                zipCode = ""
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        createGcView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
            .environment(\.colorScheme, .light)
    }
}
