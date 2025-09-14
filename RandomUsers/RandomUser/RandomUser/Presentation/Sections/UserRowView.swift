import SwiftUI


struct UserRowView: View {
    let user: RandomUsersModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.pictureURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(user.phone)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}
