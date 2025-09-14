import SwiftUI

struct UserDetailView: View {
    let user: RandomUsersModel

    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: user.pictureURL)) { phase in
                if let image = phase.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } else if phase.error != nil {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
            }

            Text("\(user.name) \(user.surname)")
                .font(.title)
                .bold()

            Text("Gender: \(user.gender.capitalized)")

            VStack(alignment: .leading, spacing: 4) {
                Text("Location:")
                    .font(.headline)
                Text("\(user.street)")
                Text("\(user.city), \(user.state)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("Registered: \(user.registeredDate)")
            
            Text("Email: \(user.email)")
                .foregroundColor(.blue)
                .underline()

            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
    }
}
