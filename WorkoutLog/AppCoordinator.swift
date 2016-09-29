import UIKit

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
        
//        let settingsTVC = UIViewController()
//        let settingsNav = UINavigationController(rootViewController: settingsTVC)
//        settingsNav.delegate = self
//        settingsNav.tabBarItem.image = #imageLiteral(resourceName: "settings")
//        settingsNav.tabBarItem.title = "Settings"
//        settingsTVC.navigationItem.title = "Settings"
        
        let vcs = [workoutsNav, routineNav, dummy!, statisticsNav]
        tabBarController.viewControllers = vcs
        tabBarController.delegate = self
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
