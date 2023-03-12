//
//  StorageManager.swift
//  kaganinaSHHUM
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage().reference()
    
    private init() {}
    
    public func uploadUserProfilePicture(
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        
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
