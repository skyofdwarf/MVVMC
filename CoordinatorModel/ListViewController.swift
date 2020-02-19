//
//  ListViewController.swift
//  CoordinatorModel
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

    lazy var coordinator: ListCoordinator = { ListCoordinator(self) }()
    var vm: ListViewModel!

    let db = DisposeBag()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List"

        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightButton

        bindViewModel()
    }

    func bindViewModel() {
        let emptyControlEvent = ControlEvent<Void>(events: Observable<Void>.empty())

        let fetch = ControlEvent<Void>(events: rx.viewWillAppear.map { _ in () })
        let edit = navigationItem.rightBarButtonItem?.rx.tap ?? emptyControlEvent
        let select = tv.rx.itemSelected

        // input
        let input = ListViewModel.Input(fetch: fetch,
                                        edit: edit,
                                        select: select)

        // vm
        vm = ListViewModel(input: input,
                           dataSource: ListDataSource(),
                           coordinator: coordinator)

        // output
        vm.output.items.bind(to: tv.rx.items(cellIdentifier: "ListCell", cellType: UITableViewCell.self)) { (row, value, cell) in
            cell.textLabel?.text = "\(row): \(value)"
        }
        .disposed(by: db)

        vm.output.category
            .debug()
            .drive(onNext: { [weak self] (category) in
                self?.title = "\(category)"
            })
            .disposed(by: db)
    }
}

// MARK: TEST: ViewModel contains Coordinator

class ListDataSource {
    func fetch() -> Observable<[Int]> {
        .just([1,2,3,4,5])
    }
}

class ListViewModel {
    struct Input {
        var fetch: ControlEvent<Void>
        var edit: ControlEvent<Void>
        var select: ControlEvent<IndexPath>
    }
    struct Output {
        var items: Observable<[Int]>
        var category: Driver<Int>
    }

    let db = DisposeBag()

    let dataSource: ListDataSource
    let coordinator: ListCoordinator

    let output: Output

    // no protocol for datasource and coordinator now
    init(input: Input, dataSource: ListDataSource, coordinator: ListCoordinator) {
        self.dataSource = dataSource
        self.coordinator = coordinator

        let items = input.fetch
            .flatMap { [weak dataSource] in dataSource?.fetch() ?? .empty() }

        input.edit
            .bind(to: coordinator.rx.category)
            .disposed(by: db)

        input.select
            .map { $0.row }
            .bind(to: coordinator.rx.details)
            .disposed(by: db)

        output = Output(items: items, category: coordinator.rx.categoryChanges)
    }
}
