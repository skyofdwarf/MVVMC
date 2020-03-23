//
//  DetailsViewModelTests.swift
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

class MockDetailsCoordinator: DetailsCoordinator  {
    var backCalled = false

    override func back() {
        backCalled = true
    }
}

class DetailsViewModelTests: XCTestCase {
    let back = PublishSubject<Void>()

    var db = DisposeBag()

    let context = 123

    var coordinator: MockDetailsCoordinator!

    var vm: DetailsViewModel!
    var output: DetailsViewModel.Output!

    override func setUp() {
        coordinator = MockDetailsCoordinator(UIViewController())

        vm = DetailsViewModel(context: context, coordinator: coordinator)

        let input = DetailsViewModel.Input(back: ControlEvent<Void>(events: back.asObservable()))

        output = vm.transform(input)

    }

    override func tearDown() {
        db = DisposeBag()
    }

    func testCoordinator() {
        expect(self.coordinator.backCalled).to(beFalse())

        // when
        back.onNext(())

        // then
        expect(self.coordinator.backCalled).to(beTrue())
    }

    func testOutput() {
        let scheduler = TestScheduler(initialClock: 0)
        let titleObserver = scheduler.createObserver(Int?.self)

        output.title
            .drive(titleObserver)
            .disposed(by: db)

        let itemsValues = titleObserver.events.compactMap { $0.value.element }

        expect(itemsValues.count).to(equal(1))
        expect(itemsValues.first).to(equal(context))
    }
}
