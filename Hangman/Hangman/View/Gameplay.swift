//
//  Gameplay.swift
//  Hangman
//
//  Created by Mangesh Darke on 2/27/19.
//  Copyright © 2019 iosdecal. All rights reserved.
//

import Foundation

class Gameplay {
    let currentPhrase: String
    lazy var currentPhraseOmitted: String = initializeCPO()
    var numIncorrect: Int = 0
    var phrases: NSArray!
    var previouslyInputtedLetters: [Character] = []
    
    init() {
        let path = Bundle.main.path(forResource: "phrases", ofType: "plist")
        phrases = NSArray.init(contentsOfFile: path!)
        
        let randomPhraseIndex = Int.random(in: 0..<phrases.count)
        
        var newCPO: String = ""
        var currentIndex: Int = 0
        let phrasesArray = Array(phrases)
        let currPhrase: String = phrasesArray[randomPhraseIndex] as! String
        for char in currPhrase {
            if (currentIndex < currPhrase.count - 1) {
                newCPO.append("\(char) ")
            } else {
                newCPO.append(char)
            }
            currentIndex += 1
        }
        self.currentPhrase = newCPO
    }
    
    //Initialize currentPhraseOmitted
    func initializeCPO() -> String {
        var newCPO: String = ""
        var currentIndex: Int = 0
        for char in self.currentPhrase {
            if char == " " {
                newCPO.append(char)
            } else {
                newCPO.append("_")
            }
            currentIndex += 1
        }
        return newCPO
    }
    
    //Update the number of incorrect guesses
    func numWrongUpdate() {
        self.numIncorrect += 1
    }
    
    //Return whether the phrase contains the letter or not
    func contains(_ letter: Character) -> Bool {
        self.previouslyInputtedLetters.append(letter)
        for char in self.currentPhrase {
            if char == letter {
                return true
            }
        }
        return false
    }
    
    //Return the indices where the letter is in the phrase
    func charIndices(_ letter: Character) -> [Int] {
        var indicesArray: [Int] = []
        var currentIndex: Int = 0
        for char in self.currentPhrase {
            if char == letter {
                indicesArray.append(currentIndex)
            }
            currentIndex += 1
        }
        return indicesArray
    }
    
    //Since the phrase contains the letter, update the omitted version with the letters
    func updateCurrentPhraseOmitted(_ indices: [Int], _ letter: Character) {
        var arrayCurrentPhraseOmitted = Array(self.currentPhraseOmitted)
        var index: Int = 0
        let indicesLength: Int = indices.count - 1
        for i in 0..<arrayCurrentPhraseOmitted.count {
            if i == indices[index] {
                arrayCurrentPhraseOmitted[i] = letter
                if index < indicesLength {
                    index += 1
                } else {
                    break
                }
            }
        }
        self.currentPhraseOmitted = String(arrayCurrentPhraseOmitted)
    }
    
    //Update hangman image
    func updateHangman() -> String {
        if self.numIncorrect <= 2 {
            return "hangman2"
        } else if self.numIncorrect <= 5 {
            return "hangman3"
        } else if self.numIncorrect == 6 {
            return "hangman4"
        } else if self.numIncorrect == 7 {
            return "hangman5"
        } else if self.numIncorrect == 8 {
            return "hangman6"
        } else {
            return "hangman7"
        }
    }
    
    func restart() {
        self.numIncorrect = 0
        self.currentPhraseOmitted = initializeCPO()
        self.previouslyInputtedLetters = []
    }
}
