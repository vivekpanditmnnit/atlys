//
//  ViewController.swift
//  Atlys_pageview
//
//  Created by Coditas on 15/08/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private var collectionView: UICollectionView = {
        let layout = CollectionViewCustomFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    private let images: [String] = [Constants.image1,
                                    Constants.image2,
                                    Constants.image3,
                                    Constants.image1,
                                    Constants.image2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupCollectionView()
        setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollToFirstIndex()
    }
    
    private func registerCells() {
        collectionView.register(CollectionViewPageCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
    }
    
    private func scrollToFirstIndex() {
        DispatchQueue.main.async { [weak self] in
            let indexPath = IndexPath(item: Constants.defaultPage, section: 0)
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self?.pageControl.currentPage = Constants.defaultPage
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewPageCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, 
                                                constant: Constants.collectionViewTopConstraint),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                   multiplier: Constants.collectionViewHeightMultiplier)
        ])
        
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! CollectionViewPageCell
        cell.setData(with: images[indexPath.item])
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / layout.itemSize.width
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * layout.itemSize.width - scrollView.contentInset.left, y: 0)
        targetContentOffset.pointee = offset
        
        pageControl.currentPage = Int(roundedIndex)
    }
}

