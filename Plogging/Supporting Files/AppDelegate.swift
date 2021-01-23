//
//  AppDelegate.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/03.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: CoreData Container
    lazy var persistContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Backup")
        container.loadPersistentStores () { description, error in
            if let error = error {fatalError("Error on load container")}
        }
        return container
    }()

    static var persistContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistContainer
    }

    static var viewContext: NSManagedObjectContext {
        return persistContainer.viewContext
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

