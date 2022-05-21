//
//  Date+Extension.swift
//  Slice
//
//  Created by Artyom Batura on 21.05.22.
//

import Foundation

final class APIDatesFormatter {
	enum Constants {
		static let defaultFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		static let formatWithMilliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
	}
	
	static let shared = APIDatesFormatter()
	
	private let dateFormatter = DateFormatter()
	
	private init() { }
	
	func dateToString(_ date: Date) -> String {
		dateFormatter.dateFormat = Constants.defaultFormat
		
		let stringRepresented = dateFormatter.string(from: date)
		return stringRepresented
	}
	
	func stringToDate(_ string: String) -> Date? {
		dateFormatter.dateFormat = Constants.defaultFormat
		if let dateInDefaultFormat = dateFormatter.date(from: string) {
			return dateInDefaultFormat
		}
		
		dateFormatter.dateFormat = Constants.formatWithMilliseconds
		if let dateWithMilliseconds = dateFormatter.date(from: string) {
			return dateWithMilliseconds
		}
	
		return nil
	}
}
