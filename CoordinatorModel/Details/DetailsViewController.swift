//
//  DetailsViewController.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/18.
//  Copyright © 2020 kimyj. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class DetailsViewController: UIViewController {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!

    let db = DisposeBag()
    var vm: DetailsViewModel?

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    func bindViewModel() {
        guard let vm = vm else { return }

        let output = vm.transform(DetailsViewModel.Input(back: backButton.rx.tap))

        output.title
            .map { "\($0)" }
            .drive(valueLabel.rx.text)
            .disposed(by: db)
    }
}

protocol DetailsCoordinatorType {
    func back()
}

final class DetailsCoordinator: Coordinator, DetailsCoordinatorType {
    func back() {
        coordinatable.viewController?.navigationController?.popViewController(animated: true)
    }
}

extension DetailsCoordinator: ReactiveCompatible {}

extension Reactive where Base: DetailsCoordinator {
    var back: Binder<Void> {
        Binder(base) { (base, _) in
            base.back()
        }
    }
}

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
//        input.back
//            .bind(to: rx.back)
//            .disposed(by: db)

//        input.back
//            .bind(onNext: { [weak coordinator] in
//                coordinator?.back()
//            })
//        .disposed(by: db)

        return Output(title: Observable.just(context).asDriver(onErrorJustReturn: 0))
    }
}

//extension DetailsViewModel: ReactiveCompatible {}
//
//extension Reactive where Base: DetailsViewModel {
//    var back: Binder<Void> {
//        Binder(base) { (base, context) in
//            base.coordinator.back()
//        }
//    }
//}
