//
//  SummaryView.swift
//  CPSC491
//
//  Created by Allan Cortes on 3/19/24.
//

import SwiftUI

struct SummaryView: View {
    @State var userExercises: [String]
    @State private var animateText = false
    @State private var borderHeight: CGFloat = 0
    @State var stopWatch: TimeInterval

    var body: some View {
    
            VStack {
                        if animateText {
                            Text("Good Job!")
                                .font(.custom("Avenir-Heavy", size: 32))
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                                .transition(.scale)
                                .animation(.easeInOut(duration: 5.0))
                                .padding(10)
                        }
    
            Text("Workout Summary")
                .font(.custom("Avenir Oblique", size: 26))
                .padding(.bottom, 10)
            VStack {
        

                       VStack(spacing: 10) {
                           ForEach(userExercises, id: \.self) { ex in
                               Text(ex)
                           }
                               .font(.custom("Avenir Book", size: 20))
                               .fixedSize(horizontal: true, vertical: false)
                               .padding(.bottom, 5)

                           
                            
                       }
            
                           }
                           .padding(.horizontal, 150)
                          
                HStack
                {
                    Text("Workout Length")
                                .font(.custom("Avenir Heavy", size: 22))
                                .padding(.trailing)
                            Text("\(timeFormatted(stopWatch))")
                                .font(.custom("Avenir Book", size: 20))
                } .padding(.horizontal, 10)
            Spacer()
            } .padding()
            .onAppear {
             
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        animateText.toggle()
                    }
                    
                }
                    
                }
    }
    private func timeFormatted(_ totalSeconds: TimeInterval) -> String {
         let seconds = Int(totalSeconds) % 60
         let minutes = Int(totalSeconds) / 60
         return String(format: "%02d:%02d", minutes, seconds)
     }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(userExercises:[], stopWatch: 0)
    }
}
