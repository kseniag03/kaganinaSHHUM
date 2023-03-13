//
//  DatabaseManager.swift
//  kaganinaSHHUM
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    public func insert(
        with post: Post,
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        
    }
    
    public func insert(
        post: Post,
        email: String,
        completion: @escaping (Bool) -> Void
    ) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")

        let data: [String: Any] = [
            "id": post.id,
            "title": post.title,
            "discription": post.text,
            "created": post.timestamp,
            "headerImageURL": post.headerImageURL?.absoluteString ?? ""
        ]

        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(post.id)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    
    public func getUser(
        for email: String,
        completion: @escaping (User?) -> Void
    ) {
        
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database
            .collection("users")
            .document(documentId)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"],
                      error == nil
                else { return }
                
                let ref = data["profile_photo"]
                let user = User(name: name, email: email, profilePhotoRef: ref)
                
                completion(user)
            }
        
    }
    
    public func getAllPosts(
        completion: @escaping ([Post]) -> Void
    ) {
        
    }
    
    public func getPosts(
        for email: String,
        completion: @escaping ([Post]) -> Void
    ) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil
                else {
                    return
                }

                let posts: [Post] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let discription = dictionary["discription"] as? String,
                          let created = dictionary["created"] as? TimeInterval,
                          let imageURLString = dictionary["headerImageURL"] as? String
                    else {
                        print("Invalid post fetch conversion")
                        return nil
                    }

                    let post = Post(
                        id: id,
                        title: title,
                        timestamp: created,
                        headerImageURL: URL(string: imageURLString),
                        text: discription
                    )
                    return post
                })

                completion(posts)
            }
    }
    
    public func insert(
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data = [
            "email": user.email,
            "name": user.name
        ]
        
        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    
    public func updateUserProfilePhoto(
        email: String,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let ref = "profile_pictures/\(path)/photo.png"
        
        let dbRef = database
            .collection("users")
            .document(path)
        
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data() as? [String: String], error == nil
            else { return }
            data["profile_photo"] = ref
            
            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }
    }
    
}
