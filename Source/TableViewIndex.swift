//
//  TableViewIndex.swift
//
//  Created by hyuni on 2017. 8. 26..
//  Copyright © 2017년 . All rights reserved.
//

import UIKit
import SnapKit

protocol TableViewIndexDelegate {
	func focusedIndex(_ index: Int, title: String)
	func focusEnded()
}

@IBDesignable
open class TableIndexView: UIControl {
	
	var delegate: TableViewIndexDelegate? = nil
	
	@IBInspectable public var bgColor: UIColor = .color(.gray, alpha: 0.5) //.clear
	@IBInspectable public var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
	@IBInspectable public var titleColor: UIColor = .black
	@IBInspectable public var titleBGColor: UIColor = .clear
	@IBInspectable public var highlightedTitleColor: UIColor = .blue
	@IBInspectable public var spacing: CGFloat = 0.0
	@IBInspectable public var indexes: [String] = [] {
		didSet {
			setup()
		}
	}
	
	private lazy var stackView: UIStackView = UIStackView()
	private lazy var itemsLabel: [UILabel] = []
	
	// MARK: - Overrides
	public override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
		
		setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setupView()
		
		setup()
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	func setupView() {
		addSubview(stackView)
		
		applyAutoLayout()
	}
	
	fileprivate func applyAutoLayout() {
		stackView.snp.remakeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
	fileprivate func setup() {
		setupBackgroundColor()
		setupStackView()
		setupIndexes()
	}
	
	func setupBackgroundColor() {
		self.backgroundColor = self.bgColor
	}
	
	fileprivate func setupStackView() {
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fillEqually
		stackView.spacing = spacing
	}
	
	func setupIndexes() {
		stackView.removeAllArrangedSubview()
		itemsLabel.removeAll()
		
		for (index, item) in self.indexes.enumerated() {
			let label = UILabel()
			label.font = self.titleFont
			label.textColor = self.titleColor
			label.textAlignment = .center
			label.highlightedTextColor = self.highlightedTitleColor
			label.backgroundColor = self.titleBGColor
			label.text = item
			label.isUserInteractionEnabled = false
			
			itemsLabel.append(label)
			stackView.addArrangedSubview(label)
		}
	}
	
	// MARK: - tracking
	var selectedIndex: Int = -1
	var previousSelectedIndex: Int = -1
	
	func changeFocusedIndex(_ index: Int) {
		guard index != -1 else {
			return
		}
		
		if self.selectedIndex != index {
			self.previousSelectedIndex = self.selectedIndex
			self.selectedIndex = index
			
			if self.previousSelectedIndex >= 0 && self.previousSelectedIndex < self.itemsLabel.count {
				self.itemsLabel[self.previousSelectedIndex].isHighlighted = false
			}
			
			if self.selectedIndex >= 0 && self.selectedIndex < self.itemsLabel.count {
				self.itemsLabel[self.selectedIndex].isHighlighted = true
			}
			
			if let delegate = self.delegate {
				delegate.focusedIndex(self.selectedIndex, title: self.indexes[self.selectedIndex])
			}
		}
	}
	
	open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		guard self.indexes.count > 0 else {
			return false
		}

		let location = touch.location(in: self.superview)
		
		guard location.x >= self.frame.origin.x && location.x <= self.frame.origin.x + self.frame.size.width else {
			return false
		}
		
		
		var selectedIndex: Int = -1
		
		for (index, label) in self.itemsLabel.enumerated() {
			let location = touch.location(in: self)
			
			if label.frame.contains(location) {
				selectedIndex = index
				print("selectedIndex(beginTracking) ==> \(selectedIndex)")
				break
			}
		}
		
		self.changeFocusedIndex(selectedIndex)
		
		return true
	}
	
	open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		guard self.indexes.count > 0 else {
			return false
		}
		
		let location = touch.location(in: self.superview)
		
		guard location.x >= self.frame.origin.x && location.x <= self.frame.origin.x + self.frame.size.width else {
			return false
		}
		
		var selectedIndex: Int = -1

		for (index, label) in self.itemsLabel.enumerated() {
			let location = touch.location(in: self)
			
			if label.frame.contains(location) {
				selectedIndex = index
				print("selectedIndex(continueTracking) ==> \(selectedIndex)")
				break
			}
		}
		
		self.changeFocusedIndex(selectedIndex)
		
		return true
	}
	
	open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		if self.indexes.count > 0, let touch = touch {
			var selectedIndex: Int = 0
			
			for (index, label) in self.itemsLabel.enumerated() {
				let location = touch.location(in: self)
				if label.frame.contains(location) {
					selectedIndex = index
					print("selectedIndex(endTracking) ==> \(selectedIndex)")
					break
				}
			}
			
			self.changeFocusedIndex(selectedIndex)
		}
		
		print("endTracking ==>")
		
		if let delegate = self.delegate {
			delegate.focusEnded()
		}
	}
	
	open override func cancelTracking(with event: UIEvent?) {
		
		print("cancelTracking <==")
		
		if let delegate = self.delegate {
			delegate.focusEnded()
		}
	}
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		if let touch = touches.first {
			self.beginTracking(touch, with: event)
		}
	}
	
	open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		
		if let touch = touches.first {
			self.continueTracking(touch, with: event)
		}
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		
		self.endTracking(touches.first, with: event)
	}
	
	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		
		self.cancelTracking(with: event)
	}
}
