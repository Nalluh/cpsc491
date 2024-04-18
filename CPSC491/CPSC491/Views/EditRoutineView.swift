//
//  EditRoutineView.swift
//  CPSC491
//
//  Created by Allan Cortes on 4/1/24.
//

import SwiftUI

struct EditRoutineView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var userAddedExercise: Bool = false
    @State private var startWorkout: Bool = false
    @State private var isInitialized: Bool = false
    @State private var routineName: String = ""
    @State private var exercise: String = ""
    @State private var routineExercises: [String] = [""]
    var routine: FetchedResults<Routine>.Element
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var routineDB: FetchedResults<Routine>
    @Environment(\.presentationMode) var presentationMode
    @State private var content = ""



    var body: some View {
        // edit user entered routine
        Form{
            // display routine title
            Section("Routine Name") {
                HStack{
                    TextField("Edit Name", text: $routineName)
                }
            }.environment(\.defaultMinListRowHeight, 700)
            //display routine exercises
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
                        //UI add empty string
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
                    // remove current entry and update it with thhe new entry (including the previous ddata)
                    deleteEntry()
                    for item in routineExercises {
                        // when ever we click [ADD] the array adds an empty string for UI purposes
                        // with this we add to the db only the routine the user entered and not the empty string
                        if item != ""
                        {
                            DataHandler().addRoutine(title: routineName, exercise: item, context: managedObjectContext)
                        }
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Enter")
                })
                .frame(maxWidth: .infinity)
            }   .listRowBackground(Color.clear)

        }.onAppear()
        {
            // check if the user has opened the view for the first time
            if !isInitialized
            {
                //since its the first time we grab the routine information for display
                routineName = routine.title!
                for item in routineDB {
                    if routine.title! == item.title! {
                        if let exercise = item.exercise{
                            routineExercises.append(exercise)
                        }
                        
                    }
                }
                // we return the array backwards because the first element of the array is an empty strring
                // reversing it puts the empty string at the end, prompting the user to add additional information
                routineExercises.reverse()
            }
            else{
                routineExercises.append("")
            }
          
            // isInitialized lets us track wether the view has been opened more than once
            // solving the problem of appending to array everytinme we open the view
            isInitialized = true
            
        }
        
        .toolbar {
            // toolbar so users can copy the routine
            ToolbarItem(placement:.navigationBarTrailing){
                Button{
                    content += "Check out this Routine!\n \(routineName) \n"
                    for item in routineExercises{
                        content += " \(item)\n"
                    }
                    shareButtonTapped()
                } label: {
                    Label("New Routine", systemImage: "square.and.arrow.up")
                }
            }
            // toolbar so users can start a workout based on the routine they created
            ToolbarItem(placement:.navigationBarTrailing){
                Button{
                    routineExercises.append("")

                        // remove empty entry
                        routineExercises.removeLast()

                    
                    startWorkout = true
 
                    
                } label: {
                    Label("New Routine", systemImage: "paperplane")
                }
            }
           
        }
        NavigationLink(destination: WorkoutTracker(userExercises: $routineExercises),isActive: $startWorkout){
            

            }
        
    }
    private func deleteEntry() {
        // delete entries that correspond to the latest entry
        // * without this all entires would be deleted
           for information in routineDB {
               if routineName == information.title!
               {
                   managedObjectContext.delete(information)
               }
           }
           do {
               try managedObjectContext.save()
           } catch {
               print("Error deleting numbers: \(error)")
           }
       }
    // bring up iphone UI for copying 
    func shareButtonTapped() {
           let av = UIActivityViewController(activityItems: [content], applicationActivities: nil)
           if let viewController = UIApplication.shared.windows.first?.rootViewController {
               viewController.present(av, animated: true, completion: nil)
           }
       }
}




