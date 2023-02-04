import SwiftUI
import CoreLocation
import WeatherKit
import Charts

class LocationManager: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last, currentLocation == nil else { return }
        
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }
}

extension Date {
    func formatAsAbbreviatedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    func formatAsAbbreviatedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self)
    }
}

struct WeatherView: View {
    let weatherService = WeatherService.shared
    @StateObject private var locationManager = LocationManager()
    @State private var weather: Weather?
    
    var hourlyWeatherData: [HourWeather] {
        
        if let weather {
            
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                return hourlyWeather.date.timeIntervalSince(Date()) >= 0
            }.prefix(24))
            
        } else {
            
            return []
        }
    }
    
    var body: some View {
        VStack{
            if let weather {
                VStack{
                    HStack{
                        Text("Singapore")
                            .padding()
                            .font(.largeTitle)
                        VStack {
                            Text("Current Condition: \(weather.currentWeather.condition.rawValue)")
                                .font(.title2)
                            Text("Temperature: \(weather.currentWeather.temperature.formatted())")
                                .font(.title2)
                            Text("Feels like: \(weather.currentWeather.apparentTemperature.formatted())")
                                .font(.title2)
//                          Text("Min: \() Max: \()")
//                              .font(.title)
                        }
                    }
                    Text("Today, \(weather.currentWeather.date.formatted())")
                        .font(.subheadline)
                }
                
                ScrollView(.vertical){
                    VStack{
                        HourlyForcastView(hourWeatherList: hourlyWeatherData, hourlyWeatherData: hourlyWeatherData)
                        TenDayForcastView(dayWeatherList: weather.dailyForecast.forecast)
                        
                        HStack{
                            // Humidity
                            VStack{
                                Image(systemName: "humidity")
                                    .font(.system(size: 65))
                                    .foregroundColor(.yellow)
                                let humidity = (weather.currentWeather.humidity * 100)
                                Text("HUMIDITY")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(humidity.formatted())%")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 155)
                            .padding()
                            .background(content: {Color.blue})
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            
                            // Pressure
                            VStack{
                                HStack{
                                    Image(systemName: "arrow.down")
                                        .resizable()
                                        .frame(width: 40, height: 60)
                                        .foregroundColor(.yellow)
                                    Image(systemName: "arrow.down")
                                        .resizable()
                                        .frame(width: 40, height: 60)
                                        .foregroundColor(.yellow)
                                    Image(systemName: "arrow.down")
                                        .resizable()
                                        .frame(width: 40, height: 60)
                                        .foregroundColor(.yellow)
                                }
                                let pressure = (weather.currentWeather.pressure)
                                Text("PRESSURE")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(pressure.formatted())")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 155)
                            .padding()
                            .background(content: {Color.blue})
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                        
                        HStack{
                            // Dew Point
                            VStack{
                                HStack{
                                    Image(systemName: "drop")
                                        .font(.system(size: 56.5))
                                        .foregroundColor(.yellow)
                                    Image(systemName: "drop")
                                        .font(.system(size: 56.5))
                                        .foregroundColor(.yellow)
                                }
                                let dewPoint = (weather.currentWeather.dewPoint)
                                Text("DEW POINT")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(dewPoint.formatted())")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 155)
                            .padding()
                            .background(content: {Color.blue})
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            
                            // UV Index
                            VStack{
                                Image(systemName: "sun.max")
                                    .font(.system(size: 53))
                                    .foregroundColor(.yellow)
                                let uvIndex = (weather.currentWeather.uvIndex)
                                Text("UV INDEX")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(uvIndex.value) - \(uvIndex.category.rawValue)")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 155)
                            .padding()
                            .background(content: {Color.blue})
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            
                        }
                        HStack{
                            // Wind Speed
                            VStack{
                                Image(systemName: "wind")
                                    .font(.system(size: 53))
                                    .foregroundColor(.yellow)
                                let windSpeed = (weather.currentWeather.wind)
                                Text("WIND SPEED")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(windSpeed.speed.formatted())")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 155)
                            .padding()
                            .background(content: {Color.blue})
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            
                            // Wind Direction
                            VStack{
                                Image(systemName: "wind")
                                    .font(.system(size: 53))
                                    .foregroundColor(.yellow)
                                let windSpeed = (weather.currentWeather.wind)
                                Text("WIND DIRECTION")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(windSpeed.compassDirection.rawValue)")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 155)
                            .padding()
                            .background(content: {Color.blue})
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                        HStack{
                            // Visibility
                            VStack{
                                Image(systemName: "mountain.2")
                                    .font(.system(size: 53))
                                    .foregroundColor(.yellow)
                                let visibility = (weather.currentWeather.visibility)
                                Text("VISIBILITY")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(visibility.formatted())")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 155)
                            .padding()
                            .background(content: {Color.blue})
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                    }
                }
            }
        }
        .task(id: locationManager.currentLocation) {
            do {
                if locationManager.currentLocation != nil {
                    let location = CLLocation(latitude: 1.30437, longitude: 103.82458)
                    self.weather =  try await weatherService.weather(for: location)
                }
            } catch {
                print(error)
            }
           
        }
        .padding()
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
