//
//  RxCocoaExampleViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var nickname = Observable.just("Jack")
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Observable에 새로 데이터 할당 불가
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.nickname = "hello"
//        }
    }
    
    
    // MARK: - Helper Functions
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    func setPickerView() {
        let items = Observable.just([
               "영화",
               "애니메이션",
               "드라마",
               "기타"
           ])
        
        items
           .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
               return element
           }
           .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .bind(to: simpleLabel.rx.text)
//            .subscribe(onNext: { value in
//                print(value)
//            })
            .disposed(by: disposeBag)
    }
    
    func setSwitch() {
        Observable.of(false) // just or of
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        
        // ex. 텍1(Observable), 텍2(Observable) -> 레이블(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        /*
        signName                // UITextField
            .rx                 // Reactive
            .text               // String?
            .orEmpty            //String    // 데이터의 흐름 Stream
            .map { $0.count }   // Int
            .map { $0 < 4 }     // Bool
            .bind(to: signEmail.rx.isHidden)
            .disposed(by: disposeBag)
         */
        
        signName.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.showAlert()
            })
//            .subscribe { [unowned self] _ in
//                self.showAlert()
//            }
            .disposed(by: disposeBag)
        
    }
    
    func setOperator() {
        
        Observable.repeatElement("Jack")    // Infinite Observable Sequence
            .take(5)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        // disposeBag: 리소스 해제 관리
        // 1. 시퀀스 끝날 때 but bind
        // 2. class deinit 자동해제 (bind)
        // 3. dispose 직접 호출 -> dispose()는 구독하는 것 마다 별도 관리가 필요
        // 4. disposeBag을 새롭게 할당하거나 nil을 전달
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            intervalObservable.dispose()
//            self.disposeBag = DisposeBag()
//        }
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)

    }
    
    func showAlert() {
        let alert = UIAlertController(title: "하하하", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    // viewController가 deinit 되면, 알아서 disposed도 동작
    // 또는 DisposeBag() 객체를 새롭게 넣어주거나, nil 할당 -> 예외 케이스(rootVC에 interval 등이 있을 경우)
    deinit {
        print("Deinit")
    }
    
}
