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
            NotificationCenter.default
                    .post(name: updateDistance, object: nil, userInfo: ["distance" : distance])
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
        locationManager.requestWhenInUseAuthorization()
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
    
    func adaptCompactMapView(to mapView: MKMapView) {
        
        if locationList.isEmpty {return}
        
        let start = locationList.first!
        
        var maxLon: CLLocationDegrees = start.coordinate.longitude
        var minLon: CLLocationDegrees = start.coordinate.longitude
        var maxLat: CLLocationDegrees = start.coordinate.latitude
        var minLat: CLLocationDegrees = start.coordinate.latitude
        
        for location in locationList {
            maxLon = max(maxLon, location.coordinate.longitude)
            maxLat = max(maxLat, location.coordinate.latitude)
            minLon = min(minLon, location.coordinate.longitude)
            minLat = min(minLat, location.coordinate.latitude)
        }
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (maxLat + minLat)/2, longitude: (maxLon+minLon)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5))
        
        mapView.setRegion(region, animated: false)
        let path = createPolyLine(locationList: locationList)
        mapView.addOverlay(path)
    }
    

    func measureMapRegion(curLocation center: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        return MKCoordinateRegion(center: center, latitudinalMeters: (500), longitudinalMeters: 500)
    }

    func createPolyLine(locationList: [CLLocation]) -> MKPolyline {
        let coords: [CLLocationCoordinate2D] = locationList.map { location in
            CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }


}
