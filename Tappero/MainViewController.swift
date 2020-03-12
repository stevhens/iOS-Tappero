//
//  ViewController.swift
//  Tappero
//
//  Created by Stevhen on 04/03/20.
//  Copyright © 2020 stevhen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var tapBtn: UIButton!
    @IBOutlet weak var tapCountLabel: UILabel!
    @IBOutlet weak var tapGoalTextField: UITextField!
    @IBOutlet weak var playBg: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
//    @IBOutlet weak var gameOverLabel: UILabel!
    
//    @IBOutlet weak var timerLabel: UILabel!
    
    var maxTaps : Int = 0
    var seconds : Int = 0
    
    var selectedSeconds : String? = ""
    let timeSeconds = ["30","45","60"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGoalTextField.keyboardType = .asciiCapableNumberPad
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.playBg.layer.cornerRadius = 20
        tapGoalTextField.layer.cornerRadius = 20
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        tap.cancelsTouchesInView = false
        self.hideKeyboardWhenTappedAround()

        view.addGestureRecognizer(tap)
        
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
            
            
            
//            maxTaps = Int(tapGoalTextField.text!)!
//            showTapImage()
//            pickerView.isHidden = true
            
            tapGoalTextField.resignFirstResponder()
        }
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
    
    
//    func showTapImage() {
////        tapCountLabel.isHidden = false
////        tapBtn.isHidden = false
//
//        logoImg.isHidden = true
//        playBtn.isHidden = true
//        tapGoalTextField.isHidden = true
////        logoBg.isHidden = true
//        playBg.isHidden = true
//    }
    
    func restartGame(){
        maxTaps = 0
//        resetBtnColor()
        pickerView.selectRow(0, inComponent: 0, animated: true)

        playBtn.isHidden = false
        tapGoalTextField.text = ""
        tapGoalTextField.isHidden = false
//        logoBg.isHidden = false
        logoImg.isHidden = false
        playBg.isHidden = false
        
//        tapBtn.isHidden = true
//        tapCountLabel.text = ""
//        tapCountLabel.isHidden = true
        pickerView.isHidden = false
//        thirtySecondsBtn.isHidden = false
//        fourtyFiveSecondsBtn.isHidden = false
//        sixtySecondsBtn.isHidden = false
        
//        gameOverLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tapVC = segue.destination as? TapViewController else { return }
        tapVC.maxTaps = self.tapGoalTextField.text
        
        if seconds == 0 {
            seconds = (timeSeconds[0] as NSString).integerValue
        }
        
        tapVC.seconds = self.seconds
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
