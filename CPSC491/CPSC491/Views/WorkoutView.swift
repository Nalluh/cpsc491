//
//  WorkoutView.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/16/24.
//

import SwiftUI

struct WorkoutView: View {
    
    @State var workoutTemplateNum: Int = 0
    private let  timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var startWorkout:Bool = false
    @State private var elapsedTime: TimeInterval = 0
    @State var userExercises: [String] = []
    // example routines
    let fullBodyExercises = [
         "Burpee",
         "Squat",
         "Deadlift",
         "Push-up",
         "Pull-up"
     ]
     
     let upperBodyExercises = [
         "Bench Press",
         "Shoulder Press",
         "Bent Over Row",
         "Tricep Dip",
         "Bicep Curl"
     ]
     
     let lowerBodyExercises = [
         "Squat",
         "Deadlift",
         "Lunges",
         "Leg Press",
         "Calf Raise"
     ]
     
     let coreExercises = [
         "Plank",
         "Russian Twists",
         "Leg Raises",
         "Crunches",
         "Mountain Climbers"
     ]
    
    var body: some View {
        VStack(alignment: .center){
            Text("Trifecta")
                .modifier(TextDesign())
        }
        Spacer()
        //header
        VStack {
            Text("Example Workouts:")
                .font(.custom("Avenir Oblique", size: 26))
            // show example routines
            HStack {
                VStack {
                    
                    Text("Full Body")
                        .font(.custom("Avenir Heavy", size: 22))
                    GroupBox {
                        Button(action: {
                            // user clicked this exmaple so we assign it to use in workoutview
                            userExercises = upperBodyExercises
                            startWorkout.toggle()
                        }) {
                            VStack {
                                Text("\(fullBodyExercises[0])").padding(.vertical, 1)
                                Text("\(fullBodyExercises[1])").padding(.vertical, 1)
                                Text("\(fullBodyExercises[2])").padding(.vertical, 1)
                                Text("\(fullBodyExercises[3])").padding(.vertical, 1)
                                Text("\(fullBodyExercises[4])").padding(.vertical, 1)
                            }
                            .font(.custom("Avenir", size: 16))
                            .frame(width: 150, height: 150)

                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button style
                    }
                }
                
                VStack {
                    Text("Upper Body")
                        .font(.custom("Avenir Heavy", size: 22))

                    GroupBox {
                        Button(action: {
                            // user clicked this exmaple so we assign it to use in workoutview
                            userExercises = upperBodyExercises
                            startWorkout.toggle()
                        }) {
                            VStack {
                                Text("\(upperBodyExercises[0])").padding(.vertical, 1)
                                Text("\(upperBodyExercises[1])").padding(.vertical, 1)
                                Text("\(upperBodyExercises[2])").padding(.vertical, 1)
                                Text("\(upperBodyExercises[3])").padding(.vertical, 1)
                                Text("\(upperBodyExercises[4])").padding(.vertical, 1)
                            }
                            .font(.custom("Avenir", size: 16))

                            .frame(width: 150, height: 150) // Fixed size frame
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button style
                    }
                }
            }
            .padding(5)
            
            HStack {
                VStack {
                    Text("Lower Body")
                        .font(.custom("Avenir Heavy", size: 22))

                    
                    GroupBox {
                        Button(action: {
                            // user clicked this exmaple so we assign it to use in workoutview
                            userExercises = lowerBodyExercises
                            startWorkout.toggle()
                        }) {
                            VStack {
                                Text("\(lowerBodyExercises[0])").padding(.vertical, 1)
                                Text("\(lowerBodyExercises[1])").padding(.vertical, 1)
                                Text("\(lowerBodyExercises[2])").padding(.vertical, 1)
                                Text("\(lowerBodyExercises[3])").padding(.vertical, 1)
                                Text("\(lowerBodyExercises[4])").padding(.vertical, 1)
                            }
                            .font(.custom("Avenir", size: 16))
                            .frame(width: 150, height: 150) // Fixed size frame
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button style
                    }
                }
                VStack {
                    Text("Core")
                        .font(.custom("Avenir Heavy", size: 22))

                    GroupBox {
                        Button(action: {
                            // user clicked this exmaple so we assign it to use in workoutview

                            userExercises = coreExercises
                            startWorkout.toggle()
                        }) {
                            VStack {
                                Text("\(coreExercises[0])").padding(.vertical, 1)
                                Text("\(coreExercises[1])").padding(.vertical, 1)
                                Text("\(coreExercises[2])").padding(.vertical, 1)
                                Text("\(coreExercises[3])").padding(.vertical, 1)
                                Text("\(coreExercises[4])").padding(.vertical, 1)
                            }
                            .font(.custom("Avenir", size: 16))
                            .frame(width: 150, height: 150) // Fixed size frame
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button style
                    }
                }
                
            }
            .padding()
            
            Button("Start Workout!"){
                userExercises = []
                startWorkout.toggle()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 40)
            .frame(maxWidth: 200)
            .background(Color.blue)
            .cornerRadius(10)
            // switch view
            NavigationLink(destination: WorkoutTracker(userExercises: $userExercises),isActive: $startWorkout){
            }.hidden()
                
                
            }
            
            
        }
    }


    
    



    
    
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
