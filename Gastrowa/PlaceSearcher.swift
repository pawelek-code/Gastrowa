import Foundation
import MapKit

class PlaceSearcher {
    func searchNearbyFood(location: CLLocationCoordinate2D, completion: @escaping ([MKMapItem]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "jedzenie"
        request.region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        MKLocalSearch(request: request).start { response, error in
            if let error = error {
                print("Błąd wyszukiwania: \(error.localizedDescription)")
                completion([])
            } else {
                completion(response?.mapItems ?? [])
            }
        }
    }
}
