//
//  DialogWindow.swift
//  CryptographyLAB2
//
//  Created by Vladislav Kondrashkov on 10/18/18.
//  Copyright © 2018 Vladislav Kondrashkov. All rights reserved.
//

import Cocoa

class DialogWindow {
    let alert: NSAlert
    
    init(question: String, text: String) {
        self.alert = NSAlert()
        self.alert.messageText = question
        self.alert.informativeText = text
        self.alert.alertStyle = NSAlert.Style.critical
        self.alert.addButton(withTitle: "Ok")
        self.alert.addButton(withTitle: "Cancel")
    }
    
    func ask() -> Bool {
        let result = self.alert.runModal()
        if result == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        return false
    }
}
