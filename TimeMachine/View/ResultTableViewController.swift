//
//  ResultTableViewController.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/8/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
	
	public var inputNobelKey: NobelKey?
	
	private let resultDetailIdentifier = "ResultDetailSegue"
	private let nobelCellIdentifier = "NobelCell"
	private let earthDistance = 10
	
	private let searchFailMsg = "Error searching for Nobel Prize Winner."
	
	private var nobelModels = [NobelModel]()
	private var currentNobelModel: NobelModel?

	private var costList = [Int]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let inputNobelKey = inputNobelKey {
			searchNobelWinner(with: inputNobelKey)
		}
		
		tableView.register(NobelTableViewCell.self, forCellReuseIdentifier: nobelCellIdentifier)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == resultDetailIdentifier {
			let resultDetailTableViewController = segue.destination as! ResultDetailTableViewController
			resultDetailTableViewController.nobelModel = currentNobelModel
		}
	}
	
	private func displayError(message: String?) {
		
		let alertController = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		
		alertController.addAction(alertAction)
		
		present(alertController, animated: true, completion: nil)
	}
}

extension ResultTableViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return nobelModels.count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
		
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: nobelCellIdentifier, for: indexPath) as! NobelTableViewCell
		cell.backgroundColor = .white
		
		cell.accessoryType = .detailButton
		cell.nameLabel.text = nobelModels[indexPath.row].firstname
		cell.costLabel.text = "Cost: \(costList[indexPath.row]) KM"
		cell.yearLabel.text = "Year: \(nobelModels[indexPath.row].year)"
		
		
		let lat = roundl(Float80(nobelModels[indexPath.row].location.lat * 100)) / 100
		let lng = roundl(Float80(nobelModels[indexPath.row].location.lng * 100)) / 100
		
		cell.latLabel.text = "Lat: \(String(lat))"
		cell.longLabel.text = "Lng: \(String(lng))"
		
		return cell
	}
}

extension ResultTableViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		currentNobelModel = nobelModels[indexPath.row]
		tableView.deselectRow(at: indexPath, animated: true)
		
		performSegue(withIdentifier: resultDetailIdentifier, sender: self)
	}
}

extension ResultTableViewController {
	
	private func calculateCost(_ previousIndex: Int, with nobelModels: [NobelModel], runningCost: Int) -> Int {
		if previousIndex < 0 {
			return 0
		} else {
			if nobelModels[previousIndex].year == nobelModels[previousIndex + 1].year {
				return runningCost
			} else {
				let currentYear = Int(nobelModels[previousIndex + 1].year) ?? 0
				let prevYear = Int(nobelModels[previousIndex].year) ?? 0
				
				return (abs(currentYear - prevYear) * earthDistance) + runningCost
			}
		}
	}
	
	private func searchNobelWinner(with nobelInputKey: NobelKey) {
		
		DispatchQueue.global().async { [weak self] in
			
			if let nobelListDict = NobelListStorage.listOfNobelsPerKey?.nobelListDict,
				let filteredNobelKey = NobelKey.filterClosest(to: nobelInputKey, from: Array(nobelListDict.keys)) {
				
			
				// Should show only up to Max Record but in case record is smaller than
				// Max Record (should not be)
				let total = ((filteredNobelKey.count >= MaxRecord) ? MaxRecord : filteredNobelKey.count)
				
				for index in 0..<total {
					
					if let nobelModel = NobelListStorage.listOfNobelsPerKey?.retrieveNobelData(from: filteredNobelKey[index]) {
						self?.nobelModels.append(contentsOf: nobelModel)
					}
				}
				
				// Calculate cost
				if let nobelModels = self?.nobelModels {
					var runningCost = 0
					for index in 0..<nobelModels.count {
						runningCost = self?.calculateCost(index - 1, with: nobelModels, runningCost: runningCost) ?? 0
						self?.costList.append(runningCost)
					}
				}
				
			}else {
				DispatchQueue.main.async {
					self?.displayError(message: self?.searchFailMsg)
				}
			}
		}
	}
}
