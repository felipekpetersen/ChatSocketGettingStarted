//
//  VisualizeViewController.swift
//  ChatSocketGettingStarted
//
//  Created by Leonardo Oliveira on 17/11/20.
//  Copyright © 2020 Felipe Petersen. All rights reserved.
//

import UIKit
import PDFKit

class VisualizeViewController: UIViewController {
    
    var fileName: String = "Ola"
    var fileData: Data?
    
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    private lazy var pdfView: PDFView = {
        let pdfView = PDFView()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
    
    private lazy var constraints: [NSLayoutConstraint] = [
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = fileName
        
        guard let data = fileData else {
            return
        }
        
        let fileType = fileName.components(separatedBy: ".")[1]
        
        if fileType.lowercased() == "txt" {
            textLabel.text = String(data: data, encoding: .utf8)
            imageView.isHidden = true
            
        } else if fileType.lowercased() == "pdf" {
            if let document = PDFDocument(data: data) {
                pdfView.document = document
            }
            
            view.addSubview(pdfView)
            NSLayoutConstraint.activate(constraints)
            
            textLabel.isHidden = true
            imageView.isHidden = true
            
        } else {
            imageView.image = UIImage(data: data)
            textLabel.isHidden = true
        }
        
    }
}
