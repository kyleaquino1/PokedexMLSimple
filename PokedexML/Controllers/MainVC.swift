//
//  MainVC.swift
//  PokedexML
//
//  Created by Kyle Aquino on 8/20/18.
//  Copyright © 2018 Kyle Aquino. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController {

    var imageView: UIImageView!
    var classificationBox: UIView!
    var classificationLabel: UILabel!
    var cameraController: CameraVC!
    var classifier: ClassificationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCamera()
        addImagePreview()
        addClassificationBox()
        addClassifier()
    }
    
    private func addClassifier() {
        classifier = ClassificationController(delegate: self)
    }
    
    private func addCamera() {
        // Instantiate cameraController
        cameraController = CameraVC()
        self.addChild(cameraController)
        cameraController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(cameraController.view)
        cameraController.didMove(toParent: self)
    }

    private func addImagePreview() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        imageView.backgroundColor = .gray
        imageView.layer.opacity = 1.0
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 72),
            imageView.heightAnchor.constraint(equalToConstant: 128)])
    }
    
    private func addClassificationBox() {
        classificationBox = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 128))
        classificationBox.backgroundColor = .gray
        self.view.addSubview(classificationBox)
        classificationBox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            classificationBox.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 0),
            classificationBox.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 0),
            classificationBox.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            classificationBox.heightAnchor.constraint(equalToConstant: 128)])
        addClassificationLabel()
    }
    
    private func addClassificationLabel() {
        classificationLabel = UILabel()
        classificationLabel.text = "Tap to take a picture of a Pokemon!"
        classificationBox.addSubview(classificationLabel)
        classificationLabel.translatesAutoresizingMaskIntoConstraints = false
        classificationLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            classificationLabel.leftAnchor.constraint(equalTo: classificationBox.leftAnchor),
            classificationLabel.topAnchor.constraint(equalTo: classificationBox.topAnchor),
            classificationLabel.bottomAnchor.constraint(equalTo: classificationBox.bottomAnchor),
            classificationLabel.rightAnchor.constraint(equalTo: classificationBox.rightAnchor),
            ])
    }
    
    func updateImage(image: UIImage) {
        self.imageView.image = image
        evaluateImage(image)
    }
    
    private func evaluateImage(_ image: UIImage) {
        // Uses model to classify image
        classifier.updateClassifications(for: image)
    }
    
}

extension MainVC: ClassificationControllerDelegate {
    func didFinishClassification(_ classification: (String, Float)) {
        if classification.1 > 0.60{
        print("Finished Classification \(classification.0) \(classification.1)")
        classificationLabel.text = "\(classification.0.capitalized) - Confidence: \(classification.1 * 100)%"
        } else {
            classificationLabel.text = "Could not recognize pokemon, try again."
        }
    }
}


extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
