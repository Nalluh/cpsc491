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
   // @Environment(\.managedObjectContext) var managedObjectContext
    // @Environment(\.dismiss) var dismiss
    
    //var food: FetchedResults<FoodInfo>.Element
    

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
                            .frame(width: 300.0, height: 360.0)
                            .padding(80.0).onAppear(){
                                progressVal = 0.30
                                //adjust value to calUsed / calGoal
                            }
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
    var color: Color=Color.green
    var body: some View{
        ZStack{
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.20)
                .foregroundColor(Color.gray)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress,1.0)))
                .stroke(style: StrokeStyle(lineWidth: 12.0,lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
                // .animation(.easeInOut(duration:2.0))
            
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

