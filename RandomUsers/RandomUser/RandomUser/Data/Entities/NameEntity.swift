import Foundation

struct NameEntity: Codable, Hashable {
    let title: String
    let first: String
    let last: String

    var fullName: String {
        "\(first) \(last)"
    }
}
