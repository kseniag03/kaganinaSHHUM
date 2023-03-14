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
        //
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
            "created": post.timestamp,
            "title": post.title,
            "discription": post.text,
            "headerImageURL": post.headerImageURL?.absoluteString ?? "",
            "recordFileURL": post.recordFileURL?.absoluteString ?? "",
            "tags": post.tags
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
    
    public func insert(
        record: Record,
        email: String,
        completion: @escaping (Bool) -> Void
    ) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")

        let data: [String: Any] = [
            "id": record.id,
            "created": record.timestamp,
            "recordFileURL": record.recordURL //.absoluteString
        ]

        database
            .collection("users")
            .document(userEmail)
            .collection("records")
            .document(record.id)
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
        database
            .collection("users")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil
                else { return }
                
                let emails: [String] = documents.compactMap({ $0["email"] as? String })
                
                print("Got emails: \(emails)")
                
                guard !emails.isEmpty
                else {
                    completion([])
                    return
                }
                
                let group = DispatchGroup()
                var result: [Post] = []
                
                for email in emails {
                    group.enter()
                    self?.getPosts(for: email) { userPost in
                        defer {
                            group.leave()
                        }
                        result.append(contentsOf: userPost)
                    }
                }
                
                group.notify(queue: .global()) {
                    print("Feed posts count: \(result.count)")
                    completion(result)
                }
                
            }
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
                else { return }

                let posts: [Post] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let created = dictionary["created"] as? TimeInterval,
                          let title = dictionary["title"] as? String,
                          let discription = dictionary["discription"] as? String,
                          let imageURLString = dictionary["headerImageURL"] as? String,
                          let recordURLString = dictionary["recordFileURL"] as? String,
                          let tags = dictionary["tags"] as? [String]
                    else {
                        print("Invalid post fetch conversion")
                        return nil
                    }
                    
                    print()
                    print("imageURLString = \(String(describing: URL(string: imageURLString)))")
                    print()
                    print("recordURLString = \(String(describing: URL(string: recordURLString)))")
                    print()

                    let post = Post(
                        id: id,
                        timestamp: created,
                        title: title,
                        text: discription,
                        headerImageURL: URL(string: imageURLString),
                        recordFileURL: URL(string: recordURLString),
                        tags: tags
                    )
                    return post
                })

                completion(posts)
            }
    }
    
    public func getRecords(
        for email: String,
        completion: @escaping ([Record]) -> Void
    ) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("users")
            .document(userEmail)
            .collection("records")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil
                else { return }

                let records: [Record] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let created = dictionary["created"] as? TimeInterval,
                          let recordURLString = dictionary["recordFileURL"] as? String,
                          let recordURL = URL(string: recordURLString)
                    else {
                        print("Invalid post fetch conversion")
                        return nil
                    }
                    
                    print()
                    print("recordURLString = \(String(describing: URL(string: recordURLString)))")
                    print()
                    
                    //guard let url = URL(string: recordURLString) else { return }
                    
                    print("Record found !!")
                    
                    let record = Record(
                        id: id,
                        timestamp: created,
                        recordURL: recordURL)
                    
                    return record
                })

                completion(records)
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
