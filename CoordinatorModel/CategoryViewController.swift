//
//  CategoryViewController.swift
//  CoordinatorModel
//
//  Created by kimyj on 2020/02/18.
//  Copyright © 2020 kimyj. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

protocol CategoryViewControllerDelegate: class {
    func categoryViewController(_ vc: CategoryViewController, didSelectSomething something: Int)
}

class CategoryViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!

    weak var delegate: CategoryViewControllerDelegate?

    lazy var coordinator: CategoryCoordinator = { CategoryCoordinator(self) }()
    var vm: CategoryViewModel!

    let db = DisposeBag()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindCoordinator()
    }

    func bindViewModel() {
        // input
        let input = CategoryViewModel.Input(fetch: selectButton.rx.tap)

        // vm
        vm = CategoryViewModel(input: input, dataSource: CategoryDataSource())

        // output
        vm.output.value
            .do(onNext: { [weak self] value in
                guard let self = self else { return }
                self.delegate?.categoryViewController(self, didSelectSomething: value)
            })
            .map { _ in () }
            .asDriver()
            .drive(coordinator.rx.back)
            .disposed(by: db)
    }

    func bindCoordinator() {
        backButton.rx.tap
            .debug()
            .bind(to: coordinator.rx.back).disposed(by: db)
    }
}

class CategoryCoordinator: Coordinator {
    private unowned let coordinatable: CategoryViewController
    fileprivate let categoryRelay = PublishRelay<Int>()

    init(_ coordinatable: CategoryViewController) {
        self.coordinatable = coordinatable
    }

    func coordinate_to_back() {
        coordinatable.navigationController?.popViewController(animated: true)
    }
}

extension CategoryCoordinator: ReactiveCompatible {}

extension Reactive where Base: CategoryCoordinator {
    var back: Binder<Void> {
        Binder(base) { (base, _) in
            base.coordinate_to_back()
        }
    }
}



// MARK: TEST: ViewModel does not contain Coordinator

class CategoryDataSource {
    func random() -> Observable<Int> {
        .just(Int.random(in: 0..<100))
    }
}

class CategoryViewModel {
    struct Input {
        var fetch: ControlEvent<Void>
    }
    struct Output {
        var value: Driver<Int>
    }

    let db = DisposeBag()

    let dataSource: CategoryDataSource

    let output: Output

    init(input: Input, dataSource: CategoryDataSource) {
        self.dataSource = dataSource

        let value = input.fetch
            .flatMap { [weak dataSource] in dataSource?.random() ?? .empty() }
            .asDriver(onErrorJustReturn: 0)

        output = Output(value: value)
    }
}
