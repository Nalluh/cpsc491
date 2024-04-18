//
//  openAI.swift
//  Chatbot
//
//  Created by Allan Cortes on 4/13/24.
//

import Foundation


let apiKey = "sk-"

enum HTTPAction: String {
    
    case get = "GET"
    case post = "POST"
}
class OpenAI {
    static let openAIShared = OpenAI()
    
    private init () {}
    
    //API endpoint -- send request
    private func doURLRequest(httpMethod: HTTPAction, message:String) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else{
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url:url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        //set HTTP headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        // configure Request
        let systemMessage = GPTMessage(role: "system", content: "You are a fitness expert and will respond in 20 words or less, if the question is not fitness/diet/health related respond im only informed about fitness/diet questions ")

        let userMessage = GPTMessage(role: "user", content: message)
        
        let question = GPTFunctionsProperty(type: "string", desc: "answer the fitness question")
        
        let params:  [String: GPTFunctionsProperty] =  ["question": question]
        
        let functionParameters = GPTFunctionsParameter(type: "object", properties: params, required: ["question"])

        let function = GPTFunction(name: "get_macro", desc: "get the macros for a give food", parameter: functionParameters)
        
        let payload = GPTPayload(model: "gpt-3.5-turbo-0613", messages: [systemMessage,userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        urlRequest.httpBody = jsonData
        return urlRequest
    }
    
    // response parsing -- getting the content aka the gpt response from request
    func sendToGPT (message:String) async throws -> String{
        let urlRequest = try doURLRequest(httpMethod: .post, message: message)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let choices = jsonResponse["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let content = message["content"] as? String {
            return content
        }
        else{
            throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
            
        }
        

    }
    
}

// structing the api request 
struct GPTPayload: Encodable {
let model: String
let messages: [GPTMessage]
let functions: [GPTFunction]

}


struct GPTMessage: Encodable {
let role: String
let content: String
}

struct GPTFunction: Encodable {
let name: String
let desc: String
let parameter: GPTFunctionsParameter
}

struct GPTFunctionsParameter: Encodable {
let type: String
let properties: [String: GPTFunctionsProperty]?
let required: [String]?
}

struct GPTFunctionsProperty: Encodable {
let type: String
let desc: String

}
