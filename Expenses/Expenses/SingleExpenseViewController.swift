//
//  SingleExpenseViewController.swift
//  Expenses
//
//  Created by Mandy Rogers on 4/26/18.
//  Copyright © 2018 Mandy Rogers. All rights reserved.
//

import UIKit

class SingleExpenseViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var existingExpense: Expense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameText.delegate = self as? UITextFieldDelegate
        amountText.delegate = self as? UITextFieldDelegate
        
        nameText.text = existingExpense?.name
        
        if let amount = existingExpense?.amount {
            amountText.text = "\(amount)"
        }
        
        if let date = existingExpense?.date {
            datePicker.date = date
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameText.resignFirstResponder()
        amountText.resignFirstResponder()
    }
    
    @IBAction func saveExpense(_ sender: Any) {
        let name = nameText.text
        let amountString = amountText.text ?? ""
        let amount = Double(amountString) ?? 0.0
        let date = datePicker.date
        
        var expense: Expense?
        
        if let existingExpense = existingExpense {
            existingExpense.name = name
            existingExpense.amount = amount
            existingExpense.date = date
            
            expense = existingExpense
        } else {
            expense = Expense(name: name, amount: amount, date: date)
        }
        
        
        if let expense = expense {
            do {
                let managedContext = expense.managedObjectContext
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Context could not be saved")
            }
        }
        
        
    }

}
