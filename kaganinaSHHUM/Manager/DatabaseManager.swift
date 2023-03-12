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
    
    public func getAllPosts(
        completion: @escaping ([Post]) -> Void
    ) {
        
    }
    
    public func getPostsForUser(
        for user: User,
        completion: @escaping ([Post]) -> Void
    ) {
        
    }
    
    public func insert(
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        
    }
    
}
