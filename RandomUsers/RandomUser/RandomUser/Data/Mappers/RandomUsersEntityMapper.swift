protocol RandomUsersEntityMapperContract {
    func map(_ entities: [UserEntity]) -> [RandomUsersModel]
    func map(_ models: [RandomUsersModel]) -> RandomUsersEntity
}

final class RandomUsersEntityMapper: RandomUsersEntityMapperContract {
    
    func map(_ entities: [UserEntity]) -> [RandomUsersModel] {
        entities.map { entity in
            let street = "\(entity.location.street.number) \(entity.location.street.name)"
            
            return RandomUsersModel(
                gender: entity.gender,
                name: entity.name.first,
                surname: entity.name.last,
                fullName: entity.name.fullName,
                email: entity.email,
                phone: entity.phone,
                pictureURL: entity.picture.large,
                street: street,
                city: entity.location.city,
                state: entity.location.state,
                registeredDate: entity.registered.date
            )
        }
    }
    
    func map(_ models: [RandomUsersModel]) -> RandomUsersEntity {
        let results = models.map { model -> UserEntity in
            let nameParts = model.fullName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            let firstName = String(nameParts.first ?? "")
            let lastName = nameParts.count > 1 ? String(nameParts[1]) : ""
            let streetComponents = model.street.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            let streetNumber = Int(streetComponents.first ?? "") ?? 0
            let streetName = streetComponents.count > 1 ? String(streetComponents[1]) : ""

            return UserEntity(
                gender: model.gender,
                name: NameEntity(title: "", first: firstName, last: lastName),
                location: LocationEntity(
                    street: StreetEntity(number: streetNumber, name: streetName),
                    city: model.city,
                    state: model.state,
                    country: "",
                    postcode: .string(""),
                    coordinates: CoordinatesEntity(latitude: "", longitude: ""),
                    timezone: TimezoneEntity(offset: "", description: "")
                ),
                email: model.email,
                registered: RegisteredEntity(date: model.registeredDate, age: 0),
                phone: model.phone,
                picture: PictureEntity(large: model.pictureURL, medium: "", thumbnail: "")
            )
        }

        return RandomUsersEntity(results: results)
    }
}
