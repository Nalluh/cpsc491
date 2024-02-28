//
//  TopView.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import SwiftUI

struct TopView: View {
    
    
    @State private var showSignInView: Bool = false
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
