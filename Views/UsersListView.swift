import SwiftUI
import Combine

struct UsersListView: View {
    @EnvironmentObject var container: AppContainer
    @ObservedObject var viewModel: UsersViewModel

    @State private var isLoading: Bool = true
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading Users...")
                        .accessibilityIdentifier("loadingIndicator")
                        .padding()
                } else if viewModel.users.isEmpty {
                    Text("No users available")
                        .foregroundColor(.secondary)
                        .accessibilityIdentifier("emptyState")
                } else {
                    List(viewModel.users) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                if let email = user.email {
                                    Text(email)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            // 👇 for UI test
                            .accessibilityIdentifier("userCell_\(user.id)")
                        }
                    }
                    // 👇 this identifier is CRUCIAL for UI tests
                    .accessibilityIdentifier("userList")
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Users")
        }
        .onAppear {
            subscribeToUsers()
            Task {
                await loadUsers()
            }
        }
    }

    private func subscribeToUsers() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { users in
                if !users.isEmpty {
                    isLoading = false
                }
            }
            .store(in: &cancellables)
    }

    private func loadUsers() async {
        do {
            _ = try await viewModel.userService.fetchUsers()
            isLoading = false
        } catch {
            print("❌ Failed to fetch users: \(error)")
            isLoading = false
        }
    }
}

