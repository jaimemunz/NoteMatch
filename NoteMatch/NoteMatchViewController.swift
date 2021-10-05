//
//  ViewController.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/2/21.
//

import UIKit
import AVFoundation

class NoteMatchViewController: UIViewController {

    var player:AVPlayer?
    var playerItem:AVPlayerItem?

    var notePlayer: NotePlayer = NotePlayer()
    
    private lazy var noteChoices = ["F", "Dm", "C", "Fm", "G", "Em"]

    var numberOfMatchingPairs: Int {
        return (noteCardGroup.count + 1 ) / 2
    }
    
    var interval: [String]? {
        didSet {
            noteChoices = interval ?? [String]()
            note = [:]
            updateCardViews()
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
            cardView.isSoundCard = card.isSoundCard
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
    }
    
    private func updateCardViews() {
        if noteCardGroup != nil {
            print(game.cards)
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
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCards.count == 2 &&
            faceUpCards[0].note == faceUpCards[1].note
    }
    
    var lastChosenCardView: NoteCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? NoteCardView, faceUpCards.count < 2 {
                lastChosenCardView = chosenCardView
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.5,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                },
                    completion: { finished in
                        let cardsToAnimate = self.faceUpCards
                        if chosenCardView.isSoundCard {
                            self.notePlayer.playNotes(forChord: chosenCardView.note)
                        }
                        if let cardNumber = self.noteCardGroup.firstIndex(of: chosenCardView) {
                            self.game.chooseCard(at: cardNumber)
                        }
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    cardsToAnimate.forEach {
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                            },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            cardsToAnimate.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                    },
                                        completion: { position in
                                            cardsToAnimate.forEach {
                                                $0.isFaceUp = false
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                    }
                                    )
                            }
                            )
                        } else if cardsToAnimate.count == 2 {
                            if chosenCardView == self.lastChosenCardView {
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.5,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                            cardView.isFaceUp = false
                                    }
                                    )
                                }
                            }
                        }
                        self.flipCountLabel.text = "Flips: \(self.game.flipCount)"
                        self.scoreLabel.text = "Score: \(self.game.gameScore)"
                }
                )
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
