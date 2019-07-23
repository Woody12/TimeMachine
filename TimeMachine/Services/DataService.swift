//
//  DataService.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/5/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case DataReadFail
	case PopulateFail
}

struct Resource<T: Codable> {
	var fileName: String
	var type: String
}

class DataService {
	
	func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
		
		guard let urlPath = Bundle.main.url(forResource: resource.fileName, withExtension: resource.type),
			let jsonData = try? Data(contentsOf: urlPath),
			let _ = try? (JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as? Array<Any> ) else {
				
				completion(.failure(.DataReadFail))
				return
		}
			
		//print("Result is \(String(describing: jsonResult))")
		
		if let newModel: T = try? JSONDecoder().decode(T.self, from: jsonData) {
			// Populate to model structure
			completion(.success(newModel))
		} else {
			completion(.failure(.PopulateFail))
		}
	}
}
