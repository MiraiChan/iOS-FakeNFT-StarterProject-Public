import UIKit

final class TabBarController: UITabBarController {
    
    let appConfiguration: AppConfiguration
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.appConfiguration = AppConfiguration()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileNC = UINavigationController(
            rootViewController: appConfiguration.profileViewController)
        profileNC.tabBarItem = UITabBarItem(
            title: AppStrings.TabBarController.profileTabBarTitle,
            image: UIImage(named: "profileBar"),
            selectedImage: nil
        )

        let catalogNC = UINavigationController(
            rootViewController: appConfiguration.catalogViewController)
        appConfiguration.catalogViewController.tabBarItem = UITabBarItem(
            title: AppStrings.TabBarController.catalogTabBarTitle,
            image: UIImage(named:"catalogBar"),
            selectedImage: nil
        )
        
        appConfiguration.cartViewController?.tabBarItem = UITabBarItem(
            title: AppStrings.TabBarController.cartTabBarTitle,
            image: UIImage(named: "backetBar"),
            selectedImage: nil
        )
        
        appConfiguration.statisticViewController?.tabBarItem = UITabBarItem(
            title: AppStrings.TabBarController.statisticTabBarTitle,
            image: UIImage(named: "statisticBar"),
            selectedImage: nil
        )
        
        viewControllers = [
            profileNC,
            catalogNC,
            appConfiguration.cartViewController ?? UIViewController(),
            appConfiguration.statisticViewController ?? UIViewController()
        ]
        
        tabBar.isTranslucent = false
        view.tintColor = .ypBlueUn
        tabBar.backgroundColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypBlack
        tabBar.tintColor = .ypBlack
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .ypWhite
            appearance.shadowColor = nil
            appearance.stackedLayoutAppearance.normal.iconColor = .ypBlack
            appearance.stackedLayoutAppearance.selected.iconColor = .ypBlueUn
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
