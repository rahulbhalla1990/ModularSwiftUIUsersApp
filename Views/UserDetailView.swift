import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Name
            Text(user.name)
                .font(.largeTitle)
                .bold()
                .accessibilityIdentifier("userNameTitle")

            // Username
            if let username = user.username {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.blue)
                    Text(username)
                        .font(.headline)
                }
                .accessibilityIdentifier("userUsernameLabel")
            }

            // Email
            if let email = user.email {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.green)
                    Text(email)
                        .font(.subheadline)
                }
                .accessibilityIdentifier("userEmailLabel")
            }

            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier("userDetailView")
    }
}

#Preview {
    UserDetailView(
        user: User(id: 1, name: "John Doe", username: "johndoe", email: "john@example.com")
    )
}

