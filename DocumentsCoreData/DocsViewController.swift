//
//  DocsViewController.swift
//  DocumentsCoreData
//
//  Created by Jasmine Tan on 2/21/20.
//  Copyright © 2020 Jasmine Tan. All rights reserved.
//

import UIKit
import CoreData

class DocsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let dateFormatter = DateFormatter()
    var documents: [Doc] = []


      @IBOutlet weak var docsTableView: UITableView!
      override func viewDidLoad() {
          super.viewDidLoad()

          // Do any additional setup after loading the view.
          dateFormatter.dateStyle = .medium
          dateFormatter.timeStyle = .medium
      }

    override func viewWillAppear(_ animated: Bool) {
        fetchDocuments()
        docsTableView.reloadData()
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            (alertAction) -> Void in
            print("OK selected")
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchDocuments() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Doc> = Doc.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)] // order results by document name ascending
        
        do {
            documents = try managedContext.fetch(fetchRequest)
        } catch {
            alertNotifyUser(message: "Fetch for documents could not be performed.")
            return
        }
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        if let managedObjectContext = document.managedObjectContext {
            managedObjectContext.delete(document)
            
            do {
                try managedObjectContext.save()
                self.documents.remove(at: indexPath.row)
                docsTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete failed.")
                docsTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocTableViewCell {
            let document = documents[indexPath.row]
            cell.nameLabel.text = document.name
            cell.sizeLabel.text = String(document.size) + " bytes"
            
            if let modifiedDate = document.modifiedDate {
                cell.modLabel.text = dateFormatter.string(from: modifiedDate)
            } else {
                cell.modLabel.text = "unknown"
            }
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocViewController,
           let segueIdentifier = segue.identifier, segueIdentifier == "existingDocument",
           let row = docsTableView.indexPathForSelectedRow?.row {
                destination.document = documents[row]
        }
    }
    
    // There are two approaches to implementing deletion of table view cells.  Both are provided below.
    
    // Approach 1: using editing style
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDocument(at: indexPath)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
