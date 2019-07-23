//
//  Annotation.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/7/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
	
	let title: String?
	let coordinate: CLLocationCoordinate2D
	
	init(title: String, coordinate: CLLocationCoordinate2D) {
		
		self.coordinate = coordinate
		self.title = title
		
		super.init()
	}

	// Annotation right callout accessory opens this mapItem in Maps app
	func mapItem() -> MKMapItem {
		let placemark = MKPlacemark(coordinate: coordinate)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = title
		return mapItem
	}
}
