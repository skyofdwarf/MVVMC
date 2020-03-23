//
//  ListViewController.swift
//  MVVMC
//
//  Created by kimyj on 2020/02/18.
//  Copyright © 2020 kimyj. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay


class ListViewController: UIViewController {
    @IBOutlet weak var tv: UITableView!

    var rightButton: UIBarButtonItem!

    var vm: ListViewModel?
    let db = DisposeBag()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List"

        rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightButton

        bindViewModel()
    }

    func bindViewModel() {
        guard let vm = vm else {
            fatalError("No ViewModel")
        }

        let fetch = ControlEvent<Void>(events: rx.viewWillAppear.map { _ in () })
        let edit = rightButton.rx.tap
        let select = tv.rx.itemSelected

        // input
        let input = ListViewModel.Input(fetch: fetch,
                                        edit: edit,
                                        select: select)

        // vm
        let output = vm.transform(input)

        // output
        output.items.bind(to: tv.rx.items(cellIdentifier: "ListCell", cellType: UITableViewCell.self)) { (row, value, cell) in
            cell.textLabel?.text = "\(row): \(value)"
        }
        .disposed(by: db)

        output.category
            .map { "\($0)" }
            .debug()
            .drive(rx.title)
            .disposed(by: db)
    }
}
