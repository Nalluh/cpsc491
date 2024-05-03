//
//  TopView.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import SwiftUI
//global variable used to check if user has filled in login / sign up form
// functions used to sign in / sign up return nothing if no information is inserted
//which prompts execution of succesful login
//this variable will = true when forms are filled
//since sign in / sign up are async functions we cannot return a value.
var userAuthWork: Bool  = false

struct TopView: View {
    
    
    
    @State private var showSignInView: Bool = false
    // when app is opened we will check if authentication has occured.
    //if auth = true open home view (contentview)
    //else promopt user to sign in
    var body: some View {
        ZStack{
            NavigationStack{
                ContentView(showSignInView: $showSignInView)
            }
        }
        .onAppear() {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented:$showSignInView) {
            NavigationStack() {
                AuthView(showSignInView: $showSignInView)
            }
        }
        
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
