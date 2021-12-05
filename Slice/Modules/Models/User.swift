//
//  User.swift
//  Slice
//
//  Created by Artyom Batura on 3.12.21.
//

import Foundation

struct User {
    var id: String
    
    var username: String
    
    var name: String
    
    var surname: String
    
    var email: String
    
    var avatarURL: String
    
    static let testUser = User(id: UUID().uuidString,
                               username: "artyombatura",
                               name: "Артем",
                               surname: "Батура",
                               email: "artyombatura@gmail.com",
                               avatarURL: "https://i.pinimg.com/736x/26/bd/ad/26bdad3d88dd702a548f1cfe46513574.jpg")
}

struct Order: Codable {
    var id: String
    
    var isActive: Bool
    
    var restaurantName: String
    
    var dishes: [Dish]
    
    var timestamp: Double
    
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, dishes, timestamp
        case isActive = "is_active"
        case restaurantName = "restaurant_name"
    }
    
    init(id: String, isActive: Bool, restaurantName: String, dishes: [Dish], timestamp: Double = 1638736507) {
        self.id = id
        self.isActive = isActive
        self.restaurantName = restaurantName
        self.dishes = dishes
        self.timestamp = timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        restaurantName = try container.decode(String.self, forKey: .restaurantName)
        dishes = try container.decode([Dish].self, forKey: .dishes)
        timestamp = try container.decode(Double.self, forKey: .timestamp)
    }
    
    var totalSum: Int {
        var sum = 0
        dishes.forEach({ sum += $0.price })
        return sum
    }
}

struct DishCountry {
    var id: String
    var name: String
    var description: String
    
    static let testDishCountry = DishCountry(id: UUID().uuidString,
                                             name: "Беларусь",
                                             description: "Беларусь имеет очень широкую кухнню")
}

struct Dish: Codable {
    enum DishType: String {
        case hot, cold
        
        func plainTitle() -> String {
            switch self {
            case .hot:
                return "Горячее"
            case .cold:
                return "Холодное"
            }
        }
    }
    
    var id: String
    
//    var country: DishCountry
    
    var photoURL: String
    
//    var dishType: DishType
    
    var name: String
    
    var description: String
    
    var weight: Double?
    
    // In minutes
    var estimatedCookingTime: Int
    
    var price: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, weight, price
        case photoURL = "photo_url"
        case estimatedCookingTime = "estimated_time"
    }
    
    init(id: String, name: String, descr: String, weight: Double, estimatedTime: Int, price: Int, url: String) {
        self.id = id
        self.name = name
        self.description = descr
        self.weight = weight
        self.estimatedCookingTime = estimatedTime
        self.price = price
        self.photoURL = url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        photoURL = try container.decode(String.self, forKey: .photoURL)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        weight = try container.decode(Double.self, forKey: .weight)
        price = try container.decode(Int.self, forKey: .price)
        estimatedCookingTime = try container.decode(Int.self, forKey: .estimatedCookingTime)
    }
    
    static var testDish: Dish {
        Dish(id: UUID().uuidString,
             name: "Блюдо 1",
             descr: "Описание",
             weight: 200,
             estimatedTime: 10,
             price: 100,
             url: "https://i.pinimg.com/736x/26/bd/ad/26bdad3d88dd702a548f1cfe46513574.jpg")
    }
}

struct Restaurant: Codable {
    var id: String
    
    var menu: [Dish]
    
    var photoURL: String
    
    var name: String
    
    var description: String
    
    var address: String
    
    var phoneNumber: String
    
    private enum CodingKeys: String, CodingKey {
        case id, menu, name, description, address
        case photoURL = "photo_url"
        case phoneNumber = "phone_number"
    }
    
    init(id: String, menu: [Dish], name: String, descr: String, address: String, phoneNumber: String, url: String) {
        self.id = id
        self.menu = menu
        self.name = name
        self.description = descr
        self.photoURL = url
        self.address = address
        self.phoneNumber = phoneNumber
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        menu = try container.decode([Dish].self, forKey: .menu)
        photoURL = try container.decode(String.self, forKey: .photoURL)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        address = try container.decode(String.self, forKey: .address)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
    }
    
    static var testRestaurant: Restaurant {
        Restaurant(id: UUID().uuidString,
                   menu: [.testDish, .testDish],
                   name: "Васильки",
                   descr: "Описание",
                   address: "Адрес",
                   phoneNumber: "80296910067",
                   url: "https://i.pinimg.com/736x/26/bd/ad/26bdad3d88dd702a548f1cfe46513574.jpg")
    }
}
