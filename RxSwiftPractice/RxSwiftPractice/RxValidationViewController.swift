//
//  RxValidationViewController.swift
//  RxSwiftPractice
//
//  Created by walkerhilla on 11/6/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RxValidationViewController: UIViewController {
  let username: UITextField = UITextField()
  let usernameValid: UILabel = UILabel()
  let password: UITextField = UITextField()
  let passwordValid: UILabel = UILabel()
  let doSometing: UIButton = UIButton()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    view.addSubview(username)
    view.addSubview(usernameValid)
    view.addSubview(password)
    view.addSubview(passwordValid)
    view.addSubview(doSometing)
    
    username.layer.borderColor = UIColor.black.cgColor
    username.layer.borderWidth = 0.8
    password.layer.borderColor = UIColor.black.cgColor
    password.layer.borderWidth = 0.8
    doSometing.setTitle("로그인", for: .normal)
    doSometing.setTitleColor(.black, for: .normal)
    doSometing.layer.borderColor = UIColor.black.cgColor
    doSometing.layer.borderWidth = 0.8
    
    username.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(100)
      make.centerX.equalToSuperview()
      make.width.equalTo(200)
      make.height.equalTo(40)
    }
    
    usernameValid.snp.makeConstraints { make in
      make.top.equalTo(username.snp.bottom).offset(10)
      make.leading.equalTo(username)
      make.width.equalTo(200)
    }
    
    password.snp.makeConstraints { make in
      make.top.equalTo(usernameValid.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.width.equalTo(200)
      make.height.equalTo(40)
    }
    
    passwordValid.snp.makeConstraints { make in
      make.top.equalTo(password.snp.bottom)
      make.leading.equalTo(password)
      make.width.equalTo(200)
    }
    
    doSometing.snp.makeConstraints { make in
      make.top.equalTo(passwordValid.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.width.equalTo(100)
      make.height.equalTo(48)
    }
    
    usernameValid.text = "사용자 이름은 5글자 내로 가능합니다."
    passwordValid.text = "비밀번호는 5글자 내로 가능합니다."
    
    
    let usernameValidation = username.rx.text.orEmpty
      .map { $0.count >= 5 }
      .asDriver(onErrorJustReturn: false)
    
    let passwordValidation = password.rx.text.orEmpty
      .map{ $0.count >= 5 }
      .asDriver(onErrorJustReturn: false)
    
    let everythingValid = Driver.combineLatest(usernameValidation, passwordValidation) { $0 && $1 }
      .asDriver(onErrorJustReturn: false)
    
    usernameValidation
      .drive(password.rx.isEnabled)
      .disposed(by: disposeBag)
    
    usernameValidation
      .drive(usernameValid.rx.isHidden)
      .disposed(by: disposeBag)
    
    passwordValidation
      .drive(passwordValid.rx.isHidden)
      .disposed(by: disposeBag)
    
    everythingValid
      .drive(doSometing.rx.isEnabled)
      .disposed(by: disposeBag)
    
    doSometing.rx.tap
      .subscribe(onNext: { [weak self] _ in
        self?.showAlert()
      })
      .disposed(by: disposeBag)
  }
  
  func showAlert() {
      let alert = UIAlertController(
          title: "RxExample",
          message: "This is wonderful",
          preferredStyle: .alert
      )
      let defaultAction = UIAlertAction(title: "Ok",
                                        style: .default,
                                        handler: nil)
      alert.addAction(defaultAction)
      present(alert, animated: true, completion: nil)
  }
}
