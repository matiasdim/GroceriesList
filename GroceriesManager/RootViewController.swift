//
//  RootViewController.swift
//  GroceriesManager
//
//  Created by Matías Gil Echavarría on 7/7/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

class RootViewController: UITableViewController {
    var items: [Product] = (0..<5).map {
        Product(name: "Item \($0 + 1)", observation: "Observation \($0 + 1)", category: .dairy)
    }
    let reuseIdentifier = "ProductCell"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.navigationItem.title = "Products"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Constants.mainColor]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addProduct))
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.tintColor = Constants.mainColor
        self.navigationController?.navigationBar.barTintColor = Constants.secondaryColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.tableView.separatorColor = Constants.secondaryColor
        self.tableView.register(UINib(nibName: self.reuseIdentifier, bundle: nil), forCellReuseIdentifier: self.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc private func addProduct() {
        self.navigationController?.present(ProductFormViewController(delegate: self, type: .create), animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as? ProductCell {
            let product = self.items[indexPath.row]
            cell.categoryLabel.text = product.category.rawValue
            cell.productNameLabel.text = product.name
            cell.observationLabel.text = product.observation

            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ProductFormViewController(product: self.items[indexPath.row],
                                                                                delegate: self, type: .edit),
                                                      animated: true)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

}

extension RootViewController: ProductFormSavedDelegate {
    func didSaveForm(product: Product, formType: FormType) {
        if formType == .create {
            self.items.append(product)
        } else if let row = self.items.firstIndex(of: product) {//self.items.firstIndex(where: { $0.id == product.id }) {
                self.items[row] = product
        }
        self.tableView.reloadData()
    }
}
