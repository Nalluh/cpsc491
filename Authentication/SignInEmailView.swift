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
    @State private var errorMessage: String? = ""
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        Spacer().frame(height: 5)
            Text("Trifecta Fitness")
                .font(Font.custom("AppleSDGothicNeo-Bold", size: 32))
                .fontWeight(.bold)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                .foregroundColor(.black)
                .padding()
        Text("Create an account below")
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(.secondary)

        VStack(spacing: 20) {

            VStack(alignment: .leading, spacing: 10) {
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
                
            }.padding()

            Button(action: {
                Task {
                    do {
                        try await vm.signUp()
                        if userAuthWork
                        {
                            showSignInView = false
                            return
                        }
                        errorMessage = "Please fill in all Fields"
                    } catch {
                        errorMessage = error.localizedDescription
                    }

                   /* do {
                        try await vm.signIn()
                        showSignInView = false
                        return
                    } catch {
                        errorMessage = error.localizedDescription
                    }*/
                }
            }) {
                Text("Sign up")
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
            .padding(.horizontal)
            
            
            Button{
                self.presentationMode.wrappedValue.dismiss()
            }label: {
                Text("Already have an account? ")
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
        .navigationBarBackButtonHidden()
    }
    }


struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
