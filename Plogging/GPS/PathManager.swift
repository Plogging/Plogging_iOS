//
// Created by KHU_TAEWOO on 2021/01/19.
//

import Foundation
import CoreLocation
import MapKit

class PathManager: NSObject {

    static var pathManager = PathManager()
    
    var locationList: [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var mapView: MKMapView?
    var backupManager = BackupManager()
    let locationManager = LocationManager.shared

    var isRecord = false

    override init() {
        super.init()
    }
    
    func setupMapview(on mapView: MKMapView) {
        self.mapView = mapView
        self.mapView?.delegate = self
        pointResentLocation(location: mapView.userLocation.coordinate)
    }

    func pointResentLocation(location: CLLocationCoordinate2D) {
        guard let region = measureMapRegion(curLocation: location) else { return }
        mapView?.setRegion(region, animated: true)
    }

    func startLocationUpdate () {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        print("[BACKUP] success restore count : \(locationList.count)")
        print("start location")
    }

    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }

    func startRunning() {
        self.isRecord = true
    }
    
    func stopRunning() {
        self.isRecord = false
        locationList = []
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
        guard let mapView = mapView else {return}
        drawPathOnMap(locationList: locationList, mapView: mapView)
    }

    func backupPath() {
        backupManager.savePathData(to: locationList)
    }


    func measureMapRegion(curLocation center: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
    }

    func createPolyLine(locationList: [CLLocation]) -> MKPolyline {
        let coords: [CLLocationCoordinate2D] = locationList.map { location in
            CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }


}
