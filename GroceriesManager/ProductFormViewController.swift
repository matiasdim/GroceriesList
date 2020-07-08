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
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var shadowView: UIView!
    
    weak var delegate: ProductFormSavedDelegate?
    var product: Product?
    var formType: FormType
    
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
        
        self.titleLabel.text = (self.formType == .create) ? "New Product" : "Edit Product"
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        var pickerInitialIndex = 0
        if let product = self.product, let index = Category.allCases.firstIndex(of: product.category) {
            pickerInitialIndex = index
        }
        self.categoryPicker.selectRow(pickerInitialIndex , inComponent: 0, animated: false)
        self.categoryPicker.setValue(Constants.secondaryColor, forKeyPath: "textColor")
        
        self.nameTextField.delegate = self
        self.nameTextField.becomeFirstResponder()
        self.nameTextField.text = self.product?.name
        self.observationTextField.delegate = self
        self.observationTextField.text = self.product?.observation
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if let name = self.nameTextField.text, !name.isEmpty, let observation = self.observationTextField.text, !observation.isEmpty {
            if let product = self.product {
                product.name = name
                product.observation = observation
                // Improve thisduble call didsave
                self.delegate?.didSaveForm(product: product, formType: self.formType)
            } else {
                self.delegate?.didSaveForm(product: Product(name: name, observation: observation, category: .none), formType: self.formType)
            }
            // When adding is presented modally. Editing is pushed from navigationcontroller
//            (self.formType == .create) ? self.dismiss(animated: true) : self.navigationController?.popViewController(animated: true)
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

extension ProductFormViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    
    
}

extension ProductFormViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category.allCases[row].rawValue
    }
}

extension ProductFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
