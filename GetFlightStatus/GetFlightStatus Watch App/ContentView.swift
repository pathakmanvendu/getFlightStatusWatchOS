//
//  ContentView.swift
//  GetFlightStatus Watch App
//
//  Created by manvendu pathak  on 23/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlightStatusViewModel()
    @State private var flightNumber = ""
    @State private var date = ""
    @State private var carrierCode = ""
    @State private var showDetailView = false

    var body: some View {
        NavigationStack{
            ScrollView{
                 TextField("Carrier Code", text: $carrierCode)
                     .padding()
                 TextField("Flight Number", text: $flightNumber)
                     .padding()
                 TextField("Date (YYYY-MM-DD)", text: $date)
                     .padding()

                 Button("Get Flight Status") {
                     viewModel.fetchFlightStatus(flightNumber: flightNumber, date: date, carrierCode: carrierCode)
                     showDetailView = true
                     
                 }
                 .padding()
                 .background(
                    NavigationLink(destination: FlightDetailView(flightData: viewModel.flightData), isActive: $showDetailView) {
                        
                    }
                 )

                 Spacer()
             }
             .padding()
        }
       
    }
}


#Preview {
    ContentView()
}
