Neighborhood Watch Aplication
Created by: Andy Delgado Alessandro Escobar Isaac Del Castillo Randy Iguanzo

This app aims to connect people within their neighborhood and be able to host and join events that are being hosted locally.

Directory Structure of Neighborhood Connect

1. Views
This directory contains the SwiftUI views for the application. Each view represents a different screen or UI component of the app.

ContentView.swift: Displays a Log In page that allows users to log in into the app. Shows an Email and Password input field.

ProfileView.swift: Provides a sign up form for a user input user information to create an account. Creates a new account onece "Sign Up" button is clicked.

HomeView.swift: Allows users to navigate to create and join group funtionalities, as well as viewing created or joined groups. Displays user's neighborhoods and upcoming events.

createGcView.swift: Interface that allows users to create new neighborhood groups. Neighborhood groups require a name, an age range, and a zip code.

CreateGroupChats.swift: Shows input information regarding the detials to find neighborhood groups. Which include zip and age, also includes a "Find Neighborhood Group" button.

chatsCreatedView.swift: Displays the neighborhood groups that have either been created or joined by the user, two different sections seperate the groups. 

settingsView.swift: Lists the UserID and email of the user currently logged into the application. Contains a sign out button that contains a navigation link to the log in page.

GroupChatOptionView.swift: Once a neighborhood group is accessed a group of options is displayed, allowing access to the chat and event funtionalities respectively.

chatView.swift: Displays the chat interface for a specific group chat. Includes message list and text input.

CreateEventView.swift: Provides a form to create a new event, including input fields for event details and a date picker.

EventDetailsView.swift: Shows detailed information about a specific event, including a map view with the event's location.

SignUpForEventView.swift: Lists available events for the user to sign up for and handles event registration.

UserEventsView.swift: Displays events that the user is signed up for and allows them to unsubscribe from events.

EventDetailsView.swift: Shows all the details of the event, includes a map showing location where event is taking place.


2. Models
This directory contains data models used in the application, including those for handling data from Firebase.

Event.swift: Defines the Event structure, including properties for event details, and methods for converting to and from Firebase data.


3. SupportingFiles
This directory includes files necessary for project configuration and setup.

AppDelegate.swift: Manages app lifecycle events and configuration.

GoogleService-info: Contains Firebase configuration settings and initialization code.


4. Resources
This directory contains resources used throughout the app, such as images and asset catalogs.
Designer (1).png: The logo image of our application.

5. Package Dependencies
This directory is found in the video that explain the installation procedure since it is accessed through the google firebase sdk inside of XCode. These are the required packages to make the application function.
FirebaseAuth
FirebaseDatabase
FirebaseDatabaseSwift
FirebaseMessaging
FirebaseStorage
