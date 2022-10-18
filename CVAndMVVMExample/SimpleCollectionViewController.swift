//
//  SimpleCollectionViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

class SimpleCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    // cellForItemAt 전에 생성되야 함. -> Register 코드와 유사
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용가능 (List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration()
            
            content.text = itemIdentifier
            content.image = UIImage(systemName: "person.fill")
            
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
