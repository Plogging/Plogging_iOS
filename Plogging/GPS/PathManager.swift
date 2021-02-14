//
// Created by KHU_TAEWOO on 2021/01/19.
//

import Foundation
import CoreLocation
import MapKit

class PathManager: NSObject {

    static var pathManager = PathManager()
    
    var locationList: [CLLocation] = []
    var distance: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: updateDistance, object: nil, userInfo: ["distance" : distance])
        }
    }

    let updateDistance: Notification.Name = Notification.Name("UpdateDistance")

    var mapView: MKMapView?
    var backupManager = BackupManager()
    let locationManager = CLLocationManager()

    var isRecord = false

    override init() {
        super.init()
    }

    // todo 위치 연결 팝업 연결
    func isSetPermissions() {
        if locationManager.authorizationStatus.rawValue < CLAuthorizationStatus.authorizedAlways.rawValue {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func setupMapview(on mapView: MKMapView) {
        self.mapView = mapView
        self.mapView?.delegate = self
        self.mapView?.isUserInteractionEnabled = true
        self.mapView?.setUserTrackingMode(.follow, animated: true)
    }

    func pointResentLocation(location: CLLocationCoordinate2D) {
        guard let region = measureMapRegion(curLocation: location) else { return }
        mapView?.setRegion(region, animated: true)
    }

    func startLocationUpdate () {
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
        stopLocationUpdate()
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
        MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 1400)
    }

    func createPolyLine(locationList: [CLLocation]) -> MKPolyline {
        let coords: [CLLocationCoordinate2D] = locationList.map { location in
            CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }


}
