//
//  ContentView.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import SwiftUI



final class ContentViewModel: ObservableObject{
    
    
    
}


struct ContentView: View {
    @Binding var showSignInView: Bool 
    @State private var selectedTab: Tab = .home
    @State private var showingSettings = false
    @State private var progressVal : Float = 3.4
    @State private var isTextBoxVisible = false
    @State private var goal  = ""

   @Environment(\.managedObjectContext) var managedObjectContext
   @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var userInfo:FetchedResults<UserInfo>
   @FetchRequest(sortDescriptors: [SortDescriptor(\.date,order:.reverse)]) var food:FetchedResults<FoodInfo>


      enum Tab {
          case home, journal, workout, routine
      }
    var body: some View {
        
            VStack {
                
                switch selectedTab {
                case .home:
                    HStack {
                        Spacer()
                        Text("      Trifecta")
                            .modifier(TextDesign())

                           
                        Spacer()
                        Button(action: {
                            self.showingSettings.toggle()
                        }) {
                            Image(systemName: "gear")
                                .padding(10)
                        }
                        
                    }

                    VStack {
                     
                        ProgressBar(progress: $progressVal)
                        
                            .frame(width: 300.0, height: 300.0)
                            .padding(80.0).onAppear(){

                                progressVal = calsToday() / getCalGoal()
                            }
                        
                        Button("Set Calorie Goal") {
                            self.isTextBoxVisible.toggle()
                            
                        }
                        if isTextBoxVisible {
                            TextField("Enter text", text: $goal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button(action: {
                                    deleteGoal()
                                DataHandler().setCalGoal(goal: goal, context: managedObjectContext)
                                
                                
                                self.isTextBoxVisible.toggle()
                                
                            }) {
                                Text("Submit")
                            }
                            .padding()
                        }
                       
                        Spacer()
                    }
                
                case .journal:
                    JournalView()
                case .workout:
                    WorkoutView()
                case .routine:
                   RoutineView()
                }
                    
                
                Spacer()
                
                HStack {
                    TabBarButton(tab: .home, selectedTab: $selectedTab, imageName: "house")
                    TabBarButton(tab: .journal, selectedTab: $selectedTab, imageName: "book")
                    TabBarButton(tab: .workout, selectedTab: $selectedTab, imageName: "figure.strengthtraining.traditional")
                    TabBarButton(tab: .routine, selectedTab: $selectedTab, imageName: "list.bullet.rectangle.portrait")
                }
                
            }
           
                          
                       
            NavigationLink(destination: SettingsView(showSignInView: $showSignInView), isActive: $showingSettings) {
                          
            }.hidden()
        }
    private func deleteGoal() {
           for users in userInfo {
               managedObjectContext.delete(users)
           }
           do {
               try managedObjectContext.save()
           } catch {
               print("Error deleting numbers: \(error)")
           }
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
    var color: Color=Color.green
    var body: some View{
        ZStack{
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.20)
                .foregroundColor(Color.gray)
            
            Text("     \(calsToday()) / \(getCalGoal())")
                .modifier(TextDesign())
                .font(.system(size: 10))
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress,1.0)))
                .stroke(style: StrokeStyle(lineWidth: 12.0,lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
                // .animation(.easeInOut(duration:2.0))
            
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
    
}


 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ContentView(showSignInView: .constant(false))
               
        }
    }
}

