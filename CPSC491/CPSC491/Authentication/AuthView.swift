//
//  AuthView.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import SwiftUI

struct AuthView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            NavigationLink{
               SignInEmailView(showSignInView: $showSignInView)
            }label: {
                Text("Sign up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            
            
        }
            .padding()
            .navigationTitle("Sign up ")
        Spacer()
    }
    
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AuthView(showSignInView: .constant(false))

        }
    }
}
