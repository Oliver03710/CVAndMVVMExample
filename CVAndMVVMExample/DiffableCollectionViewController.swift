//
//  DiffableCollectionViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/19.
//

import UIKit

import Kingfisher

final class DiffableCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Int: Section 정보, String: Data 정보
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    private let viewModel = DiffableViewModel()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        configureDataSource()
        bindData()
    }
    
    private func setCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
    }
    
    private func setSearchBar() {
        searchBar.delegate = self
    }
    
    private func bindData() {
        viewModel.photoList.bind { photo in
            // Initial
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo.results)
            self.dataSource.apply(snapshot)
        }
    }
    
    
    // MARK: - Helper Functions
    
}


// MARK: - Extension: UICollectionViewDelegate

extension DiffableCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//        let alert = UIAlertController(title: item, message: "클릭!", preferredStyle: .alert)
//
//        let confirm = UIAlertAction(title: "확인", style: .default)
//        alert.addAction(confirm)
//        present(alert, animated: true)
    }
}


// MARK: - Extension: Compositional Layout

extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            // String -> URL -> Data -> Image
            DispatchQueue.global().async {
                guard let url = URL(string: itemIdentifier.urls.thumb) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data)
                    cell.contentConfiguration = content
                }
            }
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .brown
            cell.backgroundConfiguration = background
        })
        
        // collectionView.dataSource = self 대체
        // numberOfItemsInSection, CellForItemAt 대체
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
}


// MARK: - Extension: UISearchBarDelegate

extension DiffableCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.requestSearchPhoto(query: text)
    }
}
