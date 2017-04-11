//
//  RegisterViewController.swift
//  Socket_Chat
//
//  Created by devloper65 on 4/7/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate {
    
    @IBOutlet var viewPicker: UIView!
    @IBOutlet var imgApp: UIImageView!
    @IBOutlet var btnCountry: UIButton!
    @IBOutlet var txfCCode: UITextField!
    @IBOutlet var txfNumber: UITextField!
    @IBOutlet var pickerCountry: UIPickerView!
    @IBOutlet var btnNext: UIButton!
    
    var transperantView = UIView()
    var textField = UITextField()
    var picker = ["USA","INDIA","CANADA","SPAIN","UAE","JAPAN","CHINA"]
    var pickerVALUE = ["+1","+91","+1","+34","+971","+81","+86"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        
        txfCCode.delegate = self
        txfNumber.delegate = self
        pickerCountry.delegate = self
        
        btnNext.isEnabled = false
        txfCCode.isEnabled = false
        let item1 = UIBarButtonItem(customView: btnNext)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }

    override func viewDidLayoutSubviews() {
        
        self.viewPicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 190, width: UIScreen.main.bounds.width, height: 190)
    }
    
    //MARK:- Outlet Action
    @IBAction func handlebtnCountry(_ sender: Any) {
        UIView.animate(withDuration: 10, animations: {
            self.transperantView = UIView(frame: UIScreen.main.bounds)
            self.transperantView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.addSubview(self.transperantView)
            self.view.addSubview(self.viewPicker)

        }, completion: nil)
        self.textField.resignFirstResponder()
        pickerCountry.isHidden = false
        
    }
    
    @IBAction func handlepickerDone(_ sender: Any) {
        self.viewPicker.removeFromSuperview()
        self.transperantView.removeFromSuperview()
    }
    
    @IBAction func handlepickerCancel(_ sender: Any) {
        self.viewPicker.removeFromSuperview()
        self.transperantView.removeFromSuperview()
    }
    
    @IBAction func handlebtnNxt(_ sender: Any) {

        if isValidNumber(txfNumber.text!, length: 10) {
            let nav = ProfileViewController()
            self.navigationController?.pushViewController(nav, animated: true)
            self.txfNumber.textColor = UIColor.black
            self.textField.resignFirstResponder()
        } else {
            self.txfNumber.textColor = UIColor.red
        }
    }
    //MARK:- Picker Delegate

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.picker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.picker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txfCCode.text = self.pickerVALUE[row]
//        self.btnCountry.lay
    }
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        if textField == txfNumber {
            self.addDoneButtonOnKeyboard(textField: textField)
            textField.keyboardType = UIKeyboardType.numberPad
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidNumber(textField.text!, length: 10) {
            self.btnNext.isEnabled = true
            textField.textColor = UIColor.black
            self.textField.resignFirstResponder()
        } else {
            textField.textColor = UIColor.red
        }
        return true
    }
    
    //MARK:- Custom Method
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(cancel)
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.textField = textField
        textField.inputAccessoryView = doneToolbar
    }
    
    
    func doneButtonAction(txt: UITextField) {
        if isValidNumber(textField.text!, length: 10) {
            self.btnNext.isEnabled = true
            textField.textColor = UIColor.black
            self.textField.resignFirstResponder()
        } else {
            textField.textColor = UIColor.red
        }
    }
    
    func cancelButtonAction(txt: UITextField) {
        self.textField.resignFirstResponder()
    }
    
    func isValidNumber(_ data:String,length:Int?) -> Bool{
        let ns:NSString
        if let _ = length{
            ns = "[0-9]{\(length!)}" as NSString
        }else{
            ns = "[0-9]+"
        }
        let pr:NSPredicate = NSPredicate(format: "SELF MATCHES %@",ns)
        return pr.evaluate(with: data)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
