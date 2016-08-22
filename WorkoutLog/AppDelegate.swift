import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    var tabBarController: UITabBarController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        let workoutsNav = UINavigationController()
        workoutsNav.delegate = self
        let workoutsTVC = WorkoutsTVC()
        workoutsNav.pushViewController(workoutsTVC, animated: false)
        workoutsNav.tabBarItem.title = "Workouts"
        workoutsNav.tabBarItem.image = UIImage(named: "workout")
        
        let newWorkoutNav = UINavigationController()
        self.newWorkoutNav = newWorkoutNav
        let selectWorkoutTVC = SelectWorkoutTVC(style: .grouped)
        newWorkoutNav.pushViewController(selectWorkoutTVC, animated: false)
        newWorkoutNav.delegate = self
        
        let dummy = UIViewController()
        self.dummy = dummy
        dummy.tabBarItem.title = "New"
        dummy.tabBarItem.image = UIImage(named: "newWorkout")
        
        let routineNav = UINavigationController()
        routineNav.delegate = self
        let routinesTVC = RoutinesTVC()
        routineNav.pushViewController(routinesTVC, animated: false)
        routineNav.tabBarItem.title = "Routines"
        routineNav.tabBarItem.image = UIImage(named: "routine")
        
        let vcs = [workoutsNav, dummy, routineNav]
        tabBarController = UITabBarController()
        tabBarController?.viewControllers = vcs
        tabBarController?.delegate = self
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        window?.tintColor = Theme.Colors.tintColor.color
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [
            NSFontAttributeName: Theme.Fonts.boldTitleFont.font,
            NSForegroundColorAttributeName: Theme.Colors.tintColor.color
        ]
        navBarAppearance.barStyle = UIBarStyle.black
        navBarAppearance.barTintColor = Theme.Colors.foreground.color
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = UIBarStyle.black
        tabBarAppearance.barTintColor = Theme.Colors.foreground.color
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        let attr = [ NSFontAttributeName: Theme.Fonts.titleFont.font ]
        barButtonItemAppearance.setTitleTextAttributes(attr, for: UIControlState())
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    var dummy: UIViewController!
    var newWorkoutNav: UINavigationController!
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == dummy {
            window?.rootViewController?.present(newWorkoutNav, animated: true) {
                
            }
            return false
        } else {
            return true
        }
    }
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "WorkoutLog")
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

