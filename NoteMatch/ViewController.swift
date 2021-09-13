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
        game = NoteMatch(numberOfMatchingPairs: (noteCardGroup.count + 1 ) / 2)
        var cards = [Card]()
        for index in 0..<noteCardGroup.count {
            let card = game.cards[index]
            if note[card] == nil, noteChoices.count > 0 {
                note[card] = noteChoices.remove(at: noteChoices.count.arc4random)
            }
            cards += [card]
        }
        for cardView in noteCardGroup {
            cardView.isFaceUp = false
            let card = cards.removeFirst()
            if let note = note[card] {
                cardView.note = note
            }
        }
        updateCardViewsAfterTap()
    }
    
    var numberOfMatchingPairs: Int {
        return (noteCardGroup.count + 1 ) / 2
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private func updateFlipCountLabel() {
        let attributes : [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private lazy var game = NoteMatch(numberOfMatchingPairs: numberOfMatchingPairs)
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }

    @IBOutlet var noteCardGroup: [NoteCardView]!
    
    
    
    private func updateCardViewsAfterTap() {
        print(game.cards)
        for index in noteCardGroup.indices {
            let view = noteCardGroup[index]
            let card = game.cards[index]
            view.isHidden = card.isMatched
            view.isPreviouslySeen = card.isPreviouslySeen
            view.isFaceUp = card.isFaceUp
        }
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.gameScore)"
    }
    
    private var note = [Card:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [Card]()
        
        for index in 0..<noteCardGroup.count {
            let card = game.cards[index]
            if note[card] == nil, noteChoices.count > 0 {
                note[card] = noteChoices.remove(at: noteChoices.count.arc4random)
            }
            cards += [card]
        }
        for cardView in noteCardGroup {
            cardView.isFaceUp = false
            let card = cards.removeFirst()
            if let note = note[card] {
                cardView.note = note
            }
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? NoteCardView {
                print(chosenCardView.isFaceUp)
                chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                print(chosenCardView.isFaceUp)
                if let cardNumber = noteCardGroup.firstIndex(of: chosenCardView) {
                    game.chooseCard(at: cardNumber)
                    updateCardViewsAfterTap()
                }
            }
        default:
            break
        }
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
