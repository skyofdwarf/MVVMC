//
//  DetailsCoordinator.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/24.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

protocol DetailsCoordinatorType {
    func back()
}

final class DetailsCoordinator: Coordinator, DetailsCoordinatorType {
    func back() {
        coordinatable.viewController?.navigationController?.popViewController(animated: true)
    }
}

extension DetailsCoordinator: ReactiveCompatible {}

extension Reactive where Base: DetailsCoordinator {
    var back: Binder<Void> {
        Binder(base) { (base, _) in
            base.back()
        }
    }
}
