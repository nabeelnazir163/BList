//
//  StringExtensions.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 03/11/22.
//

import UIKit
extension String {
    func currency(symbol: String = "$", minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 0) -> String{
            // removing all characters from string before formatting
//            let stringWithoutSymbol = self.replacingOccurrences(of: symbol, with: "")
//            let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")
            let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.decimalSeparator = "."
        if self != ""{
            if let number = numberFormatter.string(from: NSNumber(value: Double(self) ?? 0.0)){
                return number
            }
        }
        return self
    }

    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return digits.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        
        return false // couldn't turn string into a valid number
    }
    
    /// This function converts Unicode string to original string
    ///
    /// - Example: "\ud83d\ude0d".decode()
    ///
    /// - RESULT: 😍
    /// - Returns: return original string
    func decode() -> String {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    /// This function converts Original string to Unicode string
    ///
    /// - Example: "😍".encode()
    ///
    /// - RESULT:  \ud83d\ude0d
    /// - Returns: return unicode string
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    /// This function removes whitespaces from both sides
    func trim() -> String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// This function removes all the characters that you specified from string
    func trim(characters: [Character]) -> String {
        return String(self.filter({ !characters.contains($0) }))
    }
    
    /// This function checks whether the email that you entered is valid or not
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    /// This function checks whether the password that you entered is valid or not
    func isValidPassword() -> Bool {
      let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-zA-Z])(?=.*[$@$#!%*?&/:;~`,<>=()^]).{8,}$")
       return passwordTest.evaluate(with: self)
    }
    
    /// This function checks whether the string is empty or contains whitespaces
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
    
    /// This function localizes the given string
    var localized :String{
        return NSLocalizedString(self, comment: "")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    /// This function converts the string into URL and checks whether it can be opened or not
    func canOpenURL () -> Bool {
        if let url = URL.init(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    /// This function capitalizes first letter of sentence
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    /// Converts the string to dictionary
    func convertToDictionary() -> [Int:String]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Int:String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /// This method returns the no of words in a string.
    ///
    /// - Example:
    ///
    ///  let str = "Architects and city planners,are  \ndesigning buildings to create  a better quality of life in our urban    areas."
    ///
    /// 18 words, 21 spaces, 2 lines
    /// - Note: Consecutive spaces and newlines aren't coalesced into one generic whitespace region, so you're simply getting a bunch of empty "words" between successive whitespace characters. Get rid of this by filtering out empty strings
    func wordsCount() -> Int{
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = self.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
}
