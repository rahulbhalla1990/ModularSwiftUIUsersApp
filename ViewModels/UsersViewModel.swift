import Foundation
import Combine

@MainActor
final class UsersViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var users: [User] = []

    // MARK: - Dependencies
    let userService: UserServiceProtocol     // ✅ Accessible to the view
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(userService: UserServiceProtocol) {
        self.userService = userService
        subscribeToUpdates()
        Task {
            await loadUsers()
        }
    }

    // MARK: - Private Methods
    private func subscribeToUpdates() {
        userService.usersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }

    private func loadUsers() async {
        do {
            let users = try await userService.fetchUsers()
            self.users = users
        } catch {
            print("❌ Failed to fetch users: \(error)")
        }
    }
}

