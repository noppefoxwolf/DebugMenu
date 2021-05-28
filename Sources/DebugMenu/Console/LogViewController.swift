//
//  LogViewController.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2021/02/26.
//

import UIKit

class LogViewController: UIViewController {
    let textView: UITextView = .init()
    let inputStream: InputStream
    var data: Data = Data()
    
    init(url: URL) {
        inputStream = InputStream(fileAtPath: url.path)!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .bold)
        
        inputStream.delegate = self
        inputStream.schedule(in: .current, forMode: .default)
        inputStream.open()
        
        let rightBarButtonAction: UIAction = .init { [weak self] _ in
            self?.presentActivity()
        }
        let rightBarButtonItem = UIBarButtonItem(systemItem: .action, primaryAction: rightBarButtonAction, menu: nil)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    deinit {
        inputStream.close()
    }
    
    private func reloadData() {
        textView.text = String(data: data, encoding: .utf8)
    }
    
    private func presentActivity() {
        let item: Any = String(data: data, encoding: .utf8) as Any
        let vc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
}

extension LogViewController: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            break
        case .hasBytesAvailable:
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            defer {
                buffer.deallocate()
            }
            while inputStream.hasBytesAvailable {
                let read = inputStream.read(buffer, maxLength: bufferSize)
                if read < 0 {
                    //Stream error occured
//                    throw inputStream.streamError!
                    break
                } else if read == 0 {
                    //EOF
                    break
                }
                data.append(buffer, count: read)
            }
        case .hasSpaceAvailable:
            break
        case .errorOccurred:
            break
        case .endEncountered:
            break
        default:
            break
        }
        reloadData()
    }
}
