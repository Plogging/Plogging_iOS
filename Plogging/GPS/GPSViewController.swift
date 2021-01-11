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
    var isStart: Bool = false

    @IBOutlet private var triggerButton: UIButton!
    @IBOutlet private var loggerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
    }

    @IBAction func onClickButton(_ sender: UIButton) {
        if(!isStart) {
            print("TRIGGERD!")
            startTraceRoute()
            sender.setTitle("STOP TRACE", for: .normal)
            isStart = true
        } else {
            stopTraceRoute()
            isStart = false
        }

    }

    func setupLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

    func startTraceRoute() {
        routeBuilder = HKWorkoutRouteBuilder(healthStore: store, device: nil)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    func stopTraceRoute() {
        // TODO start, end date 정확하게 입력
        // TODO 헬스 앱에 데이터 정상 저장
        let workout = HKWorkout.init(activityType: .running, start: Date(), end: Date())
        routeBuilder?.finishRoute(with: workout, metadata: nil) { route, error in

            if error != nil { return }

            guard let successRoute = route else {
                return
            }

        }
    }

    /**
     * CLLocationManagerDelegate Methods
     */

    // MARK: - CLLocationManagerDelegate Methods.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(Error.self)
    }

    // MARK: - CLLocationManagerDelegate Methods.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status.rawValue)
    }

    // MARK: - CLLocationManagerDelegate Methods.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        print("==== \(locations.count) ===")

        // Filter the raw data.
        let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
            location.speedAccuracy <= 10.0
        }

        guard !filteredLocations.isEmpty else { return }

        // Add the filtered data to the route.
        routeBuilder?.insertRouteData(filteredLocations) { (success, error) in
            if success {

            }
        }
    }
}
