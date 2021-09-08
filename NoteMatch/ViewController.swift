//
//  ViewController.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/2/21.
//

import UIKit

class ViewController: UIViewController {

    private var noteThemes = [["F", "Dm", "C", "Fm", "G", "Em"], ["C", "Am", "G", "Em", "D", "Bm"], ["F♯m", "C♯m", "G♯m", "A", "E", "B"]]
    
    private lazy var noteChoices = noteThemes[Int(arc4random_uniform(UInt32(noteThemes.count)))]
    
    @IBAction private func newGame(_ sender: UIButton) {
        noteChoices = noteThemes[Int(arc4random_uniform(UInt32(noteThemes.count)))]
        game = NoteMatch(numberOfMatchingPairs: (cardGroup.count + 1 ) / 2)
        updateViewAfterPress()
    }
    
    var numberOfMatchingPairs: Int {
        return (cardGroup.count + 1 ) / 2
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private lazy var game = NoteMatch(numberOfMatchingPairs: numberOfMatchingPairs)
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardGroup: [UIButton]!
    
    @IBAction private func pressButton(_ sender: UIButton) {
        if let cardNumber = cardGroup.firstIndex(of: sender) {
            print("Card number is: \(cardNumber)")
            game.chooseCard(at: cardNumber)
            updateViewAfterPress()
        }
    }
    
    
    private func updateViewAfterPress() {
        for index in cardGroup.indices {
            let button = cardGroup[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(note(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = (game.cards[index].isMatched ? #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 0) :  #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1))
            }
        }
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.gameScore)"
    }
    
    private var note = [Int:String]()
    
    
    private func note(for card: Card) -> String {
        if note[card.identifier] == nil, noteChoices.count > 0 {
            note[card.identifier] = noteChoices.remove(at: noteChoices.count.arc4random)
        }
        return note[card.identifier] ?? "?"
    }
    

}


extension Int {
    var arc4random : Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
