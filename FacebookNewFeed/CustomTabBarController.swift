//
//  CustomTabBarController.swift
//  FacebookNewFeed
//
//  Created by LamHan on 7/1/18.
//  Copyright © 2018 LamHan. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let friendRequestsController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestsController)
        secondNavigationController.title = "Requests"
        secondNavigationController.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messengerVC = UIViewController()
        let messengerNavigationController = UINavigationController(rootViewController: messengerVC)
        messengerNavigationController.title = "Messenger"
        messengerNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationsNavController = UINavigationController(rootViewController: UIViewController())
        notificationsNavController.title = "Notifications"
        notificationsNavController.tabBarItem.image = UIImage(named: "globe_icon")
        
        let moreNavController = UINavigationController(rootViewController: UIViewController())
        moreNavController.title = "More"
        moreNavController.tabBarItem.image = UIImage(named: "more_icon")
        
        
        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notificationsNavController, moreNavController]
        
        tabBar.isTranslucent = false

        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor

        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
