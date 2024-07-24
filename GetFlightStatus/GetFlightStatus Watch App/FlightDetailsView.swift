//
//  FlightDetailsView.swift
//  GetFlightStatus Watch App
//
//  Created by manvendu pathak  on 23/07/24.
//

import SwiftUI


struct FlightDetailView: View {
    var flightData: FlightData?
    @ObservedObject var viewModel: LottieViewModel = .init()
    @State private var timerFired = false
    @State private var showImage = true
    @State private var timeRemaining = 10
    
    var body: some View {
        VStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .scaledToFit()
                .onAppear {
                    self.viewModel.loadAnimation(url: URL(string: "https://lottie.host/b5c14bd5-79c0-4256-8fd0-b7424849bf5f/HQKJfNo80t.json")!)
                }
                .opacity(showImage ? 1 : 0)
            
            
            
            if timerFired{
                if let flightData = flightData {
                    Image(systemName: "airplane")
                    
                    
                    HStack{
                        Text(flightData.segments.first?.boardPointIataCode ?? "")
                            .bold()
                        Text("----------")
                        Text(flightData.segments.first?.offPointIataCode ?? "")
                            .bold()
                    }
                    
                    VStack{
                        Text("Flight Number: \(removeCommas(from: "\(flightData.flightDesignator.flightNumber)"))")
                        HStack{
                            Text("Departure: ")
                            Text("\(formatDate(dateString: "\(flightData.flightPoints.first?.departure?.timings.first?.value ?? "N/A")"))")
                                .font(.system(size: 15))
                        }
                        HStack{
                            Text("Arrival: ")
                            Text("\(formatDate(dateString: "\(flightData.flightPoints.last?.arrival?.timings.first?.value ?? "N/A")"))")
                                .font(.system(size: 15))
                        }
                      
                    }
                    .padding()
                    
                }else{
                    Text("No Such Flight")
                }
            }
            
            
            
        }
        .padding(.top)
        .onAppear{
                startTimer()
            }
            .padding()
        
      
    }
    
    private func startTimer() {
        Task {
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            
            DispatchQueue.main.async {
                
                self.timerFired = true
                self.showImage = false
                self.viewModel.pause()
            }
        }
    }
    
    func removeCommas(from numberString: String) -> String {
        return numberString.replacingOccurrences(of: ",", with: "")
    }
    
    private func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            // Output time format
            dateFormatter.dateFormat =  "h:mm a"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
}


#Preview {
    FlightDetailView()
}
