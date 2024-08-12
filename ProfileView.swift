//
//  ProfileView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/8/24.
//
import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct ProfileView: View {
    @Binding var isSignUp: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var zip: String = ""
    @State private var userID: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 20)

                Text("Sign Up")
                    .font(Font.custom("Copperplate", size: 64).weight(.heavy))
                    .lineSpacing(22)
                    .foregroundColor(.cyan)
                    .offset(y: -50)

                Spacer().frame(height: 30)

                // Email Input Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.black)
                        .opacity(0.50)
                    TextField("Email", text: $email)
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

                Spacer().frame(height: 40)

                // Password Input Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("Password")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.black)
                        .opacity(0.50)
                    SecureField("Password", text: $password)
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

                Spacer().frame(height: 40)

                // ZIP Input Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("ZIP Code")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.black)
                        .opacity(0.50)
                    TextField("ZIP", text: $zip)
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

                Spacer().frame(height: 40)

                // User ID Input Field
                VStack(alignment: .leading, spacing: 5) {
                    Text("User ID")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.black)
                        .opacity(0.50)
                    TextField("User ID", text: $userID)
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

                Spacer().frame(height: 40)

                // Sign Up Button
                Button(action: {
                    signUp()
                }) {
                    Text("Sign Up")
                        .font(Font.custom("Inter", size: 24).weight(.medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.45, green: 0.82, blue: 0.40))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.25), lineWidth: 0.5)
                        )
                }
                .padding(.horizontal, 15)
                .frame(width: 360, height: 60)

                Spacer().frame(height: 20)

                // Error message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer().frame(height: 40)

                // Back to Log In Text
                Text("Back to Log In")
                    .font(Font.custom("Inter", size: 15).weight(.light))
                    .foregroundColor(Color(red: 0.98, green: 0.20, blue: 0.31))
                    .onTapGesture {
                        isSignUp.toggle()
                    }

               

            }
            .frame(width: 390, height: 844)
            .background(Color.white)
        }
    }

    private func signUp() {
        // Registers a new user with email and password
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                guard let user = authResult?.user else { return }
                // Saves user data to the database
                let ref = Database.database().reference()
                let userData: [String: Any] = [
                    "email": email,
                    "zip": zip,
                    "userID": userID
                ]
                ref.child("users").child(user.uid).setValue(userData) { error, _ in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        isSignUp = false
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isSignUp: .constant(true))
    }
}
