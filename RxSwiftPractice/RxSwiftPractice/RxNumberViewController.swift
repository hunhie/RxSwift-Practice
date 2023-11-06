//
//  RxNumberViewController.swift
//  RxSwiftPractice
//
//  Created by walkerhilla on 11/6/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RxNumberViewController: UIViewController {
  
  // 3개 입력란의 합을 sum label에 표시.
  
  let containerView: UIView = UIView()
  let number1: UITextField = UITextField()
  let number2: UITextField = UITextField()
  let number3: UITextField = UITextField()
  
  let sum: UILabel = UILabel()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    view.addSubview(containerView)
    containerView.addSubview(number1)
    containerView.addSubview(number2)
    containerView.addSubview(number3)
    view.addSubview(sum)
    
    sum.layer.borderColor = UIColor.black.cgColor
    sum.layer.borderWidth = 0.8
    
    number1.layer.borderColor = UIColor.black.cgColor
    number1.layer.borderWidth = 0.8
    number2.layer.borderColor = UIColor.black.cgColor
    number2.layer.borderWidth = 0.8
    number3.layer.borderColor = UIColor.black.cgColor
    number3.layer.borderWidth = 0.8
    
    containerView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(100)
      make.width.equalToSuperview().multipliedBy(0.75)
      make.height.equalTo(35)
      make.centerX.equalToSuperview()
    }
    
    number1.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalTo(number2.snp.leading)
      make.width.equalToSuperview().dividedBy(3)
      make.height.equalTo(35)
    }
    
    number2.snp.makeConstraints { make in
      make.leading.equalTo(number1.snp.trailing)
      make.trailing.equalTo(number3.snp.leading)
      make.width.equalToSuperview().dividedBy(3)
      make.height.equalTo(35)
    }
    
    number3.snp.makeConstraints { make in
      make.leading.equalTo(number2.snp.trailing)
      make.trailing.equalToSuperview()
      make.width.equalToSuperview().dividedBy(3)
      make.height.equalTo(35)
    }
    
    sum.snp.makeConstraints { make in
      make.top.equalTo(containerView.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
    }
    
    let sumDriver = Driver.combineLatest(number1.rx.text.orEmpty.asDriver(), number2.rx.text.orEmpty.asDriver(), number3.rx.text.orEmpty.asDriver()) { number1, number2, number3 in
      return (Int(number1) ?? 0) + (Int(number2) ?? 0) + (Int(number3) ?? 0)
    }
      .asDriver(onErrorJustReturn: 0)
    
    sumDriver
      .map { $0.description }
      .drive(sum.rx.text)
      .disposed(by: disposeBag)
  }
  
}
