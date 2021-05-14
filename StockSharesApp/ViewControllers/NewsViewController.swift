//
//  NewsViewController.swift
//  StockSharesApp
//
//  Created by Maximus on 13.05.2021.
//

import UIKit



class NewsViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, News>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, News>
    var collectionView: UICollectionView!
    private lazy var dataSource = makeDataSource()
    
    var news: [News] = []
    var  roundedRect: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        self.navigationItem.title = "NEWS"
        collectionView  = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: layout)
        self.collectionView.delegate = self
        createDummyData()
        view.addSubview(collectionView)
        configureCollectionView()
        applySnapshot()
        
    }
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsViewCell")
        
        let guide = self.view.safeAreaLayoutGuide
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func applySnapshot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(news)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, news) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath) as? NewsViewCell
            cell?.model = news
            return cell
        }
        return dataSource
    }
    
    func createDummyData() {
        var count = 0
        for i in 0..<30 {
            count += 1
            news.append(News(
                            newsDescription: "fdsfasdeqweqweqweqweqwewqegdfgdfgl;lasjkdkajsdkajsldjaslkdjaslkdjlaksjdlkasjdlok",
                            link: "apple.com", pubDate: "30.05.23",
                            title: "Fasting news\(count)"))
        }
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 200)
    }
}
