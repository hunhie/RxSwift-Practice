//
//  BirthdayViewModel.swift
//  RxSwiftPractice
//
//  Created by walkerhilla on 11/6/23.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
  let isAdult = BehaviorSubject(value: false)
  
  let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
  
  let year = BehaviorSubject(value: 2020)
  let month = BehaviorSubject(value: 12)
  let day = BehaviorSubject(value: 22)
  
  let disposeBag = DisposeBag()
  
  init() {
    birthday
      .subscribe(with: self) { owner, date in
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        owner.year.onNext(component.year!)
        owner.month.onNext(component.month!)
        owner.day.onNext(component.day!)
        
      } onDisposed: { owner in
        print("disposed")
      }
      .disposed(by: disposeBag)
    
    birthday
      .map { $0.isAdult() }
      .bind(to: isAdult)
      .disposed(by: disposeBag)
  }
}
