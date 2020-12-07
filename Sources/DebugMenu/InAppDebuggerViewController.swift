//
//  InAppDebuggerViewController.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit

class InAppDebuggerViewController: InAppDebuggerViewControllerBase {
    let collectionView: UICollectionView
    let debuggerItems: [AnyDebugItem]
    
    enum Section: Int, CaseIterable {
        case items
    }
    
    init(debuggerItems: [DebugMenuPresentable]) {
        self.debuggerItems = debuggerItems.map(AnyDebugItem.init)
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    lazy var dataSource = UICollectionViewDiffableDataSource<Section, AnyDebugItem>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
        let cellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath, item: DebugMenuPresentable) in
            var content = cell.defaultContentConfiguration()
            content.text = item.debuggerItemTitle
            cell.contentConfiguration = content
            switch item.action {
            case .didSelect:
                cell.accessories = [.disclosureIndicator()]
            case let .toggle(current, action):
                let toggle = UISwitch()
                toggle.isOn = current()
                toggle.tag = indexPath.row
                toggle.addTarget(self, action: #selector(self.onValueChangeToggle(_:)), for: .valueChanged)
                let configuration = UICellAccessory.CustomViewConfiguration(customView: toggle, placement: .trailing())
                cell.accessories = [.customView(configuration: configuration)]
            }
        }
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        return cell
    })
    
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
        collectionView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyDebugItem>()
        snapshot.appendSections([Section.items])
        snapshot.appendItems(debuggerItems, toSection: .items)
        dataSource.apply(snapshot)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.indexPathsForSelectedItems?.forEach { (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
    @objc private func onTapRightBarButtonItem() {
        self.dismiss(animated: true)
    }
    
    @objc private func onValueChangeToggle(_ toggle: UISwitch) {
        let item = debuggerItems[toggle.tag]
        guard case let .toggle(_, action) = item.action else { return }
        action(toggle.isOn) { [weak self] (result) in
            self?.onCompleteAction(result)
        }
    }
    
    private func onCompleteAction(_ result: DebugMenuResult) {
        switch result {
        case .success(let message) where message != nil:
            presentAlert(title: "Success", message: message)
        case .failure(let message) where message != nil:
            presentAlert(title: "Error", message: message)
        default:
            break
        }
    }
}

extension InAppDebuggerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .items:
            let item = debuggerItems[indexPath.row]
            switch item.action {
            case let .didSelect(action):
                action(self) { [weak self] (result) in
                    self?.onCompleteAction(result)
                }
            case .toggle:
                break
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
