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
