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
            let nav = window.rootViewController as? UINavigationController,
            let listVC = nav.topViewController as? ListViewController
            else {
                return
        }

        let coordinator  = ListCoordinator(listVC)

        listVC.vm = ListViewModel(dataSource: ListDataSource(),
                                  coordinator: coordinator.rx)
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

