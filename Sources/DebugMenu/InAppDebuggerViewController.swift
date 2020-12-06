//
//  InAppDebuggerViewController.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit
import Combine

enum InAppDebugger {}

class InAppDebuggerViewController: InAppDebuggerViewControllerBase {
    let collectionView: UICollectionView
    let debuggerItems: [DebugMenuPresentable]
    var cancellables: Set<AnyCancellable> = []
    
    enum Section: Int, CaseIterable {
        case items
    }
    
    init(debuggerItems: [DebugMenuPresentable]) {
        self.debuggerItems = debuggerItems
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        super.loadView()
        
        navigationItem.title = Application.current.appName
        navigationItem.largeTitleDisplayMode = .always
        
        collection: do {
            collectionView.backgroundColor = .systemBackground
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
        
        navigation: do {
            let rightItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onTapRightBarButtonItem))
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InAppDebugger.ItemCollectionViewCell.self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
    @objc private func onTapRightBarButtonItem() {
        self.dismiss(animated: true)
    }
}

extension InAppDebuggerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { Section.allCases.count }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .items:
            return debuggerItems.count
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .items:
            let item = debuggerItems[indexPath.row]
            let cell = collectionView.dequeue(InAppDebugger.ItemCollectionViewCell.self, for: indexPath)
            cell.configure(item: item)
            return cell
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .items:
            let item = debuggerItems[indexPath.row]
            item.didSelectedDebuggerItem(self) { [weak self] (result) in
                switch result {
                case .success(let message) where message != nil:
                    self?.presentAlert(title: "Success", message: message)
                case .failure(let message) where message != nil:
                    self?.presentAlert(title: "Error", message: message)
                default:
                    break
                }
            }
        default:
            fatalError()
        }
    }
    
    private func presentAlert(title: String, message: String?) {
        DispatchQueue.main.async { [weak self] in
            let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            vc.addAction(.init(title: "OK", style: .cancel, handler: nil))
            self?.present(vc, animated: true, completion: nil)
        }
    }
}

extension InAppDebugger {
    class ItemCollectionViewCell: CollectionViewCell {
        private let titleLabel: UILabel = UILabel(frame: .zero)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .tertiarySystemBackground
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
                titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
            ])
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        func configure(item: DebugMenuPresentable) {
            titleLabel.text = item.debuggerItemTitle
        }
    }
}

open class CollectionViewCell: UICollectionViewCell {
    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                contentView.alpha = 0.5
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.contentView.alpha = 1.0
                }
            }
        }
    }
}
