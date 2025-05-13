import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var locationError: String?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        start()
    }
    
    func start() {
        let status = manager.authorizationStatus
        print("Status autoryzacji (start): \(status.rawValue)")
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .notDetermined:
            DispatchQueue.main.async {
                self.manager.requestWhenInUseAuthorization()
            }
        case .restricted, .denied:
            locationError = "Brak uprawnień do lokalizacji"
        @unknown default:
            locationError = "Nieznany status lokalizacji"
        }
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Zmieniono autoryzację: \(manager.authorizationStatus.rawValue)")
        start()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coord = locations.first?.coordinate else {
            print("Brak współrzędnych")
            return
        }
        print("Lokalizacja odebrana: \(coord.latitude), \(coord.longitude)")
        location = coord
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = "Błąd lokalizacji: \(error.localizedDescription)"
    }
}
