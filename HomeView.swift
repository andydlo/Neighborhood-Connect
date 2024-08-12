//
//  HomeView.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/18/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

// Enum representing the tabs in the app
enum Tab: String, CaseIterable, Hashable {
    case plus
    case magnifyingglass
    case person
    case gear
}

struct HomeView: View {
    @Binding var selectedTab: Tab
    @State private var path = NavigationPath()
    
    @State private var createdNeighborhoods: [GroupChat] = []
    @State private var joinedNeighborhoods: [GroupChat] = []
    @State private var signedUpEvents: [Event] = []

    // Computed property to get the image name for the selected tab
    private var filImage: String {
        selectedTab.rawValue + ".circle"
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer().frame(height: 50) // Add some spacing at the top

                // Add your logo or any image here
                Image("Designer (1)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)

                // Add a welcome message
                Text("Welcome to Neighborhood Connect")
                    .font(.custom("Copperplate", size: 32))
                    .foregroundColor(.cyan)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding()

                // Agenda section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Neighborhoods")
                        .font(.headline)
                        .padding(.top)
                    
                    if createdNeighborhoods.isEmpty && joinedNeighborhoods.isEmpty {
                        Text("Be sure to create or join a neighborhood")
                            .foregroundColor(.gray)
                    } else {
                        // Display created neighborhoods
                        ForEach(createdNeighborhoods) { neighborhood in
                            Text(neighborhood.groupName)
                                .font(.subheadline)
                                .padding(.bottom, 1)
                        }
                        // Display joined neighborhoods
                        ForEach(joinedNeighborhoods) { neighborhood in
                            Text(neighborhood.groupName)
                                .font(.subheadline)
                                .padding(.bottom, 1)
                        }
                    }
                    
                    Text("Upcoming Events")
                        .font(.headline)
                        .padding(.top)

                    if signedUpEvents.isEmpty {
                        Text("No events coming up")
                            .foregroundColor(.gray)
                    } else {
                        // Display upcoming events
                        ForEach(signedUpEvents.sorted(by: { $0.date < $1.date })) { event in
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.subheadline)
                                    .padding(.bottom, 1)
                                Text("Date: \(event.date, formatter: eventDateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()

                Spacer()

                // Main content based on the selected tab
                if selectedTab == .plus {
                    NavigationLink(value: "createGcView") {
                        EmptyView()
                    }.hidden()
                } else if selectedTab == .person {
                    NavigationLink(value: "chatsCreatedView") {
                        EmptyView()
                    }.hidden()
                } else if selectedTab == .gear {
                    NavigationLink(value: "settingsView") {
                        EmptyView()
                    }.hidden()
                } else if selectedTab == .magnifyingglass {
                    NavigationLink(value: "CreateGroupChats") {
                        EmptyView()
                    }.hidden()
                }

                Spacer()

                // Tab bar
                HStack {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Spacer()
                        Image(systemName: selectedTab == tab ? filImage : tab.rawValue)
                            .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                            .foregroundColor(selectedTab == tab ? .red : .gray)
                            .font(.system(size: 22))
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.1)) {
                                    selectedTab = tab
                                    if tab == .person {
                                        path.append("chatsCreatedView")
                                    } else if tab == .plus {
                                        path.append("createGcView")
                                    } else if tab == .gear {
                                        path.append("settingsView")
                                    } else if tab == .magnifyingglass {
                                        path.append("CreateGroupChats")
                                    }
                                }
                            }
                        Spacer()
                    }
                }
                .frame(height: 45) // Adjusted height to be smaller
                .background(.thinMaterial)
                .cornerRadius(10)
                .padding()
                .padding(.bottom, 34) // Adjust padding for safe area
            }
            .onAppear(perform: fetchUserDetails)
            .navigationDestination(for: String.self) { view in
                if view == "createGcView" {
                    createGcView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: Button(action: {
                            path.removeLast()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                Text("Back")
                            }
                        })
                } else if view == "chatsCreatedView" {
                    chatsCreatedView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: Button(action: {
                            path.removeLast()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                Text("Back")
                            }
                        })
                } else if view == "settingsView" {
                    settingsView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: Button(action: {
                            path.removeLast()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                Text("Back")
                            }
                        })
                } else if view == "CreateGroupChats" {
                    CreateGroupChats()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: Button(action: {
                            path.removeLast()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                Text("Back")
                            }
                        })
                }
            }
            .edgesIgnoringSafeArea(.all) // Ensure it respects safe area
        }
    }

    private func fetchUserDetails() {
        fetchGroupChats()
        fetchSignedUpEvents()
    }

    // Fetch group chats for the current user
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

            self.createdNeighborhoods = newCreatedGroupChats
            self.joinedNeighborhoods = newJoinedGroupChats
        }
    }

    // Fetch signed-up events for the current user
    private func fetchSignedUpEvents() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("Unable to get current user email.")
            return
        }

        let ref = Database.database().reference().child("events")
        ref.observe(.value) { snapshot in
            var newEvents: [Event] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let event = Event(snapshot: snapshot) {
                    if event.attendees.contains(currentUserEmail) {
                        newEvents.append(event)
                    }
                }
            }
            self.signedUpEvents = newEvents
        }
    }
}

// DateFormatter to format the event date
private let eventDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(.plus))
    }
}
