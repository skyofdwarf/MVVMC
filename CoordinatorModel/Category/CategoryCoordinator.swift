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

protocol CategoryCoordinatorInterface  {
    func back()
    func showHelp()
}

protocol RxCategoryCoordinatorInterface  {
    var back: Binder<Void> { get }
    var help: Binder<Void> { get }
}

class CategoryCoordinator: CategoryCoordinatorInterface {
    private unowned let vc: UIViewController
    fileprivate let categoryRelay = PublishRelay<Int>()

    init(_ vc: UIViewController) {
        self.vc = vc
    }

    func back() {
        vc.navigationController?.popViewController(animated: true)
    }

    func showHelp() {
        vc.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}

extension CategoryCoordinator: ReactiveCompatible {}

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

