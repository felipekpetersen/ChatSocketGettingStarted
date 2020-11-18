//
//  MainViewController.swift
//  ChatSocketGettingStarted
//
//  Created by Leonardo Oliveira on 17/11/20.
//  Copyright © 2020 Felipe Petersen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController{
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var openFileButton: UIButton!
    
    var nickname: String = "Ola"
    var fileName: String = "Ola"
    var fileData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openFileButton.isHidden = true
        openFileButton.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recieveFile()
    }
    
    func recieveFile() {
        SocketIOManager.sharedInstance.getFile { (data) in
            
            if let fileData = data["file"] as? Data {
                self.fileData = fileData
            }
            
            if let nickname = data["nickname"] as? String {
//                if nickname == SocketIOManager.sharedInstance.myNick {
//                    return
//                }
                self.nickname = nickname
            }
            
            if let fileName = data["type"] as? String {
                self.fileName = fileName
            }
            
            
            let fileType = self.fileName.components(separatedBy: ".")[1]
            
            self.label.text = "Novo arquivo!\nArquivo .\(fileType) enviado por \(self.nickname)."
            self.imageView.image = UIImage(systemName: "square.and.arrow.down")
            self.openFileButton.isHidden = false
        }
    }
    
    @IBAction func openFile(_ sender: Any) {
        performSegue(withIdentifier: "openSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openSegue",
           let destination = segue.destination as? VisualizeViewController {
            destination.fileName = fileName
            destination.fileData = fileData
        }
    }
    
}
