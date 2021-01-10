//
// Created by KHU_TAEWOO on 2021/01/10.
//

import Foundation
import UIKit
import HealthKit
import MapKit

class GPSViewController: UIViewController, CLLocationManagerDelegate{

    var locationManager: CLLocationManager = CLLocationManager()
    var store: HKHealthStore = HKHealthStore()
    var routeBuilder: HKWorkoutRouteBuilder?

    @IBOutlet private var triggerButton: UIButton!
    @IBOutlet private var loggerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
    }

    @IBAction func onClickButton(_ sender: UIButton) {
        print("TRIGGERD!")
        startTraceRoute()
    }

    func setupLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

    func startTraceRoute() {
        routeBuilder = HKWorkoutRouteBuilder(healthStore: store, device: nil)
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(Error.self)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status.rawValue)
    }

    // MARK: - CLLocationManagerDelegate Methods.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)

        // Filter the raw data.
        let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
            location.horizontalAccuracy <= 10.0
        }

        guard !filteredLocations.isEmpty else { return }

        // Add the filtered data to the route.
        routeBuilder?.insertRouteData(filteredLocations) { (success, error) in
            if success {
                print(filteredLocations)
            }
        }
    }
}
