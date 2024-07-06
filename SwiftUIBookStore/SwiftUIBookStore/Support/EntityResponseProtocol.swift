//
//  EntityResponseProtocol.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import Foundation

protocol EntityResponseProtocol: Codable, Hashable {
    static func null() -> Self
    static func empty() -> Self
    static func mock() -> Self
}
