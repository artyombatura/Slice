//
//  MockRestaurantsService.swift
//  Slice
//
//  Created by Artyom Batura on 5.12.21.
//

import Foundation



//private let vasilki = Restaurant(id: UUID().uuidString,
//                                  menu: [],
//                                  photoURL: "https://avatars.mds.yandex.net/get-altay/1879929/2a0000016b920ddc793356618743ae7ae538/XXL",
//                                  name: "Васильки",
//                                  description: "Рестораны народной кухни «Васiлькi» ежедневно встречают Гостей белорусским радушием и гостеприимством, ведь это не только место, где можно вкусно поесть, но и то самое место, где можно отдохнуть душой и провести время в компании близких!",
//                                  address: "г. Минск, ст. м. Восток",
//                                  phoneNumber: "+375292281337")
//
//private let mcdonalds = Restaurant(id: UUID().uuidString,
//                                   menu: [.testDish, .testDish, .testDish, .testDish, .testDish, .testDish],
//                                   photoURL: "https://realt.by/typo3temp/pics/91/88/9188a372e5cd93a8cf9a9f3bd35ab567.jpg",
//                                   name: "McDonalds",
//                                   description: "McDonald’s, «Макдо́налдс» — американская корпорация, работающая в сфере общественного питания, крупнейшая в мире сеть ресторанов быстрого питания, работающая по системе франчайзинга.",
//                                   address: "г. Минск, ст. м. Уручье",
//                                   phoneNumber: "+375292298311")
//
//private let kfc = Restaurant(id: UUID().uuidString,
//                                   menu: [.testDish, .testDish, .testDish, .testDish, .testDish, .testDish],
//                                   photoURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Sign_for_the_first_KFC_restaurant%2C_Mar_16.jpg/1200px-Sign_for_the_first_KFC_restaurant%2C_Mar_16.jpg",
//                                   name: "KFC",
//                                   description: "Kentucky Fried Chicken, сокращённо KFC — международная сеть ресторанов общественного питания, специализирующаяся на блюдах из курицы. ",
//                                   address: "г. Минск, ст. м. Восток, Dana Mall",
//                                   phoneNumber: "+375292298311")




class MockRestaurantsService: RestaurantsServiceProtocol {
    func getRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        if let path = Bundle.main.path(forResource: "MockedRestaurants", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                let jsonDecoder = JSONDecoder()
                
                if let rests = try? jsonDecoder.decode([Restaurant].self, from: data) {
                    completion(rests)
                }
            }
        }
    }
    
    func getLastRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        if let path = Bundle.main.path(forResource: "MockedRestaurants", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                let jsonDecoder = JSONDecoder()
                
                if let rests = try? jsonDecoder.decode([Restaurant].self, from: data) {
                    completion(rests.dropLast())
                }
            }
        }
    }
}
