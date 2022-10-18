//
//  SimpleCollectionViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

class User {
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class SimpleCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
//    var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    var list = [
        User(name: "뽀로로", age: 10),
        User(name: "홍길동", age: 15),
        User(name: "둘리", age: 25),
        User(name: "사탕", age: 33),
        User(name: "고길동", age: 40)
    ]
    
    
    
    // cellForItemAt 전에 생성되야 함. -> Register 코드와 유사
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용가능 (List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemBrown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
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
            
            cell.contentConfiguration = content
            
            
        }
    }
    
    
    // MARK: - Helper Functions
    
    
    
    // MARK: - CollectionView Functions
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = list[indexPath.item]
        
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        return cell
    }
    
}
