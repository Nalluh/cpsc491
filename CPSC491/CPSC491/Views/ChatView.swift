import SwiftUI

struct ChatView: View {
    @State private var question: String = ""
    // for ai
    @State private var conversation: String = ""
    @State private var userConversation: [String] = [""]
    @State private var gptConversation: [String] = [""]
    @State private var response: String = "Waiting for response..."
    
    var body: some View {
        //header logo
        VStack(alignment: .center){
            Text("Trifecta")
                .modifier(TextDesign())
        }
        VStack {
            // show conversation between user and gpt
            ScrollViewReader { view in
                ScrollView {
                    VStack(alignment: .trailing, spacing: 10) {
                        ForEach(combinedConversation) { item in
                            HStack {
                                if item.sender == "User" {
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text(item.sender)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 8)
                                            .background(Capsule().foregroundColor(.white))
                                        
                                        Text(item.message)
                                            .padding(10)
                                            .foregroundColor(.white)
                                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.black))
                                    }
                                } else {
                                    VStack(alignment: .leading) {
                                        Text(item.sender)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 8)
                                            .background(Capsule().foregroundColor(.white))
                                        
                                        Text(item.message)
                                            .padding(10)
                                            .foregroundColor(.white)
                                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.black))
                                    }
                                    
                                    Spacer()
                                }
                            }
                            
                        }
                    }
                }
                .padding()
                    
            }
            
                Spacer()
                //get question
                HStack {
                    TextField("Enter a question", text: $question)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 13)

                    Button {
                        //append user conversation for screen
                        userConversation.append(question)
                        //append question to  conversation
                        conversation += " \(question)"
                        //send request to gpt api
                        async {
                            do {
                                if question.isEmpty {
                                    self.response = "Please enter a question."
                                    return
                                }
                            
                                // get api response
                                self.response = try await OpenAI.openAIShared.sendToGPT(message: conversation)
                                // append gpt conversation for screen
                                gptConversation.append(response)
                                // reset conversation and then append the previous question so that if user has concern about previous query we can give context to gpt api
                                conversation = ""
                                conversation += "Previous query (ignore this if it is not related to the pending question) :\(question), Pending question = "
                                //reset text box after button pressed
                                question = ""
                            } catch {
                                self.response = "Error: \(error.localizedDescription)"
                            }
                        }
                    }
                label: {
                    Label("", systemImage: "paperplane")
                }.padding(.horizontal, 2)
                .font(.system(size: 24)) // Adjust the size as needed

                }
         
            .onAppear(){
                // trick so that chatview does not need parameters and the chat does not display empty strings
                userConversation.removeFirst()
                gptConversation.removeFirst()
            }
        }
    }
    
    
    struct ConversationItem: Identifiable {
        let id = UUID()
        let sender: String
        let message: String
    }
    
    // gets the user and gpt conversations and merges them
    private var combinedConversation: [ConversationItem] {
            // create new array
            var combined: [ConversationItem] = []
            // get max length to use in loop
            let maxLength = max(userConversation.count, gptConversation.count)
            // append user messages with identifier
            for i in 0..<maxLength {
                if i < userConversation.count {
                    combined.append(ConversationItem(sender: "User", message: userConversation[i]))
                }
                // append gpt messages with identifier

                if i < gptConversation.count {
                    combined.append(ConversationItem(sender: "Agent", message: gptConversation[i]))
                }
            }
        // return an array with identifiers for each message
            return combined
        }
}
