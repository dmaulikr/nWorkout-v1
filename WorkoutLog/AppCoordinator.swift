import UIKit
import CoreData

class Coordinator: NSObject {
    var context = CoreData.shared.context
}

class AppCoordinator: Coordinator {
    var tabBarController: UITabBarController
    var dummy: UIViewController!
    var newWorkoutNav: UINavigationController!
    
    override init() {
        tabBarController = UITabBarController()
        super.init()
        setupTBC()
        Theme.setupAppearances()
        fetchIncompletes()
    }
    
    func fetchIncompletes() {
        let request = Workout.request
        request.fetchBatchSize = Lets.defaultBatchSize
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "complete == false")
        let incompletes = try! CoreData.shared.context.fetch(request)
        print(incompletes)
        
        if let first = incompletes.first {
            let wtvc = WorkoutTVC(dataProvider: first)
            let dummyNavBarItem = dummy.tabBarItem!
            dummyNavBarItem.image = #imageLiteral(resourceName: "show")
            dummyNavBarItem.title = "Show"
            wtvc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Side", style: .plain, target: wtvc, action: #selector(wtvc.hideButtonPushed))
            newWorkoutNav.pushViewController(wtvc, animated: false)
            tabBarController.present(newWorkoutNav, animated: true, completion: nil)            
        }
    }
    func setupTBC() {
        let workoutsTVC = WorkoutsTVC()
        let workoutsNav = UINavigationController(rootViewController: workoutsTVC)
        workoutsNav.delegate = self
        workoutsNav.tabBarItem.image = UIImage(named: "workout")
        workoutsNav.tabBarItem.title = "Workouts"
        workoutsTVC.navigationItem.title = "Workouts"
        
        let routinesTVC = RoutinesTVC()
        let routineNav = UINavigationController(rootViewController: routinesTVC)
        routineNav.delegate = self
        routineNav.tabBarItem.image = UIImage(named: "routine")
        routineNav.tabBarItem.title = "Routines"
        routinesTVC.navigationItem.title = "Routines"
        
        let selectWorkoutTVC = SelectWorkoutTVC(style: .grouped)
        newWorkoutNav = UINavigationController(rootViewController: selectWorkoutTVC)
        newWorkoutNav.delegate = self
        selectWorkoutTVC.navigationItem.title = "New Workout"
        
        dummy = UIViewController()
        dummy.tabBarItem.title = "New"
        dummy.tabBarItem.image = UIImage(named: "newWorkout")
        
        let statisticsTVC = StatisticsTVC()
        let statisticsNav = UINavigationController(rootViewController: statisticsTVC)
        statisticsNav.delegate = self
        statisticsNav.tabBarItem.image = #imageLiteral(resourceName: "statistics")
        statisticsNav.tabBarItem.title = "Statistics"
        statisticsTVC.navigationItem.title = "Statistics"
        
        let settingsTVC = UIViewController()
        let settingsNav = UINavigationController(rootViewController: settingsTVC)
        settingsNav.delegate = self
        settingsNav.tabBarItem.image = #imageLiteral(resourceName: "settings")
        settingsNav.tabBarItem.title = "Settings"
        settingsTVC.navigationItem.title = "Settings"
        
        let vcs = [workoutsNav, routineNav, dummy!, statisticsNav]
        tabBarController.viewControllers = vcs
        tabBarController.delegate = self
        
        let itemWidth = tabBarController.tabBar.frame.width / CGFloat(tabBarController.tabBar.items!.count)
        let backgroundView = UIView(frame: CGRect(x: itemWidth * 2, y: 0, width: itemWidth, height: tabBarController.tabBar.frame.height))
        backgroundView.backgroundColor = Theme.Colors.tint
        tabBarController.tabBar.insertSubview(backgroundView, at: 0)
    }
}

extension AppCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == dummy {
            tabBarController.present(newWorkoutNav, animated: true) {
            
            }
            return false
        } else {
            return true
        }
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    
}
