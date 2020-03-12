//
//  TapViewController.swift
//  Tappero
//
//  Created by Stevhen on 12/03/20.
//  Copyright © 2020 stevhen. All rights reserved.
//

import UIKit

class TapViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tapCountLabel: UILabel!
    @IBOutlet weak var tapBtn: UIButton!
    @IBOutlet weak var gameOverLabel: UILabel!

    var maxTaps: String!
    var currTaps : Int = 0
    
    var timer = Timer()
    var isTimerRunning = false
    var seconds : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapCountLabel.textColor = UIColor(red:0.31, green:0.32, blue:0.66, alpha:1.0)
        timerLabel.textColor = UIColor(red:0.31, green:0.32, blue:0.66, alpha:1.0)
        
        if isTimerRunning == false {
            isTimerRunning = true
            runTimer()
        }
    }
    
    func showFailAlert() {
        
        let alert = UIAlertController(title: "Time's Up", message: "Goal not Achieved\n Try again🥺", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWinAlert() {
        
        let alert = UIAlertController(title: "Congratulation", message: "Goal Achieved\n You have tapped \(currTaps) times✨", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    fileprivate func restartGame() {
        //            restartGame()
        isTimerRunning = false
        timer.invalidate()
        
        tapBtn.isEnabled = true
        maxTaps = ""
        tapCountLabel.text = ""
        
        if let image = UIImage(named: "star3") {
            self.tapBtn.setImage(image, for: .normal)
        }
    }
    
    @objc func updateTimer() {
        seconds -= 1
        
        if seconds < 1 {
            showFailAlert()
            restartGame()
        }
        
        timerLabel.text = "\(seconds)"
    }
    
    @IBAction func tapBtnPressed(_ sender: UIButton) {
        currTaps += 1
                tapBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                UIView.animate(withDuration: 1.0,
                               delay: 0.2,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 4.0,
                options: .allowUserInteraction,
                animations: { [weak self] in
                  self?.tapBtn.transform = .identity
                },
                completion: nil)

                updateTapCountLabel()
                
                if isEnded() {
        //            showWinAlert()
        //            let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        //            myLabel.text = "GameOver!"
        //            myLabel.fontSize = 65
        //            myLabel.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.65)
        //            self.addChild(myLabel)
                    
                    gameOver()
                    timer.invalidate()
                    
                    //delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
                       // Code you want to be delayed
                        self.restartGame()
                    }
                }
    }
    
    
    func gameOver(){
            //UIImage
            UIView.transition(with: tapBtn,
                              duration: 5.00,
                              options: .curveEaseIn,
            animations: {
                if let image = UIImage(named: "gameOver") {
                    self.tapBtn.setImage(image, for: .normal)
                }
            },
            completion: nil)
            tapBtn.isEnabled = false
            gameOverLabel.isHidden = false
            
            UIView.animate(withDuration: 1, delay: 0.2, options: [.transitionCrossDissolve], animations: {
                self.gameOverLabel.text = "GAME OVER"
                self.gameOverLabel.center.x = self.view.bounds.width - 230.0
                  self.view.layoutIfNeeded()
            }, completion: nil)
            
            
    //        let winner = SKLabelNode(fontNamed: "Chalkduster")
    //        winner.text = "You Win!"
    //        winner.fontSize = 65
    //        winner.fontColor = SKColor.green
    //        winner.position = CGPoint(x: 82, y: 423)
    //
    //        self.addChild(winner)
            
            //game over animation
    //        gameOverLbl = SKLabelNode(fontNamed:"Chalkduster")
    //        gameOverLbl.text = "GameOver!"
    //        gameOverLbl.fontSize = 65
    //        gameOverLbl.position = CGPoint(x: 82, y: 423)
    //        self.addChild(gameOverLbl! as UIViewController)
        }
    
    func isEnded() -> Bool {
        return currTaps >= (maxTaps as NSString).integerValue
    }
        
    func updateTapCountLabel() {
        tapCountLabel.text = "\(currTaps)"
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
