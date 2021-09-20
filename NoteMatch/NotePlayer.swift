//
//  NotePlayer.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/19/21.
//

import Foundation

import AVFoundation

class NotePlayer {
    var player:AVPlayer?
    var playerItem:AVPlayerItem?

    //    "C Major/A Minor": ["F", "Dm", "C", "Fm", "G", "Em"],
    //    "G Major/E Minor": ["C", "Am", "G", "Em", "D", "Bm"],
    //    "E Major/C# Minor": ["F♯m", "C♯m", "G♯m", "A", "E", "B"],
    
    static func getNotes(fromChord chord: String) -> [String] {
        switch chord {
        case "F": return ["f3", "a3", "c3"]
        case "Dm": return ["d3", "f3", "a3"]
        case "C": return ["c3", "e3", "g3"]
        case "Fm": return ["f3", "g-3", "c3"]
        case "G": return ["g3", "b3", "d3"]
        case "Em": return ["e3", "g3", "b3"]
        case "Am": return ["a3", "c3", "e3"]
        case "D": return ["d3", "f-3", "a3"]
        case "Bm": return ["b3", "d3", "f-3"]
        case "F♯m": return ["f-3", "a3", "c-3"]
        case "C♯m": return ["c-3", "e3", "g-3"]
        case "G♯m": return ["g-3", "b3", "d-3"]
        case "A": return ["a3", "c-3", "e3"]
        case "E": return ["e3", "g-3", "b3"]
        case "B": return ["b3", "d-3", "f-3"]
        default: return []
        }
    }
    
    func playNotes(forChord chord: String) {
        for note in NotePlayer.getNotes(fromChord: chord) {
            guard let url = Bundle.main.url(forResource: note, withExtension: ".mp3") else { fatalError("Failed to find sound file.") }
            let playerItem:AVPlayerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            
            player?.seek(to: .zero)
            player?.play()
        }
    }
    
    
    
}
