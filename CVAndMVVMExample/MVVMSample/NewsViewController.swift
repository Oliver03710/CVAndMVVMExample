//
//  NewsViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/20.
//

import UIKit

import RxCocoa
import RxSwift

final class NewsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    let viewModel = NewsViewModel()
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    let disposeBag = DisposeBag()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        addTargets()
        bindData()
    }
    
    
    // MARK: - Selectors
    
    @objc func numberTextFieldChanged() {
        guard let text = numberTextField.text else { return }
        viewModel.changePageNumberFormat(text: text)
    }
    
//    @objc func resetButtonTapped() {
//        viewModel.resetSample()
//    }
//
//    @objc func loadButtonTapped() {
//        viewModel.loadSample()
//    }
    
    
    // MARK: - Helper Functions
    
    func addTargets() {
//        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetSample()
            }
            .disposed(by: disposeBag)
        
        loadButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.loadSample()
            }
            .disposed(by: disposeBag)
        
        numberTextField.rx.text
            .withUnretained(self)
            .subscribe { (vc, text) in
                vc.viewModel.changePageNumberFormat(text: text!)
            }
            .disposed(by: disposeBag)
    }
    
    func bindData() {
//        viewModel.pageNumber.bind { value in
//            print("bind == \(value)")
//            self.numberTextField.text = value
//        }
        
        viewModel.rxNumber.bind { [unowned self] value in
            self.numberTextField.text = value
        }
        .disposed(by: disposeBag)
        
        viewModel.list.bind { item in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
                
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
        .disposed(by: disposeBag)
    }
}


// MARK: - Collection View With Compositional Layout

extension NewsViewController {
    
    func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.body
            
            cell.contentConfiguration = content
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
}
