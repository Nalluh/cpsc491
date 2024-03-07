//
//  RoutineView.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/16/24.
//

import SwiftUI

struct RoutineView: View {

    @State var prev: String = ""
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }

    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<FoodInfo>

        var body: some View {
            Spacer()
            Text("Unique Dates:")
            ForEach(uniqueFood(from: food)) { food in
                Text(formattedDate(from: food.date!))
                
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
