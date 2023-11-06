//
//  NicknameViewModel.swift
//  RxSwiftPractice
//
//  Created by walkerhilla on 11/6/23.
//

import Foundation
import RxSwift
import RxCocoa

// NicknameViewModel의 기능
// 사용자가 입력한 nickname의 유효성을 검사하여 그 결과를 UI에 표시
// 유효성 결과 값을 지니는 nicknameValid과 사용자가 입력한 데이터를 저장하는 nickname으로 옵저버블 구성
class NicknameViewModel {
  let nickname = BehaviorSubject(value: "")
  let nicknameValid = BehaviorSubject(value: false)
  let disposeBag = DisposeBag()
  
  init() {
    // drive와 subscribe의 차이
    // drive는 항상 메인 스레드에서의 동작을 보장함
    // 따라서 UI 관련 작업에 주로 사용됨.
    nickname
    // nickname의 길이에 따라 유효성 검증 후 nicknameValid에 바인딩
      .map { $0.count < 2 || $0.count >= 6 }
      .bind(to: nicknameValid)
      .disposed(by: disposeBag)
  }
}
