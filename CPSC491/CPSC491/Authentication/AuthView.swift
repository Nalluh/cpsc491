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
            return
        }
                
                userAuthWork = true
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
    }
    
}



struct AuthView: View {
    @Binding var showSignInView: Bool
    @StateObject private var vm = AuthViewModel()
    @State private var errorMessage: String? = ""

    var body: some View {
        VStack{
            VStack{
                Text("Trifecta Fitness")
                    .font(Font.custom("AppleSDGothicNeo-Bold", size: 32))
                    .fontWeight(.bold)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .foregroundColor(.black)
                    .padding()
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("  Email:")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    TextField("example @email.com", text: $vm.email)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                    
                    
                    HStack {
                        Text("  Password:")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    SecureField("example", text: $vm.password)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                    
             
                    
                    Button {
                        Task{
                            do{
                                try await  vm.signIn()
                                if userAuthWork
                                {
                                    showSignInView = false
                                    return
                                }
                                errorMessage = "Please fill in all Fields"
                            }
                            catch{
                                errorMessage = error.localizedDescription
                            }
                            
                        }
                        
                    } label: {
                        Text("Sign in")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.gray, Color.black]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                            .cornerRadius(10)
                    }
                }
                
            }
            
            HStack{
                VStack{
                    Divider().padding(1).background(Color.black)
                }
                Text("OR")
                VStack{
                    Divider().padding(1).background(Color.black)
                }
            }.padding()

            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)){
                Task{
                    do{
                        try await vm.googleSignIn()
                        showSignInView = false
                    }catch{
                        errorMessage = error.localizedDescription

                    }
                }
            }.padding()
            
            NavigationLink{
               SignInEmailView(showSignInView: $showSignInView)
            }label: {
                Text("Dont have an account? Sign up")
                    .font(.headline)
                    .underline()
                    .foregroundColor(.blue)
            }
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding()
            }
                Spacer()
        }.onAppear(){
            userAuthWork = false
        }
            .padding()
   
           
       
    }
    
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AuthView(showSignInView: .constant(false))

        }
    }
}
