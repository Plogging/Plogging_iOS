//
// Created by KHU_TAEWOO on 2021/01/11.
//

import Foundation
import CoreLocation
import MapKit

extension MapkitViewController: CLLocationManagerDelegate, MKMapViewDelegate {

    // todo validate location 업데이트 시, 경로 랜더링
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // todo refactor
        guard let curLocation = locations.last else { return }

        let howRecent = curLocation.timestamp.timeIntervalSinceNow
        guard curLocation.horizontalAccuracy < 50 && abs(howRecent) < 20 else { return }

        if let lastLocation = locationList.last {
            let delta = curLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        }

        locationList.append(curLocation)
    }

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 5
        return renderer
    }

    func measureMapRegion(curLocation center: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
    }

    func createPolyLine(locationList: [CLLocation]) -> MKPolyline {
        let coords: [CLLocationCoordinate2D] = locationList.map { location in
            CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }

    func loadMap(curLocation: CLLocationCoordinate2D, locationList: [CLLocation], mapView: MKMapView) {

        if(locationList.isEmpty) {return}

        let region = measureMapRegion(curLocation: curLocation)
        mapView.setRegion(region!, animated: true)

        let path = createPolyLine(locationList: locationList)
        mapView.addOverlay(path)
    }

}

