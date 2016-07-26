import Foundation

struct WeatherListViewModel {
    let weatherItems: [WeatherItem]
}
struct WeatherItem {
    let cityName: String
    let temperature: String
}

protocol WeatherListPresenter {
    func loadContent()
    func presentWeatherDetail(city: String)
    func presentAddWeatherLocation()
}

class WeatherListDefaultPresenter: WeatherListPresenter {
    
    let interactor: WeatherListInteractor
    let router: WeatherListRouter
    weak var view: WeatherListView?
    
    required init(interactor: WeatherListInteractor, router: WeatherListRouter, view: WeatherListView) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    func loadContent() {
        self.interactor.fetchWeather { (result) in
            switch result {
            case .Success(let fetchedWeather):
                self.view?.displayWeatherList(self.buildViewModelForWeatherData(fetchedWeather))
                break
            case .Failure(let reason):
                self.view?.displayError(reason.localizedDescription)
            }
        }
    }
    
    func presentWeatherDetail(city: String) {
        self.router.navigateToWeatherDetail(city)
    }
    
    func presentAddWeatherLocation() {
        self.router.navigateToAddWeatherLocation()
    }
    
    private func buildViewModelForWeatherData(weatherData: [CityWeatherData]) -> WeatherListViewModel {
        let weatherItems = weatherData.map { (item) -> WeatherItem in
            return WeatherItem(cityName: item.cityName, temperature: item.weatherData?.temperature ?? "n/a" )
        }
        return WeatherListViewModel(weatherItems: weatherItems)
    }
    
}
