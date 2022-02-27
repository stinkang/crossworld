//
//  SocketManager.swift
//  word_o_crossv2
//
//  Created by Austin Kang on 2/2/22.
//

import Foundation
import UIKit
import SwiftUI
import Starscream

struct SocketManager: UIViewControllerRepresentable {
    @EnvironmentObject var xWordViewModel: XWordViewModel
    func makeUIViewController(context: Context) -> SocketManagerViewController {
        return SocketManagerViewController(xWordViewModel: xWordViewModel)
    }

    func updateUIViewController(_ uiViewController: SocketManagerViewController, context: Context) {
        if (xWordViewModel.shouldSendMessage) {
            do {
                let typedTextData = MoveData(
                    text: xWordViewModel.typedText,
                    previousIndex: xWordViewModel.previousFocusedSquareIndex,
                    currentIndex: xWordViewModel.focusedSquareIndex,
                    acrossFocused: xWordViewModel.acrossFocused,
                    wasTappedOn: xWordViewModel.textState == .tappedOn,
                    wentBackToLobby: false
                )
                try uiViewController.sendMessage(typedTextData)
            } catch {
                print("Unexpected error: \(error).")
            }
            xWordViewModel.changeShouldSendMessage(to: false)
        }
    }
}

final class SocketManagerViewController: UIViewController {
    @ObservedObject var xWordViewModel: XWordViewModel
    private var isConnected = false
    let socket = WebSocket(request: URLRequest(url: URL(string: "http://192.168.86.199:8082")!))
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    init(xWordViewModel: XWordViewModel) {
        self.xWordViewModel = xWordViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.delegate = self
        socket.connect()
    }

    deinit {
        socket.disconnect(closeCode: 0)
        socket.delegate = nil
    }
}

extension SocketManagerViewController : WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            var typedTextData: MoveData
            do {
                try typedTextData = self.decoder.decode(MoveData.self, from: data)
                xWordViewModel.changeOtherPlayersMove(to: typedTextData)
            } catch {
                print("error decoding data")
            }
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            print(error);
            //handleError(error)
        }
    }

    public func sendMessage(_ data: MoveData) throws {
        var json: Data
        try json = self.encoder.encode(data)
        socket.write(data: json)
    }

//
//  public func websocketDidConnect(_ socket: Starscream.WebSocket) {
//
//  }
//
//  public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
//
//  }
//
//  public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
//
//  }
//
//  public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
//
//  }
}
//    private let closeButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .white
//        button.setTitle("Close", for: .normal)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let session = URLSession(
//            configuration: .default,
//            delegate: self,
//            delegateQueue: OperationQueue()
//        )
//        let url = URL(
//            string: "ws://localhost:8082")
//        let webSocket = session.webSocketTask(with: url!)
//        webSocket.resume()
//
//        closeButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
//        view.addSubview(closeButton)
//        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
//        closeButton.center = view.center
//    }
//
//    func ping() {
//        webSocket?.sendPing { error in
//            if let error = error {
//                print("Ping error: \(error)")
//            }
//        }
//    }
//
//    @objc func close() {
//        webSocket?.cancel(with: .goingAway, reason: "Demo ended".data(using: .utf8))
//    }
//
//    func send() {
//        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
//            self.send()
//            self.webSocket?.send(.string("send new message \(Int.random(in: 0...1000))"), completionHandler: { error in
//                if let error = error {
//                    print("Send error: \(error)")
//                }
//            })
//        }
//    }
//
//    func receive() {
//        webSocket?.receive(completionHandler: { [weak self] result in
//            switch result {
//            case .success(let message):
//                switch message {
//                case .data(let data):
//                    print("Got Data: \(data)")
//                case .string(let message):
//                    print("Got string: \(message)")
//                @unknown default:
//                    break
//                }
//            case .failure(let error):
//                print("Receive error: \(error)")
//            }
//
//            self?.receive()
//        })
//    }
//
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
//        print("Did connect to socket")
//        ping()
//        receive()
//        send()
//    }
//
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        print("Closed connection because")
//    }
//}
