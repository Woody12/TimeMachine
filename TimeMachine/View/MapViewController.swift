//
//  MapViewController.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/7/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	
	public var mapViewPresenter: MapViewPresenter?
	
	private let regionRadius: CLLocationDistance = 1000
	private let InputIdentifier = "InputSegue"
	
	private var selectCoordinate: CLLocationCoordinate2D?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Initialize
		mapViewPresenter = MapViewPresenter(self)
		
		// Map Info
		mapView.mapType = .hybrid
		mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		mapView.delegate = self
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchMap))
		mapView.addGestureRecognizer(tapGesture)
		
		navigationItem.title = "Select Coordinate"
		navigationItem.largeTitleDisplayMode = .always
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		checkLocationAuthorizationStatus()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == InputIdentifier {
			
			let inputViewController = segue.destination as! InputViewController
			inputViewController.selectCoordinate = selectCoordinate
		}
	}
	
	// MARK: - Event Handler
	
	@objc
	func touchMap(sender: UITapGestureRecognizer) {
		let touchLocation = sender.location(in: mapView)
		let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
		
		let annotation = Annotation(title: "My Location", coordinate: locationCoordinate)
		mapView.addAnnotation(annotation)
		let selectLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
		centerMapOnLocation(location: selectLocation)
		
		selectCoordinate = locationCoordinate
	}
	
	// MARK: - CLLocationManager
	
	let locationManager = CLLocationManager()
	func checkLocationAuthorizationStatus() {
		if CLLocationManager.authorizationStatus() == .authorizedAlways {
			mapView.showsUserLocation = true
		} else {
			locationManager.requestAlwaysAuthorization()
		}
	}
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
												  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		mapView.setRegion(coordinateRegion, animated: true)
	}
}

extension MapViewController: MKMapViewDelegate {
	
	  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
	    guard let annotation = annotation as? Annotation else { return nil }
		
	    let identifier = "marker"
	    var view: MKMarkerAnnotationView
		
	    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
	      dequeuedView.annotation = annotation
	      view = dequeuedView
	    } else {
			view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			view.canShowCallout = true
			view.calloutOffset = CGPoint(x: -5, y: 5)
			view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
	    }
		
	    return view
	  }

	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
	
		// Display Map Input
		
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
				 calloutAccessoryControlTapped control: UIControl) {
		
		performSegue(withIdentifier: InputIdentifier, sender: self)
//		let launchOptions = [MKLaunchOptionsDirectionsModeKey:
//			MKLaunchOptionsDirectionsModeDriving]
//		location.mapItem().openInMaps(launchOptions: launchOptions)
	}
}

extension MapViewController {
	
	public func displayError(message: String?) {
		
		let alertController = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		
		alertController.addAction(alertAction)
		
		present(alertController, animated: true, completion: nil)
	}
}
