//
//  AuthenticationManger.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import Foundation
import FirebaseAuth



struct authDataResultModel {
    
    let userID: String
    let email: String?
    let photoURL: String?
    
    
    init(user: User) {
        self.userID = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        
    }
}


final class AuthenticationManager{
    
    
    static let shared = AuthenticationManager()
    private init() {}
    
   
    
    func getAuthenticatedUser() throws -> authDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return authDataResultModel(user: user)
    }
    

    
    func signOut() throws {
       try Auth.auth().signOut()
    }
    
    
    
    
}
//email
extension AuthenticationManager {
    func registerUser(email: String, password: String) async throws -> authDataResultModel {
       let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return authDataResultModel(user: authDataResult.user)
    }
    
    func signInUser(email: String, password: String) async throws -> authDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authDataResultModel(user: authDataResult.user)
    }
        
    func resetPassword(email:String) async throws {
        
      try await  Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    
    func updatePass(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
        
    }
    
    func updateEmail(email:String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.sendEmailVerification(beforeUpdatingEmail:email)
        
    }
    
}


extension AuthenticationManager {
    
    @discardableResult
    func googleSignIn(tokens: googleSignInModel) async throws -> authDataResultModel{
        let cred = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)

        return try await signIn(credential: cred )
    }
    
    func signIn(credential: AuthCredential) async throws -> authDataResultModel{
        let authDataResult =   try await Auth.auth().signIn(with: credential)
        return authDataResultModel(user: authDataResult.user)

    }
}
