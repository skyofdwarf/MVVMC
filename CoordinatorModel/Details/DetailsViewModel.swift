//
//  DetailsViewModel.swift
//  CoordinatorModel
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
    let coordinator: DetailsCoordinatorType

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    init(context: Int, coordinator: DetailsCoordinatorType) {
        self.context = context
        self.coordinator = coordinator
    }

    func transform(_ input: Input) -> Output {
        input.back
            .bind(to: rx.back)
            .disposed(by: db)

        return Output(title: Observable.just(context).asDriver(onErrorJustReturn: 0))
    }
}

extension DetailsViewModel: ReactiveCompatible {}

extension Reactive where Base: DetailsViewModel {
    var back: Binder<Void> {
        Binder(base) { (base, context) in
            base.coordinator.back()
        }
    }
}
