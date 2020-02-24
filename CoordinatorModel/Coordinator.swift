//
//  Coordinator.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/18.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import UIKit

/// Coordinatable protocol
protocol Coordinatable: class {
    var viewController: UIViewController? { get }
    var view: UIView? { get }
}

extension UIViewController: Coordinatable {
    var viewController: UIViewController? { self }
    var view: UIView? { nil }
}

extension UIView: Coordinatable {
    var viewController: UIViewController? { nil }
    var view: UIView? { self }
}

/// Coordinator protocol
protocol CoordinatorType {
    var coordinatable: Coordinatable { get }

    init(_ coordinatable: Coordinatable)
}

/// Base Coordinator class
class Coordinator: CoordinatorType {
    /// Coordinatable object
    ///
    /// - note: `coordinatable` is _unowned_
    unowned let coordinatable: Coordinatable

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    required init(_ coordinatable: Coordinatable) {
        self.coordinatable = coordinatable
    }
}
