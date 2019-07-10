//
//  String+HTML.swift
//  BrokerDomainCore
//
//  Created by Ponomarev Vasiliy on 28/03/2019.
//  Copyright © 2019 BCS. All rights reserved.
//
public extension String {

    /**
     Создает строку из переданного html кода.

     - parameter htmlEncodedString: html код в виде строки.
     */
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }

    /**
     Получает атрибутную строку из текущей строки, которая является html кодом.

     - returns: Атрибутная строка.
     */
    func getAttributedStringFromHTMLString() -> NSAttributedString {
        do {
            guard let data = self.data(using: .utf8, allowLossyConversion: true) else {
                return NSAttributedString()
            }

            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                                          documentAttributes: nil)
            return attributedString
        } catch {
            debugPrint(error)
            return NSAttributedString()
        }
    }

    /**
     Очищает текущую строку от html тегов и заменяет их читабельными символами.

     - returns: Преобразованная строка.
     */
    func cleanSimpleHTML() -> String {
        var escapedString = self
        escapedString = escapedString.removeAll(["<p>"])
        escapedString = escapedString.replaceAll(["</p>"], withString: "\n")
        escapedString = escapedString.replaceAll(["<br/>", "<br />"], withString: "\n\n")
        escapedString = escapedString.removeAll(["<strong>", "</strong>"])
        escapedString = escapedString.removeAll(["<ul>", "</ul>", "</li>"])
        escapedString = escapedString.replaceAll(["<li>"], withString: "● ")

        escapedString = escapedString.unescapedString()

        return escapedString
    }

    /**
     Преобразует в текущей строке специальные символы в символы html.

     - returns: Преобразовання строка.
     */
    func escapedString() -> String {
        var escapedString = self

        for item in HtmlSymbols.allValues {
            escapedString = escapedString.replacingOccurrences(of: item.rawValue, with: item.escapeadSymbol())
        }

        return escapedString
    }

    /**
     Преобразует в текущей строке символы html в специальные символы.

     - returns: Преобразовання строка.
     */
    func unescapedString() -> String {
        var unescapedString = self

        for item in HtmlSymbols.allValues {
            unescapedString = unescapedString.replacingOccurrences(of: item.escapeadSymbol(), with: item.rawValue)
        }

        return unescapedString
    }

    fileprivate enum HtmlSymbols: String {
        case and    = "&"
        case left   = "«"
        case right  = "»"
        case quot   = "\""
        case gt     = ">"
        case lt     = "<"
        case mdash  = "—"
        case ndash  = "–"
        case space  = " "

        static let allValues = [and, left, right, quot, gt, lt, mdash, ndash, space]

        func escapeadSymbol() -> String {
            switch self {
            case .and    : return "&amp;"
            case .left   : return "&laquo;"
            case .right  : return "&raquo;"
            case .quot   : return "&quot;"
            case .gt     : return "&gt;"
            case .lt     : return "&lt;"
            case .mdash  : return "&mdash;"
            case .ndash  : return "&ndash;"
            case .space  : return "&nbsp;"
            }
        }
    }
}