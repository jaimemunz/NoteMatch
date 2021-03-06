//
//  NoteMatch.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/3/21.
//

import Foundation

class NoteMatch {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyOneFaceUpCard : Int? {
        get {
            let arrayOfFaceUpCardsIndices = cards.indices.filter {
                return cards[$0].isFaceUp
            }
            return arrayOfFaceUpCardsIndices.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var flipCount = 0
    
    private(set) var gameScore = 0
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "NoteMatch.chooseCard(\(index)): Chosen index not found in cards")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, !(matchIndex == index) {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    gameScore += 10
                }
                if !cards[index].isMatched {
                    if cards[index].isPreviouslySeen {
                        gameScore -= 1
                    }
                    if cards[matchIndex].isPreviouslySeen {
                        gameScore -= 1
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyOneFaceUpCard = index
            }
            cards[index].isPreviouslySeen = true
        }
    }
    
    init(numberOfMatchingPairs: Int) {
        assert(numberOfMatchingPairs > 0, "NoteMatch.init(\(numberOfMatchingPairs)): number of matching pairs must be at least 1")

        for _ in 1...numberOfMatchingPairs {
            let card = Card()
            var soundCard = card
            soundCard.isSoundCard = true
            cards += [card, soundCard]
        }
        
        cards.shuffle()
    }
    
}


extension Collection {
    var oneAndOnly : Element? {
        return count == 1 ? first : nil
    }
}
