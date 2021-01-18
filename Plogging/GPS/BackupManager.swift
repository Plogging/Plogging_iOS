//
// Created by KHU_TAEWOO on 2021/01/19.
//

import Foundation
import CoreData

class BackupManager {
    func savePathData(to pathDataList: [CLLocation]) {

        var latitude: [Double] = []
        var longitude: [Double] = []
        var startTime: Date?
        var endTime: Date?

        if let start = pathDataList.first {startTime = start.timestamp}
        if let end = pathDataList.last {endTime = end.timestamp}
        pathDataList.forEach { location in
            latitude.append(location.coordinate.latitude)
            longitude.append(location.coordinate.longitude)
        }

        let context = AppDelegate.viewContext
        let pathEntity = NSEntityDescription.entity(forEntityName: "Path", in: context)

        if let entity = pathEntity {
            let createdPath = NSManagedObject(entity: entity, insertInto: context)
            createdPath.setValue(latitude, forKey: "lat")
            createdPath.setValue(longitude, forKey: "lon")
            createdPath.setValue(startTime, forKey: "startTime")
            createdPath.setValue(endTime, forKey: "endTime")
        }

        do {
            try context.save()
        } catch {
            print("ERROR ON SAVE")
        }

    }

    func restorePathData() -> [CLLocation] {
        let context = AppDelegate.viewContext
        var paths: [Path]?
        do {
            paths = try context.fetch(Path.fetchRequest()) as? [Path]
        } catch {

        }
        var result = [CLLocation]()

        paths?.forEach{ path in
            let lat: [Double] = path.value(forKey: "lat") as! [Double]
            let lon: [Double] = path.value(forKey: "lon") as! [Double]

            for index in 0..<lat.count {
                result.append(CLLocation(latitude: lat[index], longitude: lon[index]))
            }
        }

        return result
    }
}