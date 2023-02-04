//
//  TenDayForcastView.swift
//  WeatherFast Ultimate
//
//  Created by Aadish Samir on 4/2/23.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct TenDayForcastView: View {
    
    let dayWeatherList: [DayWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("10-DAY FORCAST")
                .font(.caption)
            
            List(dayWeatherList, id: \.date) { dailyWeather in
                HStack {
                    Text("\(dailyWeather.date.formatAsAbbreviatedDay())")
                        .frame(maxWidth: 100, alignment: .leading)
                    
                    Image(systemName: "\(dailyWeather.symbolName)")
                        .frame(maxWidth: 200)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 100))
                        .foregroundColor(.yellow)
                    
                    Text("Min: \(dailyWeather.lowTemperature.formatted())")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Max: \(dailyWeather.highTemperature.formatted())")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }.listRowBackground(Color.blue)
            }
            .listStyle(.plain)
        }
        .frame(width: 350, height: 300)
        .padding()
        .background(content: {Color.blue})
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .foregroundColor(.white)
    }
    
}
