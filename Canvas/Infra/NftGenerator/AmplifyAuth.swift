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
            
            let _ = Amplify.Auth.signOut()
            
            Amplify.Auth.signIn(username: Env["COGNITO_EMAIL"], password: Env["COGNITO_PASSWORD"]) { result in
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
