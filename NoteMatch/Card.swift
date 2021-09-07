//
//  Cards.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/3/21.
//

import Foundation

struct Card {
    
    var identifier: Int
    var isFaceUp = false
    var isMatched = false
    var isPreviouslySeen = false
    
    static var uniqueIdentifier = 0
    
    static func uniqueIdentifierFactory() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    init() {
        self.identifier = Card.uniqueIdentifierFactory()
    }
    
}
