//
//  Double+Extension.swift
//  Slice
//
//  Created by Artyom Batura on 20.05.22.
//

import Foundation

extension Double {
	func stringWithNDecimalPlaces(_ n: Int) -> String {
		return String(format: "%.\(n)f", self)
	}
}
