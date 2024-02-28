//
//  Worker.swift
//  ThreadStudy
//
//  Created by roger deutsch on 11/30/23.
//

import Foundation
import SwiftUI

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
            // print("### response \(response) ####")
            let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data)
            print (decodedResponse?.value ?? " yada yo!")
            return decodedResponse?.value ?? "FAILED!"
        }
    }
    
    func getChuckNorrisData2() async -> String{
        var data: Data? = nil
        var retError: HTTPURLResponse? = nil
        
        do {
            (data, retError) = try await (URLSession.shared.data(from: URL(string:"https://api.chucknorris.io/jokes/random-")!) as? (Data, HTTPURLResponse))!
            print("printing data : \(data)")
            print ("response error --->  \(retError?.statusCode)")
            // catches errors in response from web api -- so web api has been
            // successfully contacted but a "normal" status error occurs
            // Other bad errors throw exceptions which is caught below
            // bad URL like string:"https://api.chucknorris.io/jokes/random-"
            // will cause this error (404)
            switch retError?.statusCode{
            case _ where retError!.statusCode < 200 || retError!.statusCode >= 300:
                return "Couldn't carry on.  Bad status code from API \(retError?.statusCode)"
                default:
                    print("Success!")
            }
        }
        catch{
            // catches errors when the URL is not well formed
            // bad URL like the following causes this exception:
            // (notice the x in the protocol portion of URL
            // string:"httpxs://api.chucknorris.io/jokes/random"
            print("!! What ERROR? \(error)")
            return "failed to retrieve data"
        }
        do {
            let decodedResponse = try JSONDecoder().decode(Fake.self, from: data!)
            //print (decodedResponse?.value ?? " chuck 2")
            return decodedResponse.x ?? "FAILED!"
        }
        catch{
            print ("!!!!   error! occurred: \(error)  !!!!")
        }
        
        return "failed!"
    }
    
    func getInitialPokemonList() async -> String{
        var data: Data? = nil
        var response: HTTPURLResponse? = nil
        do{
            (data, response) = try await ((URLSession.shared.data(from: URL(string:"https://pokeapi.co/api/v2/pokemon")!) as? (Data, HTTPURLResponse))!)
            switch response?.statusCode{
            case _ where response!.statusCode < 200 || response!.statusCode >= 300:
                return "Couldn't carry on.  Bad status code from API \(response!.statusCode)"
                default:
                    print("Pokemon Success!")
                print("DATA: \(String(decoding: data!, as: UTF8.self))")
            }
        }
        catch{
            // catches errors when the URL is not well formed
            // bad URL like the following causes this exception:
            // (notice the x in the protocol portion of URL
            // string:"httpxs://api.chucknorris.io/jokes/random"
            print("Failed \(error)")
            return "BAD URL - Failed to retrieve data."
        }
        
        do{
        
            let decodedJson = try JSONDecoder().decode(PokemonBase.self, from: data!)
            let randomChoice = Int.random(in:0...19)
            return "\(decodedJson.results[randomChoice].name) : \(randomChoice)"
                //print("respone: \(String(decoding: data, as: UTF8.self))")
            
        }
        catch {
            print("*** error: Couldn't DECODE JSON \(error) ***")
        }
        return "completed method"
    }
    
    struct Fake: Codable{
        // just so I can force and decode error
        let x: String
        let value: String
    }
    
    struct Joke: Codable{
        let value: String
    }
    
    struct PokemonBase : Codable{
        let count: Int
        let next: String?
        let previous: String?
        let results: [PokemonChar]
    }
    
    struct PokemonChar : Codable{
        let name: String
        let url: String
    }
}
