//
//  GameViewController.swift
//  Hangman
//
//  Created by Mangesh Darke on 2/24/19.
//  Copyright © 2019 iosdecal. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var confirmGuessButton: UIButton!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var currentPhraseOmitted: UILabel!
    @IBOutlet weak var currentGuess: UILabel!
    
    var currentGame = Gameplay()
    let tempUIImage = UIImageView()
    var currentLetter: Character = "#"
    var currentButton: UIButton = UIButton()
    var player: AVAudioPlayer?
    
    @IBOutlet var letterButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        quitButton.layer.cornerRadius = 5
        restartButton.layer.cornerRadius = 5
        confirmGuessButton.layer.cornerRadius = 5
        currentPhraseOmitted.text = currentGame.currentPhraseOmitted
        gameImage.image = UIImage(named: "hangman1")
    }
    @IBAction func quitPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "gamePageToHomePage", sender: sender)
    }
    
    @IBAction func checkGuess(_ sender: UIButton) {
        var input = currentLetter
        if contains(input) {
            input = "#"
        }
        if input != "#" {
            currentButton.setTitleColor(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal) 
            if (currentGame.contains(input)) {
                let indices: [Int] = currentGame.charIndices(input)
                currentGame.updateCurrentPhraseOmitted(indices, input)
                currentPhraseOmitted.text = currentGame.currentPhraseOmitted
                playSound("Yes")
                if currentGame.currentPhrase == currentGame.currentPhraseOmitted {
                    let alert = UIAlertController(title: "You Win! :)", message: "You have correctly guessed the phrase!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("New Game", comment: "Start a new game"), style: .default, handler: { action in
                        self.newGame()
                    }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Quit", comment: "Quit playing the game"), style: .default, handler: { action in
                        self.performSegue(withIdentifier: "gamePageToHomePage", sender: self.quitButton)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    playSound("Cheering")
 
                }
            } else {
                currentGame.numWrongUpdate()
                incorrectGuessesLabel.text?.append(" \(input)")
                self.gameImage.image = UIImage(named: currentGame.updateHangman())
                self.gameImage.sizeToFit()
                playSound("No")
                if currentGame.numIncorrect == 9 {
                    let alert = UIAlertController(title: "You Lose! :(", message: "You made too many incorrect guesses and have been hanged!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Restart", comment: "Restart the game"), style: .default, handler: { action in
                        self.restartPressed(self.restartButton)
                    }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Quit", comment: "Quit playing the game"), style: .default, handler: { action in
                        self.quitPressed(self.quitButton)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    playSound("Sad Trombone")
                }
            }
        }
    }
    
    @IBAction func letterPressed(_ sender: UIButton) {
        let letterText = sender.titleLabel!.text?.lowercased()
        if !contains(Character(letterText!)) && sender.currentTitleColor != #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) {
            currentLetter = Character(letterText!)
            currentButton = sender
            currentGuess.text = "Guess:   \(String(sender.currentTitle!))"
        }
    }
    
    
    func newGame() {
        currentGame = Gameplay()
        for button in letterButtons {
            button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        }
        currentPhraseOmitted.text = currentGame.currentPhraseOmitted
        gameImage.image = UIImage(named: "hangman1")
        incorrectGuessesLabel.text = "Wrong Guesses: "
        currentGuess.text = "Guess: "
    }
    
    
    
    @IBAction func restartPressed(_ sender: UIButton) {
        currentGame.restart()
        for button in letterButtons {
            button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        }
        currentPhraseOmitted.text = currentGame.currentPhraseOmitted
        gameImage.image = UIImage(named: "hangman1")
        incorrectGuessesLabel.text = "Wrong Guesses: "
        currentGuess.text = "Guess: "
    }
    
    func contains(_ inputtedCharacter: Character) -> Bool {
        for char in currentGame.previouslyInputtedLetters {
            if char == inputtedCharacter {
                return true
            }
        }
        return false
    }
    
    func playSound(_ soundFileName: String) {
        let path = Bundle.main.path(forResource: soundFileName, ofType:"wav")!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            // couldn't load file :(
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
