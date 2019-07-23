//
//  AnnotationView.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/7/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation
import MapKit

class AnnotationView: MKAnnotationView {
	
	override var annotation: MKAnnotation? {
		willSet {
			canShowCallout = true
			calloutOffset = CGPoint(x: -5, y: 5)
			rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		}
	}
	
}
