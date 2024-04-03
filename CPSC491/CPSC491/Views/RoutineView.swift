//
//  RoutineView.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/16/24.
//

import SwiftUI

struct RoutineView: View {
    @State private var showingAddRoutine: Bool = false
    @State private var routineNames: [String] = []
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var routine: FetchedResults<Routine>
    
        var body: some View {
            VStack(alignment: .center){
                Text("Trifecta")
                    .modifier(TextDesign())
            }
            
            
            Spacer()
            NavigationStack{
                VStack{
                    List
                    {
                        ForEach(uniqueRoutine(from: routine)) { routine in
                            // add a nav link that will send to a view to allow editing of routine
                            // also in view allow users to copy routine
                            // and pass the routine to the workout screen
                            NavigationLink(destination: EditRoutineView(routine: routine)){
                                Text(routine.title!)
                                    .font(.custom("Avenir-Heavy", size: 20))
                            }
                        }
                    }.listStyle(.plain)
                        .listRowSeparatorTint(Color.black)
                }
            }
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing){
                    Button{
                        showingAddRoutine.toggle()
                    } label: {
                        Label("New Routine", systemImage: "plus.circle")
                    }
                }
            }.sheet(isPresented: $showingAddRoutine){
                    AddRoutineView()
            }
        }
    
    func uniqueRoutine(from routine: FetchedResults<Routine>) -> [Routine] {

        var uniqueSet: Set<String> = []
        var uniqueRoutineNames: [Routine] = []
        for item in routine {
            if !uniqueSet.contains(item.title!) {
                uniqueSet.insert(item.title!)
                uniqueRoutineNames.append(item)
            }
        }
        return uniqueRoutineNames
    }

    
    }




struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineView()
    }
}
