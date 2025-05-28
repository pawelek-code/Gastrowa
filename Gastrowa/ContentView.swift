import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var rawMapItems: [MKMapItem] = []
    @State private var foodPlaces: [IdentifiableMapItem] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    let searcher = PlaceSearcher()

    var body: some View {
        VStack {
            if let location = locationManager.location {
                Map(coordinateRegion: $region, annotationItems: foodPlaces) { place in
                    MapAnnotation(coordinate: place.mapItem.placemark.coordinate) {
                        VStack {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                            Text(place.mapItem.name ?? "")
                                .font(.caption)
                        }
                    }
                }
                .onAppear {
                    region.center = location
                }
                .frame(height: 300)
                .cornerRadius(12)
                .padding()

                Button("Szukaj jedzenia w pobliżu") {
                    searcher.searchNearbyFood(location: location) { items in
                        rawMapItems = items
                        foodPlaces = items.map { IdentifiableMapItem(mapItem: $0) }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                List(foodPlaces, id: \.id) { place in
                    VStack(alignment: .leading) {
                        Text(place.mapItem.name ?? "Brak nazwy")
                            .font(.headline)
                        Text(place.mapItem.placemark.title ?? "")
                            .font(.subheadline)
                    }
                }
            } else if let error = locationManager.locationError {
                Text("❌ \(error)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Oczekiwanie na lokalizację...")
            }
        }
        .padding()
    }
}
