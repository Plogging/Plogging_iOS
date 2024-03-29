//
// Created by KHU_TAEWOO on 2021/01/19.
//

import Foundation
import CoreData

// TODO: Refactoring (HIGH) (Scheme 변경)
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

        AppDelegate.persistContainer.performBackgroundTask { context in
            do {
                let paths: [Path]? = try context.fetch(Path.fetchRequest()) as? [Path]
                let updatePath: Path?

                if paths?.count == 0 {
                    updatePath = NSManagedObject(entity: Path.entity(), insertInto: context) as? Path
                } else {
                    updatePath = (paths?.first)
                }

                updatePath?.setValue(latitude, forKey: "lat")
                updatePath?.setValue(longitude, forKey: "lon")
                updatePath?.setValue(startTime, forKey: "startTime")
                updatePath?.setValue(endTime, forKey: "endTime")

                print("[BACKUP] save count : \(pathDataList.count)")
                try context.save()
            } catch {
                print("ERROR ON SAVE")
                fatalError(error.localizedDescription)
            }
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

        if let lat: [Double] = path.value(forKey: "lat") as? [Double],
           let lon: [Double] = path.value(forKey: "lon") as? [Double] {

            for index in 0..<lat.count {
                result.append(CLLocation(latitude: lat[index], longitude: lon[index]))
            }
        }
            context.delete(path)
        }

        print("[BACKUP] restore count : \(result.count)")
        
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }

        return result
    }

    func removePathData() {
        let context = AppDelegate.viewContext
        do {
            let paths = try context.fetch(Path.fetchRequest()) as? [Path]
            paths?.forEach{ path in context.delete(path) }
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
