//
//  ChatViewController.swift
//  ChatSocketGettingStarted
//
//  Copyright © 2020 Felipe Petersen. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var usersOnlineLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var botConst: NSLayoutConstraint!
    
    var chatMessages = [[String: AnyObject]]()
    let MESSAGE_CELL = "MessageTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUsersOnline()
        self.setupTableView()
        self.messageTextField.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        getChat() 
        
    }
    
  
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.botConst.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.botConst.constant = 0
    }
    
    func setupUsersOnline() {
        var usersString = ""
        let users = SocketIOManager.sharedInstance.users
        for user in users {
            if let name = user["nickname"] {
                usersString.append("\(name), ")
            }
        }
        self.usersOnlineLabel.text = usersString
    }
    
    func getChat() {
//        self.chatMessages.removeAll()
        SocketIOManager.sharedInstance.getChatMessage { (messages) in
            DispatchQueue.main.async {
                self.chatMessages.append(messages)
                self.messagesTableView.reloadData()
                self.messagesTableView.scrollsToTop = false
            }

        }
    }
    
    func setupTableView() {
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.register(UINib(nibName: MESSAGE_CELL, bundle: nil), forCellReuseIdentifier: MESSAGE_CELL)
    }
    
    
    @IBAction func didTapSendButton(_ sender: Any) {
        if let message = self.messageTextField.text, message.isEmpty == false {
            SocketIOManager.sharedInstance.sendMessage(message: message)
            //            DispatchQueue.main.async {
            self.messageTextField.text = ""
            self.messageTextField.resignFirstResponder()
            //                self.messagesTableView.reloadData()
//            self.getChat()
            //            }
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MESSAGE_CELL, for: indexPath) as! MessageTableViewCell
        cell.setup(name: self.chatMessages[indexPath.row]["nickname"] as! String, message: chatMessages[indexPath.row]["message"] as! String)
        return cell
        
    }
}

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
