//
//  BeyondUserTableViewController.swift
//  GitHubClientAG
//
//  Created by Alexandre Giguere on 2019-10-24.
//  Copyright © 2019 Beyond Technologies. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    private let viewModel = BeyondUsersViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let footerLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.viewTitle
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        configureSearchController()
        
        setRefreshControl()
        
        configureTableView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            refreshControl = nil
            navigationItem.searchController = nil
        } else {
            setRefreshControl()
            configureSearchController()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetail1" {
            if let viewController = segue.destination as? UserDetailTableViewController {
                viewController.user = viewModel.user(at: tableView.indexPathForSelectedRow!)
            }
        } else if segue.identifier == "UserDetail2" {
            if let viewController = segue.destination as? UserDetailTableViewController {
                viewController.user = sender as? BeyondUser
            }
        }
    }

    // MARK: - TableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! BeyondUserTableViewCell

        cell.user = viewModel.user(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteUser(at: indexPath)
        
        updateTableViewFooter()
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveUser(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: - TableViewDataDelegate
    // Way 1
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let user = viewModel.user(at: indexPath)
//
//        let viewController = UserDetailTableViewController.createInstanceFromStoryboard(user: user)
//
//        navigationController?.pushViewController(viewController, animated: true)
//    }
    
    // Way 2
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let user = viewModel.user(at: indexPath)

        performSegue(withIdentifier: "UserDetail2", sender: user)
    }
}

// MARK: - Private API
private extension UsersTableViewController {
    
    @objc func refresh(_ sender: UIRefreshControl) {
        viewModel.refresh {
            self.refreshControl?.endRefreshing()
            self.updateTableViewFooter()
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        configureTableViewFooter()
    }
    
    func configureTableViewFooter() {
        footerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        footerLabel.frame.size.height = 34
        footerLabel.textColor = .lightGray
        footerLabel.textAlignment = .center
        
        updateTableViewFooter()
        
        tableView.tableFooterView = footerLabel
    }
    
    func updateTableView() {
        updateTableViewFooter()
    }
    
    func updateTableViewFooter() {
        footerLabel.text = viewModel.footerText
    }
    
    func setRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    func configureSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
    }
}

// MARK: - UISearchControllerDelegate
extension UsersTableViewController: UISearchControllerDelegate { }

// MARK: - UISearchResultsUpdating
extension UsersTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        viewModel.filterUsersForSearchText(searchText)
        
        tableView.reloadData()
        
        updateTableView()
    }
}
