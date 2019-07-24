//
//  SocketIOManager.swift
//  SessionSharing
//
//  Created by Noel Achkar on 7/24/19.
//  Copyright © 2019 Noel Achkar. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    let socketManager = SocketManager(socketURL: URL(string: "\(SocketServer):\(SocketPort)")!, config: [.log(false), .compress, .reconnectAttempts(10)])
    
    var socket: SocketIOClient!
    var sid : String?
    
    override init() {
        super.init()
        
        socket = socketManager.socket(forNamespace: "/")
        socket?.onAny {print("Got event: \($0.event), with items: \($0.items!)")}
    }
    
    //Connection
    func socketConnectedHandler(completionHandler: @escaping () -> Void) {
        socket.on(clientEvent: .connect) { (data, ack) in
            if self.sid?.isStringNull() == false {
                self.socket.emit("requestLogin")
            } else {
                completionHandler()
            }
        }
    }
    
    func socketDisconnectedHandler(completionHandler: @escaping () -> Void) {
        socket.on(clientEvent: .error) { (data, ack) in
            completionHandler()
        }
    }
    
    func requestLoginHandler(completionHandler: @escaping (_ response: [String : Any]) -> Void) {
        socket.on("requestLogin") { data, ack in
            if let response = data[0] as? [String:String] {
                completionHandler(response)
            }
        }
    }
    
    func requestSessionHandler(completionHandler: @escaping (_ response: String) -> Void) {
        socket.on("requestSession") { [weak self] data, ack in
            if let response = data[0] as? [String:String] {

                if let sessionToken = response["sessionToken"] {
                    self!.sid = sessionToken
                    self!.socketManager.config = [.log(false), .compress, .reconnectAttempts(10),.extraHeaders(["sid":sessionToken])]
                    self!.socketManager.reconnect()
                } else if let error = response["error"] {
                    completionHandler(error)
                }
            }
        }
    }
    
    func emitRequestSession(token: String) {
        socket.emit("requestSession", ["token": token.encodeBase64()])
    }
    
    func establishConnection() {
        socket?.connect()
    }
}
