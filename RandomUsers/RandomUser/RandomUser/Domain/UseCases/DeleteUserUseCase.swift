protocol DeleteUserUseCaseContract {
    func run(at index: Int)
}

final class DeleteUserUseCase: DeleteUserUseCaseContract {
    private let randomUserRepository: RandomUsersRepositoryContract
    
    init(randomUserRepository: RandomUsersRepositoryContract = RandomUsersRepository()) {
        self.randomUserRepository = randomUserRepository
    }
    
    func run(at index: Int) {
        randomUserRepository.delete(at: index)
    }
}
