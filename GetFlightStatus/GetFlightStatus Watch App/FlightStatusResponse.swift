//
//  FlightStatusResponse.swift
//  GetFlightStatus Watch App
//
//  Created by manvendu pathak  on 23/07/24.
//

import Foundation


struct FlightStatusResponse: Codable {
    let meta: Meta
    let data: [FlightData]
}

struct Meta: Codable {
    let count: Int
    let links: Links
}

struct Links: Codable {
    let selfLink: String

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
    }
}

struct FlightData: Codable {
    let scheduledDepartureDate: String
    let flightDesignator: FlightDesignator
    let flightPoints: [FlightPoint]
    let segments: [Segment]
    let legs: [Leg]
}

struct FlightDesignator: Codable {
    let carrierCode: String
    let flightNumber: Int
}

struct FlightPoint: Codable {
    let iataCode: String
    let departure: FlightTiming?
    let arrival: FlightTiming?
}

struct FlightTiming: Codable {
    let timings: [Timing]
}

struct Timing: Codable {
    let qualifier: String
    let value: String
}

struct Segment: Codable {
    let boardPointIataCode: String
    let offPointIataCode: String
    let scheduledSegmentDuration: String
}

struct Leg: Codable {
    let boardPointIataCode: String
    let offPointIataCode: String
    let aircraftEquipment: AircraftEquipment
    let scheduledLegDuration: String
}

struct AircraftEquipment: Codable {
    let aircraftType: String
}
