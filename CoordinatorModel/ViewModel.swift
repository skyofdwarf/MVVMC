//
//  ViewModel.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/19.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
