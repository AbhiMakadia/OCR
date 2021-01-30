//
//  OCRDetailCVCell.swift
//  OCR
//
//  Created by Abhi Makadiya on 30/01/21.
//

import UIKit

class OCRDetailCVCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imgOCR: UIImageView!
    @IBOutlet weak var tvOCRText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(_ obj: OCRModel) {
        imgOCR.image = obj.image
        tvOCRText.text = obj.txt
    }
    
}
