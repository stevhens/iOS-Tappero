//
//  ViewController.swift
//  Tappero
//
//  Created by Stevhen on 04/03/20.
//  Copyright © 2020 stevhen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var tapBtn: UIButton!
    @IBOutlet weak var tapCountLabel: UILabel!
    @IBOutlet weak var tapGoalTextField: UITextField!
    @IBOutlet weak var playBg: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var maxTaps : Int = 0
    var currTaps : Int = 0
    var seconds : Int = 0
    var timer = Timer()
    var isTimerRunning = false
    var selectedSeconds : String? = ""
    let timeSeconds = ["30","45","60"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapCountLabel.isHidden = true
        tapBtn.isHidden = true
        
        tapGoalTextField.keyboardType = .asciiCapableNumberPad
        tapCountLabel.textColor = UIColor(red:0.31, green:0.32, blue:0.66, alpha:1.0)
        timerLabel.textColor = UIColor(red:0.31, green:0.32, blue:0.66, alpha:1.0)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.playBg.layer.cornerRadius = 20
        tapGoalTextField.layer.cornerRadius = 20
//        self.playBg.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        self.playBtn.layer.shadowOpacity = 0.4
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        tap.cancelsTouchesInView = false
        self.hideKeyboardWhenTappedAround()

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
        timerLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeSeconds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeSeconds[row] + " Seconds"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSeconds = timeSeconds[row]
        if let a = selectedSeconds {
            seconds = (a as NSString).integerValue
        } else {
            seconds = 30
        }
    }
    
    override func dismissKeyboard(){
        tapGoalTextField.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    fileprivate func hideSecondsBtn() {
    }
    
    @IBAction func playBtnPressed(_ sender: Any) {
        
        //put time deadline
        
        if validateGoalInput(x: tapGoalTextField.text) {
            hideSecondsBtn()
            timerLabel.isHidden = false
            
            if seconds == 0 {
                seconds = (timeSeconds[0] as NSString).integerValue
            }
            timerLabel.text = "\(seconds)"
            
            maxTaps = Int(tapGoalTextField.text!)!
            showTapImage()
            pickerView.isHidden = true
            
            if isTimerRunning == false {
                isTimerRunning = true
                runTimer()
            }
            
            tapGoalTextField.resignFirstResponder()
            
            updateTapCountLabel()
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        
        if seconds < 1 {
            showFailAlert()
            restartGame()
        }
        
        timerLabel.text = "\(seconds)"
    }
    
    func showFailAlert() {
        
        let alert = UIAlertController(title: "Time's Up", message: "Goal not Achieved\n Try again🥺", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapBtnPressed(_ sender: Any) {
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
    
    func updateTapCountLabel() {
        tapCountLabel.text = "\(currTaps)"
    }
    
    func showWinAlert() {
        
        let alert = UIAlertController(title: "Congratulation", message: "Goal Achieved\n You have tapped \(currTaps) times✨", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInputAlert(x: Int){
        let alerts = ["Field must not be empty", "Must be number", "Must greater than zero"]
        
        let alert = UIAlertController(title: "Warning", message: alerts[x], preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateGoalInput(x : String?) -> Bool {
        var flag: Bool = false
        
        if x == nil || x == "" {
            showInputAlert(x: 0)
        }
        else if !x!.isInt {
            showInputAlert(x: 1)
        }
        else if Int(x!)! < 0 {
            showInputAlert(x: 2)
        }
        else {
            flag = true
        }
        
        return flag
    }
    
    func resetBtnColor() {
//        thirtySecondsBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
//        fourtyFiveSecondsBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
//        sixtySecondsBtn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
//        thirtySecondsBtn.isHighlighted = false
//        fourtyFiveSecondsBtn.isHighlighted = false
//        sixtySecondsBtn.isHighlighted = false
//        thirtySecondsBtn.setImage(UIImage(named: "30.png"), for: .normal)
//        fourtyFiveSecondsBtn.setImage(UIImage(named: "45.png"), for: .normal)
//        sixtySecondsBtn.setImage(UIImage(named: "60.png"), for: .normal)
    }
    
//    @IBAction func timerBtnPressed(_ sender: UIButton) {
//        resetBtnColor()
//
//        if sender == thirtySecondsBtn {
////            thirtySecondsBtn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
//            thirtySecondsBtn.setImage(UIImage(named: "30dark"), for: .normal)
//
//            seconds = 30
//        }
//        else if sender == fourtyFiveSecondsBtn {
////            fourtyFiveSecondsBtn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
//            fourtyFiveSecondsBtn.setImage(UIImage(named: "45dark"), for: .normal)
//            seconds = 45
//        }
//        else if sender == sixtySecondsBtn {
////            sixtySecondsBtn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
////            sixtySecondsBtn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
//            sixtySecondsBtn.setImage(UIImage(named: "60dark"), for: .normal)
//            seconds = 60
//        }
//
//        timerLabel.text = "Time left: \(seconds)"
//
//    }
    
    
    func showTapImage() {
        tapCountLabel.isHidden = false
        tapBtn.isHidden = false
        
        logoImg.isHidden = true
        playBtn.isHidden = true
        tapGoalTextField.isHidden = true
//        logoBg.isHidden = true
        playBg.isHidden = true
    }
    
    func restartGame(){
        maxTaps = 0
        currTaps = 0
//        resetBtnColor()
        pickerView.selectRow(0, inComponent: 0, animated: true)

        playBtn.isHidden = false
        tapGoalTextField.text = ""
        tapGoalTextField.isHidden = false
//        logoBg.isHidden = false
        logoImg.isHidden = false
        playBg.isHidden = false
        
        tapBtn.isHidden = true
        tapCountLabel.text = ""
        tapCountLabel.isHidden = true
        pickerView.isHidden = false
//        thirtySecondsBtn.isHidden = false
//        fourtyFiveSecondsBtn.isHidden = false
//        sixtySecondsBtn.isHidden = false
        
        timerLabel.isHidden = true
        isTimerRunning = false
        gameOverLabel.isHidden = true
        tapBtn.isEnabled = true
        
        timer.invalidate()
        
        if let image = UIImage(named: "star3") {
            self.tapBtn.setImage(image, for: .normal)
        }
    }
    
    func isEnded() -> Bool {
        return currTaps >= maxTaps
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
