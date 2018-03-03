//
//  ViewController.swift
//  AlamofireContributors
//
//  Created by Vasyl Skrypij on 3/1/18.
//  Copyright © 2018 Vasyl Skrypij. All rights reserved.
//

import UIKit

class ContributorsListViewController: UITableViewController {

    // MARK: - Properties
    private var usersData: [User] = []
    private var currentPage = 0
    private var isLoading = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 80
        
        loadData { (users, error) in
            if let users = users {
                self.addNewUsers(users)
            }
            if let error = error {
                self.showAlert(withErrorMessage: error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ContributorDetailsViewController, let cell = sender as? ContributorsListTableViewCell {
            viewController.login = usersData[(tableView.indexPath(for: cell)?.row)!].login
        }
    }
    
    // MARK: - Private
    
    typealias loadDataCompletionHandler = (_ result : [User]?, _ error: Error?) -> Void
    
    private func loadData(completion : @escaping loadDataCompletionHandler) {
        guard isLoading == false else {
            return
        }
        
        isLoading = true
        APIManager.sharedInstance.contributorsList(page: currentPage + 1) { result in
            switch result {
            case .success(let users):
                guard users.count > 0 else{
                    return
                }
                
                self.currentPage += 1
                self.isLoading = false
                completion(users, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private func addNewUsers(_ users: [User]) {
        let rowsIndexes = (0..<users.count).map({ i in
            return IndexPath(row: self.usersData.count + i, section: 0)
        })
        
        self.usersData.append(contentsOf: users)
        let contentOffset = self.tableView.contentOffset
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: rowsIndexes, with: .bottom)
        self.tableView.endUpdates()
        self.tableView.setContentOffset(contentOffset, animated: false)
    }
    
    private func showAlert(withErrorMessage message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableViewDataSource
extension ContributorsListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.contributors, for: indexPath) as! ContributorsListTableViewCell
        
        cell.updateCellForUser(usersData[indexPath.row])
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ContributorsListViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == self.usersData.count) {
            loadData { (users, error) in
                if let users = users {
                    self.addNewUsers(users)
                }
                if let error = error {
                    self.showAlert(withErrorMessage: error.localizedDescription)
                }
            }
        }
    }
    
}

