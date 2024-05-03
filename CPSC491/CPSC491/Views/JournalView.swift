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
    @State var cal: Double = 0
    @State var foodName: String = ""
    @State var foodMT: String = ""
    @State var formattedFoodDate: String = ""
    @State private var prevDate: String = ""
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var food:FetchedResults<FoodInfo>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var userInfo:FetchedResults<UserInfo>
    @State private var showingAddFood = false
    @State var dateSet: Set<String> = Set()
    private var allowEdits: Bool = true


    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter
    }()
    
    let dateFormatterForSearchBar: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd yyyy"
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
                        
                        Text(String(formattedCurrentDate))
                            .font(.system(size: 12))
                            .modifier(TextDesign())
                    }
                   // display food with breakfast specification
                    List {
                        Section(header: Text("Breakfast")){
                            // look at all entitys
                            ForEach(food) { food in
                                
                                var formattedFoodDate: String {
                                    return dateFormatter.string(from: food.date!)
                                }
                                // if the entity has a date that matches the current date
                                // we will check for its meal type
                                if formattedFoodDate == formattedCurrentDate { //verify date to show current day only
                                    // if meal type are equal than the entity belongs here
                                    // display food
                                    if food.mealType! == "Breakfast"{
                                        // allow navigation to food information ie. cals protein etc
                                        NavigationLink(destination: FoodInfoView(food:food,allowEdits:allowEdits)){
                                            HStack{
                                                // display food name
                                                VStack(alignment: .leading){
                                                    if let name = food.name {
                                                        Text(name)
                                                            .bold()
                                                    }
                                                    // below show the calories
                                                    Text("\(Int(food.cal))")  + Text(" calories").foregroundColor(.red)
                                                    
                                                }
                                                Spacer()
                                                
                                                // show time of when it was submitted
                                                Text(getTime(date:food.date!))
                                                    .foregroundColor(.gray)
                                                    .italic()
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }// date format check
                                
                                // to delete entrys
                            }.onDelete(perform: deleteFood)
                            
                            // rest of the code performs the same
                            // with just checks for date and mealtype
                            
                            
                        }
                        // display food with lunch specification

                        Section(header: Text("Lunch")){
                            
                            ForEach(food) { food in
                                
                                var formattedFoodDate: String {
                                    return dateFormatter.string(from: food.date!)
                                }
                                if formattedFoodDate == formattedCurrentDate { //verify date to show current day only
                                    if food.mealType! == "Lunch"{
                                        NavigationLink(destination: FoodInfoView(food:food,allowEdits:allowEdits)){
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
                        // display food with dinner specification

                        Section(header: Text("Dinner")){
                            
                            ForEach(food) { food in
                                
                                var formattedFoodDate: String {
                                    return dateFormatter.string(from: food.date!)
                                }
                                if formattedFoodDate == formattedCurrentDate { //verify date to show current day only
                                    if food.mealType! == "Dinner"{
                                        NavigationLink(destination: FoodInfoView(food:food,allowEdits:allowEdits)){
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
                        // UI
                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listStyle(.plain)
                        .searchable(text: $search) {
                                ForEach(uniqueFood(from: food)) { food in
                                    let foodDateSearchBar = dateFormatterForSearchBar.string(from:food.date!)
                                    let foodDate = dateFormatter.string(from:food.date!)
                                    // if search has no input show entire list on entries
                                    if search.isEmpty
                                    {
                                        NavigationLink(destination: FoodDayView(viewingDate:foodDate)){
                                        Text(foodDateSearchBar)
                                       }
                                    }
                                    // else show entries corresponding to what the user has type eg. fr will return all entries with day friday
                                    else if foodDateSearchBar.localizedCaseInsensitiveContains(search){
                                        NavigationLink(destination: FoodDayView(viewingDate:foodDate)){
                                            Text(foodDateSearchBar)
                                        }
                                        
                                    }

                                }
                            
                    }
                        
                
                }// Top of view with edit and add buttons
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
        
    
        
    

 // convert entities in db to a set for display
    func uniqueFood(from food: FetchedResults<FoodInfo>) -> [FoodInfo] {
        func formattedDate(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            return formatter.string(from: date)
        }
        var uniqueSet: Set<String> = []
        var uniqueFoodItems: [FoodInfo] = []
        for item in food {
            let formattedDate = formattedDate(from: item.date!)
            if !uniqueSet.contains(formattedDate) {
                uniqueSet.insert(formattedDate)
                uniqueFoodItems.append(item)
            }
        }
        return uniqueFoodItems
    }

    // remove entites
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0]}.forEach(managedObjectContext.delete)
            DataHandler().save(context: managedObjectContext)
        }
        
        
    }
    
    // get calories for today
    private func calsToday() -> Double {
        var calToday : Double = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!){
                calToday += item.cal
            }
        }
        return calToday
    }
    
    // get user set calorie goal 
    private func getCalGoal() -> Float {
        var calGoal: Float = 0
        for usr in userInfo {
            if let goal = Float(usr.calGoal!){
                calGoal += goal
            }
        }
        return calGoal
    }
    
  
    
}


struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
