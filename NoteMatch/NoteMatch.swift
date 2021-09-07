//
//  NoteMatch.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/3/21.
//

import Foundation

class NoteMatch {
    
    var cards = [Card]()
    
    var indexOfOneAndOnlyOneFaceUpCard : Int?
    
    var flipCount = 0
    
    var gameScore = 0
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, !(matchIndex == index) {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    gameScore += 2
                }
                if !cards[index].isMatched {
                    if cards[index].isPreviouslySeen {
                        gameScore -= 1
                    }
                    if cards[matchIndex].isPreviouslySeen {
                        gameScore -= 1
                    }
                }
                indexOfOneAndOnlyOneFaceUpCard = nil
                cards[index].isFaceUp = true
            } else {
                for indexOfFaceDownCards in cards.indices {
                    cards[indexOfFaceDownCards].isFaceUp = false
                }
                indexOfOneAndOnlyOneFaceUpCard = index
                cards[index].isFaceUp = true
            }
            cards[index].isPreviouslySeen = true
        }
    }
    
    init(numberOfMatchingPairs: Int) {
        for _ in 1...numberOfMatchingPairs {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
    }
    
}
