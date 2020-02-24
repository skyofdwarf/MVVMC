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

protocol CategoryCoordinatorInterface {
    func back()
    func showHelp()

    var rx: RxCategoryCoordinatorInterface { get }
}

protocol RxCategoryCoordinatorInterface  {
    var back: Binder<Void> { get }
    var help: Binder<Void> { get }
}

final class CategoryCoordinator: Coordinator, CategoryCoordinatorInterface {
    var rx: RxCategoryCoordinatorInterface { Reactive<CategoryCoordinator>(self) }

    func back() {
        coordinatable.viewController?.navigationController?.popViewController(animated: true)
    }

    func showHelp() {
        coordinatable.viewController?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}

extension Reactive: RxCategoryCoordinatorInterface where Base: CategoryCoordinator {
    var back: Binder<Void> {
        Binder(base) { (base, _) in
            base.back()
        }
    }

    var help: Binder<Void> {
        Binder(base) { (base, _) in
            base.showHelp()
        }
    }
}
