//
//  ListViewModelTests.swift
//  CoordinatorModelTests
//
//  Created by kimyj on 2020/02/19.
//  Copyright © 2020 kimyj. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxRelay
import RxBlocking
import RxTest
import Nimble

@testable import MVVMC

class MockDataSource: ListDataSourceType {
    let items: [Int]
    init(_ items: [Int]) {
        self.items = items
    }

    func fetch() -> Observable<[Int]> {
        .just(items)
    }
}

class MockListCoordinator: Coordinator, ListCoordinatorType  {
    let categoryRelay = PublishRelay<Int>()

    var showDetailsCalled = false
    var showCategoriesCalled = false

    var details: Binder<Int> {
        Binder(self) { (base, context) in
            base.showDetailsCalled = true
        }
    }

    var category: Binder<Void> {
        Binder(self) { (base, _) in
            base.showCategoriesCalled = true
        }
    }

    var categoryChanges: Driver<Int> {
        return categoryRelay.asDriver(onErrorJustReturn: 0)
    }
}

class ListViewModelTests: XCTestCase {
    let fetch = PublishSubject<Void>()
    let edit = PublishSubject<Void>()
    let select = PublishSubject<IndexPath>()

    var db = DisposeBag()

    let items = [1,2,3,4,5,6]

    var dataSource: MockDataSource!
    var coordinator: MockListCoordinator!

    var vm: ListViewModel!
    var output: ListViewModel.Output!

    override func setUp() {
        dataSource = MockDataSource(items)
        coordinator = MockListCoordinator(UIViewController())

        vm = ListViewModel(dataSource: dataSource, coordinator: coordinator)

        let input = ListViewModel.Input(fetch: ControlEvent<Void>(events: fetch.asObservable()),
                                        edit: ControlEvent<Void>(events: edit.asObservable()),
                                        select: ControlEvent<IndexPath>(events: select.asObservable()))

        output = vm.transform(input)
    }

    override func tearDown() {
        db = DisposeBag()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoordinator() {
        expect(self.coordinator.showDetailsCalled).to(beFalse())
        expect(self.coordinator.showCategoriesCalled).to(beFalse())

        // when
        edit.onNext(())

        // then
        expect(self.coordinator.showCategoriesCalled).to(beTrue())

        // when
        select.onNext(IndexPath(row: 3, section: 7))

        // then
        expect(self.coordinator.showDetailsCalled).to(beTrue())
    }

    func testCategoryEvents() {
        let scheduler = TestScheduler(initialClock: 0)
        let categoryObserver = scheduler.createObserver(Int.self)

        output.category
            .drive(categoryObserver)
            .disposed(by: db)

        // when
        let categories = [13, 20]
        categories.forEach {
            self.coordinator.categoryRelay.accept($0)
        }

        // then
        let categoryValues = categoryObserver.events.compactMap { $0.value.element }

        expect(categoryValues.count).to(equal(categories.count))
        expect(categoryValues).to(equal(categories))
    }

    func testDataSourceItems() {
        let scheduler = TestScheduler(initialClock: 0)
        let itemsObserver = scheduler.createObserver([Int].self)

        output.items
            .bind(to: itemsObserver)
            .disposed(by: db)

        fetch.onNext(())

        let itemsValues = itemsObserver.events.compactMap { $0.value.element }

        expect(itemsValues.count).to(equal(1))
        expect(itemsValues.first).to(equal(dataSource.items))
    }
}
