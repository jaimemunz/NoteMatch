//
//  NoteMatchIntervalChooserViewController.swift
//  NoteMatch
//
//  Created by Jaime Munoz on 9/14/21.
//

import UIKit

class NoteMatchIntervalChooserViewController: UIViewController {

    let themes = [
        "C Major/A Minor": ["F", "Dm", "C", "Fm", "G", "Em"],
        "G Major/E Minor": ["C", "Am", "G", "Em", "D", "Bm"],
        "E Major/C# Minor": ["F♯m", "C♯m", "G♯m", "A", "E", "B"],
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Interval" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let noteMatchController = segue.destination as? NoteMatchViewController {
                    noteMatchController.interval = theme
                }
            }
        }
    }

}
