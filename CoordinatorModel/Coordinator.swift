//
//  Coordinator.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/18.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatableView {
    var view: UIView! { get }
}

protocol CoordinatableViewController: CoordinatableView {
    var vc: UIViewController { get }
}

typealias Coordinatable = CoordinatableViewController

extension UIView: CoordinatableView {
    var view: UIView! { return self }
}

extension UIViewController: CoordinatableViewController  {
    var vc: UIViewController { return self }
}

protocol Coordinator {
    //var coordinatable: Coordinatable { get }
}

extension Coordinator {
}
