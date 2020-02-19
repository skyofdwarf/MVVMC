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

class ListCoordinator: Coordinator {
    private unowned let coordinatable: ListViewController

    fileprivate let categoryRelay = PublishRelay<Int>()

    init(_ coordinatable: ListViewController) {
        self.coordinatable = coordinatable
    }

    func coordinate_to_details(context: Int = 0) {
        guard
            let nav = coordinatable.vc.navigationController,
            let storyboard = coordinatable.storyboard,
            let details = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        else {
            return
        }

        details.context = context

        nav.pushViewController(details, animated: true)
    }

    func coordinate_to_category(context: Int = 0) {
        guard
            let nav = coordinatable.vc.navigationController,
            let storyboard = coordinatable.storyboard,
            let category = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
        else {
            return
        }

        category.delegate = self

        nav.pushViewController(category, animated: true)
    }
}

extension ListCoordinator: CategoryViewControllerDelegate {
    func categoryViewController(_ vc: CategoryViewController, didSelectSomething something: Int) {
        categoryRelay.accept(something)
    }
}

extension ListCoordinator: ReactiveCompatible {}

extension Reactive where Base: ListCoordinator {
    var details: Binder<Int> {
        Binder(base) { (base, context) in
            base.coordinate_to_details(context: context)
        }
    }

    var category: Binder<Void> {
        Binder(base) { (base, _) in
            base.coordinate_to_category()
        }
    }

    var categoryChanges: Driver<Int> {
        return base.categoryRelay.asDriver(onErrorJustReturn: 0)
    }
}
