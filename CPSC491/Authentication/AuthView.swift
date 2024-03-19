//
//  AuthView.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth


struct googleSignInModel {
    let idToken: String
    let accessToken: String
}
@MainActor
final class AuthViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws   {
        guard !email.isEmpty, !password.isEmpty else{
            // add validation metrics here
            print("No email or password found.")
            return
        }
        
                let userData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                print (userData)
                    
        
    }
    
    func googleSignIn() async throws{
        guard let topView = Utilities.shared.topViewController() else {
            throw URLError(.cancelled)
        }
        
        let signIn = try await GIDSignIn.sharedInstance.signIn(withPresenting: topView)
        
        guard  let idToken: String = signIn.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = signIn.user.accessToken.tokenString
        
        let tokens = googleSignInModel(idToken: idToken, accessToken: accessToken)
        
        
        try await AuthenticationManager.shared.googleSignIn(tokens: tokens)
       // let cred = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    }
    
}



struct AuthView: View {
    @Binding var showSignInView: Bool
    @StateObject private var vm = AuthViewModel()
    var body: some View {
        VStack{
            VStack{
                TextField("Email:", text:$vm.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                
                
                SecureField("Password:", text:$vm.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Button {
                    Task{
                        do{
                          try await  vm.signIn()
                          showSignInView = false
                          return
                        }
                        catch{
                            print(error)

                                // error handling here
                        }
                        
                    }
                    
                } label: {
                    Text("Sign in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                }

                
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)){
                Task{
                    do{
                        try await vm.googleSignIn()
                        showSignInView = false
                    }catch{
                        
                    }
                }
            }
            
            NavigationLink{
               SignInEmailView(showSignInView: $showSignInView)
            }label: {
                Text("Dont have an account? Sign up")
                    .font(.headline)
                    .underline()
                    .foregroundColor(.blue)
            }
            
                Spacer()
        }
        
            .padding()
            .navigationTitle("Sign In ")
       
    }
    
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AuthView(showSignInView: .constant(false))

        }
    }
}
