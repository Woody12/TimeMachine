//
//  NobelListViewModel.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/7/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation
import CoreLocation

public let MaxRecord = 20

struct NobelKey: Hashable {
	
	let year: String
	let coordinate: Coordinate
	
	var distanceToRef: CLLocationDistance
	
	init?(year: String, coordinate: Coordinate) {
		self.year = year
		self.coordinate = coordinate
		self.distanceToRef = 0
	}
}

extension NobelKey {
	
	public static func filterClosest(to inputKey: NobelKey, from nobelKeys:[NobelKey]) -> [NobelKey]? {
		
		let sortedYears = nobelKeys.sorted(by: { $0.year < $1.year }).map({ $0.year })
		let closestYears = retrieveClosestYear(to: inputKey.year, from: sortedYears)
		let filterNobelKey = calculateDistance(to: inputKey.coordinate, using: closestYears, from: nobelKeys)
		
		return filterNobelKey
	}
	
	// should we sort NobelKey by year first?
	
	// Calculate closest year and coordinate distance
	// Year has higher consideration since it is more expensive to jump to multiple years
	private static func retrieveClosestYear(to inputYear: String, from years: [String]) -> [String]? {
		
		// Use Binary Sort assuming NobelKey.year is already sorted.
		
		var startPosition = 0
		var endPosition = years.count - 1
		
		for _ in 1...years.count {
			
			let half: Int = ((endPosition - startPosition) / 2)
			let index = startPosition + half
			let keyYear = years[index]
			
			// Find closest year using binary search
			if keyYear == inputYear {
				return addRemainingYears(for: years, startingWith: index)
				
			}else if keyYear < inputYear {
				// Right side
				startPosition += half + 1

			}else {
				// Left side
				endPosition = startPosition + half - 1
			}
			
			// Check to get the closest year
			if startPosition > endPosition {
				return addRemainingYears(for: years, startingWith: index)
			}
		}
		
		// No years found
		return nil
	}
	
	private static func addRemainingYears(for years: [String], startingWith startIndex: Int) -> [String] {
		
		var filteredYears = [String]()
		
		if (years.count - (startIndex + 1)) < MaxRecord {
			// Add previous years
			for index in (startIndex - MaxRecord + 1)...startIndex {
				filteredYears.append(years[index])
			}
		} else {
			// Add next years
			for index in startIndex..<(startIndex + MaxRecord) {
				filteredYears.append(years[index])
			}
		}
		
		return filteredYears
	}
	
	// Return list of filtered Keys
	private static func calculateDistance(to inputCoordinate: Coordinate, using closestYears: [String]?, from nobelKeys:[NobelKey]) -> [NobelKey]? {
		
		guard let closestYears = closestYears else { return nil }
		
		// Filter with all the closest years
		var filteredNobelKeys = nobelKeys.filter({ closestYears.contains($0.year) }).sorted(by: { $0.year < $1.year })
		
		// Initialize coordinate
		let referenceCoordinate = CLLocation(latitude: CLLocationDegrees(exactly: inputCoordinate.lat) ?? 0, longitude: CLLocationDegrees(exactly: inputCoordinate.lng) ?? 0)
		
		// Calculate and sorted distance for each year
		var previousYear = ""
		var tempIndex = 0
		
		var tempNobelKeys = [NobelKey]()
		var resultNobelKeys = [NobelKey]()
		
		for index in 0..<MaxRecord {
			
			// Sort distance for each year and store in the result
			if (previousYear != filteredNobelKeys[index].year) && (previousYear != "") {
				
				// Sort the distance and zero out the distance calculation
				if tempNobelKeys.count == 1 {
					var nobelKey = tempNobelKeys[0]
					nobelKey.distanceToRef = 0
					resultNobelKeys.append(nobelKey)
				} else {
					tempNobelKeys = tempNobelKeys.sorted(by: {$0.distanceToRef < $1.distanceToRef})
					for var nobelKey in tempNobelKeys {
						nobelKey.distanceToRef = 0
						resultNobelKeys.append(nobelKey)
					}
				}
				
				// Reset
				tempIndex = 0
				tempNobelKeys.removeAll()
			}
			
			let distance = referenceCoordinate.distance(from: CLLocation(latitude: CLLocationDegrees(exactly: filteredNobelKeys[index].coordinate.lat) ?? 0, longitude: CLLocationDegrees(exactly: filteredNobelKeys[index].coordinate.lng) ?? 0))
			
			// Add to temporary storage for distance sorting per year
			tempNobelKeys.append(filteredNobelKeys[index])
			tempNobelKeys[tempIndex].distanceToRef = distance
			tempIndex += 1
			
			// Keep track when year changes
			previousYear = filteredNobelKeys[index].year
		}
		
		return resultNobelKeys
	}
}

struct NobelListViewModel {
	
	public let nobelListDict: [NobelKey: [NobelModel]]
	
	init(_ nobelListDict: [NobelKey: [NobelModel]]) {
		self.nobelListDict = nobelListDict
	}
}

extension NobelListViewModel {
	
	public func retrieveNobelData(from nobelKey: NobelKey) -> [NobelModel]? {
		
		return nobelListDict[nobelKey]
	}
}

extension NobelListViewModel: CustomDebugStringConvertible {
	
	var debugDescription: String {
		return "Nobel List: \(nobelListDict)"
	}
}
