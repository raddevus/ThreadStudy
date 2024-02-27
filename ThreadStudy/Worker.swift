//
//  Worker.swift
//  ThreadStudy
//
//  Created by roger deutsch on 11/30/23.
//

import Foundation

struct Worker{
    
    func fasterTask() async  {
        (1...100_000).map {
            if ($0 % 10_000 == 0){
                print("!!!fasterTask!!! \($0 / 10_000)")
            }
        }
    }
    
    func fetchWeatherHistory() async -> [Double] {
        (1...13_500_000).map {
            if ($0 % 100_000 == 0){
                print("\($0 / 10_000) I'm working on it")
            }
            return Double.random(in: -10...30)
        }
    }
    
    func getChuckNorrisData() -> Task<String, Error>{
        Task{
            let (data, response) = try await URLSession.shared.data(from: URL(string:"https://api.chucknorris.io/jokes/random")!)
            print("### response \(response) ####")
            let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data)
            print (decodedResponse?.value ?? " yada yo!")
            return decodedResponse?.value ?? "FAILED!"
        }
    }
    
    func getChuckNorrisData2() async -> String{
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://api.chucknorris.io/jokes/random")!)
            let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data)
            print (decodedResponse?.value ?? " yada yo!")
            return decodedResponse?.value ?? "FAILED!"
        }
        catch{
            print (error)
        }
        return "failed!"
    }
    
    struct Joke: Codable{
        let value: String
    }
}
