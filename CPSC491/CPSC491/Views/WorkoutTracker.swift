//
//  WorkoutTracker.swift
//  CPSC491
//
//  Created by Allan Cortes on 3/6/24.
//

import SwiftUI


struct Exercise: Identifiable {
    var id = UUID()
    var name: String
}

struct WorkoutTracker: View {
    let exercises = [
        "Push-ups",
        "Sit-ups",
        "Squats",
        "Lunges",
        "Burpees",
        "Plank",
        "Jumping Jacks",
        "Mountain Climbers",
        "Bicycle Crunches",
        "Russian Twists",
        "Bench Press",
        "Deadlifts",
        "Pull-ups",
        "Dumbbell Rows",
        "Shoulder Press",
        "Barbell Curls",
        "Tricep Dips",
        "Leg Press",
        "Leg Curls",
        "Calf Raises"
    ]
    @State private var userExercises: [Exercise] = []
    @State private var exerciseName: String = ""
    
    var body: some View {
        VStack {
                   HStack {
                       TextField("Enter exercise", text: $exerciseName)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                       Button(action: {
                           if !exerciseName.isEmpty {
                               userExercises.append(Exercise(name: exerciseName))
                               exerciseName = ""
                           }
                       }) {
                           Text("Add")
                       }
                   }
                   List {
                       ForEach(userExercises) { exercise in
                           Section(header: Text("\(exercise.name)")) {
                               Text(exercise.name)
                           }
                       }
                   }
               }
               .padding()
        /*VStack{
         
            HStack{
                Text("\(determineTitleTime(for:currentTime)) Workout")
                    .bold()
                    .font(.custom("AppleSDGothicNeo-Bold", size: 22))
            }
            // have a foreach that displays a section with user input then textfields below add if empty statement
            if !userExercises.isEmpty{
                ForEach(userExercises, id: \.self) { exercise in
                                Text(exercise)
                                    
                            
                    Section(header: exercise)
                }
            }
            Button("Add Exercises"){
                
                
                }  .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: 200)
                .background(Color.blue)
                .cornerRadius(10)
            
            
            
            
        }.padding() */
    }
        

    
    
             
    let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
    }()
             
    var currentTime: String {
    return dateFormatter.string(from: Date())
        }
             
    func determineTitleTime(for timeOfDay: String) -> String {
        var title: String
        
        switch timeOfDay {
        case "00:00 AM"..."11:59 AM":
            title = "Morning"
        case "12:00 PM"..."17:59 PM":
            title = "Afternoon"
        default:
            title = "Evening"
        }
        
        return title
    }
    
    
    
}






struct WorkoutTracker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTracker()
    }
}
