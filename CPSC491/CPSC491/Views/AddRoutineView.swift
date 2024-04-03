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
                        if item != ""
                        {
                            DataHandler().addRoutine(title: routineName, exercise: item, context: managedObjectContext)
                        }
                    }
                    if routineName != "" && routineExercises.count < 2{
                        DataHandler().addRoutineTitleOnly(title: routineName, context: managedObjectContext)
                    }
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
