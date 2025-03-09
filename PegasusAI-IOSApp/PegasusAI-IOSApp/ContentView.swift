import SwiftUI



struct ContentView: View {
    @State private var selectedLocation: String = "Edmonton"
    var body: some View {
        //create a navigation stack so the user can easily switch screens
        
        NavigationStack{
            ZStack {
                //make background black. Wrap around the NavStack
                Color.black.edgesIgnoringSafeArea(.all)
                
                //vertically stack the logo, title, location buttons and search button
                VStack {
                    //place Pegasus ai Logo
                    Image("inverted_horse") // Placeholder for logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding()
                    
                    //create the title
                    Text("Mission No-Fail")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    //create a stack of buttons on the front page
                    VStack(spacing: 10) {
                        //create 3 location buttons and vertically stack them
                        LocationButton(title: "Edmonton", selected: $selectedLocation)
                        LocationButton(title: "Banff", selected: $selectedLocation)
                        LocationButton(title: "Jasper", selected: $selectedLocation)
                    }
                    .padding(30)
            
                    //Navigation Button to next page to check weather
                    NavigationLink {
                        WeatherView(location: selectedLocation) // Pass view inside closure
                    } label: {
                        Text("Check Weather")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(50)
                    }

                }
            }
        }
    }
}


/*struct WeatherView: View {
    var location: String
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                //make background black. Wrap around the NavStack
                Color.black.edgesIgnoringSafeArea(.all)
                
                //Location header with logo
                VStack {
                    HStack {
                        Text("Ready to Fly")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            
                        //place Pegasus ai Logo
                        Image("inverted_horse") // Placeholder for logo
                            .resizable()
                            .scaledToFit()
                            .frame(width:60, height: 60)
                    }.padding(.top)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .padding(.all)
                        .overlay(
                            VStack {
                                HStack {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 20, height: 20)
                                        .padding(.top)
                                    
                                    Text("Conditions are Good")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.title2)
                                        .padding(.top)
                                    //One location button has rounded corners and color
                                    //and horizontally stacks a circle and a title
                                    
                                }.padding(.top)
                                
                                Image("ed") // Placeholder for map
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(30)
                                
                                Text("Visibility: 31 km\n")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .multilineTextAlignment(.leading)
                                
                                Text("Temperature: 7C\n")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .multilineTextAlignment(.leading)
                                
                                Text("UV Index: 0 Low\n")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                
                                Text("Humidity: 60%\n")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                            }
                        )
                        
                
                    }
                }
        
            
            }
    }
}*/

struct WeatherView: View {
    var location: String
    @State private var weather: WeatherData?
    private let weatherService = WeatherService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Ready to Fly")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        Image("inverted_horse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .padding(5)
                        .overlay(
                            VStack {
                                HStack {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Conditions are Good")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.title2)
                                }
                                
                                Image("ed")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(30)
                                
                                if let weather = weather {
                                    HStack {
                                        Text("Visibility:")
                                            .frame(maxWidth: .infinity, alignment: .trailing).bold().padding(.leading) // Left-align the title
                                        Spacer(minLength: 80)
                                        Text("\(String(format: "%.2f", weather.visibility)) km")
                                            .frame(maxWidth: .infinity, alignment: .leading) // Left-align the data
                                    }
                                    .padding(.horizontal)

                                    HStack {
                                        Text("Temperature:")
                                            .frame(maxWidth: .infinity, alignment: .trailing).bold().padding(.leading)
                                        Spacer(minLength: 80)
                                        Text("\(String(format: "%.2f", weather.temperature))°C")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lineLimit(3)
                                    }
                                    .padding(.horizontal)

                                    HStack {
                                        Text("UV Index:")
                                            .frame(maxWidth: .infinity, alignment: .trailing).bold().padding(.leading)
                                        Spacer(minLength: 80)
                                        Text("\(String(format: "%.2f", weather.uvIndex))")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal)

                                    HStack {
                                        Text("Humidity:")
                                            .frame(maxWidth: .infinity, alignment: .trailing).bold().padding(.leading)
                                        Spacer(minLength: 80)
                                        Text("\(String(format: "%.2f", weather.humidity))%")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal)

                                } else {
                                    Text("Fetching weather data...")
                                }
                            }
                            .foregroundColor(.white)
                            .font(.title3)
                        )
                }
            }
        }
        .onAppear {
            print("Received location: \(location)")
            weatherService.fetchWeather(for: location) { fetchedWeather in
                DispatchQueue.main.async {
                    self.weather = fetchedWeather
                }
            }
        }
    }
}


struct LocationButton: View {
    var title: String
    @Binding var selected: String
    
    var body: some View {
        Button(action: { selected = title }) {
            HStack {
                Circle()
                    .fill(selected == title ? Color.green : Color.gray)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .foregroundColor(.white)
                    .padding()
                
                //One location button has rounded corners and color
                //and horizontally stacks a circle and a title
                
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
            .padding(5)
        }
        
    }
}

#Preview {
    ContentView()
}
