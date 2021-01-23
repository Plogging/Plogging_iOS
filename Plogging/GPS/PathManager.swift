//
// Created by KHU_TAEWOO on 2021/01/19.
//

import Foundation
import CoreLocation
import MapKit

class PathManager: NSObject {

    var locationList: [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var mapView: MKMapView
    var backupManager = BackupManager()
    let locationManager = LocationManager.shared

    init(on mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }


    func startLocationUpdate() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        print("[BACKUP] success restore count : \(locationList.count)")
    }

    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
        backupManager.removePathData()
    }

    func drawPathOnMap(locationList: [CLLocation], mapView: MKMapView) {
        if(locationList.isEmpty) {return}
        guard let region = measureMapRegion(curLocation: locationList.last!.coordinate) else {return;}
        mapView.setRegion(region, animated: true)
        let path = createPolyLine(locationList: locationList)
        mapView.addOverlay(path)
    }

    func retrievePath() {
        locationList = backupManager.restorePathData()
        drawPathOnMap(locationList: locationList, mapView: mapView)
    }

    func backupPath() {
        backupManager.savePathData(to: locationList)
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


}
