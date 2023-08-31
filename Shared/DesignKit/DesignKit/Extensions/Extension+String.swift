//
//  Extension+String.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import Foundation

extension String {

    // MARK: - Decode HTML characters
    public func trimHtmlTags() -> String {
        let sentence = self.replacingOccurrences(of: "<break>", with: "\n")
        let tagsRemoved = sentence.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return tagsRemoved
    }

    public var byDecodingHTMLEntities: String {
        func decodeNumeric(_ string: Substring, base: Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        func decode(_ entity: Substring) -> Character? {
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        var result = ""
        var position = startIndex
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            guard let semiRange = self[position...].range(of: ";") else {
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            if let decoded = decode(entity) {
                result.append(decoded)
            } else {
                result.append(contentsOf: entity)
            }
        }
        result.append(contentsOf: self[position...])
        return result
    }

    // MARK: - Right to left
    public func rightToLeft() -> Bool {
        if self == "ar" || self == "ur" || self == "fa" || self == "ckb" {
            return true
        }
        return false
    }
    // MARK: - Check url from a string
    public func checkForUrls() -> [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count))
            return matches.compactMap({$0.url})
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    // MARK: - Converts HTML String to Attributed String
    public func htmlToAttributedString() -> NSMutableAttributedString? {
        let rawData = self.replacingOccurrences(of: "\n", with: "<br/>")
        let htmlData = NSString(string: rawData).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                  options: options,
                                                                  documentAttributes: nil)
        return attributedString
    }
    public func condensed() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    public func slice(from: String, to string: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: string, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    public func htmlDecoded() -> String {
        guard self != "" else { return self }
        var newStr = self
        let entities = [
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&nbsp;": " ",
            "<break>": ""
        ]

        for (name, value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
    public func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
    public var boolValue: Bool {
        return (self as NSString).boolValue
    }
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    public func getFirstnCharacters(verseString: String, count: Int) -> String {
        let index = verseString.index(verseString.startIndex, offsetBy: count)
        let newSubstring = verseString[..<index] + "..."
        return String(newSubstring)
    }
    public func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    public func isValidName() -> Bool {
        let regex = "[A-Za-zÀ-ÖØ-öø-ÿ0-9_.]"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
}
private let characterEntities: [Substring: Character] = [
    "&quot;": "\"",
    "&amp;": "&",
    "&apos;": "'",
    "&lt;": "<",
    "&gt;": ">",
    "&nbsp;": "\u{00a0}",
    "&diams;": "♦"
]
