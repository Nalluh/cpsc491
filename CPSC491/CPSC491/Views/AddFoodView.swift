//
//  AddFoodView.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/23/24.
//

import SwiftUI



struct AddFoodView: View {
    @State var cal: Double = 0
    @State var foodName: String = ""
    @State var foodProtein:  String = ""
    @State var foodCarb:  String = ""
    @State var foodFat: String = ""
    @State var foodMT: String = ""

    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    var currentTime: String {
        
        return dateFormatter.string(from: Date())
    }
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form{
            Section{
                HStack{
                    TextField("Name", text: $foodName)
                    TextField("Protein", text:$foodProtein)
                    
                }
                HStack{
                    TextField("Carb", text: $foodCarb)
                    TextField("Fat", text: $foodFat)
                }
                VStack{
                    Text("Calories: \(Int(cal))")
                    Slider(value: $cal, in: 0...1000, step: 1)
                }.padding(10)
                HStack{
                    Spacer()
                    Button("Enter"){
                        foodMT = determineMealTime(for: currentTime)
                        DataHandler().addFood(name: foodName, cal: cal,protein: foodProtein,carb: foodCarb,fat: foodFat ,mealType:foodMT,context: managedObjectContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
    
    func determineMealTime(for timeOfDay: String) -> String {
        var foodMT: String
        
        switch timeOfDay {
        case "00:00 AM"..."11:59 AM":
            foodMT = "Breakfast"
        case "12:00 PM"..."17:59 PM":
            foodMT = "Lunch"
        default:
            foodMT = "Dinner"
        }
        
        return foodMT
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
