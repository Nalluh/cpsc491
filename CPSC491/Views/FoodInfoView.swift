//
//  FoodInfoView.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/27/24.
//

import SwiftUI

struct FoodInfoView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    var food: FetchedResults<FoodInfo>.Element
    var allowEdits: Bool

    
    @State var cal: Double = 0
    @State var foodName: String = ""
    @State var foodProtein:  String = ""
    @State var foodCarb:  String = ""
    @State var foodFat: String = ""

    var body: some View {
        Form{
            Section{
                if allowEdits{
                HStack{
                    TextField("Name", text: $foodName)
                    TextField("Protein", text:$foodProtein)
                    
                }
                HStack{
                    TextField("Carb", text: $foodCarb)
                    TextField("Fat", text: $foodFat)
                    
                }
                    .onAppear{
                        foodName = food.name!
                        cal = food.cal
                        foodProtein = food.protein!
                        foodCarb = food.carb!
                        foodFat = food.fat!
                    }
                    VStack{
                        
                        Text("Calories: \(Int(cal))")
                        Slider(value: $cal, in: 0...1000, step:10)
                     }
                    }
                    else{
                        HStack{
                            Text("\(foodName)")
                            Spacer()
                            Text("Protein: ").italic() + Text ("\(foodProtein)")

                        }
                        HStack{
                            Text("Carb: ").italic() + Text ("\(foodCarb)")
                            Spacer()
                            Text("Fat: ").italic() + Text ("\(foodFat)")
                        }
                            .onAppear{
                                foodName = food.name!
                                cal = food.cal
                                foodProtein = food.protein!
                                foodCarb = food.carb!
                                foodFat = food.fat!
                            }
                        VStack{
                            Text("Calories: \(Int(cal))")
                            Slider(value: $cal, in: 0...1000, step:10)
                                .disabled(true)
                        }
                    }
                }
                .padding()
            if allowEdits {
                HStack{
                    Spacer()
                    
                        Button("Submit"){
                            
                            DataHandler().editFood(food: food, name: foodName, cal: cal, protein:foodProtein, carb:foodCarb, fat:foodFat,context: managedObjectContext)
                            dismiss()
                        }
                        Spacer()
                    }
                    
                }//
            }
        }
    }

    

