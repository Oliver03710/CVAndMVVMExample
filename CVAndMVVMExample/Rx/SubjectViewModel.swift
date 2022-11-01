//
//  SubjectViewModel.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/25.
//

import Foundation

import RxCocoa
import RxSwift

protocol CommomViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

struct Contact {
    var name: String
    var age: Int
    var number: String
}

final class SubjectViewModel: CommomViewModel {
    
    // MARK: - Properties
    
    var contactData = [
    Contact(name: "Jack", age: 21, number: "01012344321"),
    Contact(name: "Metaverse Jack", age: 23, number: "01012341234"),
    Contact(name: "Real Jack", age: 25, number: "01012345678")
    ]
    
//    var list = PublishSubject<[Contact]>()
    var list = PublishRelay<[Contact]>()
    
    
    // MARK: - In & Out Data
    
    struct Input {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let list: Driver<[Contact]>
        let searchText: Observable<String>
    }
    
    
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
    
    func transform(input: Input) -> Output {
        
        let list = list.asDriver(onErrorJustReturn: [])
        
        let text = input.searchText
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        return Output(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: text)
    }
    
     
}
