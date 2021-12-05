//
//  OrdersService.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation

protocol OrdersServiceProtocol {
    func save(_ order: Order, completion: @escaping () -> Void)
    
    func getLastOrders(user id: String, completion: @escaping ([Order]) -> Void)
}
