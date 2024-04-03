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
    @State private var userUpdateCals: Bool = false
    @State private var goal  = ""
    @State private var calGoal:Int  = 0
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var userInfo:FetchedResults<UserInfo>
    @Environment(\.managedObjectContext) var managedObjectContext


    
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
            Section(content: {
                Button("Update Calorie Goal"){
                    userUpdateCals.toggle()
                }   .alert("Update Calorie Goal", isPresented: $userUpdateCals) {
                    VStack {
                        TextField("New Calorie Goal", text: $goal)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        Button("OK") {
                            if let calGoal = Int(goal)
                                {
                                  if calGoal  > 0 {
                                    deleteGoal()
                                    DataHandler().setCalGoal(goal: goal, context: managedObjectContext)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }, header: {
                Text("User Options")
                
            })
            .navigationTitle("Settings")
        }
    }
    private func deleteGoal() {
           for users in userInfo {
               managedObjectContext.delete(users)
           }
           do {
               try managedObjectContext.save()
           } catch {
               print("Error deleting numbers: \(error)")
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

