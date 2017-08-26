//
//  UIColor+Extension.swift
//  testindex
//
//  Created by hyuni on 2017. 8. 26..
//  Copyright © 2017년 . All rights reserved.
//

import UIKit

extension UIColor {
	public static func hex(_ hex: Int, _ alpha: CGFloat) -> UIColor {
		let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let g = CGFloat((hex & 0xFF00) >> 8) / 255.0
		let b = CGFloat((hex & 0xFF)) / 255.0
		
		return UIColor(red: r, green: g, blue: b, alpha: alpha)
	}
	
	public static func hex(_ hex: Int) -> UIColor {
		return self.hex(hex, 1.0)
	}
	
	public static func color(_ color: UIColor, alpha: CGFloat) -> UIColor {
		var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
		
		color.getRed(&red, green: &green, blue: &blue, alpha: nil)
		
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}

