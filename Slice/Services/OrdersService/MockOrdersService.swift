//
//  MockOrdersService.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation

class MockOrdersService: OrdersServiceProtocol {
    func save(_ order: Order, completion: @escaping () -> Void) {
        completion()
    }
    
    func getLastOrders(user id: String, completion: @escaping ([Order]) -> Void) {
//        completion
        if let path = Bundle.main.path(forResource: "MockedOrders", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                let jsonDecoder = JSONDecoder()
                
                if let orders = try? jsonDecoder.decode([Order].self, from: data) {
                    completion(orders)
                }
            }
        }
    }
}
