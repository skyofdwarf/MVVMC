//
//  CategoryViewModelTests.swift
//  CoordinatorModelTests
//
//  Created by kimyj on 2020/02/26.
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

struct  MockCategoryDataSource: CategoryDataSourceType {
    let value: Int

    func random() -> Observable<Int> {
        .just(value)
    }
}

class MockCategoryCoordinator: Coordinator, CategoryCoordinatorType  {
    var backCalled = false

    func back() { backCalled = true }
}

class CategoryViewModelTests: XCTestCase {
    let back = PublishSubject<Void>()
    let fetch = PublishSubject<Void>()

    var db = DisposeBag()

    let context = 777

    var dataSource: MockCategoryDataSource!
    var coordinator: MockCategoryCoordinator!

    var vm: CategoryViewModel!
    var output: CategoryViewModel.Output!

    override func setUp() {
        dataSource = MockCategoryDataSource(value: context)
        coordinator = MockCategoryCoordinator(UIViewController())

        vm = CategoryViewModel(dataSource: dataSource, coordinator: coordinator)

        let input = CategoryViewModel.Input(fetch: ControlEvent<Void>(events: fetch.asObservable()),
                                            back: ControlEvent<Void>(events: back.asObservable()))


        output = vm.transform(input)
    }

    override func tearDown() {
        db = DisposeBag()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoordinator_back() {
        // when
        back.onNext(())

        // then
        expect(self.coordinator.backCalled).to(beTrue())
    }

    func testCoordinator_fetch() {
        // when
        fetch.onNext(())

        // then
        expect(self.coordinator.backCalled).to(beTrue())
    }

    func testOutput() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        output.value
            .drive(observer)
            .disposed(by: db)

        fetch.onNext(())

        let values = observer.events.compactMap { $0.value.element }

        expect(values.count).to(equal(1))
        expect(values.first).to(equal(context))
    }
}
