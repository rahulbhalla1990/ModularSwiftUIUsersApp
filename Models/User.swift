import Foundation

public struct User: Identifiable, Codable, Equatable {
    public let id: Int
    public let name: String
    public let username: String?
    public let email: String?
}