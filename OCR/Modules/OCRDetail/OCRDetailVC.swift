//
//  OCRDetailVC.swift
//  OCR
//
//  Created by Abhi Makadiya on 30/01/21.
//

import UIKit

class OCRDetailVC: UIViewController {

    // MARK: - Variables
    var arrOCR: [OCRModel] = []
    var coordinator: HomeCoordinator?
    
    // MARK: - Outlets
    @IBOutlet weak var cvOCR: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Functions
    func setupUI() {
        cvOCR.register(R.nib.ocrDetailCVCell)
    }
    
}

// MARK: - CollectionView Delegates
extension OCRDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOCR.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ocrDetailCVCell, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configCell(arrOCR[indexPath.row])
        return cell
    }
    
}

extension OCRDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
