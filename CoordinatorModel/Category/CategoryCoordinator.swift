//
//  CategoryCoordinator.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/19.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

/// Protocol using functional interface
protocol CategoryCoordinatorType {
    func back()
    func showHelp()
}

final class CategoryCoordinator: Coordinator, CategoryCoordinatorType {
    func back() {
        coordinatable.viewController?.navigationController?.popViewController(animated: true)
    }

    func showHelp() {
        coordinatable.viewController?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
