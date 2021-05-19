//
//  SearchViewController.swift
//  StockSharesApp
//
//  Created by Maximus on 29.03.2021.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate {
    
    var dymmyData: [String] = ["Nokia", "Microsoft", "Apple", "Bank of America", "Yandex", "Bank of Uruganda", "UFO", "Nokia", "Microsoft", "Apple", "Bank of America", "Yandex", "Bank of Uruganda", "UFO"]
    
    var collectionViewLayout: UICollectionViewFlowLayout!
    var collectionView : UICollectionView!
    var tableView = UITableView()
    var filteredItems = [Model]()
    var sharesListController: SharesListViewController = SharesListViewController()
  
    func configureTableView() {
        view.addSubview(tableView)
        let guide = view.safeAreaLayoutGuide
        tableView.backgroundColor = .white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: "\(StockTableViewCell.self)")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120.0
        tableView.allowsSelection = false
    }
    
    var showSuggestingSearch: Bool = false {
        didSet {
            if oldValue != showSuggestingSearch {
                print("WTF: \(showSuggestingSearch)")
                tableView.reloadData()
                if showSuggestingSearch {
                    collectionView.alpha = 1
                } else {
                    collectionView.alpha = 0
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTableView()
        configureView()
    }
    
    func configureView() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionView =  UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width / 3, height: view.frame.size.width / 3)
        collectionViewLayout.scrollDirection = .vertical
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchSuggestionCell.self, forCellWithReuseIdentifier: "SearchSuggestionCell")
        collectionView.register(PopularRequestHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "\(PopularRequestHeaderView.self)")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StockTableViewCell.self)", for: indexPath) as? StockTableViewCell
        let items = filteredItems[indexPath.row]
        cell?.configure(with: items)
        return cell!
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 1 ? dymmyData.count : dymmyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchSuggestionCell", for: indexPath) as! SearchSuggestionCell
        if showSuggestingSearch {
            let item = dymmyData[indexPath.row]
            cell.label.adjustsFontSizeToFitWidth = true
            cell.label.text = item
            print("SHOW")
        } else {
            tableView.alpha = 1
            collectionView.removeFromSuperview()
            return cell
        }
        return cell
    }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(PopularRequestHeaderView.self)", for: indexPath) as? PopularRequestHeaderView else {
                    fatalError("Invalid view type")
                }
                if indexPath.section == 0 {
                    headerView.label.text = "Popular requests"
                } else {
                    headerView.label.text = "You’ve searched for this"
                }
                
                return headerView
            default:
                assert(false, "InvalidElementType")
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: view.frame.size.width, height: 40)
        }
}
    

    
    
    extension SearchViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return CGFloat(10.0)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size: CGSize = dymmyData[indexPath.row].size(withAttributes: [.font: UIFont.systemFont(ofSize: 14.0)])
            return CGSize(width: size.width + 16, height: 40)
        }
    }



