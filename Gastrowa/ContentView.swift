import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var foodPlaces: [MKMapItem] = []

    let searcher = PlaceSearcher()

    var body: some View {
        VStack {
            if let error = locationManager.locationError {
                Text("Błąd: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if let location = locationManager.location {
                Button("Szukaj jedzenia w pobliżu") {
                    searcher.searchNearbyFood(location: location) { items in
                        foodPlaces = items
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                List(foodPlaces, id: \.self) { place in
                    VStack(alignment: .leading) {
                        Text(place.name ?? "Brak nazwy")
                            .font(.headline)
                        Text(place.placemark.title ?? "")
                            .font(.subheadline)
                    }
                }
            } else {
                Text("Pobieranie lokalizacji…")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
