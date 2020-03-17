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
    @IBOutlet weak var tapGoalTextField: UITextField!
    @IBOutlet weak var playBg: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var maxTaps : Int = 0
    var seconds : Int = 0
    
    var selectedSeconds : String? = ""
    let timeSeconds = ["30","45","60"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGoalTextField.becomeFirstResponder()
        
        tapGoalTextField.underlined()
        
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
        pickerView.reloadAllComponents()
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
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: timeSeconds[row] + " Seconds", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tapVC = segue.destination as? TapViewController else { return }
        
        if validateGoalInput(x: tapGoalTextField.text) {
            tapGoalTextField.resignFirstResponder()
        }
        
        tapVC.taps = self.tapGoalTextField.text
        
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

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func leftBorder(){
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 70, y: 0, width: 1, height: 223)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
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
