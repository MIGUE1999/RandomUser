@testable import RandomUser

final class RandomUsersMapperMock: RandomUsersEntityMapperContract {
    var mappedModels: [RandomUsersModel] = []
    var mappedEntity: RandomUsersEntity?

    func map(_ entities: [UserEntity]) -> [RandomUsersModel] {
        return mappedModels
    }

    func map(_ models: [RandomUsersModel]) -> RandomUsersEntity {
        return mappedEntity ?? RandomUsersEntity(results: [])
    }
}
