//
//  NewsViewModel.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/20.
//

import Foundation

import RxCocoa
import RxSwift

class NewsViewModel {
    
    // MARK: - Properties
    
//    var pageNumber: CObservable<String> = CObservable("3000")
//    var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
//    var list = PublishSubject<[News.NewsItem]>()
    var rxNumber = BehaviorSubject(value: "3,000")
    var list = BehaviorRelay(value: News.items)
    
    // MARK: - Helper Functions
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
//        pageNumber.value = result
        rxNumber.onNext(result)
    }
    
    func resetSample() {
//        sample.value = []
//        list.onNext([])
        list.accept([])
    }
    
    func loadSample() {
//        sample.value = News.items
//        list.onNext(News.items)
        list.accept(News.items)
    }
}
