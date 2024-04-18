//
//  AddRoutineView.swift
//  CPSC491
//
//  Created by Allan Cortes on 3/25/24.
//

import SwiftUI

struct AddRoutineView: View {
    @State private var userAddedExercise: Bool = false
    @State private var routineName: String = ""
    @State private var routineExercises: [String] = [""]
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss

    
    
    var body: some View {
            // add routines into entity db
        Form{
            Section("Routine Name") {
                HStack{
                    TextField("Add Name", text: $routineName)
                }
            }.environment(\.defaultMinListRowHeight, 700)
            
            Section(content: {
                ForEach(routineExercises.indices, id: \.self) { index in
                    TextField("Exercise", text: $routineExercises[index])
                }
                
            }, header:{
                HStack{
                    Text("Add Exercises")
                    Spacer()
                    Button(action: {
                     //    when ever we click [ADD] the array adds an empty string for UI purposes <-------------- happens here
                        userAddedExercise = true
                        routineExercises.append("")
                    }) {
                        HStack {
                            Image(systemName: "plus")
                        }
                        .foregroundColor(.blue)
                    }
                }
            })
            Section{
                Button(action: {
                    for item in routineExercises {
                        // when ever we click [ADD] the array adds an empty string for UI purposes
                        // with this we add to the db only the exercises the user entered and not the empty string
                        if item != ""
                        {
                            DataHandler().addRoutine(title: routineName, exercise: item, context: managedObjectContext)
                        }
                    }
                    // handles case were user only submitted a routine title and no exercises
                    if routineName != "" && routineExercises.count < 2{
                        DataHandler().addRoutineTitleOnly(title: routineName, context: managedObjectContext)
                    }
                    // close view on submit
                    dismiss()
                }, label: {
                    Text("Enter")
                })
                .frame(maxWidth: .infinity)
            }   .listRowBackground(Color.clear)

        }
       

        
    }
        
    }


struct AddRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutineView()
    }
}
