//
//  InputViewController.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/8/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit
import MapKit

class InputViewController: UIViewController {
	
	@IBOutlet weak var latitudeTextField: UITextField!
	
	@IBOutlet weak var longitudeTextField: UITextField!
	
	@IBOutlet weak var yearPickerView: UIPickerView!
	
	public var selectCoordinate: CLLocationCoordinate2D?
	
	private let ResultIdentifier = "ResultSegue"
	
	private let startYear = 1900
	private let endYear = 2020
	
	private var selectPickerRow = 0
	private var yearData = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Initialize Years
		initYearPickerView()
		
		latitudeTextField.text = String(Double(selectCoordinate?.latitude ?? 0))
		longitudeTextField.text = String(Double(selectCoordinate?.longitude ?? 0))
		
		let rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchNobel))
		navigationItem.rightBarButtonItem = rightBarButtonItem
	}
	
	@objc
	func searchNobel() {
		performSegue(withIdentifier: ResultIdentifier, sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == ResultIdentifier {
			let resultTableViewController = segue.destination as! ResultTableViewController
				
			let inputCoordinate = Coordinate(lat: Double(selectCoordinate?.latitude ?? 0) , lng: Double(selectCoordinate?.longitude ?? 0))
			let inputNobelKey = NobelKey(year: yearData[selectPickerRow], coordinate: inputCoordinate)
			resultTableViewController.inputNobelKey = inputNobelKey
		}
	}
	
	private func initYearPickerView() {
		
		yearPickerView.dataSource = self
		yearPickerView.delegate = self
		
		for index in startYear...endYear {
			yearData.append(String(index))
		}
	}
}

extension InputViewController: UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return endYear - startYear + 1
	}
}

extension InputViewController: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return yearData[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectPickerRow = row
	}
}
