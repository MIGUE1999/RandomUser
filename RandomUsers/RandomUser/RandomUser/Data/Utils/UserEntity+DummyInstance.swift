extension UserEntity {
    static func dummyInsatance() -> UserEntity {
        return UserEntity(
            gender: "male",
            name: NameEntity(title: "Mr", first: "John", last: "Doe"),
            location: LocationEntity(
                street: StreetEntity(number: 123, name: "Main St"),
                city: "City",
                state: "State",
                country: "Country",
                postcode: .string("12345"),
                coordinates: CoordinatesEntity(latitude: "0", longitude: "0"),
                timezone: TimezoneEntity(offset: "+0", description: "UTC")
            ),
            email: "john.doe@example.com",
            registered: RegisteredEntity(date: "2020-01-01", age: 1),
            phone: "123456789",
            picture: PictureEntity(large: "url", medium: "url", thumbnail: "url")
        )
    }
}
