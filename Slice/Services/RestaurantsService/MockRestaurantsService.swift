//
//  MockRestaurantsService.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation

class MockRestaurantsService: RestaurantsServiceProtocol {
    func getRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        if let path = Bundle.main.path(forResource: "MockedRestaurants", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                let jsonDecoder = JSONDecoder()
                
                if let rests = try? jsonDecoder.decode([Restaurant].self, from: data) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        completion(rests)
                    })
                }
            }
        }
    }
    
    func getLastRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        if let path = Bundle.main.path(forResource: "MockedRestaurants", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                let jsonDecoder = JSONDecoder()
                
                if let rests = try? jsonDecoder.decode([Restaurant].self, from: data) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        completion(rests.dropLast())
                    })
                }
            }
        }
    }
}
