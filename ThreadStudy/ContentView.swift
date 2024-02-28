//
//  ContentView.swift
//  ThreadStudy
//
//  Created by roger deutsch on 11/30/23.
//

import SwiftUI

struct ContentView: View {
    @State private var jokeText = ""
    @State private var joke2 = ""
    @State private var pokemonMsg = ""
    
    let worker = Worker()
    func generateRows(){
        print("I am here!  Hear me roar!!")
        
    }
    var body: some View {
        TabView{
            VStack {
                Text(jokeText)
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Text(joke2)
                Text(pokemonMsg)
                Button("Get Weather"){
                    // NOTE:  1) Each Task runs concurrently with each other.
                    // 2) Statements within each Task run synchronously (previous one has to complete before next one runs) -- blocking type of calls
                    
                    Task{
                        jokeText = try! await worker.getChuckNorrisData().result.get()
                    }
                    Task{
                        await worker.fasterTask()
                        print ("##### START #####")
                        let output = await worker.fetchWeatherHistory()
                        print("output.count : \(output.count)  & \(output[38343])")
                        print ("##### END #####")
                    }
                   Task{
                        joke2 = await worker.getChuckNorrisData2()
                    }
                    Task{
                        pokemonMsg = await worker.getInitialPokemonList()
                        
                    }
                    print("**** AFTER TASK ***** ")
                }.buttonStyle(.bordered)
            }
            .padding()
            .tabItem{
                Label("First", systemImage: "star")
            }
            VStack{
                Text("another")
                Form{
                    //print("generating rows...")
                    
                    ForEach(0..<500){
                        Text("Row \($0)")
                    }
                    
                }.onAppear(perform: generateRows)
            }.tabItem{
                Label("2nd", systemImage:"square")
            }
            VStack{
                Text("More")
            }.tabItem{
                Label("3rd", systemImage: "circle")
            }
            VStack{
                Text("Last")
            }.tabItem{
                Label("4th",systemImage: "triangle")
            }
        }
    }
}

#Preview {
    ContentView()
}
