//
//  Constant.swift
//  Heady - Skill Assessment Test
//
//  Created by Romit on 29/03/20.
//  Copyright © 2020 Romit. All rights reserved.
//

import Foundation
import UIKit


struct Urls {

	private static var base_url: String  { return "https://stark-spire-93433.herokuapp.com/" }
	private static var json_method: String  { return "json" }
	static var data_url: String  { return base_url + json_method }
}

extension String
{
	func addTitle(title : String) -> NSAttributedString
	{
		let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
		let attributedString = NSMutableAttributedString(string:title, attributes:attrs)

		let normalString = NSMutableAttributedString(string:self)
		attributedString.append(normalString)
		return attributedString
	}

    func convertDoubleToCurrency() -> String{
        let amount1 = Double(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        return numberFormatter.string(from: NSNumber(value: amount1!))!
    }
}
