//
//  ProductFormViewController.swift
//  GroceriesManager
//
//  Created by Matías Gil Echavarría on 7/7/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit

enum FormType {
    case create
    case edit
}

protocol ProductFormSavedDelegate: AnyObject {
    func didSaveForm(product: Product, formType: FormType)
}

class ProductFormViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var observationTextField: UITextField!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var titleContainer: UIView!
    
    weak var delegate: ProductFormSavedDelegate?
    var product: Product?
    var formType: FormType
    private var selectedSegmentIndex = 0
    
    init(product: Product? = nil, delegate: ProductFormSavedDelegate, type: FormType){
        self.product = product
        self.formType = type
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = "New Product"
        self.titleContainer.isHidden = (self.formType == .edit)
        
        self.nameTextField.delegate = self
        self.nameTextField.text = self.product?.name
        self.observationTextField.delegate = self
        self.observationTextField.text = self.product?.observation
        
        
        //SegmntedControl setup
        self.segmentedControl.removeAllSegments()
        self.segmentedControl.backgroundColor = Constants.secondaryColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.mainColor], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.secondaryColor], for: .selected)
        for (index, category) in Category.allCases.enumerated() {
            self.segmentedControl.insertSegment(withTitle: category.rawValue, at: index, animated: false)
        }
        
        if let product = self.product, let index = Category.allCases.firstIndex(of: product.category) {
            self.segmentedControl.selectedSegmentIndex = index
        } else {
            self.segmentedControl.selectedSegmentIndex = self.selectedSegmentIndex
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let name = self.nameTextField.text, !name.isEmpty, let observation = self.observationTextField.text, !observation.isEmpty {
            if let product = self.product {
                product.name = name
                product.observation = observation
                product.category = Category.allCases[self.selectedSegmentIndex]
                // Improve thisduble call didsave
                self.delegate?.didSaveForm(product: product, formType: self.formType)
            } else {
                self.delegate?.didSaveForm(product: Product(name: name,
                                                            observation: observation,
                                                            category: Category.allCases[self.selectedSegmentIndex]),
                                           formType: self.formType)
            }
            // When adding, form is presented modally. On edit, it is pushed from navigationcontroller
            if self.formType == .create {
                self.dismiss(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "All fields are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func resignFirstResponder() -> Bool {
        return true
    }

}

extension ProductFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
