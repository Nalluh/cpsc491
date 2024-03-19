import SwiftUI



struct WorkoutTracker: View {
    var currentTime: String {
        return dateFormatter.string(from: Date())
    }
    
    @State private var userExercises: [String] = []
    @State private var exerciseName: String = ""
    @State private var addExercise: Bool = false
    @State private var stopWatch: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
      
        
        HStack(alignment: .center){
            
            Text("\(determineTitleTime(for: currentTime)) Workout")
                    .modifier(TextDesign())
            
            Text("\(timeFormatted(stopWatch))")
                .font(.custom("AppleSDGothicNeo-Bold", size: 16))
                .padding(.trailing)
            
        }
        Spacer()
        VStack {
            List {
                ForEach(userExercises.indices, id: \.self) { index in
                    NavigationLink(destination: WorkoutExerciseInfo(exerciseName: userExercises[index])) {
                        VStack(alignment: .center) {
                            Label("\(userExercises[index])   ", systemImage: "figure.strengthtraining.traditional")
                                .font(.custom("AppleSDGothicNeo-Bold", size: 20))
                         
                                
                               
                               
                        }
                    }
                }.padding()
                .foregroundColor(.white)
                .background(Color.yellow)
                .cornerRadius(12)
            }
            .listStyle(.inset)
           
            

            Button("Add Exercise") {
                exerciseName = ""
                addExercise.toggle()
            }
            .padding()
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 27.5)
            .frame(maxWidth: 200)
            .background(Color.blue)
            .cornerRadius(10)
            .alert("Enter Exercise", isPresented: $addExercise) {
                VStack {
                    TextField("Enter Exercise", text: $exerciseName)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    Button("OK") {
                        if (!exerciseName.isEmpty ){
                            appendExercise()
                            addExercise = false
                        }
                    }
                }
                .padding()
            }

            Spacer(minLength: 30)
        }
        .onReceive(timer) { _ in
            stopWatch += 1
        }.navigationBarBackButtonHidden(true)
    }

  private  func timeFormatted(_ totalSeconds: TimeInterval) -> String {
        let seconds = Int(totalSeconds) % 60
        let minutes = Int(totalSeconds) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
             
   private func determineTitleTime(for timeOfDay: String) -> String {
        var title: String
        
        switch timeOfDay {
        case "00:00 AM"..."11:59 AM":
            title = "Morning"
        case "12:00 PM"..."17:59 PM":
            title = "Afternoon"
        default:
            title = "Evening"
        }
        
        return title
    }
        
    private func appendExercise() {
        userExercises.append(exerciseName)
    }
    
    
   
}

struct WorkoutTracker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutTracker()
    }
}
