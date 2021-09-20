//
//  ViewController.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/2/21.
//

import UIKit

class NoteMatchViewController: UIViewController {

    
    private lazy var noteChoices = ["F", "Dm", "C", "Fm", "G", "Em"]
    
    @IBAction private func newGame(_ sender: UIButton) {
        noteChoices = interval!
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
    
    var interval: [String]? {
        didSet {
            noteChoices = interval ?? [String]()
            note = [:]
            updateCardViewsAfterTap()
        }
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
        if noteCardGroup != nil {
            for index in noteCardGroup.indices {
                let view = noteCardGroup[index]
                let card = game.cards[index]
                if card.isMatched && !view.isHidden {
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.7, delay: 0.0, options: [], animations: {
                        view.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                    },
                    completion: { position in
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75, delay: 0.0, options: [], animations: {
                            view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                            view.alpha = 0
                        }, completion: { position in
                            view.isHidden = card.isMatched
                        })
                    })
                }
                if view.isFaceUp != card.isFaceUp {
                    UIView.transition(with: view, duration: 0.6, options: [.transitionFlipFromLeft], animations: {
                        view.isFaceUp = card.isFaceUp
                    })
                }
            }
            flipCountLabel.text = "Flips: \(game.flipCount)"
            scoreLabel.text = "Score: \(game.gameScore)"
        }
    }
    
    private var note = [Card:String]()
    
    private var faceUpCards: [NoteCardView] {
        return noteCardGroup.filter {
            $0.isFaceUp
        }
    }
    
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
                UIView.transition(with: chosenCardView, duration: 0.6, options: [.transitionFlipFromLeft], animations: {
                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                }, completion: { position in
                    
                    /*
                    if self.faceUpCards.count == 2 && self.faceUpCards[0].note == self.faceUpCards[1].note {
                        self.faceUpCards.forEach { cardView in
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.7, delay: 0.0, options: [], animations: {
                                cardView.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                            })
                        }
                    }
                    */
                    if let cardNumber = self.noteCardGroup.firstIndex(of: chosenCardView) {
                        self.game.chooseCard(at: cardNumber)
                        self.updateCardViewsAfterTap()
                    }
                })
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
