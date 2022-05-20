//
//  APIResults.swift
//  Slice
//
//  Created by Artyom Batura on 19.05.22.
//

import Foundation


// MARK: - API results models

enum APIResults { }

// MARK: - Login Result

extension APIResults {
	struct LoginResultModel: Codable {
		let authToken: String
		let user: UserAPI
		
		enum CodingKeys: String, CodingKey {
			case user
			case authToken = "auth_token"
		}
	}
	
	struct UserAPI: Codable {
		let id: Int
		let username: String
		let firstName: String
		let lastName: String
		let email: String
		let avatarURL: String?
		
		enum CodingKeys: String, CodingKey {
			case id, username, email
			case firstName = "first_name"
			case lastName = "last_name"
			case avatarURL = "avatar_url"
		}
	}
}

// MARK: - All Restaurants Result

extension APIResults {
	struct RestaurantAPI: Codable {
		let id: Int
		let name: String
		let description: String
		let address: String
		let phoneNumber: String
		let photoURL: String?
		
		enum CodingKeys: String, CodingKey {
			case id, name, description, address
			case phoneNumber = "phone_number"
			case photoURL = "photo_url"
		}
	}
}

// MARK: - Restaurant Meny Result

extension APIResults {
	struct DishAPI: Codable {
		let id: Int
		let name: String
		let description: String
		let weight: String
		let price: String
		let estimatedTime: Int
		let photoURL: String?
		let dishType: String?
		let country: CountryAPI?
		
		enum CodingKeys: String, CodingKey {
			case id, name, description, weight, price, country
			case estimatedTime = "estimated_time"
			case photoURL = "photo_url"
			case dishType = "dish_type"
		}
	}
}

// MARK: - Country Result

extension APIResults {
	struct CountryAPI: Codable {
		let name: String
		let description: String
	}
}

// MARK: - Orders Result

extension APIResults {
	struct OrderAPI: Codable {
		let id: Int
		let date: String?
		let status: String
		let restaurant: RestaurantAPI
		let dishes: [DishAPI]
		
		var statusCasted: OrderStatus? {
			return OrderStatus(rawValue: status)
		}
	}
	
	enum OrderStatus: String {
		case active = "Active"
		case delayed = "Delayed"
		case cancelled = "Cancelled"
		case done = "Done"
	}
}

// MARK: - Payments

extension APIResults {
	struct CardAPI: Codable {
		let id: Int
		let number: String
		let expirationDate: String
		let cvc: String
		
		enum CodingKeys: String, CodingKey {
			case id, number
			case expirationDate = "expiration_date"
			case cvc = "cvv"
		}
	}
}
