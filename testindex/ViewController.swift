//
//  ViewController.swift
//  testindex
//
//  Created by hyuni on 2017. 8. 26..
//  Copyright © 2017년 . All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
	
	var tableView: UITableView = UITableView()
	var indexView: TableIndexView = TableIndexView()
	var focusedLabel: UILabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		setupView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupView() {
		view.addSubview(tableView)
		view.addSubview(indexView)
		view.addSubview(focusedLabel)
		
		indexView.bringSubview(toFront: tableView)
		focusedLabel.sendSubview(toBack: tableView)
		
		focusedLabel.isHidden = true
		focusedLabel.font = UIFont.boldSystemFont(ofSize: 30)
		focusedLabel.textColor = .black
		focusedLabel.textAlignment = .center
		focusedLabel.highlightedTextColor = .blue
		focusedLabel.backgroundColor = .color(.gray, alpha: 0.5)
		
		indexView.delegate = self
		indexView.indexes = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
		
		tableView.snp.remakeConstraints { (make) in
			make.top.equalTo(topLayoutGuide.snp.bottom)
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		indexView.snp.remakeConstraints { (make) in
			make.top.equalTo(tableView)
			make.trailing.equalTo(tableView)
			make.bottom.equalTo(tableView)
			make.width.equalTo(20)
		}
		
		focusedLabel.snp.remakeConstraints { (make) in
			make.centerX.equalTo(tableView)
			make.centerY.equalTo(tableView)
			make.size.equalTo(CGSize(width: 50, height: 50))
		}
	}
	
}

extension ViewController: TableViewIndexDelegate {
	func focusedIndex(_ index: Int, title: String) {
		focusedLabel.bringSubview(toFront: self.tableView)
		focusedLabel.isHidden = false
		
		focusedLabel.text = title
		focusedLabel.isHighlighted = true
	}
	
	func focusEnded() {
		focusedLabel.sendSubview(toBack: self.tableView)
		focusedLabel.isHidden = true
	}
}

