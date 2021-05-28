//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/23.
//

import UIKit

class EnvelopePreviewTableViewController: UITableViewController {
    var envelops: [Envelope] = []
    var fetcher: ((_ completions: @escaping ([Envelope]) -> Void) -> Void)
    
    init(fetcher: @escaping (_ completions: @escaping ([Envelope]) -> Void) -> Void) {
        self.fetcher = fetcher
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        tableView.register(Value1TableViewCell.self)
        
        let refreshControlAction: UIAction = .init { [weak self] _ in
            self?.fetch()
        }
        let refreshControl = UIRefreshControl(frame: .zero, primaryAction: refreshControlAction)
        tableView.refreshControl = refreshControl
        
        let rightBarButtonAction: UIAction = .init { [weak self] _ in
            self?.presentActivity()
        }
        let rightBarButtonItem = UIBarButtonItem(systemItem: .action, primaryAction: rightBarButtonAction, menu: nil)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        fetch()
    }
    
    private func fetch() {
        fetcher { [weak self] envelops in
            DispatchQueue.main.async { [weak self] in
                self?.envelops = envelops
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Copy", style: .default, handler: { _ in
            UIPasteboard.general.string = message
        }))
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func presentActivity() {
        let texts = envelops.map({ "\($0.key) : \($0.value)" }).joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [texts], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        envelops.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Value1TableViewCell.self, for: indexPath)
        let envelop = envelops[indexPath.row]
        cell.textLabel?.text = envelop.key
        cell.detailTextLabel?.text = envelop.value
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let envelop = envelops[indexPath.row]
        presentAlert(title: envelop.key, message: envelop.value)
    }
}
