//
//  FlightStatusViewModel.swift
//  GetFlightStatus Watch App
//
//  Created by manvendu pathak  on 23/07/24.
//

import Foundation
import Alamofire

class FlightStatusViewModel: ObservableObject {
    @Published var flightData: FlightData?
    private var accessToken: String?

    func fetchFlightStatus(flightNumber: String, date: String, carrierCode: String) {
        getAccessToken { token in
            guard let token = token else {
                print("Failed to get access token")
                return
            }
            
            self.accessToken = token
            self.requestFlightStatus(flightNumber: flightNumber, date: date, carrierCode: carrierCode)
        }
    }

    private func getAccessToken(completion: @escaping (String?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters: Parameters = [
            "grant_type": "client_credentials",
            "client_id": "8KWC7tBH5uY0VpA8RdraklwyhKKD7J18",
            "client_secret": "z3cbZqBDgp1aUuQL"
        ]
        
        AF.request("https://test.api.amadeus.com/v1/security/oauth2/token", method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: AccessTokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    completion(tokenResponse.access_token)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
    }

    private func requestFlightStatus(flightNumber: String, date: String, carrierCode: String) {
        guard let token = accessToken else {
            print("No access token available")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let parameters: Parameters = [
            "carrierCode": carrierCode,
            "flightNumber": flightNumber,
            "scheduledDepartureDate": date
        ]
        
        AF.request("https://test.api.amadeus.com/v2/schedule/flights", parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: FlightStatusResponse.self) { response in
                switch response.result {
                case .success(let flightStatusResponse):
                    DispatchQueue.main.async {
                        
                        self.flightData = flightStatusResponse.data.first
                        print(self.flightData)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}

struct AccessTokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}
