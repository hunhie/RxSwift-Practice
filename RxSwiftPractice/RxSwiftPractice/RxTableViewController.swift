//
//  RxTableViewController.swift
//  RxSwiftPractice
//
//  Created by walkerhilla on 2023/11/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RxTableViewController: UIViewController, UITableViewDelegate {

  let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    // 옵저버블 객체를 생성
    let items = Observable.just((0..<20).map { "\($0)" })
    
    // 생성한 객체를 통해 TableView Cell에 bind
    items
      .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {row, element, cell in
        cell.textLabel?.text = "\(element) @ row \(row)"
      }
      .disposed(by: disposeBag)
    
    tableView.rx
      .modelSelected(String.self)
      .subscribe { value in
        print("Tapped \(value)")
      }
      .disposed(by: disposeBag)
    
    tableView.rx
        .itemAccessoryButtonTapped
        .subscribe(onNext: { indexPath in
          print("Tapped \(indexPath.section),\(indexPath.row)")
        })
        .disposed(by: disposeBag)
  }


}

