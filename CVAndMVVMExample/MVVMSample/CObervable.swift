//
//  CObervable.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/20.
//

import Foundation

import Foundation

final class CObservable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
//            print("\(oldValue) Changed")
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
//        print(#function)
        closure(value)
        listener = closure
    }
    
}
