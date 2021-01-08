//: A MapKit based Playground

import MapKit
import PlaygroundSupport
import CoreLocation
import HealthKit



class LocationDelegate : NSObject, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("run delegate")
        let filteredLocations = locations.filter{(location: CLLocation) -> Bool in
            
            // 50m 오차 범위 설정 (노이즈 제거)
//            location.horizontalAccuracy <= 50.0
            true
        }
        
        guard !filteredLocations.isEmpty else { return }
        
        routeBuilder.insertRouteData(filteredLocations) {(success, error) in
            if !success {
                print("ERROR on insert route")
            } else {
                print("SUCCESS")
            }
        }
    }
    
}
var locationManager = CLLocationManager()

print(CLLocationManager.locationServicesEnabled())

let delegater = LocationDelegate()

locationManager.delegate = delegater
locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
locationManager.startUpdatingLocation()

let store: HKHealthStore = HKHealthStore()
let routeBuilder = HKWorkoutRouteBuilder(healthStore: store, device: nil)









func _stopRecord(myWorkout: HKWorkout) {
    routeBuilder.finishRoute(with: myWorkout, metadata: nil) {
        (newRoute, error) in
            
            guard newRoute != nil else {
                print("ERROR on finishRoute")
                return
            }
            do {
                print("SUCCESS save route")
                
            }
    }
}


let appleParkWayCoordinates = CLLocationCoordinate2DMake(37.334922, -122.009033)

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:800, height:800))

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 0.02
mapRegion.center = appleParkWayCoordinates
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)

// Create a map annotation
let annotation = MKPointAnnotation()
annotation.coordinate = appleParkWayCoordinates
annotation.title = "Apple Inc."
annotation.subtitle = "One Apple Park Way, Cupertino, California."

mapView.addAnnotation(annotation)

// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView






















//let appleParkWayCoordinates = CLLocationCoordinate2DMake(37.334922, -122.009033)
//
//// Now let's create a MKMapView
//let mapView = MKMapView(frame: CGRect(x:0, y:0, width:800, height:800))
//
//// Define a region for our map view
//var mapRegion = MKCoordinateRegion()
//
//let mapRegionSpan = 0.02
//mapRegion.center = appleParkWayCoordinates
//mapRegion.span.latitudeDelta = mapRegionSpan
//mapRegion.span.longitudeDelta = mapRegionSpan
//
//mapView.setRegion(mapRegion, animated: true)
//
//// Create a map annotation
//let annotation = MKPointAnnotation()
//annotation.coordinate = appleParkWayCoordinates
//annotation.title = "Apple Inc."
//annotation.subtitle = "One Apple Park Way, Cupertino, California."
//
//mapView.addAnnotation(annotation)
//
//// Add the created mapView to our Playground Live View
//PlaygroundPage.current.liveView = mapView
