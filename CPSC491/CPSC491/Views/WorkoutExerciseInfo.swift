//
//  WorkoutExerciseInfo.swift
//  CPSC491
//
//  Created by Allan Cortes on 3/7/24.
//

import SwiftUI




struct WorkoutExerciseInfo: View {
    @State private var counter:Int = 0
    @State private var exerciseCount:Int = 0
    @State private var recentDate:String = ""
    @State  var exerciseName:String
    @State private var sets: [(weight: String, reps: String)] = [(weight: "", reps: "")]
    @State private var isInitialized: Bool = false
    @State private var userAddedSet: Bool = false
    @State private var getDate: Bool = false


    
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }
    var currentDate: String {
        return dateFormatter.string(from: Date())
    }
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var userExerciseInfo: FetchedResults<GymInfo>

    
    var body: some View {

        Text("\(exerciseName)") .font(.custom("AppleSDGothicNeo", size: 22))

       
       
                   List {
                       //display information
                       ForEach(sets.indices, id: \.self) { index in
                           Section(header: Text("Set \(index + 1)").foregroundColor(.blue)                                       .font(.custom("AppleSDGothicNeo-Bold", size: 18))
) {
                               HStack {
                                   Text("Weight:")
                                       .foregroundColor(.primary)
                                       .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                                   TextField("", text: $sets[index].weight)
                                       .padding(.vertical, 8)
                                       .padding(.horizontal, 10)
                                       .background(Color.secondary.opacity(0.1))
                                       .cornerRadius(8)
                                   Text("Reps:")
                                       .foregroundColor(.primary)
                                       .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                                   TextField("", text: $sets[index].reps)
                                       .padding(.vertical, 8)
                                       .padding(.horizontal, 10)
                                       .background(Color.secondary.opacity(0.1))
                                       .cornerRadius(8)
                                
                                    }
                               .onAppear(){
                                   if !isInitialized {

                                       for ex in userExerciseInfo {
                                           // find match for exercise name
                                           if exerciseName == ex.name!{
                                               // get date of most recent entry
                                               if getDate == false
                                               {
                                                   recentDate = formattedDate(from: ex.date!)
                                                   getDate = true
                                               }
                                               // if entry in db has date that is not from the most recent do not show it
                                               if formattedDate(from: ex.date!) == recentDate
                                               {
                                                   if let total = Int(ex.setTotal!){
                                                       exerciseCount = total
                                                   }
                                                   
                                                  //append to display array the information from db
                                                   if counter != exerciseCount{
                                                       // since the array[0] is initialized above we need to reasign value to avoid a blank entry
                                                       if counter == 0{
                                                           sets[0].weight = ex.weight!
                                                           sets[0].reps = ex.reps!
                                                       }
                                                       else{
                                                           sets.append((weight: ex.weight!, reps: ex.reps!))
                                                       }
                                                       counter += 1
                                                   }

                                                       
                                               }
                                                   
                                               isInitialized = true

                                           }
                                           
                                       }
                                       if isInitialized // if exercise is in db we show it on screen but we appended
                                      {                 // in descending order so we need to reverse it
                                           sets.reverse()// without this check everytime the user adds a new entry the set is reversed
                                                         // thus adding blank entries to the start of the array
                                      }
                                   }

                               }//appear
                            
                           }
                      
                        
                       }.onDisappear(){
                           // isInitialized == false means that the exercise has not been added to the db before
                           if userAddedSet && isInitialized == false
                           {
                               // get sets array and add them to db
                               for index in sets.indices {
                                   // everytime the user adds a new row the array appends a blank place holder
                                   // add to entries to db but not the placeholder
                                   if sets[index].weight != "" && sets[index].reps != "" {
                                       DataHandler().addExercise(name: exerciseName, Reps: sets[index].reps, Weight: sets[index].weight, Total: String(sets.count), context: managedObjectContext)
                                   }
                               }
                           }
                           // isInitialized == true means that the exercise is in the db
                           if isInitialized == true && userAddedSet {
                               deleteEntry() // delete entries so that we can add the new ones
                               for index in sets.indices {
                                   if sets[index].weight != "" && sets[index].reps != "" {
                                       DataHandler().addExercise(name: exerciseName, Reps: sets[index].reps, Weight: sets[index].weight, Total: String(sets.count), context: managedObjectContext)
                                   }
                                   
                               }

                           }
                     
                           
                       }
                       Button(action: {
                           userAddedSet = true
                           sets.append((weight: "", reps: ""))
                       }) {
                           HStack {
                               Image(systemName: "plus")
                               Text("Add")
                           }
                           .foregroundColor(.blue)
                       }
                       .listStyle(.automatic)
                       .listRowBackground(Color.clear)
                   }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listStyle(.plain) //list
                   
               }
        
    private func deleteEntry() {
        // delete entries that correspond to the latest entry
        // * without this all entires would be deleted
           for information in userExerciseInfo {
               if formattedDate(from: information.date!) == recentDate
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
        }
    


struct WorkoutExerciseInfo_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutExerciseInfo(exerciseName: "")
    }
}
