//
//  ViewController.swift
//  CryptographyLAB2
//
//  Created by Vladislav Kondrashkov on 10/18/18.
//  Copyright © 2018 Vladislav Kondrashkov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var frequencyTextField: NSTextField!
    @IBOutlet weak var decryptedTextField: NSTextField!
    @IBOutlet weak var encryptedTextField: NSTextField!
    @IBOutlet weak var sourceTextField: NSTextField!
    @IBOutlet weak var firstKeyField: NSTextField!
    @IBOutlet weak var secondKeyField: NSTextField!
    
    let module: Int = 26
    let encrypter = Encrypter()
    
    @IBAction func encryptButtonAction(_ sender: NSButton) {
        encryptedTextField.stringValue = ""
        
        let sourceText = sourceTextField.stringValue
        guard let firstKey = Int(firstKeyField.stringValue),
            let secondKey = Int(secondKeyField.stringValue),
            firstKey < module && secondKey < module else {
                return
        }
        
        if !Int.isMutuallyPrimal(firstKey, and: module) || !Int.isMutuallyPrimal(secondKey, and: module) {
            let dialogWindow = DialogWindow(question: "Continue?", text: "One of your keys are not mutually primal with module. Result may be incorrect. Do you want to continue?")
            if dialogWindow.ask() == false {
                return
            }
        }
        
        let encryptedText = encrypter.encryptText(sourceText, with: firstKey, and: secondKey, by: module)
        encryptedTextField.stringValue = encryptedText
        
        let frequencyDictionary = encrypter.getFrequency(text: encryptedText)
        encrypter.setNewFrequency(newFrequency: frequencyDictionary)
        var frequencyText: String = ""
        for (symbol, frequency) in frequencyDictionary {
            frequencyText += symbol + " - " + String(frequency) + "\n"
        }
        frequencyTextField.stringValue = frequencyText
    }
    
    @IBAction func decryptButtonAction(_ sender: NSButton) {
        decryptedTextField.stringValue = ""
        
        let encryptedText = encryptedTextField.stringValue
        guard let firstKey = Int(firstKeyField.stringValue),
            let secondKey = Int(secondKeyField.stringValue),
            firstKey < module && secondKey < module else {
                return
        }
        
        if !Int.isMutuallyPrimal(firstKey, and: module) || !Int.isMutuallyPrimal(secondKey, and: module) {
            let dialogWindow = DialogWindow(question: "Continue?", text: "One of your keys are not mutually primal with module. Result may be incorrect. Do you want to continue?")
            if dialogWindow.ask() == false {
                return
            }
        }
        
        // let decryptedText = encrypter.decryptText(encryptedText, with: firstKey, and: secondKey, by: module)
        let decryptedText = encrypter.replaceByFrequency(encryptedText: encryptedText, defaultFrequency: encrypter.getDefaultFrequency(), newFrequency: encrypter.getNewFrequency())
        decryptedTextField.stringValue = decryptedText
    }
    
    @IBAction func clearButtonAction(_ sender: NSButton) {
        switch sender.tag {
        case 1:
            sourceTextField.stringValue = ""
        case 2:
            encryptedTextField.stringValue = ""
        case 3:
            decryptedTextField.stringValue = ""
        default:
            print("ERROR!")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frequencyDictionary = encrypter.getDefaultFrequency()
        var frequencyText: String = ""
        for (symbol, frequency) in frequencyDictionary {
            frequencyText += symbol + " - " + String(frequency) + "\n"
        }
        frequencyTextField.stringValue = frequencyText
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

