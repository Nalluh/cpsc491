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
            
            // display routines that user has created
            Spacer()
            NavigationStack{
                VStack{
                    List
                    {
                        ForEach(uniqueRoutine(from: routine)) { routine in
                            // allow user to click the routine title
                            // they will be taken to another view for modifications to the routine
                            NavigationLink(destination: EditRoutineView(routine: routine)){
                                Text(routine.title!)
                                    .font(.custom("Avenir-Heavy", size: 20))
                            }
                        }.onDelete(perform: deleteRoutine)

                        // UI
                    }.listStyle(.plain)
                        .listRowSeparatorTint(Color.black)
                }
            } // UI ---- allows for user to create more routines
            .toolbar {
                ToolbarItem(placement:.navigationBarTrailing){
                    Button{
                        showingAddRoutine.toggle()
                    } label: {
                        Label("New Routine", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }.sheet(isPresented: $showingAddRoutine){
                    AddRoutineView()
            }
        }
    
    
    // get a set of routines 
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
    
    // remove entites
    private func deleteRoutine(offsets: IndexSet) {
        withAnimation {
            offsets.map { uniqueRoutine(from: routine)[$0]}.forEach(managedObjectContext.delete)
            DataHandler().save(context: managedObjectContext)
        }
        
        
    }

    
    }




struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineView()
    }
}
