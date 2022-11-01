//
//  ValidationViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/27.
//

import UIKit

import RxCocoa
import RxSwift

class ValidationViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        bind()
//        observableVSSubject()
    }
    
    func bind() {
        
        // After
        let input = ValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Before
//        viewModel.validText     // Output
//            .asDriver()
//            .drive(validationLabel.rx.text)
//            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: validationLabel.rx.isHidden, stepButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Before
//        let validation = nameTextField.rx.text      // Input
//            .orEmpty
//            .map { $0.count >= 8 }
//            .share()    // Subject, Relay
//
//        validation
//            .bind(to: validationLabel.rx.isHidden, stepButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        // Before
//        validation
//            .withUnretained(self)
//            .bind { (vc, value) in
//                let color: UIColor = value ? .systemPink : .lightGray
//                vc.stepButton.backgroundColor = color
//            }
//            .disposed(by: disposeBag)
        
        output.tap
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)
        
        // Stream == Sequence
//        stepButton.rx.tap
//            .subscribe { _ in
//                print("Next")
//            } onDisposed: {
//                print("Disposed")
//            }
//            .disposed(by: disposeBag)
            // dispose: 리소스 정리, deinit
        
    }
    
    // 옵저버블과 서브젝트의 차이점
    // 서브젝트는 옵저버이자 옵저버블 역할
    // 서브젝트는 스트림을 공유한다.
    func observableVSSubject() {
        
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
//            .share()
        
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(stepButton.rx.title())
            .disposed(by: disposeBag)
        
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt
            .subscribe { value in
                print("sampleInt: \(value)")
            }
            .disposed(by: disposeBag)
        
        sampleInt
            .subscribe { value in
                print("sampleInt: \(value)")
            }
            .disposed(by: disposeBag)
        
        sampleInt
            .subscribe { value in
                print("sampleInt: \(value)")
            }
            .disposed(by: disposeBag)
        
        // Stream을 공유한다 -> 같은 값이 나옴
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 0...100))
        
        subjectInt
            .subscribe { value in
                print("subjectInt: \(value)")
            }
            .disposed(by: disposeBag)
        
        subjectInt
            .subscribe { value in
                print("subjectInt: \(value)")
            }
            .disposed(by: disposeBag)
        
        subjectInt
            .subscribe { value in
                print("subjectInt: \(value)")
            }
            .disposed(by: disposeBag)
    }

}
