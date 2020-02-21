//
//  Coordinator.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/18.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var viewController: UIViewController { get }

    init(viewController: UIViewController)
}
