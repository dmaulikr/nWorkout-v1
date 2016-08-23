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
        setupAppearances()
    }
    
    func setupTBC() {
        let workoutsNav = UINavigationController()
        workoutsNav.delegate = self
        let workoutsTVC = WorkoutsTVC()
        workoutsNav.pushViewController(workoutsTVC, animated: false)
        workoutsNav.tabBarItem.title = "Workouts"
        workoutsNav.tabBarItem.image = UIImage(named: "workout")
        workoutsTVC.navigationItem.title = "Workouts"
        
        let routineNav = UINavigationController()
        routineNav.delegate = self
        let routinesTVC = RoutinesTVC()
        routineNav.pushViewController(routinesTVC, animated: false)
        routineNav.tabBarItem.title = "Routines"
        routineNav.tabBarItem.image = UIImage(named: "routine")
        routinesTVC.navigationItem.title = "Routines"
        
        let newWorkoutNav = UINavigationController()
        self.newWorkoutNav = newWorkoutNav
        let selectWorkoutTVC = SelectWorkoutTVC(style: .grouped)
        newWorkoutNav.pushViewController(selectWorkoutTVC, animated: false)
        newWorkoutNav.delegate = self
        selectWorkoutTVC.navigationItem.title = "New Workout"
        
        let dummy = UIViewController()
        self.dummy = dummy
        dummy.tabBarItem.title = "New"
        dummy.tabBarItem.image = UIImage(named: "newWorkout")
        
        let statisticsNav = UINavigationController()
        statisticsNav.delegate = self
        let statisticsTVC = StatisticsTVC()
        statisticsNav.pushViewController(statisticsTVC, animated: false)
        statisticsNav.tabBarItem.title = "Statistics"
        statisticsTVC.navigationItem.title = "Statistics"
        statisticsNav.tabBarItem.image = #imageLiteral(resourceName: "statistics")
        
        let settingsNav = UINavigationController()
        settingsNav.delegate = self
        let settingsTVC = UIViewController()
        settingsNav.pushViewController(settingsTVC, animated: false)
        settingsNav.tabBarItem.title = "Settings"
        settingsNav.tabBarItem.image = #imageLiteral(resourceName: "settings")
        settingsTVC.navigationItem.title = "Settings"
        
        let vcs = [workoutsNav, routineNav, dummy, statisticsNav, settingsNav]
        tabBarController.viewControllers = vcs
        tabBarController.delegate = self
    }
    
    func setupAppearances() {
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
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = Theme.Colors.backgroundColor.color
        
        let cellAppearance = UITableViewCell.appearance()
        cellAppearance.backgroundColor = UIColor.clear
        
        let labelAppearance = UILabel.appearance()
        labelAppearance.font = Theme.Fonts.titleFont.font
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
