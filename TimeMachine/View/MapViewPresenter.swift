//
//  MapViewPresenter.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/7/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

class MapViewPresenter {
	
	public weak var mapViewController: MapViewController?
	
	//private var listOfNobelsPerKey: NobelListViewModel?
	
	private let dataReadFailMsg = "Error loading data."
	private let populateFailMsg = "Error populating data perhaps due to network issue."
	
	init(_ mapVM: MapViewController?) {
		mapViewController = mapVM
		
		// Load data to model
		retrieveNobelWinnerData()
	}
}

extension MapViewPresenter {
	
	private func retrieveNobelWinnerData() {
	
		let resource: Resource<[NobelModel]> = Resource(fileName: "nobel-prize-laureates", type: "json")
		
		DataService().load(resource: resource) { [weak self] (result: Result<[NobelModel], NetworkError>) in
			
			switch result {
			case .failure(let reason):
				
				let errorMsg = ((reason == .DataReadFail) ? self?.dataReadFailMsg : self?.populateFailMsg)
				
				DispatchQueue.main.async {
					self?.mapViewController?.displayError(message: errorMsg)
				}
				
			case .success(let nobelData):
				
				// Create persistent storage
				self?.storeNobelInfo(with: nobelData)
			}
		}
	}
	
	private func storeNobelInfo(with nobelData: [NobelModel]) {
		
		// Store persistent storage: [Year: NobelData] and
		// Coordinate list: [Coordinate: Year] for searching closest input coordinate
		
		//var coordinateList = [Coordinate: String]()
		var nobelListDict = [NobelKey: [NobelModel]]()
		
		
		for nobel in nobelData {
			
			let year = nobel.year
			let coordinate = nobel.location
			let nobelKey = NobelKey(year: year, coordinate: coordinate)!
			
			var nobelList: [NobelModel]? = nobelListDict[nobelKey]
			if var nobelList = nobelList {
				nobelList.append(nobel)
				nobelListDict[nobelKey] = nobelList
			}else {
				nobelList = [NobelModel]()
				nobelList?.append(nobel)
				nobelListDict[nobelKey] = nobelList
			}
		}
		
		// Assign Persisent data
		NobelListStorage.listOfNobelsPerKey = NobelListViewModel(nobelListDict)
		//print(listOfNobelsPerKey ?? "No List of Nobels per Year")
		
	}
}
