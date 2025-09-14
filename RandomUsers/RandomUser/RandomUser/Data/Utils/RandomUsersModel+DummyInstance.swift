extension RandomUsersModel {
    static func dummyInsatance() -> RandomUsersModel {
        return RandomUsersModel(gender: "male",
                                name: "John",
                                surname: "Doe",
                                fullName: "John Doe",
                                email: "john@example.com",
                                phone: "123456",
                                pictureURL: "url",
                                street: "123 Street",
                                city: "City",
                                state: "State",
                                registeredDate: "2020-01-01")
    }
}
