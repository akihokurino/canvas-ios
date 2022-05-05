import Combine
import FirebaseStorage
import Foundation

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    
    private let videoBucketName = "gs://canvas-329810-video"
    
    private init() {}
    
    func uploadVideo(data: Data, path: String) -> Future<Int64, AppError> {
        return Future<Int64, AppError> { promise in
            let metadata = StorageMetadata()
            metadata.contentType = "video"
            
            let ref = Storage.storage(url: self.videoBucketName).reference().child(path)
            
            ref.putData(data, metadata: metadata) { metadata, _ in
                guard let metadata = metadata else {
                    promise(.failure(AppError.defaultError()))
                    return
                }
                
                let size = metadata.size
                promise(.success(size))
            }
        }
    }
}
