//
//  ToDoTableViewController.swift
//  ToDoApp
//
//  Created by d.chernov on 19/04/2023.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
    var manageObjectContext: NSManagedObjectContext?
    var toDoLists = [ToDo]()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    
    // MARK: - Table view data source
    
    func loadData(){
        do {
            let result = try manageObjectContext?.fetch(request)
            toDoLists = result!
            tableView.reloadData()
        }catch{
            fatalError("Error in loading item into ToDo")
        }
    }
    
    func saveData(){
        do{
            try manageObjectContext?.save()
        }
        catch{
            fatalError("Cannot be saved")
        }
        loadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add new Task", message: "Please fill this form", preferredStyle: .alert)
        alert.addTextField{ textInfo in
            textInfo.placeholder = "Enter task"
        }
        alert.addTextField{
            textDetail in
            textDetail.placeholder = "Enter details"
        }
        
        let actionButton = UIAlertAction(title: "Add Task", style: .default) { alertAction in
            let text = alert.textFields?.first
            let textDetail = alert.textFields?[1]
            let entities = NSEntityDescription.entity(forEntityName: "ToDo", in: self.manageObjectContext!)
            let list = NSManagedObject(entity: entities!, insertInto: self.manageObjectContext)
            
            list.setValue(text?.text, forKey: "item")
            list.setValue(textDetail?.text, forKey: "detail")
            self.saveData()
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(actionButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoLists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItem", for: indexPath)
        
        let toDoItem = toDoLists[indexPath.row]
        
        cell.textLabel?.text = toDoItem.item
        cell.detailTextLabel?.text = toDoItem.detail
        cell.accessoryType = toDoItem.isDone ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toDoLists[indexPath.row].isDone = !toDoLists[indexPath.row].isDone
        saveData()
    }
    //    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        remove(indexPath: indexPath)
    //        return nil
    //    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let toDoItem = toDoLists[indexPath.row]
            
            // Remove the item from Core Data
            manageObjectContext!.delete(toDoItem)
            
            do {
                try manageObjectContext!.save()
            } catch let error {
                print("Error deleting item: \(error.localizedDescription)")
            }
            
            // Remove the item from the local array and update the table view
            
            toDoLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            showNotification(message: "Task was sucessfully deleted", duration: 1)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "🗑"
    }
    
    func showNotification(message: String, duration: TimeInterval) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        // Dismiss the alert after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
