//
//  TrendingViewModel.swift
//  GithubRepos
//
//  Created by Noel Achkar on 7/24/19.
//  Copyright © 2019 Noel Achkar. All rights reserved.
//

import Foundation

class MainViewModel {
    
    init() {
        weak var weakself = self
        SocketIOManager.sharedInstance.socketConnectedHandler {
            weakself?.connected = true
        }
        
        SocketIOManager.sharedInstance.socketDisconnectedHandler {
            weakself?.connected = false
        }
        
        SocketIOManager.sharedInstance.requestSessionHandler { (result) in
            weakself?.error = result
        }
        
        SocketIOManager.sharedInstance.requestLoginHandler { (result) in
            weakself?.loginData = result
        }
    }
    
    func emitLogin(password: String) {
        SocketIOManager.sharedInstance.emitRequestSession(token: password)
    }
    
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var error: String? {
        didSet { self.showAlert?() }
    }
    
    var connected: Bool = false {
        didSet { self.socketDidConnect?() }
    }
    
    var loginData: [String : Any] = [:] {
        didSet { self.didFinishLogin?() }
    }
    
    var socketDidConnect: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var showAlert: (() -> ())?
    var didFinishLogin: (() -> ())?
}
