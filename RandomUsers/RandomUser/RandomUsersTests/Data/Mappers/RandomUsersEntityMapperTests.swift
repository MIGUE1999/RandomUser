import XCTest
@testable import RandomUser

final class RandomUsersEntityMapperTests: XCTestCase {
    
    var sut: RandomUsersEntityMapper!
    
    override func setUp() {
        super.setUp()
        sut = RandomUsersEntityMapper()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_map_entitiesToModels() {
        // Given
        let userEntity = UserEntity.dummyInsatance()
        
        // When
        let models = sut.map([userEntity])
        
        // Then
        XCTAssertEqual(models.count, 1)
        let model = models.first!
        XCTAssertEqual(model.gender, "male")
        XCTAssertEqual(model.name, "John")
        XCTAssertEqual(model.surname, "Doe")
        XCTAssertEqual(model.fullName, "John Doe")
        XCTAssertEqual(model.email, "john.doe@example.com")
        XCTAssertEqual(model.phone, "123456789")
        XCTAssertEqual(model.pictureURL, "url")
        XCTAssertEqual(model.street, "123 Main St")
        XCTAssertEqual(model.city, "City")
        XCTAssertEqual(model.state, "State")
        XCTAssertEqual(model.registeredDate, "2020-01-01")
    }
    
    func test_map_modelsToEntity() {
        // Given
        let model = RandomUsersModel(
            gender: "female",
            name: "Jane",
            surname: "Smith",
            fullName: "Jane Smith",
            email: "jane.smith@example.com",
            phone: "987-654-3210",
            pictureURL: "http://example.com/large2.jpg",
            street: "456 Elm St",
            city: "Los Angeles",
            state: "CA",
            registeredDate: "2019-12-31"
        )
        
        // When
        let entity = sut.map([model])
        
        // Then
        XCTAssertEqual(entity.results.count, 1)
        let userEntity = entity.results.first!
        XCTAssertEqual(userEntity.gender, "female")
        XCTAssertEqual(userEntity.name.first, "Jane")
        XCTAssertEqual(userEntity.name.last, "Smith")
        XCTAssertEqual(userEntity.email, "jane.smith@example.com")
        XCTAssertEqual(userEntity.phone, "987-654-3210")
        XCTAssertEqual(userEntity.picture.large, "http://example.com/large2.jpg")
        XCTAssertEqual(userEntity.location.city, "Los Angeles")
        XCTAssertEqual(userEntity.location.state, "CA")
        XCTAssertEqual(userEntity.location.street.number, 456)
        XCTAssertEqual(userEntity.location.street.name, "Elm St")
        XCTAssertEqual(userEntity.registered.date, "2019-12-31")
        XCTAssertEqual(userEntity.registered.age, 0)
    }
    
    func test_map_modelsToEntity_withSingleName() {
        let model = RandomUsersModel(
            gender: "female",
            name: "Cher",
            surname: "",
            fullName: "Cher",
            email: "cher@example.com",
            phone: "555-555-5555",
            pictureURL: "",
            street: "1 Sunset Blvd",
            city: "Hollywood",
            state: "CA",
            registeredDate: "2018-01-01"
        )
        
        // When
        let entity = sut.map([model])
        
        // Then
        let userEntity = entity.results.first!
        XCTAssertEqual(userEntity.name.first, "Cher")
        XCTAssertEqual(userEntity.name.last, "")
        XCTAssertEqual(userEntity.location.street.number, 1)
        XCTAssertEqual(userEntity.location.street.name, "Sunset Blvd")
    }
}
