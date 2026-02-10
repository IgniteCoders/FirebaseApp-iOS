//
//  AuthViewModel.swift
//  FirebaseApp
//
//  Created by Tardes on 10/2/26.
//
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class AuthManager {
    
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func signIn(username: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: username, password: password)
    }
    
    func signUp(username: String, password: String) async throws -> String {
        return try await Auth.auth().createUser(withEmail: username, password: password).user.uid
    }
    
    func signInWithGoogle(presentingIn: UIViewController) async throws -> User? {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return nil }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingIn)

        let googleUser = result.user
        
        guard let idToken = googleUser.idToken?.tokenString else {
            return nil
        }

        let credentials = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: googleUser.accessToken.tokenString
        )
        
        // Firebase auth flow
        let authResult = try await self.signIn(with: credentials)
        
        let userId = authResult.user.uid
        let firstName = googleUser.profile?.givenName ?? ""
        let lastName = googleUser.profile?.familyName ?? ""
        let photoUrl = googleUser.profile?.imageURL(withDimension: 200)?.absoluteString
        
        let user = User(
            id: userId,
            firstName: firstName,
            lastName: lastName,
            email: authResult.user.email!,
            gender: 2,
            birthdate: nil,
            photoUrl: photoUrl
        )
        
        return user
    }
    
    private func signIn(with credentials: AuthCredential) async throws -> AuthDataResult {
        return try await Auth.auth().signIn(with: credentials)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}
