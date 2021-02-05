//
// Created by KHU_TAEWOO on 2021/01/20.
//

import Foundation
import CoreLocation
import MapKit

extension PathManager: CLLocationManagerDelegate{
    // todo validate location 업데이트 시, 경로 랜더링
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // todo refactor
        guard let currentLocation = locations.last else { return }

        let howRecent = currentLocation.timestamp.timeIntervalSinceNow

        guard abs(howRecent) < 10 else { return }

        if let lastLocation = locationList.last {
            let delta = currentLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        }

        locationList.append(currentLocation)

        print("[BACKUP] update count : \(locations.count)")

        if (locationList.count % 10) == 0 {
            backupPath()
        }

        drawPathOnMap(locationList: locationList, mapView: mapView)
    }
}

extension PathManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 5
        return renderer
    }
}
