//
// Created by KHU_TAEWOO on 2021/01/11.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapkitViewController: UIViewController {


    private var timer: Timer?

    @IBOutlet private var distanceLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var paceLabel: UILabel!
    @IBOutlet var mapView: MKMapView!

    var isTouched: Bool = false
    var pathManger: PathManager?

    var seconds = 0
    var distance: Measurement<UnitLength>?


    @IBAction func onTouch(_ sender: UIButton) {
        if !isTouched {
            print("HELLO")
            startRun()
            isTouched = true
        } else {
            print("STOP")
            pathManger?.stopLocationUpdate()
            isTouched = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pathManger = PathManager()
        pathManger?.setupMapview(on: mapView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pathManger?.stopLocationUpdate()
    }

    func startRun() {
        seconds = 0
        distance = pathManger!.distance
        updateDisplay()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.eachSecond()
        }

        pathManger?.startLocationUpdate()
    }


    func eachSecond() {
        seconds += 1
        updateDisplay()
    }

    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance!)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance!,
                seconds: seconds,
                outputUnit: UnitSpeed.minutesPerMile)

        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
        
    }




}
