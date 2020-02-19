//
//  CategoryCoordinator.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/19.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

protocol CategoryCoordinatorInterface  {
    func back()
}

protocol RxCategoryCoordinatorInterface  {
    var back: Binder<Void> { get }
}

class CategoryCoordinator: CategoryCoordinatorInterface {
    private unowned let coordinatable: CategoryViewController
    fileprivate let categoryRelay = PublishRelay<Int>()

    init(_ coordinatable: CategoryViewController) {
        self.coordinatable = coordinatable
    }

    func back() {
        coordinatable.navigationController?.popViewController(animated: true)
    }
}

extension CategoryCoordinator: ReactiveCompatible {}

extension Reactive: RxCategoryCoordinatorInterface where Base: CategoryCoordinator {
    var back: Binder<Void> {
        Binder(base) { (base, _) in
            base.back()
        }
    }
}

