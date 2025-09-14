import Foundation

protocol RandomUserLocalDataSourceContract {
    func save<T: Codable>(_ items: [T]) throws
    func load<T: Codable>(as type: T.Type) throws -> T
    
    func loadBlockedEmails() -> Set<String>
    func saveBlockedEmails(_ emails: Set<String>)
}

final class RandomUserLocalDataSource: RandomUserLocalDataSourceContract {
    private var documentsDirectory: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    private let fileName = "users.json"
    
    private let blockedEmailsKey = "blockedEmails"
    
    convenience init(documentsDirectory: URL) {
        self.init()
        self.documentsDirectory = documentsDirectory
    }

    func save<T: Codable>(_ items: [T]) throws {
        let url = documentsDirectory.appendingPathComponent(fileName)
        let data = try JSONEncoder().encode(items)
        try data.write(to: url, options: [.atomic])
    }
    
    func load<T: Codable>(as type: T.Type) throws -> T {
        let url = documentsDirectory.appendingPathComponent(fileName)
        let data = try Data(contentsOf: url)
        let items = try JSONDecoder().decode(T.self, from: data)
        return items
    }
        
    func loadBlockedEmails() -> Set<String> {
        let saved = UserDefaults.standard.array(forKey: blockedEmailsKey) as? [String] ?? []
        return Set(saved)
    }
    
    func saveBlockedEmails(_ emails: Set<String>) {
        UserDefaults.standard.set(Array(emails), forKey: blockedEmailsKey)
    }
}
