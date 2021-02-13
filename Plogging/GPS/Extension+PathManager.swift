//
// Created by KHU_TAEWOO on 2021/01/20.
//

import Foundation
import CoreLocation
import MapKit

extension PathManager: CLLocationManagerDelegate{
    // todo validate location 업데이트 시, 경로 랜더링
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("receive location")

        // todo refactor
        guard let currentLocation = locations.last else { return }
        let howRecent = currentLocation.timestamp.timeIntervalSinceNow
        guard abs(howRecent) < 10 else { return }

        if !isRecord {
//            pointResentLocation(location: currentLocation.coordinate)
//            print("skip location")
            return
        }

        if let lastLocation = locationList.last {
            distance = distance + Int(currentLocation.distance(from: lastLocation))
        }

        locationList.append(currentLocation)

        print("[BACKUP] update count : \(locations.count)")

        if locationList.count % 10 == 0 {
            backupPath()
        }
        guard let mapView = mapView else {return}
        drawPathOnMap(locationList: locationList, mapView: mapView)
    }
}

extension PathManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .fromInt(red: 255, green: 128, blue: 144, alpha: 1)
        renderer.lineWidth = 5
        return renderer
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation) {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
            annotationView.image = UIImage(named: "UserLocation")
            return annotationView
        }
        return nil
    }
}
