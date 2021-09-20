//
//  NoteCardView.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/12/21.
//

import UIKit

class NoteCardView: UIView {
    
    var note: String = "A" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isFaceUp: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isMatched = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var isSoundCard = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    private func centeredAttributedFont(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        print(string)
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: font])
    }
    
    private var noteString: NSAttributedString {
        return centeredAttributedFont(isSoundCard ? "🔊" : note, fontSize: 16.0)
    }
    
    private func createNoteLabel() -> UILabel {
        let label = UILabel()
        // so it can take up as many lines as it needs to
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private lazy var noteLabel: UILabel = createNoteLabel()
    
    private func configureNoteLabel(_ label: UILabel) {
        label.attributedText = noteString
        label.frame.size = CGSize.zero // to clear out the size to size to fit / up and down
        label.sizeToFit() // will size label to fit contents
        label.isHidden = !isFaceUp // hide if face down
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureNoteLabel(noteLabel)
        noteLabel.frame.origin = bounds.origin.offsetBy(dx: bounds.midX-(noteLabel.frame.width/2), dy: bounds.midY-(noteLabel.frame.height/2))
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.orange.setFill()
        roundedRect.fill()
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension NoteCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
        
    public var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    public var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
}
