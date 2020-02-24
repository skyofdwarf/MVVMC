//
//  CategoryCoordinator.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/19.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

/// Protocol using function interface
protocol CategoryCoordinatorType {
    func back()
}

final class CategoryCoordinator: Coordinator, CategoryCoordinatorType {
    func back() {
        coordinatable.viewController?.navigationController?.popViewController(animated: true)
    }
}
