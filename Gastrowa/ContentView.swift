import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var foodPlaces: [MKMapItem] = []
    
    //Map
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.7,
            longitude: -74),
        span: MKCoordinateSpan(
            latitudeDelta: 10,
            longitudeDelta: 10
        )
    )

    let searcher = PlaceSearcher()


    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
            
            // Poniżej całkowicie niezmieniony oryginalny kod
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
