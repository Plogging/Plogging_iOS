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
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isZoomEnabled = true
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




}
