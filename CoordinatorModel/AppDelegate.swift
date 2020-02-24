//
//  AppDelegate.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/18.
//  Copyright © 2020 kimyj. All rights reserved.
//

import UIKit

class AppCoordinator {
    static func setup(for window: UIWindow?) {
        guard
            let window = window,
            let navigationController = window.rootViewController as? UINavigationController,
            let listVC = navigationController.topViewController as? ListViewController
            else {
                return
        }

        listVC.vm = ListViewModel(dataSource: ListDataSource(),
                                  coordinator: ListCoordinator(listVC))
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        AppCoordinator.setup(for: window)

        return true
    }
}

