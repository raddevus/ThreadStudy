//
//  ContentView.swift
//  ThreadStudy
//
//  Created by roger deutsch on 11/30/23.
//

import SwiftUI

struct ContentView: View {
    let worker = Worker()
    func generateRows(){
        print("I am here!  Hear me roar!!")
        
    }
    var body: some View {
        TabView{
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button("Get Weather"){
                    
                    Task{
                        await worker.fasterTask()
                        print ("##### START #####")
                        await worker.fetchWeatherHistory()
                        print ("##### END #####")
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
