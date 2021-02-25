//
//  LogsViewController.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2021/02/25.
//

import UIKit

class LogsViewController: UICollectionViewController {
    init() {
        super.init(collectionViewLayout: .init())
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
                self?.removeItem(indexPath)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [delete])
        }
        self.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Section: Int, CaseIterable {
        case logs
    }
    
    lazy var dataSource = UICollectionViewDiffableDataSource<Section, URL>(collectionView: collectionView) { (collectionView, indexPath, logURL) in
        let cellRegstration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath, logURL: URL) in
            var content = cell.defaultContentConfiguration()
            content.text = logURL.lastPathComponent
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        return collectionView.dequeueConfiguredReusableCell(
            using: cellRegstration,
            for: indexPath,
            item: logURL
        )
    }
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, URL>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        reloadData()
    }
    
    private func removeItem(_ indexPath: IndexPath) {
        let url = snapshot.itemIdentifiers(inSection: .logs)[indexPath.row]
        try! FileManager.default.removeItem(at: url)
        snapshot.deleteItems([url])
        dataSource.apply(snapshot)
    }
    
    private func reloadData() {
        snapshot.appendSections([.logs])
        for path in try! FileManager.default.contentsOfDirectory(atPath: URL.makeDebugMenuURL().path) {
            let url = URL.makeDebugMenuURL().appendingPathComponent(path)
            snapshot.appendItems([url], toSection: .logs)
        }
        dataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = snapshot.itemIdentifiers(inSection: .logs)[indexPath.row]
        let vc = LogViewController(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}
