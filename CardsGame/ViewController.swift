//
//  ViewController.swift
//  CardsGame
//
//  Created by Student28 on 12/07/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var eastScoreLabel: UILabel!
    @IBOutlet weak var eastSideLabel: UILabel!
    @IBOutlet weak var westScoreLabel: UILabel!
    @IBOutlet weak var westSideLabel: UILabel!
    @IBOutlet weak var card_number_2: UIImageView!
    @IBOutlet weak var card_number_1: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    var playerName: String?
    var playerSide: String?
    var westName: String = ""
    var eastName: String = ""
   
    var game: Game?
    override func viewDidLoad() {
        super.viewDidLoad()
        if playerName == nil{
            playerName = UserDefaults.standard.string(forKey: "playerName")
        }
        
        if let name = playerName{
            if let side = playerSide{
                if side == "east"{
                    eastSideLabel.text = name
                    westSideLabel.text = "PC"
                    eastName = name
                    westName = "PC"
                }
                else{
                    eastSideLabel.text = "PC"
                    westSideLabel.text = name
                    eastName = "PC"
                    westName = name
                }
                print(side)
            }
           
            print(eastName)
            //westSideLabel.text = name
            game = Game(westName: westName, eastName: eastName)
           
        }
    
        game?.callback = {
            [weak self] card1, card2, westScore, eastScore in self?.updateCards(card1: card1, card2: card2, westScore: westScore, eastScore: eastScore)
        }
        
        game?.timerUpdateCallback = {[weak self] timeLeft in self?.updateTimerLabel(timeLeft: timeLeft)}
        
        game?.gameEndCallback = {
            [weak self] winner, score in self?.showGameEndScreen(winner: winner, score:score)
        }
        
        game?.startGame()
    }
    
    private func updateTimerLabel(timeLeft: Int){
        if timeLeft > 0 {
            timerLabel.isHidden = false
            timerLabel.text = "\(timeLeft)"
        }
        else{
            timerLabel.isHidden = true
        }
    }
    
   
    private func showGameEndScreen(winner: String, score: Int){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let endGameVC = storyboard.instantiateViewController(withIdentifier: "EndGameController") as?EndGameController {
            endGameVC.winnerText = winner
            endGameVC.winnerScore = score
            self.present(endGameVC, animated: true, completion: nil)
        }
    }
  
    
    private func updateCards(card1: String, card2: String, westScore: Int, eastScore: Int){
        card_number_1.image = UIImage(named: card1)
        card_number_2.image = UIImage(named: card2)
        westScoreLabel.text = "\(westScore)"
        eastScoreLabel.text = "\(eastScore)"
        
    }
    

}

