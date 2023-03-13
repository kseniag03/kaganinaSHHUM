//
//  StorageManager.swift
//  kaganinaSHHUM
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init() {}
    
    public func uploadUserProfilePhoto(
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        guard let pngData = image?.pngData() else { return }
        
        container
            .reference(withPath: "profile_pictures/\(path)/photo.png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil
                else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func dowloadURLForProfilePicture(
        user: User,
        completion: @escaping (URL?) -> Void
    ) {
        
    }
    
    public func uploadPostHeaderImage(
        post: Post,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        
    }
    
    public func dowloadURLForPostHeaderImage(
        post: Post,
        completion: @escaping (URL?) -> Void
    ) {
        
    }
    
}
