//
//  HomeViewController.swift
//  OCR
//
//  Created by Abhi Makadiya on 30/01/21.
//

import UIKit
import VisionKit
import Vision

class HomeViewController: UIViewController {
    
    // MARK: - Variables & Declarations
    var coordinator: HomeCoordinator?
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var arrOcrImage: [OCRModel] = []
    var currentProcessingIndex = 0
    
    // MARK: - Outlets
    @IBOutlet weak var btnTapToOCR: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - IB Actions
    @IBAction func btnTapToocrAction(_ sender: UIButton) {
        guard VNDocumentCameraViewController.isSupported else {
            return
        }
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        self.present(documentCameraViewController, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    func setupUI() {
        btnTapToOCR.layer.cornerRadius = 6.0
        setupVisionrequest()
    }
    
    func setupVisionrequest() {
        textRecognitionRequest = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let weakSelf = self else {
                return
            }
            guard let results = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            var octText = ""
            for result in results {
                guard let topCandidate = result.topCandidates(1).first else {
                    return
                }
                octText += topCandidate.string
                octText += "\n"
            }
            if weakSelf.currentProcessingIndex <= weakSelf.arrOcrImage.count-1 {
                let currentIndex = weakSelf.arrOcrImage[weakSelf.currentProcessingIndex]
                currentIndex.txt = octText
                weakSelf.arrOcrImage[weakSelf.currentProcessingIndex] = currentIndex
                if weakSelf.currentProcessingIndex == weakSelf.arrOcrImage.count-1 {
                    //last index
                    DispatchQueue.main.async { [weak self] in
                        guard let weakSelf = self else {
                            return
                        }
                        weakSelf.coordinator?.goToOCRDetail(model: weakSelf.arrOcrImage)
                        weakSelf.restoreAll()
                    }
                }
            }
            weakSelf.arrOcrImage[weakSelf.currentProcessingIndex].txt = octText
            weakSelf.currentProcessingIndex += 1
        }
        
        textRecognitionRequest.progressHandler = { [weak self] (request, value, error) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.navigationItem.title = "\(weakSelf.currentProcessingIndex+1)/\(weakSelf.arrOcrImage.count)"
                weakSelf.progressView.setProgress(Float(value), animated: true)
            }
        }
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
    }
    
    func restoreAll() {
        arrOcrImage.removeAll()
        currentProcessingIndex = 0
        progressView.progress = 0.0
        navigationItem.title = ""
    }
    
    func processImage(_ image: UIImage) {
        let model = OCRModel()
        model.image = image
        arrOcrImage.append(model)
        recognizeTextInImage(image)
    }
    
    func recognizeTextInImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch let error {
                print(error)
            }
        }
    }
    
    func reDrawImage(_ image: UIImage) -> UIImage {
        guard let imageData = image.jpegData(compressionQuality: 1),
            let redrawImage = UIImage(data: imageData) else {
                return image
        }
        return redrawImage
    }
}

// MARK: - Document Camera Controller Delegates
extension HomeViewController: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        for pageIndex in 0...(scan.pageCount-1) {
            var image = scan.imageOfPage(at: pageIndex)
            image = reDrawImage(image)
            processImage(image)
        }
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true, completion: nil)
    }
}
