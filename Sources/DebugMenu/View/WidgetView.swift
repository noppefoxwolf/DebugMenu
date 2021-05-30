//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import UIKit
import Combine

class WidgetView: UIVisualEffectView {
    private let tableView: UITableView = .init(frame: .null, style: .plain)
    private var cancellables: Set<AnyCancellable> = []
    private let complications: [ComplicationPresentable]
    
    init(complications: [ComplicationPresentable]) {
        self.complications = complications
        super.init(effect: UIBlurEffect(style: .systemMaterialDark))
        frame = .init(origin: .zero, size: .init(width: 200, height: 200))
        
        let stackView = UIStackView(arrangedSubviews: [tableView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(Value1TableViewCell.self)
        tableView.register(GraphTableViewCell.self)
        tableView.register(IntervalTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        isHidden = false
        complications.forEach({ $0.startMonitoring() })
        Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink { [weak self] _ in
            self?.reloadData()
        }.store(in: &cancellables)
    }
    
    func hide() {
        isHidden = true
        complications.forEach({ $0.stopMonitoring() })
        cancellables = []
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
}

extension WidgetView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        complications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let complication = complications[indexPath.row]
        switch complication.fetcher {
        case let .text(fetcher):
            let cell = tableView.dequeue(Value1TableViewCell.self, for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = complication.title
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.text = fetcher()
            cell.detailTextLabel?.textColor = .lightGray
            cell.detailTextLabel?.numberOfLines = 0
            return cell
        case let .graph(fetcher):
            let cell = tableView.dequeue(GraphTableViewCell.self, for: indexPath)
            cell.textLabel?.text = complication.title
            cell.setData(fetcher())
            return cell
        case let .interval(fetcher):
            let cell = tableView.dequeue(IntervalTableViewCell.self, for: indexPath)
            cell.textLabel?.text = complication.title
            cell.setDurations(fetcher())
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
    }
}
