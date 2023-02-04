//
//  HourlyForecastView.swift
//  WeatherFast Ultimate
//
//  Created by Aadish Samir on 4/2/23.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct HourlyForcastView: View {
    
    let hourWeatherList: [HourWeather]
    let hourlyWeatherData: [HourWeather]
    
    var body: some View {
        // Main Forecast
        VStack(alignment: .leading) {
            Text("HOURLY FORECAST")
                .font(.caption)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(hourWeatherList, id: \.date) { hourWeatherItem in
                        VStack(spacing: 20) {
                            Text(hourWeatherItem.date.formatAsAbbreviatedTime())
                            Image(systemName: "\(hourWeatherItem.symbolName)")
                                .foregroundColor(.yellow)
                            Text(hourWeatherItem.temperature.formatted())
                                .fontWeight(.medium)
                        }.padding()
                    }
                }
            }
        }
            .frame(width: 350)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .foregroundColor(.white)
    }
    
}
