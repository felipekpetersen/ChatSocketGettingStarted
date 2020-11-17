//
//  ChatSingleton.swift
//  ChatSocketGettingStarted
//
//  Copyright © 2020 Felipe Petersen. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    var users = [[String : AnyObject]]()
    var myNick = ""
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: "http://192.168.15.4:3000")!, config: [.log(true), .compress])
    lazy var socket:SocketIOClient = manager.defaultSocket
    
    
    func establishConnection() {
        socket.connect()
    }
    
    func connectToServerWithNickname(nickname: String, success: @escaping ()->() ) {
        socket.emit("connectUser", nickname)
        self.myNick = nickname
        socket.on("userList") { ( dataArray, ack) -> Void in
            self.users = dataArray[0] as! [[String : AnyObject]]
            success()
        }
    }
    
    func sendMessage(message: String) {
        socket.emit("chatMessage", myNick, message)
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
          socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
              var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as AnyObject
              messageDictionary["message"] = dataArray[1] as AnyObject
              messageDictionary["date"] = dataArray[2] as AnyObject
            completionHandler(messageDictionary)
          }
      }
    
    func closeConnection() {
        socket.disconnect()
    }
}
