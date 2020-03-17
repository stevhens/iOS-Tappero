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

    var taps: String!
    var maxTaps : Int = 0
    var currTaps : Int = 0
    
    var timer = Timer()
    var isTimerRunning = false
    var seconds : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapCountLabel.textColor = UIColor(red:0.31, green:0.32, blue:0.66, alpha:1.0)
        timerLabel.textColor = UIColor(red:0.31, green:0.32, blue:0.66, alpha:1.0)
        timerLabel.text = "\(seconds)"
        tapCountLabel.text = "\(currTaps)"
        
        maxTaps = (taps as NSString).integerValue
        
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
    
    @objc func updateTimer() {
        seconds -= 1
        
        if seconds < 1 {
            gameOver(x: 0)
            timer.invalidate()
            
            //delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                
                self.dismiss(animated: true, completion: nil)
                
                self.restartGame()
            }
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
                
                gameOver(x: 1)
                timer.invalidate()
                
                //delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.dismiss(animated: true, completion: nil)
                    self.restartGame()
                }
            }
    }
    
    
    func gameOver(x: Int){
        var img: String = ""
        var status: String = ""
        var color: UIColor?
        
        if x == 0 {
            img = "loseBtn"
            status = "GAME OVER"
            color = #colorLiteral(red: 0.9333333333, green: 0.168627451, blue: 0.1647058824, alpha: 1)
        } else {
            img = "winBtn"
            status = "You Win"
            color = #colorLiteral(red: 0.2235294118, green: 0.7333333333, blue: 0.1803921569, alpha: 1)
        }
        
        UIView.transition(with: tapBtn,
                          duration: 5.00,
                          options: .curveEaseIn,
        animations: {
            if let image = UIImage(named: img) {
                self.tapBtn.setImage(image, for: .normal)
            }
        },
        completion: nil)
        
        tapBtn.isEnabled = false
        gameOverLabel.isHidden = false
        
        UIView.animate(withDuration: 1, delay: 0.2, options: [.transitionCrossDissolve], animations: {
            self.gameOverLabel.text = status
            self.gameOverLabel.textColor = color
            self.gameOverLabel.center.x = self.view.bounds.width - 210.0
              self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func isEnded() -> Bool {
        return currTaps >= maxTaps
    }
        
    func updateTapCountLabel() {
        tapCountLabel.text = "\(currTaps)"
    }
    
    func restartGame() {
            isTimerRunning = false
        
            tapBtn.isEnabled = true
            maxTaps = 0
            
            if let image = UIImage(named: "star3") {
                self.tapBtn.setImage(image, for: .normal)
            }
        }
}
