//
//  Item.swift
//  Gastrowa
//
//  Created by Pablo on 13/05/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
