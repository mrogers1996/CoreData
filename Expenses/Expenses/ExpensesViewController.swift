//
//  ExpensesViewController.swift
//  Expenses
//
//  Created by Mandy Rogers on 4/26/18.
//  Copyright © 2018 Mandy Rogers. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var expensesTable: UITableView!
    
    let dateFormatter = DateFormatter()
    var expenses = [Expense]()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            expenses = try managedContext.fetch(fetchRequest)
            expensesTable.reloadData()
        } catch {
            print("Fetch could not be performed")
        }
    
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expensesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let expense = expenses[indexPath.row]
        
        cell.textLabel?.text = expense.name
        
        if let date = expense.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
    
    
    
    @IBAction func addNewExpense(_ sender: Any) {
        performSegue(withIdentifier: "showExpense", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SingleExpenseViewController,
            let selectedRow = self.expensesTable.indexPathForSelectedRow?.row else {
                return
        }
        
        destination.existingExpense = expenses[selectedRow]
    }
    
    func deleteExpense(at indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        
        if let managedContext = expense.managedObjectContext {
            managedContext.delete(expense)
            
            do {
                try managedContext.save()
                
                self.expenses.remove(at: indexPath.row)
                
                expensesTable.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Delete failed")
                
                expensesTable.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteExpense(at: indexPath)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
