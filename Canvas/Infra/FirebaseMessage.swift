import Combine
import Firebase
import Foundation

class FirebaseMessageManager {
    static let shared = FirebaseMessageManager()

    private init() {}

    func token() -> Future<String, AppError> {
        return Future<String, AppError> { promise in
            Messaging.messaging().token { token, error in
                guard error == nil else {
                    promise(.failure(.plain(error!.localizedDescription)))
                    return
                }

                promise(.success(token!))
            }
        }
    }
}
