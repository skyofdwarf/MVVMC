//
//  ListCoordinator.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/18.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

protocol ListCoordinatorType  {
    func showDetails(context: Int)
    func showCategories()

    var rx: RxListCoordinatorType { get }
}

protocol RxListCoordinatorType {
    var details: Binder<Int> { get }
    var category: Binder<Void> { get }
    var categoryChanges: Driver<Int> { get }
}

class ListCoordinator: Coordinator, ListCoordinatorType {
    let viewController: UIViewController

    var rx: RxListCoordinatorType { Reactive<ListCoordinator>(self) }

    fileprivate let categoryRelay = PublishRelay<Int>()

    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showDetails(context: Int) {
        guard let navigationController = viewController.navigationController,
            let storyboard = viewController.storyboard,
            let details = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        else {
            return
        }

        details.context = context

        navigationController.pushViewController(details, animated: true)
    }

    func showCategories() {
        guard
            let navigationController = viewController.navigationController,
            let storyboard = viewController.storyboard,
            let categoryVC = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
        else {
            return
        }

        let coordinator  = CategoryCoordinator(categoryVC)

        categoryVC.delegate = self
        categoryVC.vm = CategoryViewModel(dataSource: CategoryDataSource(),
                                          coordinator: coordinator)

        navigationController.pushViewController(categoryVC, animated: true)
    }
}

extension ListCoordinator: CategoryViewControllerDelegate {
    func categoryViewController(_ vc: CategoryViewController, didSelectSomething something: Int) {
        categoryRelay.accept(something)
    }
}

extension ListCoordinator: ReactiveCompatible {}

extension Reactive: RxListCoordinatorType where Base: ListCoordinator {
    var details: Binder<Int> {
        Binder(base) { (base, context) in
            base.showDetails(context: context)
        }
    }

    var category: Binder<Void> {
        Binder(base) { (base, _) in
            base.showCategories()
        }
    }

    var categoryChanges: Driver<Int> {
        return base.categoryRelay.asDriver(onErrorJustReturn: 0)
    }
}
