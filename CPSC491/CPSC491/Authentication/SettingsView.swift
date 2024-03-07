//
//  SettingsView.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import SwiftUI


@MainActor
final class SettingsViewModel: ObservableObject{
    
    func logOut() throws   {
       try AuthenticationManager.shared.signOut()
    }
    
    func resetPass() async throws {
        
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = user.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    
    func resetEmail() async throws {
        let Email = "test@testing.com"

       try  await AuthenticationManager.shared.updateEmail(email: Email)
    }
    
}



struct SettingsView: View {
    
    @StateObject private var vm = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        List{
            Button("Log out"){
                Task{
                    do{
                        try vm.logOut()
                        showSignInView = true
                    }catch{
                        
                    }
                }
            }
            Section(content: {
                Button("Reset Password"){
                    Task{
                        do{
                            try await vm.resetPass()
                            print("pass reset sent")
                            }catch{
                            
                        }
                    }
                }
             
                Button("Update Email"){
              
                    Task{
                        do{
                            try await vm.resetEmail()
                            print("email reset sent")
                        }catch{
                            print(error)
                        }
                    }
                }
            }, header: {
                Text("Account Options")
            })
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SettingsView(showSignInView: .constant(false))
            

        }
    }
}

