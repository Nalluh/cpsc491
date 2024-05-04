//
//  ContentView.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import SwiftUI
import CoreMotion



struct ContentView: View {
    @Binding var showSignInView: Bool 
    @State private var selectedTab: Tab = .home
    @State private var showingSettings = false
    @State private var progressVal : Float = 3.4
    @State private var streakValue: Int = 0
    @State var streakStatus: String = ""
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
   @Environment(\.managedObjectContext) var managedObjectContext
   @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var userInfo:FetchedResults<UserInfo>
   @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var food:FetchedResults<FoodInfo>

    let dateFormatterContent: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var currentDay: String {
        return dateFormatterContent.string(from: Date())
    }
    
    
      enum Tab {
          case home, journal, workout, routine , chat
      }


    
    var body: some View {

        VStack {
            
            switch selectedTab {
            case .home:
                HStack {
                    Spacer()
                    VStack(alignment: .center){
                        Text("       Trifecta")
                            .modifier(TextDesign())
                    }
                    
                    Spacer()
                    Button(action: {
                        self.showingSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .padding(10)
                    }
                    
                }
                
                VStack(alignment: .center){
                    VStack(alignment: .center, spacing: -50){
                        
                        ProgressBar(progress: $progressVal)
                        
                            .frame(width: 300.0, height: 300.0)
                            .padding(80.0).onAppear(){
                                
                                progressVal = calsToday() / getCalGoal()
                            }
                        if getCalRemaining() >  0
                        {
                            Text("   \(getCalRemaining()) calories remaining")
                                .font(.system(size: 14))
                                .modifier(TextDesign() )
                        }
                        else{
                            Text("   Limit Reached")
                                .font(.system(size: 14))
                                .modifier(TextDesign() )
                        }
                    }
                    Spacer()
                    VStack(alignment: .center)
                    {
                      
                        Text("Log Streak:  \(streakValue)    \(streakStatus)")
                            .font(.custom("Avenir-Heavy", size: 16))
                            .padding(10)
                            .padding(.horizontal, 15)
                            .background(
                                Group {
                                    if streakValue < 1 {
                                        Color(red: 1, green: 0.2, blue: 0.2)
                                    } else {
                                        Color(red: 0.5, green: 1.0, blue: 0.5)
                                        
                                        
                                    }
                                }
                                    .cornerRadius(10)
                            )
                        
                    }
                    
                    
                    
                    Spacer()
                }
                
            case .journal:
                JournalView()
            case .workout:
                WorkoutView()
            case .routine:
                RoutineView()
            case .chat:
                ChatView()
            }

        

                Spacer()
                
                HStack {
                    TabBarButton(tab: .home, selectedTab: $selectedTab, imageName: "house")
                    TabBarButton(tab: .journal, selectedTab: $selectedTab, imageName: "book")
                    TabBarButton(tab: .workout, selectedTab: $selectedTab, imageName: "figure.strengthtraining.traditional")
                    TabBarButton(tab: .routine, selectedTab: $selectedTab, imageName: "list.bullet.rectangle.portrait")
                    TabBarButton(tab: .chat, selectedTab: $selectedTab, imageName: "person.fill.questionmark")
                }
                //update streak status 
            }.onReceive(timer) { _ in
                
                 streakValue = getStreak()
                streakStatus = streakValue < 1 ? "😕" : "😁"
                
            }

                          
            
            NavigationLink(destination: SettingsView(showSignInView: $showSignInView), isActive: $showingSettings) {
                          
            }.hidden()
            //.navigationBarBackButtonHidden()
    }
    
    
    
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
    
    private func calsToday() -> Float {
       var calToday : Float = 0
       for item in food {
           if Calendar.current.isDateInToday(item.date!){
               calToday += Float(item.cal)
           }
       }
       return calToday
   }


   private func getCalGoal() -> Float {
       var calGoal: Float = 0
       for usr in userInfo {
           if let goal = Float(usr.calGoal!){
               calGoal += goal
           }
       }
       return calGoal
   }
    
    private func getStreak() -> Int {
        var streak = 0
        var doesStreakExist = false

        // Sort the food set by date desc order
        let sortedFood = uniqueFood(from: food).sorted { $0.date! > $1.date! }

        
        let today = Date()

        // Iterate through the sorted food entries
        for foodEntry in sortedFood {
            // Check if the entry's date is yesterday or today
            if let entryDate = foodEntry.date, Calendar.current.isDateInToday(entryDate) || Calendar.current.isDateInYesterday(entryDate) {
                // Increment streak
                streak += 1
                doesStreakExist = true
            } else {
                // If the streak breaks, exit the loop
                break
            }
        }

        // If there was no streak found, return 0
        if !doesStreakExist {
            streak = 0
        }

        return streak
    }
    
    private func getCalRemaining() -> Int {
        let todayCals = calsToday()
        let totalCals = getCalGoal()
        return  Int(totalCals - todayCals);
    }
   
    
    
}

struct TabBarButton: View {
    let tab: ContentView.Tab
    @Binding var selectedTab: ContentView.Tab
    let imageName: String
    
    var body: some View {
        Button(action: {
            self.selectedTab = self.tab
        }) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(self.tab == self.selectedTab ? .blue : .gray)
        }
    }
}

struct ProgressBar: View{
    @Binding var progress: Float
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var userInfo:FetchedResults<UserInfo>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var food:FetchedResults<FoodInfo>
    var body: some View{
        ZStack{
            Circle()
                .stroke(lineWidth: 30.0)
                .opacity(0.20)
                .foregroundColor(Color.gray)
        
                Text("   \(calsToday()) / \(getCalGoal())")
                    .font(.system(size: 30))
                    .modifier(TextDesign())
             
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress,1.0)))
                .stroke(style: StrokeStyle(lineWidth: 22.0,lineCap: .round, lineJoin: .round))
                .foregroundColor(determineColor())
                .rotationEffect(Angle(degrees: 270))
                // .animation(.easeInOut(duration:2.0))
            
        }.onAppear(){
             
        }
        
    }
    
    private func calsToday() -> Int {
       var calToday : Int = 0
       for item in food {
           if Calendar.current.isDateInToday(item.date!){
               calToday += Int(item.cal)
           }
       }
       return calToday
   }


   private func getCalGoal() -> Int {
       var calGoal: Int = 0
       for usr in userInfo {
           if let goal = Int(usr.calGoal!){
               calGoal += goal
           }
       }
       return calGoal
   }
    
    private func getCalRemaining() -> Int {
        let todayCals = calsToday()
        let totalCals = getCalGoal()
        return  Int(totalCals - todayCals);
    }

    private func determineColor() -> Color{
        if getCalRemaining() < 0{
            return Color.red
        }
        else{
            return Color.green
        }
    }
  
    
}


 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ContentView(showSignInView: .constant(false))
               
        }
    }
}

