import SwiftUI

@main
struct ModularSwiftUIUsersApp: App {
    let container = AppContainer.bootstrap()

    var body: some Scene {
        WindowGroup {
            UsersListView(
                viewModel: UsersViewModel(userService: container.userService)
            )
            .environmentObject(container)
        }
    }
}
