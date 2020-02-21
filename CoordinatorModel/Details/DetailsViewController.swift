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

    lazy var coordinator: DetailsCoordinator = { DetailsCoordinator(viewController: self) }()
    let db = DisposeBag()

    var context: Int?

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindCoordinator()
    }

    func bindViewModel() {
        // no VM now
        valueLabel.text = "\(context ?? 0)"
    }

    func bindCoordinator() {
        backButton.rx.tap
            .debug()
            .bind(to: coordinator.rx.back).disposed(by: db)
    }
}

class DetailsCoordinator: Coordinator {
    unowned let viewController: UIViewController

    required init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func coordinate_to_back() {
        viewController.navigationController?.popViewController(animated: true)
    }
}

extension DetailsCoordinator: ReactiveCompatible {}

extension Reactive where Base: DetailsCoordinator {
    var back: Binder<Void> {
        Binder(base) { (base, _) in
            base.coordinate_to_back()
        }
    }
}


