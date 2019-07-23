//
//  NobelTableViewCell.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/8/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class NobelTableViewCell: UITableViewCell {

	var nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		label.font = UIFont(name: "Helvetica", size: 20.0)
		label.sizeToFit()
		label.numberOfLines = 0
		return label
	}()
	
	var costLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		label.font = UIFont(name: "Helvetica", size: 20.0)
		label.sizeToFit()
		label.numberOfLines = 0
		return label
	}()
	
	var yearLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		label.font = UIFont(name: "Helvetica", size: 20.0)
		label.sizeToFit()
		label.numberOfLines = 0
		return label
	}()
	
	var latLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		label.font = UIFont(name: "Helvetica", size: 20.0)
		label.sizeToFit()
		label.numberOfLines = 0
		return label
	}()
	
	var longLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		label.font = UIFont(name: "Helvetica", size: 20.0)
		label.sizeToFit()
		label.numberOfLines = 0
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addSubview(nameLabel)
		addSubview(yearLabel)
		addSubview(latLabel)
		addSubview(longLabel)
		addSubview(costLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
			nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
			nameLabel.widthAnchor.constraint(equalToConstant: 100.0),
			
			costLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
			costLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10.0),
			
			yearLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
			yearLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50.0),
			
			latLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20.0),
			latLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
			
			longLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20.0),
			longLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -100.0)
		])
	}
}
