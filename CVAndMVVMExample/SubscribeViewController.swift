//
//  SubscribeViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/26.
//

import UIKit

import RxCocoa
import RxSwift

class SubscribeViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 첫번째 방법
        button.rx.tap
            .subscribe { [unowned self] _ in
                self.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 두번째 방법
        button.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 세번째 방법: 네트워크 통신이나 파일 다운로드 등 백그라운드 작업?
        button.rx.tap
            .observe(on: MainScheduler.instance)    // 다른쓰레드로 동작하게 변경
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 네번째 방법: bind - subscribe, mainScheduler, error x
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 다섯번째 방법: operator로 데이터의 stream 조작
        button.rx.tap
            .map { "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // 여섯번째 방법: driver traits - bind + stream 공유(리소스 낭비 방지, share())
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }
}
