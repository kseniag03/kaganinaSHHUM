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
    
    public func dowloadURLForProfilePhoto(
        path: String,
        completion: @escaping (URL?) -> Void
    ) {
        container.reference(withPath: path)
            .downloadURL { url, _ in
                completion(url)
            }
    }
    /*
    public func uploadPostHeaderImage(
        post: Post,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        
    }*/
    
    public func uploadPostHeaderImage(
        email: String,
        image: UIImage?,
        postId: String,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        guard let image = image else { return }

        guard let pngData = image.pngData() else { return }

        container
            .reference(withPath: "post_headers/\(path)/\(postId).png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil
                else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func uploadUserRecord(
        email: String,
        record: URL,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")

        container
            .reference(withPath: "user_records/\(path)/")
            .putFile(from: record)
    }
    
    public func uploadPostRecord( // ...
        email: String,
        audioData: Data,
        postId: String,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        //guard let data = audioData else { return }

        container
            .reference(withPath: "user_records/\(path)/\(postId).m4a")
            .putData(audioData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil
                else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    /*
    public func dowloadURLForPostHeaderImage(
        post: Post,
        completion: @escaping (URL?) -> Void
    ) {
        
    }*/
    
    public func downloadURLForPostHeader(
        email: String,
        postId: String,
        completion: @escaping (URL?) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        
        let picPath = "post_headers/\(path)/\(postId).png"
        
        print("!!! picPath = \(picPath)")

        container
            .reference(withPath: "post_headers/\(path)/\(postId).png")
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    public func downloadURLForRecord(
        email: String,
        recordId: String,
        completion: @escaping (URL?) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        
        let picPath = "user_records/\(path)/\(recordId).png"
        
        print("!!! picPath = \(picPath)")

        container
            .reference(withPath: "user_records/\(path)/\(recordId).png")
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
}
