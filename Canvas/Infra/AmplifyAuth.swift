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
            if self.isLogin() {
                promise(.success(()))
            }
            
            Amplify.Auth.signIn(username: "aki030402@gmail.com", password: "Test1234") { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(.plain(error.localizedDescription)))
                }
            }
        }
    }
}
