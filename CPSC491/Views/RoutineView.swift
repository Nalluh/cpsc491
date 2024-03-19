//
//  RoutineView.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/16/24.
//

import SwiftUI

struct RoutineView: View {

    @State var c: Int = -1
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<FoodInfo>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var userExerciseInfo: FetchedResults<GymInfo>
    
        var body: some View {
            Text("test")
            

            Spacer()
            Text("Unique Dates:")
            List
            {
                ForEach(userExerciseInfo) { ex in
                    if ex.name! == "testing"
                        {
                        let exDate = formattedDate(from: ex.date!)
                            HStack
                            {
                                Text("\(c)")
                                Text(ex.name!)
                                Text(ex.reps!)
                                Text(ex.weight!)
                                Text(ex.setTotal!)
                                Text(exDate)
                                
                               
                            }
                
                        }
                    
                }
            }
        }
    
    
        func uniqueFood(from food: FetchedResults<FoodInfo>) -> [FoodInfo] {
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
    }




struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineView()
    }
}
