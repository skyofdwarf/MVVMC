//
//  CategoryViewModel.swift
//  MVVMC
//
//  Created by kimyj on 2020/02/19.
//  Copyright © 2020 kimyj. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay

protocol CategoryDataSourceType {
    func random() -> Observable<Int>
}

class CategoryDataSource: CategoryDataSourceType {
    func random() -> Observable<Int> {
        .just(Int.random(in: 0..<100))
    }
}

class MockCategoryDataSource: CategoryDataSourceType {
    func random() -> Observable<Int> {
        .just(100)
    }
}

protocol CategoryViewModelInput {
    var fetch: ControlEvent<Void> { get }
    var back: ControlEvent<Void> { get }
}

protocol CategoryViewModelOutput {
    var value: Driver<Int> { get }
}

class CategoryViewModel: ViewModel {
    struct Input {
        var fetch: ControlEvent<Void>
        var back: ControlEvent<Void>
    }
    struct Output {
        var value: Driver<Int>
    }

    let db = DisposeBag()

    let dataSource: CategoryDataSourceType
    let coordinator: CategoryCoordinatorType

    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    init(dataSource: CategoryDataSourceType, coordinator: CategoryCoordinatorType) {
        self.dataSource = dataSource
        self.coordinator = coordinator
    }

    func transform(_ input: Input) -> Output {
        input.back
            .bind(to: rx.back)
            .disposed(by: db)

        let value = input.fetch
            .flatMap(dataSource.random)
            .asDriver(onErrorJustReturn: 0)

        value
            .map { _ in () }
            .drive(rx.back)
            .disposed(by: db)

        return Output(value: value)
    }
}

extension CategoryViewModel: ReactiveCompatible {}

/// ViewModel adopts ReactiveCompatible to use cordinator with rx way
extension Reactive where Base: CategoryViewModel {
    var back: Binder<Void> {
        Binder(base) { (base, context) in
            base.coordinator.back()
        }
    }
}
