struct LocationEntity: Codable {
    let street: StreetEntity
    let city: String
    let state: String
    let country: String
    let postcode: Postcode
    let coordinates: CoordinatesEntity
    let timezone: TimezoneEntity
}

struct StreetEntity: Codable {
    let number: Int
    let name: String
}

enum Postcode: Codable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            self = .int(intVal)
            return
        }
        if let stringVal = try? container.decode(String.self) {
            self = .string(stringVal)
            return
        }
        throw DecodingError.typeMismatch(Postcode.self,
                                         DecodingError
            .Context(codingPath: decoder.codingPath,
                     debugDescription: "Wrong type for Postcode"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intVal):
            try container.encode(intVal)
        case .string(let stringVal):
            try container.encode(stringVal)
        }
    }
    
    var stringValue: String {
        switch self {
        case .int(let intVal):
            return String(intVal)
        case .string(let stringVal):
            return stringVal
        }
    }
}

struct CoordinatesEntity: Codable {
    let latitude: String
    let longitude: String
}

struct TimezoneEntity: Codable {
    let offset: String
    let description: String
}
