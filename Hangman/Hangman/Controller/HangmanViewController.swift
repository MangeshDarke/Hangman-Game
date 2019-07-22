//
//  HangmanViewController
//  Hangman
//
//  Created by David [Entei] Xiong on 2/19/19.
//  Copyright © 2019 iosdecal. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    
    @IBOutlet weak var playGameButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       playGameButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func initiateGame(_ sender: UIButton) {
        performSegue(withIdentifier: "homePageToGamePage", sender: sender)
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? GameViewController {
            let image = UIImage(named: "hangman-1")
            dest.tempUIImage.image = image
        }
    }*/
    
}

