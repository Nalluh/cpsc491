//
//  FoodDayView.swift
//  CPSC491
//
//  Created by Allan Cortes on 3/5/24.
//

import SwiftUI

struct FoodDayView: View {
    
    @State var viewingDate: String
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var food:FetchedResults<FoodInfo>
     var allowEdits: Bool = false
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter
    }()
    
    var body: some View {
                List {
                    Section(header: Text("Breakfast")){
                        ForEach(food) { food in
                            
                            var formattedFoodDate: String {
                                return dateFormatter.string(from: food.date!)
                            }
                            if(formattedFoodDate == viewingDate){
                                if food.mealType! == "Breakfast"{
                                    
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
                            
                            
                        }
                        
                        
                        
                        
                    }
                    Section(header: Text("Lunch")){
                        
                        ForEach(food) { food in
                            
                            var formattedFoodDate: String {
                                return dateFormatter.string(from: food.date!)
                            }
                            if formattedFoodDate == viewingDate { //verify date to show current day only
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
                            
                            
                        }
                        
                        
                        
                        
                    }
                    Section(header: Text("Dinner")){
                        
                        ForEach(food) { food in
                            
                            var formattedFoodDate: String {
                                return dateFormatter.string(from: food.date!)
                            }
                            if formattedFoodDate == viewingDate { //verify date to show current day only
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
                            
                            
                        }
                        
                        
                        
                        
                    }
                }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listStyle(.sidebar)
            
                
            }
            
            
            
            
        }
        

struct FoodDayView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDayView(viewingDate: "")
    }
}
