//
//  EndGameController.swift
//  CardsGame
//
//  Created by Student28 on 12/07/2024.
//

import Foundation

import UIKit

class EndGameController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    var winnerText: String?
    var winnerScore: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let winnerText = winnerText, let winnerScore = winnerScore{
            print(winnerText)
            winnerLabel.text = "Winner: \(winnerText)"
            scoreLabel.text = "Score: \(winnerScore)"
        }
    }
    
    @IBAction func backToMenuTapped(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let openScreenVC = storyboard.instantiateViewController(withIdentifier: "OpenScreenController") as? OpenScreenController {
            self.present(openScreenVC, animated: true, completion: nil)
        }
    }    }
