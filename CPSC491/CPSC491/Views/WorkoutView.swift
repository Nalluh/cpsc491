//
//  WorkoutView.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/16/24.
//

import SwiftUI

struct WorkoutView: View {

    @StateObject private var vm = timerViewModel()
    private let  timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var startWorkout:Bool = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning = false
    var body: some View {
        Spacer()
        
        Button("Start Workout!"){
            startWorkout.toggle()
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(height: 55)
        .frame(maxWidth: 200)
        .background(Color.blue)
        .cornerRadius(10)
        .sheet(isPresented: $startWorkout) {
            WorkoutTracker()
        }
    }
        
    }

    
    



    
    
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
