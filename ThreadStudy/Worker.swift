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
}
