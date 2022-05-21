//
//  OrderDatesActionsValidator.swift
//  Slice
//
//  Created by Artyom Batura on 22.05.22.
//

import Foundation

final class OrderDatesActionsValidator {
	enum Constants {
		static let minutesOffsetToBeDelayed: Double = 30
		static let minutesOffsetToBeCancelled: Double = 15
		
		static let secondsInMinute: Double = 60
	}
	
	// aka 30 minutes
	let secondsOffsetToBeDelayed: Double = Constants.minutesOffsetToBeDelayed * Constants.secondsInMinute
	let secondeOffsetToBeCancelled: Double = Constants.minutesOffsetToBeCancelled * Constants.secondsInMinute
	
	static let shared = OrderDatesActionsValidator()
	
	private init() { }
	
	func isCouldBeCreatedAsDelayed(selectedDate: Date) -> Bool {
		let now = Date.now
		return (selectedDate.timeIntervalSince1970 - now.timeIntervalSince1970) / Constants.secondsInMinute >= Constants.minutesOffsetToBeDelayed
	}
	
	func isCouldBeCancelled(dateString: String) -> Bool {
		if let selectedDate = APIDatesFormatter.shared.stringToDate(dateString) {
			let now = Date.now
			return (selectedDate.timeIntervalSince1970 - now.timeIntervalSince1970) / Constants.secondsInMinute >= Constants.minutesOffsetToBeCancelled
		}
		return false
	}
}
