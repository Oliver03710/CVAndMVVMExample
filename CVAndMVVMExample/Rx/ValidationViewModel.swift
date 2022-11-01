//
//  ValidationViewModel.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/27.
//

import Foundation

import RxCocoa
import RxSwift

final class ValidationViewModel {
    
    // MARK: - Properties
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요")
    
    
    // MARK: - In & Out Data
    
    struct Input {
        let text: ControlProperty<String?>  // nameTextField.rx.text
        let tap: ControlEvent<Void>         // stepButton.rx.tap
    }
    
    struct Output {
        let validation: Observable<Bool>
        let tap: ControlEvent<Void>
        let text: Driver<String>
    }
    
    
    // MARK: - Helper Functions
    
    func transform(input: Input) -> Output {
        let valid = input.text
            .orEmpty
            .map { $0.count >= 8 }
            .share()
        
        let text = validText.asDriver()
        
        return Output(validation: valid, tap: input.tap, text: text)
    }
    
}
