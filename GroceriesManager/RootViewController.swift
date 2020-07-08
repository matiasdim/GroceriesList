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

class RootViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
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
        self.navigationController?.navigationBar.tintColor = Constants.mainColor
        self.navigationController?.navigationBar.barTintColor = Constants.secondaryColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.tableView.separatorColor = Constants.secondaryColor
        self.tableView.register(UINib(nibName: self.reuseIdentifier, bundle: nil), forCellReuseIdentifier: self.reuseIdentifier)
        self.tableView.backgroundColor = Constants.mainColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.emptyView.isHidden = !self.items.isEmpty
    }
    
    @objc private func addProduct() {
        self.navigationController?.present(ProductFormViewController(delegate: self, type: .create), animated: true, completion: nil)
    }
}

extension RootViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
}


extension RootViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as? ProductCell {
            let product = self.items[indexPath.row]
            cell.categoryLabel.text = product.category.rawValue
            cell.productNameLabel.text = product.name
            cell.observationLabel.text = product.observation

            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ProductFormViewController(product: self.items[indexPath.row],
                                                                                delegate: self, type: .edit),
                                                      animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.emptyView.isHidden = !self.items.isEmpty
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
        self.emptyView.isHidden = !self.items.isEmpty
        self.tableView.reloadData()
    }
}
