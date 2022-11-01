//
//  SubscribeViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/26.
//

import UIKit

import RxAlamofire
import RxCocoa
import RxDataSources
import RxSwift

class SubscribeViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>> { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
    }
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRxAlamofire()
        testRxDataSource()
        
        Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
            .skip(3)
            .filter { $0 % 2 == 0 }
//            .debug()
            .map { $0 * 2 }
            .subscribe { value in
//                print("\(value)")
            }
            .disposed(by: disposeBag)

        
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
            // .debug()    // Print 해주는 명령어 -> 출시 후 그리 필요하지 않은 부분
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
    
    
    // MARK: - Helper Functions
    
    func testRxAlamofire() {
        // Success, Error -> <Single>
        let url = APIKeys.searchURL + "apple"
        request(.get, url, headers: ["Authorization": APIKeys.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe(onNext: { value in
                print(value.results[0].likes)
            })
            .disposed(by: disposeBag)
    }
    
    func testRxDataSource() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "title1", items: [1, 2, 3]),
            SectionModel(model: "title2", items: [1, 2, 3]),
            SectionModel(model: "title3", items: [1, 2, 3])
        ])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
