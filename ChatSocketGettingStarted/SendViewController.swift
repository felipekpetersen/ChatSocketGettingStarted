//
//  SendViewController.swift
//  ChatSocketGettingStarted
//
//  Copyright © 2020 Felipe Petersen. All rights reserved.
//

import UIKit
import MobileCoreServices

class SendViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var fileStackView: UIStackView!
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var data: Data?
    var fileName: String = ""
    
//    var chatMessages = [[String: AnyObject]]()
    
    private lazy var documentPicker: UIDocumentPickerViewController = {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),
                                                                            String(kUTTypeContent)
                                                                            ,String(kUTTypeItem),
                                                                            String(kUTTypeData)], 
                                                            in: .open)
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = self
        return documentPicker
    }()
    
    // MARK:- Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 10.0
        
        sendButton.isHidden = true
        fileStackView.isHidden = true
        
        self.present(documentPicker, animated: true, completion: nil)
        
//        self.setupUsersOnline()
//        self.setupTableView()
//        self.messageTextField.delegate = self
//         
        
    }
    
    // MARK:- Functions
    
    func setupUsersOnline() {
        var usersString = ""
        let users = SocketIOManager.sharedInstance.users
        for user in users {
            if let name = user["nickname"] {
                usersString.append("\(name), ")
            }
        }
//        self.usersOnlineLabel.text = usersString
    }
    
    func getChat() {
//        self.chatMessages.removeAll()
        SocketIOManager.sharedInstance.getChatMessage { (messages) in
            DispatchQueue.main.async {
//                self.chatMessages.append(messages)
//                self.messagesTableView.reloadData()
//                self.messagesTableView.scrollsToTop = false
            }

        }
    }
    
    // MARK:- IBAction Functions
    
    @IBAction func didTapSendButton(_ sender: Any) {
        
        if let data = self.data {
            SocketIOManager.sharedInstance.sendFile(fileData: data, type: fileName)
        }
        
        let alert = UIAlertController(title: "Arquivo enviado!", 
                                           message: "Operação realizada com sucesso.", 
                                           preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension SendViewController: UIDocumentPickerDelegate {
    
    // MARK:- UIDocumentPickerDelegate Functions
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let fileURL = urls.first else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            self.data = data
            
            let fileName = String(describing: fileURL.lastPathComponent)
            self.fileName = fileName
            
            let fileType = self.fileName.components(separatedBy: ".")[1].lowercased()
            
            if fileType == "txt" {
                fileImageView.image = UIImage(systemName: "doc.plaintext")
            } else if fileType == "pdf" {
                fileImageView.image = UIImage(systemName: "doc")
            } else {
                fileImageView.image = UIImage(data: data)
            }
            
            fileNameLabel.text = fileName
            sendButton.isHidden = false
            fileStackView.isHidden = false
        
        } catch {
            
            let errorAlert = UIAlertController(title: "Erro", 
                                               message: "Ocorreu um erro ao carregar o arquivo. Por favor, tente novamente.", 
                                               preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            errorAlert.addAction(action)
            
            present(errorAlert, animated: true, completion: nil)
            
            print(error.localizedDescription)
        }
    }
}
