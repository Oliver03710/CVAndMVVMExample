//
//  SubjectViewModel.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/25.
//

import Foundation

import RxCocoa
import RxSwift

struct Contact {
    var name: String
    var age: Int
    var number: String
}

final class SubjectViewModel {
    
    // MARK: - Properties
    
    var contactData = [
    Contact(name: "Jack", age: 21, number: "01012344321"),
    Contact(name: "Metaverse Jack", age: 23, number: "01012341234"),
    Contact(name: "Real Jack", age: 25, number: "01012345678")
    ]
    
//    var list = PublishSubject<[Contact]>()
    var list = PublishRelay<[Contact]>()
    
    
    // MARK: - Helper Functions
    
    
    func fetchData() {
//        list.onNext(contactData)
        list.accept(contactData)
    }
    
    func resetData() {
//        list.onNext([])
        list.accept([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "")
        contactData.append(new)
//        list.onNext(contactData)
        list.accept(contactData)
    }
    
    func filterData(query: String) {
        let result = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
//        list.onNext(result)
        list.accept(result)
    }
     
}
