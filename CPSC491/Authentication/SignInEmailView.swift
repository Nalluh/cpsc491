//
//  SignInEmailView.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import SwiftUI
import UIKit


@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""

   
    func signUp() async throws   {
        guard !email.isEmpty, !password.isEmpty else{
            print("No email or password found.")
            return
        }
        
       
            let userData = try await AuthenticationManager.shared.registerUser(email: email, password: password)
            
            print (userData)
        
    }
    
    
    func signIn() async throws   {
        guard !email.isEmpty, !password.isEmpty else{
            // add validation metrics here
            print("No email or password found.")
            return
        }
        
                let userData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                print (userData)
                    
        
    }
}


struct SignInEmailView: View {
    @Binding var showSignInView: Bool
    @StateObject private var vm = SignInEmailViewModel()
   

    
    var body: some View {
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
                        try await  vm.signUp()
                        showSignInView = false
                        return
                    }
                    catch{
                        // error handling here
                        print(error)
                    }
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
                Text("Sign up")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }

            
        }
        .navigationTitle("Sign up")
        .padding()
        Spacer()
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
