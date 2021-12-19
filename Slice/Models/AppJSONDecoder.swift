//
//  AppJSONDecoder.swift
//  Slice
//
//  Created by Artyom Batura on 14.12.21.
//

import Foundation

class AppJSONDecoder<T: Decodable> {
    func decode(jsonData data: Data) throws -> T {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch {
            throw error
        }
    }
}
