@testable import RandomUser

final class DeleteUserUseCaseMock: DeleteUserUseCaseContract {
    var deletedIndex: Int?

    func run(at index: Int) {
        deletedIndex = index
    }
}
