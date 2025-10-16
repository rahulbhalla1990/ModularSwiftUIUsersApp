import Foundation
import SwiftUI

public final class AppContainer: ObservableObject {
    public let userService: UserServiceProtocol

    public init(userService: UserServiceProtocol) {
        self.userService = userService
    }

    public static func bootstrap() -> AppContainer {
        let client = NetworkClient()
        let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users") ??
                  URL(string: "https://jsonplaceholder.typicode.com/users")!
        let userService = RemoteUserService(client: client, url: url)
        return AppContainer(userService: userService)
    }
    
    
}
