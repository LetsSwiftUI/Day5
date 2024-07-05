//
//  Item.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
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
