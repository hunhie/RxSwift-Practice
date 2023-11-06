//
//  PickerViewController.swift
//  RxSwiftPractice
//
//  Created by walkerhilla on 11/6/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PickerViewController: ViewController {
  
  let pickerView1 = UIPickerView()
  let pickerView2 = UIPickerView()
  let pickerView3 = UIPickerView()
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    view.addSubview(pickerView1)
    view.addSubview(pickerView2)
    view.addSubview(pickerView3)
    
    pickerView1.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(100)
      make.leading.trailing.equalToSuperview()
    }
    
    pickerView2.snp.makeConstraints { make in
      make.top.equalTo(pickerView1.snp.bottom).offset(15)
      make.leading.trailing.equalToSuperview()
    }
    
    pickerView3.snp.makeConstraints { make in
      make.top.equalTo(pickerView2.snp.bottom).offset(15)
      make.leading.trailing.equalToSuperview()
    }
    
    
    // 옵저버블을 생성해서 PickerView의 itemTitle 속성에 bind.
    // bind를 이용해서 UI에 값을 전달하려면 UI객체는 rx로 매핑하여 사용해야함.
    Observable.just([1, 2, 3])
      .bind(to: pickerView1.rx.itemTitles) { _, item in
        return "\(item)"
      }
      .disposed(by: disposeBag)
    
    // UI의 이벤트 구독 역시 rx로 매핑하여 modelSelected 이벤트를 구독함, model이 선택되었을 때 type은 Int로 받겠다.
    // onNext 이벤트를 통해서 print
    pickerView1.rx.modelSelected(Int.self)
      .subscribe(onNext: { models in
        print("models selected 1: \(models)")
      })
      .disposed(by: disposeBag)
    
    
    // 이하 pickerView2,3의 매커니즘은 동일함.
    Observable.just([1, 2, 3])
      .bind(to: pickerView2.rx.itemAttributedTitles) { _, item in
        return NSAttributedString(string: "\(item)",
                                  attributes: [
                                    NSAttributedString.Key.foregroundColor: UIColor.cyan,
                                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                                  ])
      }
      .disposed(by: disposeBag)
    
    pickerView2.rx.modelSelected(Int.self)
      .subscribe(onNext: { models in
        print("models selected 2: \(models)")
      })
      .disposed(by: disposeBag)
    
    Observable.just([UIColor.red, UIColor.green, UIColor.blue])
      .bind(to: pickerView3.rx.items) { _, item, _ in
        let view = UIView()
        view.backgroundColor = item
        return view
      }
      .disposed(by: disposeBag)
    
    pickerView3.rx.modelSelected(UIColor.self)
      .subscribe(onNext: { models in
        print("models selected 3: \(models)")
      })
      .disposed(by: disposeBag)
  }
}
