//
//  SubjectViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/25.
//

import UIKit

import RxCocoa
import RxSwift

class SubjectViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var newButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let publish = PublishSubject<Int>()     // 초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100)      // 초기값 필수
    // bufferSize 작성된 이벤트 갯수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한 번에 이벤트를 전달
    let replay = ReplaySubject<Int>.create(bufferSize: 3)
    let async = AsyncSubject<Int>()
    
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewModel.list
//            .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
//                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
//            }
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.viewModel.fetchData()
            })
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.viewModel.resetData()
            })
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.viewModel.newData()
            })
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [unowned self] value in
                self.viewModel.filterData(query: value)
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Helper Functions
    
    func usingSubjects() {
        /*
         viewModel.list
             .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                 cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
             }
             .disposed(by: disposeBag)
         
        addButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()     // 같은 값을 받지 않음
            .withUnretained(self)
            .subscribe { (vc, value) in
                print("========\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
         */
    }
}


// MARK: - Extension: Subject Properties

extension SubjectViewController {
    
    func publishSubject() {
        
        // 초기값이 없는 빈 상태, subscribe 전/error/completed notification 이후 이벤트 무시
        // subscribe 후에 대한 이벤트는 모두 처리
        publish.onNext(1)
        publish.onNext(2)
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(5))
        publish.onCompleted()
        
        publish.onNext(6)
        publish.onNext(7)
    }
    
    func behaviorSubject() {
        
        // 구독 전에 가장 최근 값을 같이 emit
        behavior.onNext(1)
        behavior.onNext(2)
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5))
        behavior.onCompleted()
        
        behavior.onNext(6)
        behavior.onNext(7)
    }
    
    func replaySubject() {
        
        // if bufferSize 1,000개 -> 어디서 보관? -> 메모리
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposeBag)
        
        replay.onNext(3)
        replay.onNext(4)
        replay.on(.next(5))
        replay.onCompleted()
        
        replay.onNext(6)
        replay.onNext(7)
    }
    
    func asyncSubject() {
        
        `async`.onNext(100)
        `async`.onNext(200)
        `async`.onNext(300)
        `async`.onNext(400)
        `async`.onNext(500)
        
        `async`
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async completed")
            } onDisposed: {
                print("async disposed")
            }
            .disposed(by: disposeBag)
        
        `async`.onNext(3)
        `async`.onNext(4)
        `async`.on(.next(5))
        `async`.onNext(6)
//        async.onCompleted()
        `async`.onNext(7)
    }
}
