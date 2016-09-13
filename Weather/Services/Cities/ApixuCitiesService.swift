import Foundation
import Alamofire
import Mapper


extension City: Mappable {
    init(map: Mapper) throws {
        try cityId = map.from("id", transformation: { return String($0!) })
        try name = map.from("name")
        try region = map.from("region")
        try country = map.from("country")
        try latitude = map.from("lat")
        try longitude = map.from("lon")
    }
}


class ApixuCitiesService: CitiesService {
    
    private let apixuCitiesUrl = "https://api.apixu.com/v1/search.json"
    private let apixuKey = "6dbb6fcfa4b74a599f580222160508"
    
    // MARK: <CitiesService>
    
    func fetchCities(withName name: String, completion: CitiesServiceCompletion) {
        let parameters = ["key": self.apixuKey,
                          "q": name]
        Alamofire.request(.GET, self.apixuCitiesUrl, parameters: parameters)
            .responseJSON { (response) in
                switch response.result {
                case .Success(let JSON):
                    if let JSON = JSON as? [NSDictionary] {
                        let cities = City.from(JSON)
                        completion(cities: cities, error: nil)
                    }
                case .Failure(let error):
                    completion(cities: nil, error: error)
                }
            }
    }
    
}