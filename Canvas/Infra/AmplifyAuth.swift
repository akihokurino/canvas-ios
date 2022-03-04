import Amplify
import Foundation
import Combine

class AmplifyAuthManager {
    static let shared = AmplifyAuthManager()

    private init() {}

    func isLogin() -> Bool {
        return Amplify.Auth.getCurrentUser() != nil
    }

    func signIn() -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            Amplify.Auth.signIn(username: "aki030402.admin@gmail.com", password: "Test1234") { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(AppError.wrap(error)))
                }
            }
        }
    }
}
