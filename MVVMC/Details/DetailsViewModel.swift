//
//  DetailsViewModel.swift
//  MVVMC
//
//  Created by kimyj on 2020/02/24.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

protocol DetailsViewModelInput {
    var back: ControlEvent<Void> { get }
}
protocol DetailsViewModelOutput {
    var title: Driver<Int?> { get }
}

class DetailsViewModel: ViewModel {
    struct Input: DetailsViewModelInput {
        var back: ControlEvent<Void>
    }
    struct Output: DetailsViewModelOutput {
        var title: Driver<Int?>
    }

    let db = DisposeBag()
    let context: Int
    let coordinator: DetailsCoordinator

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    init(context: Int, coordinator: DetailsCoordinator) {
        self.context = context
        self.coordinator = coordinator
    }                          

    func transform(_ input: Input) -> Output {
        input.back
            .bind(to: coordinator.rx.back)
            .disposed(by: db)

        return Output(title: Observable.just(context).asDriver(onErrorJustReturn: 0))
    }
}
