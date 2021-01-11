//
// Created by KHU_TAEWOO on 2021/01/11.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapkitViewController: UIViewController {

    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    var distance = Measurement(value: 0, unit: UnitLength.meters)

    var locationList: [CLLocation] = []

    @IBOutlet private var distanceLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var paceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var isTouched: Bool = false

    @IBAction func onTouch(_ sender: UIButton) {
        if !isTouched {
            print("HELLO")
            startRun()
            isTouched = true
        } else {
            loadMap()
        }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    func startRun() {
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.eachSecond()
        }

        startLocationUpdate()
    }

    func startLocationUpdate() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }

    func eachSecond() {
        seconds += 1
        updateDisplay()
        loadMap()
    }

    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                seconds: seconds,
                outputUnit: UnitSpeed.minutesPerMile)

        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
        
        print(locationList.count)
    }

    private func mapRegion() -> MKCoordinateRegion? {

        let latitudes = locationList.map { location -> Double in
            location.coordinate.latitude
        }

        let longitudes = locationList.map { location -> Double in
            location.coordinate.longitude
        }

        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }

    private func polyLine() -> MKPolyline {

        let coords: [CLLocationCoordinate2D] = locationList.map { location in
            CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }

    func loadMap() {

        if(locationList.isEmpty) {return}

        let region = mapRegion()
        mapView.setRegion(region!, animated: true)
        let path = polyLine()
        mapView.addOverlay(path)
    }



}
