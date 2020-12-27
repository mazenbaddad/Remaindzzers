//
//  AppDelegate.swift
//  Remaindzzers
//
//  Created by mazen baddad on 10/31/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    let nofificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        checkLocationAuth()
        authorizeUserNotification() 
        
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) { return true }
        
        // if it's lower than IOS 13.0
        let remainderTableViewController = RemainderTableViewController(style: .plain)
        let navigationRemainderTableViewController = RNavigationController(rootViewController: remainderTableViewController)
        window?.rootViewController = navigationRemainderTableViewController
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    // MARK: - Core Location
    
    func checkLocationAuth() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied:
            break
        case .authorizedAlways:
            startUpadtingLocation()
        case .authorizedWhenInUse:
            startUpadtingLocation()
        default:
            break
        }
    }
    
    func startUpadtingLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        
        
        // monitoring existing locations
        let locations = RemainderCategory.locations
        for (index , location) in locations.enumerated() {
            
            let id = "\(location.category.rawValue)\(index)"
            let region = CLCircularRegion(center: location.coordinates, radius: 10, identifier: id)
            region.notifyOnExit = false
            self.locationManager.startMonitoring(for: region)
        }

    }
    
    
    //MARK:- User Notification
    
    func authorizeUserNotification() {
        let options : UNAuthorizationOptions = [.alert , .sound]
        nofificationCenter.requestAuthorization(options: options) { (_, _) in }
        nofificationCenter.delegate = self
    }
    
    func addNotification(for remainders : Array<Remainder> ,with category : String ) {
        if remainders.count == 1 {
            let remainder = remainders.first!
            let remainderDescription = remainder.remainderDescription != nil ? "\n\(remainder.remainderDescription!)" : ""
            let title = "Your are close from a \(category)"
            let body = "You have a remainder for \(remainders.first!.title!) \(remainderDescription)"
            self.addNotification(with: title, body: body)
        }else if remainders.count > 1 {
            let title = "Your are close from a \(category)"
            var body = "You have a remainder for"
            for remainder in remainders where remainder.title != nil{
                body += " , \(remainder.title!)"
            }
            self.addNotification(with: title, body: body)
        }
    }
    
    func addNotification(with title : String , body : String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let date = Date(timeIntervalSinceNow: 1)
        let dateComponent = Calendar.current.dateComponents([.year , .month , .day , .hour ,.minute , .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        nofificationCenter.add(request) { (_) in}
    }
    
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Remaindzzers")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("erro monitoring did fail for region")
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let chatCategory = region.identifier.first , let intCategory = Int(String(chatCategory)) , let circularRegion = region as? CLCircularRegion{
            print(region.identifier)
            print(circularRegion.center)
            let categoryRawValue = Int16(intCategory)
            if categoryRawValue <= 4 {
                // default categories
                print("default")
                let categories = ["pharmacy","grocery","bakery","butchery","plantShop"]
                let category = categories[intCategory]
                do {
                    let request = Remainder.fetchRequest() as NSFetchRequest<Remainder>
                    request.predicate = NSPredicate(format: "category == %i", categoryRawValue)
                    let remainders = try persistentContainer.viewContext.fetch(request)
                    self.addNotification(for: remainders, with: category)
                }catch {
                    print(error)
                }
                
            }else {
                // custom category
                print("custom")
                do {
                    let request = Remainder.fetchRequest() as NSFetchRequest
                    request.predicate = NSPredicate(format: "latitude == %lf And longitude == %lf" , circularRegion.center.latitude , circularRegion.center.longitude)
                    let remainders = try persistentContainer.viewContext.fetch(request)
                    print("count:\(remainders.count)")
                    do {
                        let request = CustomCategory.fetchRequest() as NSFetchRequest
                        request.predicate = NSPredicate(format: "id == %@" , region.identifier)
                        let categories = try persistentContainer.viewContext.fetch(request)
                        if let category = categories.first , let title = category.title {
                            print("title")
                            self.addNotification(for: remainders, with: title)
                        }else {
                            print("no title")
                        }
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
