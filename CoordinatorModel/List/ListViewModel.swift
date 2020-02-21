//
//  ListViewModel.swift
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

protocol ListDataSourceType: class {
    func fetch() -> Observable<[Int]>
}

class ListDataSource: ListDataSourceType {
    func fetch() -> Observable<[Int]> {
        .just([1,2,3,4,5])
    }
}

class MockListDataSource: ListDataSourceType {
    func fetch() -> Observable<[Int]> {
        .just([1,2,3,4,5])
    }
}

protocol ListViewModelInput {
    var fetch: ControlEvent<Void> { get }
    var edit: ControlEvent<Void> { get }
    var select: ControlEvent<IndexPath> { get }
}

protocol ListViewModelOutput {
    var items: Observable<[Int]> { get }
    var category: Driver<Int> { get }
}

class ListViewModel: ViewModel {
    struct Input: ListViewModelInput {
        var fetch: ControlEvent<Void>
        var edit: ControlEvent<Void>
        var select: ControlEvent<IndexPath>
    }
    struct Output: ListViewModelOutput {
        var items: Observable<[Int]>
        var category: Driver<Int>
    }

    let db = DisposeBag()

    let dataSource: ListDataSourceType
    let coordinator: RxListCoordinatorType

    fileprivate let categoryRelay = PublishRelay<Int>()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    init(dataSource: ListDataSourceType, coordinator: RxListCoordinatorType) {
        self.dataSource = dataSource
        self.coordinator = coordinator
    }

    func transform(_ input: Input) -> Output {
        let items = input.fetch
            .flatMap(dataSource.fetch)

        input.edit
            .bind(to: coordinator.category)
            .disposed(by: db)

        input.select
            .map { $0.row }
            .bind(to: coordinator.details)
            .disposed(by: db)

        return Output(items: items, category: coordinator.categoryChanges)
    }
}
