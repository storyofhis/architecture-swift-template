//
//  Log.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 16/05/26.
//

import Foundation

enum Log {
    static func info(_ message: String) {
        print("[INFO] \(message)")
    }
    
    static func warning(_ message: String) {
        print("[WARNING] \(message)")
    }
    
    static func error(_ message: String) {
        print("[ERROR] \(message)")
    }
}
