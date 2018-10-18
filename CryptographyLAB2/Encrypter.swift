//
//  Encrypter.swift
//  CryptographyLAB2
//
//  Created by Vladislav Kondrashkov on 10/18/18.
//  Copyright © 2018 Vladislav Kondrashkov. All rights reserved.
//

import Foundation

class Encrypter {
    /*
    private let frequencyDictionary: [(String, Float)] = [("E", 12.31), ("T", 9.59), ("A", 8.05), ("O", 7.94), ("N", 7.19),
                               ("I", 7.18), ("S", 6.59), ("R", 6.03), ("H", 5.14), ("L", 4.03),
                               ("D", 3.65), ("C", 3.20), ("U", 3.10), ("P", 2.29), ("F", 2.28),
                               ("M", 2.25), ("W", 2.03), ("Y", 1.88), ("B", 1.62), ("G", 1.61),
                               ("V", 0.93), ("K", 0.52), ("Q", 0.2), ("X", 0.2), ("J", 0.1), ("Z", 0.09)]
    */
    /*
    private let frequencyDictionary: [(String, Float)] = [("E", 12.02), ("T", 9.10), ("A", 8.12), ("O", 7.68), ("I", 6.95),
                                                          ("N", 6.95), ("S", 6.28), ("R", 6.02), ("H", 5.92), ("D", 4.32),
                                                          ("L", 3.98), ("U", 2.88), ("C", 2.71), ("M", 2.61), ("F", 2.30),
                                                          ("Y", 2.11), ("W", 2.09), ("G", 2.03), ("P", 1.82), ("B", 1.49),
                                                          ("V", 1.11), ("K", 0.69), ("X", 0.17), ("Q", 0.11), ("J", 0.10), ("Z", 0.07)]
    */
    
    /* HAMLET FREQUENCY */
    private let frequencyDictionary: [(String, Float)] = [("E", 11.26), ("T", 9.39), ("O", 8.9), ("A", 7.73), ("I", 6.62),
                                                          ("N", 6.32), ("S", 6.32), ("H", 6.28), ("R", 6.2), ("L", 4.78),
                                                          ("D", 3.99), ("U", 3.49), ("M", 3.25), ("Y", 2.52), ("W", 2.19),
                                                          ("F", 2.05), ("C", 1.98), ("G", 1.75), ("P", 1.44), ("B", 1.39),
                                                          ("V", 0.91), ("K", 0.88), ("Q", 0.11), ("X", 0.11), ("Z", 0.08), ("J", 0.07)]
    /*
    private let frequencyDictionary: [(String, Float)] = [("E", 12.7), ("T", 9.06), ("A", 8.17), ("O", 7.51), ("I", 6.97),
                                                          ("N", 6.75), ("S", 6.33), ("H", 6.09), ("R", 5.99), ("D", 4.25),
                                                          ("L", 4.03), ("C", 2.78), ("U", 2.76), ("M", 2.41), ("W", 2.36),
                                                          ("F", 2.23), ("G", 2.02), ("Y", 1.97), ("P", 1.93), ("B", 1.49),
                                                          ("V", 0.96), ("K", 0.77), ("X", 0.15), ("J", 0.15), ("Q", 0.10), ("Z", 0.05)]
    */
    private var newFrequencyDictionary = [(String, Float)]()

    private let punctuationMarks = [",", ".", " ", "!", "?", ":", ";", "\n", "\t", "\"", "'", ")", "(", "-", "’"]
    private let russianAlphabetOffset = 1040
    private let englishAlphabetOffset = 65
    
    func encryptText(_ sourceText: String, with firstKey: Int, and secondKey: Int, by module: Int) -> String {
        var indexOffset: Int = 0;
        
        if module == 26 {
            indexOffset = englishAlphabetOffset
        }
        else if module == 33 {
            indexOffset = russianAlphabetOffset
        }
        
        var encryptedText: String = ""
        for symbol in sourceText {
            if punctuationMarks.contains(String(symbol)) {
                encryptedText += String(symbol)
                continue
            }
            if symbol >= "0" && symbol <= "9" {
                encryptedText += String(symbol)
                continue
            }
            var characterIndex = symbol.code - indexOffset
            var lowerCased = false
            if characterIndex >= 32 {
                lowerCased = true
                characterIndex -= 32
            }
            
            var newSymbolCode = (characterIndex * secondKey + firstKey) % module + indexOffset
            if lowerCased {
                newSymbolCode += 32
            }
            let newSymbol = Character(UnicodeScalar(newSymbolCode)!)
            encryptedText += String(newSymbol)
        }
        
        return encryptedText
    }
    
    func setNewFrequency(newFrequency: [(String, Float)]) {
        self.newFrequencyDictionary = newFrequency
    }
    func getDefaultFrequency() -> [(String, Float)] {
        return self.frequencyDictionary
    }
    func getNewFrequency() -> [(String, Float)] {
        return self.newFrequencyDictionary
    }
    
    func replaceByFrequency(encryptedText: String, defaultFrequency: [(String, Float)], newFrequency: [(String, Float)]) -> String {
        var decryptedText = ""
        for character in encryptedText {
            if punctuationMarks.contains(String(character)) {
                decryptedText += String(character)
                continue
            }
            if character >= "0" && character <= "9" {
                decryptedText += String(character)
                continue
            }
            var index = 0
            for (symbol, _) in newFrequency {
                if symbol == String(character).uppercased() {
                    break
                }
                index += 1
            }
            let newSymbol = defaultFrequency[index].0
            decryptedText += newSymbol
        }
        return decryptedText
    }
    
    func getFrequency(text: String) -> [(String, Float)] {
        var clearTextLength: Float = 0
        for character in text {
            if punctuationMarks.contains(String(character)) {
                continue
            }
            clearTextLength += 1
        }
        
        var newFrequencyDictionary = [(String, Float)]()
        for (symbol, _) in frequencyDictionary {
            var characterAppeared: Float = 0
            for character in text {
                if symbol == String(character).uppercased() {
                    characterAppeared += 1
                }
            }
            let newFrequency = characterAppeared / clearTextLength * 100
            newFrequencyDictionary.append((symbol, newFrequency))
        }
        
        newFrequencyDictionary = newFrequencyDictionary.sorted(by: { $0.1 > $1.1 })
        return newFrequencyDictionary
    }
    
}
