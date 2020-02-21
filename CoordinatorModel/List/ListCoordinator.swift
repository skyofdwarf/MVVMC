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
}

protocol RxListCoordinatorType {
    var details: Binder<Int> { get }
    var category: Binder<Void> { get }
    var categoryChanges: Driver<Int> { get }
}

class ListCoordinator: ListCoordinatorType {
    private unowned let vc: UIViewController

    fileprivate let categoryRelay = PublishRelay<Int>()

    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    init(_ vc: UIViewController) {
        self.vc = vc
    }

    func showDetails(context: Int) {
        guard let navigationController = vc.navigationController,
            let storyboard = vc.storyboard,
            let details = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        else {
            return
        }

        details.context = context

        navigationController.pushViewController(details, animated: true)
    }

    func showCategories() {
        guard
            let navigationController = vc.navigationController,
            let storyboard = vc.storyboard,
            let categoryVC = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
        else {
            return
        }

        let coordinator  = CategoryCoordinator(categoryVC)

        categoryVC.delegate = self
        categoryVC.vm = CategoryViewModel(dataSource: CategoryDataSource(),
                                          coordinator: coordinator.rx)

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
