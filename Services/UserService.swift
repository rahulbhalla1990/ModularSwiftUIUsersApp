import Foundation
import Combine

public protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
    var usersPublisher: Published<[User]>.Publisher { get }
}

public final class RemoteUserService: UserServiceProtocol {
    @Published public private(set) var users: [User] = []
    public var usersPublisher: Published<[User]>.Publisher { $users }

    private let client: NetworkClientProtocol
    private let url: URL

    public init(client: NetworkClientProtocol, url: URL) {
        self.client = client
        self.url = url
    }

    public func fetchUsers() async throws -> [User] {
        let (data, _) = try await client.fetchData(from: url)
        let users = try JSONDecoder().decode([User].self, from: data)
        self.users = users
        return users
    }
}
