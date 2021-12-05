//
//  RestaurantsService.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation

protocol RestaurantsServiceProtocol {
    func getRestaurants(completion: @escaping ([Restaurant]) -> Void)
    
    func getLastRestaurants(completion: @escaping ([Restaurant]) -> Void)
}

