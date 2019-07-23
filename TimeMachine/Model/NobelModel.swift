//
//  NobelModel.swift
//  TimeMachine
//
//  Created by Woody Lee on 7/5/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import Foundation

struct Coordinate: Codable, Hashable {
	let lat: Double
	let lng: Double
}

struct NobelModel: Codable {
	
	enum CodingKeys: String, CodingKey {
		case id
		case category
		case died
		case diedcity
		case borncity
		case born
		case surname
		case firstname
		case motivation
		case location
		case city
		case borncountry
		case year
		case diedcountry
		case country
		case gender
		case name
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		category = try values.decode(String.self, forKey: .category)
		died = try values.decode(String.self, forKey: .died)
		diedcity = try values.decode(String.self, forKey: .diedcity)
		borncity = try values.decode(String.self, forKey: .borncity)
		born = try values.decode(String.self, forKey: .born)
		surname = try values.decode(String.self, forKey: .surname)
		firstname = try values.decode(String.self, forKey: .firstname)
		motivation = try values.decode(String.self, forKey: .motivation)
		location = try values.decode(Coordinate.self, forKey: .location)
		city = try values.decode(String.self, forKey: .city)
		borncountry = try values.decode(String.self, forKey: .borncountry)
		year = try values.decode(String.self, forKey: .year)
		diedcountry = try values.decode(String.self, forKey: .diedcountry)
		country = try values.decode(String.self, forKey: .country)
		gender = try values.decode(String.self, forKey: .gender)
		name = try values.decode(String.self, forKey: .name)
	}
	
	let id: Int
	let category: String
	let died: String
	let diedcity: String
	let borncity: String
	let born: String
	let surname: String
	let firstname: String
	let motivation: String
	let location: Coordinate
	let city: String
	let borncountry: String
	let year: String
	let diedcountry: String
	let country: String
	let gender: String
	let name: String
}
