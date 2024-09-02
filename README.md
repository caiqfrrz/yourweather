# 🌤️ YourWeather

YourWeather is a weather app that provides real-time weather updates, future forecasts, and detailed weather information for your favorite cities. Search to add the city you would like to know about the weather to your list, and hold it to remove it! With a sleek and modern interface, YourWeather is built using SwiftUI, integrating seamlessly with [OpenWeatherMap](https://openweathermap.org/) API's to fetch accurate weather data.

## Features

- **Current Weather**: Real-time weather information including temperature and weather conditions.
- **Hourly and Daily Forecasts**: Detailed hourly and daily weather forecasts.
- **Location Search**: Easily search and add new cities to your list, with real-time search suggestions.
- **City Management**: Add, update, and remove cities from your watchlist.

## Technologies Used

- **SwiftUI**
- **CoreLocation**
- **OpenWeather API's**: One Call 3.0 and Geocoding API
- **JSON parsing**

## Screenshots 

<img src="https://github.com/user-attachments/assets/dec7ed92-0e5f-462e-80d4-23de73018e54" width="264" height="570" />
<img src="https://github.com/user-attachments/assets/8b0ba805-764e-4b4e-be52-e0253778d9df" width="264" height="570"  />
<img src="https://github.com/user-attachments/assets/a0e1f4e3-6697-456c-bd98-131adf5d81c9" width="264" height="570" />
<img src="https://github.com/user-attachments/assets/eaf10ac1-8e9a-4e72-b0f1-d64591d0d68f" width="264" height="570" />
<img src="https://github.com/user-attachments/assets/e7491a40-3dfa-492b-9ac4-cfcce6a7aa29" width="264" height="570" />
<img src="https://github.com/user-attachments/assets/07affe6c-84b9-4c2d-b1bd-8862da2579a4" width="264" height="570" />


## Getting Started

### API configuration
To connect the app to a weather service, you'll need to configure your API keys:

1. **Get an API key:**
   - Create an account and get a free API key from [OpenWeatherMap](https://openweathermap.org/) (to get to use the One Call 3.0 API you will need billing information attributed to your OpenWeather account, but you can limit the calls to 1000 calls per day to make sure you will not be charged, as the API gives 1000 free calls per day.)
     
2. **Configure the API key**
   - Add your API key to the code as:
   ```sh
   let API_KEY = (api key)
   ```
   - Be careful when sharing your code and remember your key is in there.
  

### Now you can run the code
  
