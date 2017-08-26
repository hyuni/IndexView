//
//  UIStackView+Extension.swift
//  testindex
//
//  Created by hyuni on 2017. 8. 26..
//  Copyright © 2017년 . All rights reserved.
//

import UIKit

extension UIStackView {
	convenience init(axis: UILayoutConstraintAxis, spacing: CGFloat = 0, alignment: UIStackViewAlignment = .fill, distribution: UIStackViewDistribution = .fill) {
		self.init()
		
		self.axis = axis
		self.spacing = spacing
		self.alignment = alignment
		self.distribution = distribution
	}
	
	func removeAllArrangedSubview() {
		arrangedSubviews.forEach {
			self.removeArrangedSubview($0)
			$0.removeFromSuperview()
		}
	}
}

