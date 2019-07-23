//
//  ResultDetailTableViewController.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/8/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class ResultDetailTableViewController: UITableViewController {
	
	
	@IBOutlet weak var IDLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var firstnameLabel: UILabel!
	@IBOutlet weak var surnameLabel: UILabel!
	@IBOutlet weak var genderLabel: UILabel!
	@IBOutlet weak var bornLabel: UILabel!
	@IBOutlet weak var bornCityLabel: UILabel!
	@IBOutlet weak var bornCountryLabel: UILabel!
	@IBOutlet weak var diedLabel: UILabel!
	@IBOutlet weak var diedCityLabel: UILabel!
	@IBOutlet weak var diedCountryLabel: UILabel!
	@IBOutlet weak var yearLabel: UILabel!
	@IBOutlet weak var latLabel: UILabel!
	@IBOutlet weak var longLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var countryLabel: UILabel!
	@IBOutlet weak var motivationLabel: UILabel!
	
	public var nobelModel: NobelModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		displayNobelData()
	}
	
	private func displayNobelData() {
		
		guard let nobelModel = nobelModel else { return }
		
		IDLabel.text = String(nobelModel.id)
		categoryLabel.text = nobelModel.category
		diedLabel.text = nobelModel.died
		diedCityLabel.text = nobelModel.diedcity
		bornCityLabel.text = nobelModel.borncity
		bornLabel.text = nobelModel.born
		surnameLabel.text = nobelModel.surname
		firstnameLabel.text = nobelModel.firstname
		motivationLabel.text = nobelModel.motivation
		latLabel.text = String(nobelModel.location.lat)
		longLabel.text = String(nobelModel.location.lng)
		cityLabel.text = nobelModel.city
		bornCountryLabel.text = nobelModel.borncountry
		yearLabel.text = nobelModel.year
		diedCountryLabel.text = nobelModel.diedcountry
		countryLabel.text = nobelModel.country
		genderLabel.text = nobelModel.gender
		nameLabel.text = nobelModel.name
	}
}
