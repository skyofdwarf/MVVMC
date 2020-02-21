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

final class CategoryCoordinator: CategoryCoordinatorInterface {
    var rx: RxCategoryCoordinatorInterface { Reactive<CategoryCoordinator>(self) }

    private unowned let vc: UIViewController

    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
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
