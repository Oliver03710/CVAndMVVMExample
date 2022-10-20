//
//  SimpleCollectionViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

struct User: Hashable {
    let id = UUID().uuidString  // asdfg-1234-adsf3-asg4 등의 형태
    let name: String    // Hashable
    let age: Int    // Hashable
}

class SimpleCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
//    var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    var list = [
        User(name: "뽀로로", age: 10),
        User(name: "뽀로로", age: 10),
        User(name: "둘리", age: 25),
        User(name: "사탕", age: 33),
        User(name: "고길동", age: 40)
    ]
    
    // cellForItemAt 전에 생성되야 함. -> Register 코드와 유사
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
       
        collectionView.collectionViewLayout = createLayout()
        
        // 1. Identifier, 2. Struct
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
//            cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .systemBlue
            
            content.secondaryText = "\(itemIdentifier.age)"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
            
            content.image = indexPath.item < 3 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.imageProperties.tintColor = .black
            
            print("setup")
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            
            backgroundConfig.backgroundColor = .lightGray
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .systemPink
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
    }
    
    
    // MARK: - Helper Functions
    
    
    
    // MARK: - CollectionView Functions
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return list.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let item = list[indexPath.item]
//
//        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
//
//        return cell
//    }
    
}


// MARK: - Extension: Compositional Layout

extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용가능 (List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemBrown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
