//
//  JournalView.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/16/24.
//

import SwiftUI
import CoreData



struct JournalView: View {
  
    @State var search: String = ""
    @State var calGoal: Int = 3000
    @State var cal: Double = 0
    @State var foodName: String = ""
    @State var testing: String = "02-25-2022"
    @State var foodMT: String = ""


    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var food:FetchedResults<FoodInfo>
    @State private var showingAddFood = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter
    }()
    
    var formattedCurrentDate: String {
        return dateFormatter.string(from: Date())
    }
   
    
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .trailing) {
                    HStack{
                        Text("Calories \(Int(calsToday()))  /  \(calGoal)")
                            .modifier(TextDesign())
                            .font(.system(size: 14))
                        
                        Text(String(formattedCurrentDate))
                            .font(.system(size: 12))
                            .modifier(TextDesign())
                    }
                    List {
                        Section(header: Text("Breakfast")){
                                ForEach(food) { food in
                                    var formattedFoodDate: String {
                                        return dateFormatter.string(from: food.date!)
                                    }
                                    if formattedFoodDate == formattedCurrentDate { //verify date to show current day only
                                        if food.mealType! == "Breakfast"{
                                            
                                            NavigationLink(destination: FoodInfoView(food:food)){
                                                HStack{
                                                    VStack(alignment: .leading){
                                                        if let name = food.name {
                                                            Text(name)
                                                                .bold()
                                                        }
                                                        Text("\(Int(food.cal))")  + Text(" calories").foregroundColor(.red)
                                                        
                                                    }
                                                    Spacer()
                                                    
                                                    
                                                    Text(getTime(date:food.date!))
                                                        .foregroundColor(.gray)
                                                        .italic()
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }// date format check
                                    
                                    
                                }.onDelete(perform: deleteFood)
                                
                                
                           
                            
                        }
                        Section(header: Text("Lunch")){
                          
                                ForEach(food) { food in
                                    
                                    var formattedFoodDate: String {
                                        return dateFormatter.string(from: food.date!)
                                    }
                                    if formattedFoodDate == formattedCurrentDate { //verify date to show current day only
                                        if food.mealType! == "Lunch"{
                                            NavigationLink(destination: FoodInfoView(food:food)){
                                                HStack{
                                                    VStack(alignment: .leading){
                                                        if let name = food.name {
                                                            Text(name)
                                                                .bold()
                                                        }
                                                        Text("\(Int(food.cal))")  + Text(" calories").foregroundColor(.red)
                                                        
                                                    }
                                                    Spacer()
                                                    
                                                    
                                                    Text(getTime(date:food.date!))
                                                        .foregroundColor(.gray)
                                                        .italic()
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }// date format check
                                    
                                    
                                }.onDelete(perform: deleteFood)
                                
                                
                           
                            
                        }
                        Section(header: Text("Dinner")){
                            
                                ForEach(food) { food in
                                    
                                    var formattedFoodDate: String {
                                        return dateFormatter.string(from: food.date!)
                                    }
                                    if formattedFoodDate == formattedCurrentDate { //verify date to show current day only
                                        if food.mealType! == "Dinner"{
                                            NavigationLink(destination: FoodInfoView(food:food)){
                                                HStack{
                                                    VStack(alignment: .leading){
                                                        if let name = food.name {
                                                            Text(name)
                                                                .bold()
                                                        }
                                                        Text("\(Int(food.cal))")  + Text(" calories").foregroundColor(.red)
                                                        
                                                    }
                                                    Spacer()
                                                    
                                                    
                                                    Text(getTime(date:food.date!))
                                                        .foregroundColor(.gray)
                                                        .italic()
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }// date format check
                                    
                                    
                                }.onDelete(perform: deleteFood)
                                
                                
                          
                            
                        }
                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    
                }
                .toolbar {
                    ToolbarItem(placement:.navigationBarTrailing){
                        Button{
                            showingAddFood.toggle()
                        } label: {
                            Label("AddFood", systemImage: "plus.circle")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        EditButton()
                    }
                }.sheet(isPresented: $showingAddFood){
                    AddFoodView()
                }
            }
            .navigationViewStyle(.stack)
            
        }
        
        
    }
    
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0]}.forEach(managedObjectContext.delete)
                DataHandler().save(context: managedObjectContext)
            }
        
        
    }
    private func calsToday() -> Double {
        var calToday : Double = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!){
                calToday += item.cal 
            }
        }
        return calToday
    }
}


struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
