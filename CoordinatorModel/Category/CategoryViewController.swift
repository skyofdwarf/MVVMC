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

    var vm: CategoryViewModel?

    let db = DisposeBag()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    func bindViewModel() {
        guard let vm = vm else {
            fatalError("No ViewModel")
        }

        // input
        let input = CategoryViewModel.Input(fetch: selectButton.rx.tap,
                                            back: backButton.rx.tap)

        let output = vm.transform(input)

        // output
        output.value
            .drive(onNext: { [weak self] value in
                guard let self = self else { return }
                self.delegate?.categoryViewController(self, didSelectSomething: value)
            })
            .disposed(by: db)
    }
}
