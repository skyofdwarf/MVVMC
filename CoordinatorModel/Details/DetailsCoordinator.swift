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

/// Protocol using functional interface
protocol DetailsCoordinatorType {
    func back()
}

/// DetailsCoordinator can be subclassed
/*final*/ class DetailsCoordinator: Coordinator, DetailsCoordinatorType {
    func back() {
        coordinatable.viewController?.navigationController?.popViewController(animated: true)
    }
}

extension DetailsCoordinator: ReactiveCompatible {}

/// DetailsCoordinator adopts ReactiveCompatible to provide rx way interfaces
extension Reactive where Base: DetailsCoordinator {
    var back: Binder<Void> {
        Binder(base) { (base, _) in
            base.back()
        }
    }
}
