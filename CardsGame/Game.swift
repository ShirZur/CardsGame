//
//  Game.swift
//  CardsGame
//
//  Created by Student28 on 12/07/2024.
//



import Foundation

class Game {
    var westName: String?
    var eastName: String?
    
    var side: String?
    var callback: ((String, String, Int, Int) -> Void)?
    var gameEndCallback: ((String, Int) -> Void)?
    var timerUpdateCallback: ((Int) -> Void)?
   
    
    var gameTimer: Timer?
    
    var cardImages =  ["card_2", "card_3", "card_4", "card_5", "card_6", "card_7", "card_8", "card_9", "card_10"]
    var reversedCardImage = "reversed_card"
    
    var westScore = 0
    var eastScore = 0
    var roundCount = 0
    let maxRounds = 10
    var currentTime = 0.0
    var shouldEndGame = false
    var timeLeft = 0
    
    init(westName: String, eastName: String ){
        self.westName = westName
        self.eastName = eastName
        print(westName)
        print(eastName)
       
    }
    
    func startGame(){
        westScore = 0
        eastScore = 0
        roundCount = 0
        currentTime = 0.0
        timeLeft = 5
        callback?(reversedCardImage, reversedCardImage,westScore, eastScore)
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
    }
    @objc private func updateGame(){
        print(currentTime)
        
        currentTime += 1.0

        if currentTime >= 2 && currentTime <= 5 {
            timeLeft = 5 - Int(currentTime)
            timerUpdateCallback?(timeLeft)
        }else{
            timerUpdateCallback?(0)
        }
        if currentTime == 2.0{
            displayRandomCards()
            timeLeft = 3   }
        else if currentTime == 5.0{
            if shouldEndGame{
                endGame()
            }
            else{
                showRevesedCards()
                currentTime = 0.0
                timeLeft = 5
            }
            
        }
    }
    
    private func showRevesedCards(){
        
        callback?(reversedCardImage, reversedCardImage, westScore, eastScore)
        
    }
    
    private func displayRandomCards()
    {
        //reverseTimer?.invalidate()
        
        let randomIndex1 = Int.random(in: 0..<cardImages.count)
        let randomIndex2 = Int.random(in: 0..<cardImages.count)
        
        callback?(cardImages[randomIndex1], cardImages[randomIndex2], westScore, eastScore)
        
        updateScores(playerCard: randomIndex1, pcCard: randomIndex2)
        roundCount += 1
        if roundCount >= maxRounds{
            shouldEndGame = true
        }
    }
        
        func updateScores(playerCard: Int, pcCard: Int){
            if playerCard > pcCard {
                westScore += 1
            }else if pcCard > playerCard{
                eastScore += 1
            }
        }
        
        
        func endGame(){
            gameTimer?.invalidate()
            gameTimer = nil
            let winner: String
            let score: Int
            if westScore > eastScore{
                    winner = "\(westName ?? "Player")"
                    score = westScore
            }else if eastScore > westScore{
                    winner = "PC"
                    score = eastScore
            }else{
                winner = "\(westName ?? "Player")"
                score = westScore
            }
            gameEndCallback?(winner, score)
        }
        
        
        
        
    }
    

