//
//  InAppDebuggerViewController.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit

@available(iOS 14, *)
class InAppDebuggerViewController: UIViewController {
    let collectionView: UICollectionView
    let debuggerItems: [AnyDebugItem]
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyDebugItem>!

    enum Section: Int, CaseIterable {
        case items
    }
    
    init(debuggerItems: [DebugMenuPresentable]) {
        self.debuggerItems = debuggerItems.map(AnyDebugItem.init)
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(
            frame: .null,
            collectionViewLayout: collectionViewLayout
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "DebugMenu"
        navigationItem.largeTitleDisplayMode = .always

        navigation: do {
            let rightItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction(handler: { [weak self] (_) in
                self?.parent?.parent?.dismiss(animated: true)
            }), menu: nil)
            navigationItem.rightBarButtonItem = rightItem
        }
        
        toolbar: do {
            let label = UILabel(frame: .null)
            label.font = UIFont.preferredFont(forTextStyle: .caption1)
            label.textColor = UIColor.label
            label.text = "\(Application.current.appName) \(Application.current.version) (\(Application.current.build))"
            let bundleIDLabel = UILabel(frame: .null)
            bundleIDLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
            bundleIDLabel.textColor = UIColor.secondaryLabel
            bundleIDLabel.text = "\(Application.current.bundleIdentifier)"
            let vStack = UIStackView(arrangedSubviews: [label, bundleIDLabel])
            vStack.axis = .vertical
            vStack.alignment = .center
            let space = UIBarButtonItem.flexibleSpace()
            let item = UIBarButtonItem(customView: vStack)
            navigationController?.isToolbarHidden = false
            toolbarItems = [space, item, space]
        }
        configureDataSource()
        collectionView.delegate = self
        performUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deselectSelectedItems()
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
    
    private func deselectSelectedItems(animated: Bool = true) {
        collectionView.indexPathsForSelectedItems?.forEach { (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: animated)
        }
    }
}

@available(iOS 14, *)
extension InAppDebuggerViewController {

    func configureDataSource() {
        let selectCellRegstration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath, title: String) in
            var content = cell.defaultContentConfiguration()
            content.text = title
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }

        let executableCellRegstration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath, title: String) in
            var content = cell.defaultContentConfiguration()
            content.text = title
            cell.contentConfiguration = content
        }

        let toggleCellRegstration = UICollectionView.CellRegistration { (cell: ToggleCell, indexPath, item: (title: String, current: () -> Bool, onChange: (Bool) -> Void)) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            cell.current = item.current
            cell.onChange = item.onChange
        }

        let sliderCellRegstration = UICollectionView.CellRegistration { (cell: SliderCell, indexPath, item: (title: String, current: () -> Double, range: ClosedRange<Double>, onChange: (Double) -> Void)) in
            cell.title = item.title
            cell.current = item.current
            cell.range = item.range
            cell.onChange = item.onChange
        }

        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) in
            switch item.action {
                case .didSelect:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: selectCellRegstration,
                        for: indexPath,
                        item: item.debuggerItemTitle
                    )
                case .execute:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: executableCellRegstration,
                        for: indexPath,
                        item: item.debuggerItemTitle
                    )
                case let .toggle(current, onChange):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: toggleCellRegstration,
                        for: indexPath,
                        item: (item.debuggerItemTitle, current, { [weak self] (value) in
                        onChange(value, { [weak self] (result) in
                            self?.onCompleteAction(result)
                        })
                    })
                    )
                case let .slider(current, range, onChange):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: sliderCellRegstration,
                        for: indexPath,
                        item: (item.debuggerItemTitle, current, range, { [weak self] (value) in
                        onChange(value, { [weak self] (result) in
                            self?.onCompleteAction(result)
                        })
                    })
                )
            }
        })
    }

    func performUpdate() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyDebugItem>()
        snapshot.appendSections([Section.items])
        snapshot.appendItems(debuggerItems, toSection: .items)
        dataSource.apply(snapshot)
    }
}

@available(iOS 14, *)
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
            case let .execute(action):
                action { [weak self] (result) in
                    self?.onCompleteAction(result)
                }
            case .toggle, .slider:
                break
            }
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section) {
        case .items:
            let item = debuggerItems[indexPath.row]
            switch item.action {
            case .didSelect, .execute:
                return true
            case .toggle, .slider:
                return false
            }
        default:
            fatalError()
        }
    }
    
    private func presentAlert(title: String, message: String?) {
        DispatchQueue.main.async { [weak self] in
            let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            vc.addAction(.init(title: "OK", style: .cancel, handler: { [weak self] _ in
                self?.deselectSelectedItems()
            }))
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
