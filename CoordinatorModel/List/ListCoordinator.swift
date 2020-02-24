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

/// Protocol using rx interface
protocol ListCoordinatorType  {
    var details: Binder<Int> { get }
    var category: Binder<Void> { get }
    var categoryChanges: Driver<Int> { get }
}

final class ListCoordinator: Coordinator, ListCoordinatorType {
    fileprivate let categoryRelay = PublishRelay<Int>()

    var details: Binder<Int> {
        Binder(self) { (base, context) in
            base.showDetails(context: context)
        }
    }

    var category: Binder<Void> {
        Binder(self) { (base, _) in
            base.showCategories()
        }
    }

    var categoryChanges: Driver<Int> {
        return categoryRelay.asDriver(onErrorJustReturn: 0)
    }
}

private extension ListCoordinator {
    func showDetails(context: Int) {
        guard
            let viewController = coordinatable.viewController,
            let navigationController = viewController.navigationController,
            let storyboard = viewController.storyboard,
            let details = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        else {
            return
        }

        details.vm = DetailsViewModel(context: context, coordinator: DetailsCoordinator(details))

        navigationController.pushViewController(details, animated: true)
    }

    func showCategories() {
        guard
            let viewController = coordinatable.viewController,
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
