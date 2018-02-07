//
//  ViewController.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/12/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit
import CoreData

class InventoriesViewController: UIViewController {
    let stack = CoreDataStack.instance
    
    @IBOutlet weak var tableView: UITableView!
    var inventories = [Inventory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetch = NSFetchRequest<Inventory>(entityName: "Inventory")
        do {
            let result = try stack.viewContext.fetch(fetch)
            self.inventories = result
            self.tableView.reloadData()
            
        }catch let error {
            print(error)
        }
    }
}

extension InventoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventories.count
    }
}

extension InventoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryTableViewCell
        
        let item = inventories[indexPath.row]
        cell.titleLabel.text = item.name
        cell.dateLabel.text = DateFormatter.localizedString(from: item.date!, dateStyle: .short, timeStyle: .short)
        cell.quantityLabel.text = "x\(item.quantity)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let item = self.inventories[indexPath.row]
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete"){(UITableViewRowAction,NSIndexPath) -> Void in
            self.stack.deleteIn(context: self.stack.viewContext, item: item)
            self.inventories.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit"){(UITableViewRowAction,NSIndexPath) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "addInventory") as! AddInventoryViewController
            vc.item = item
            vc.context = self.stack.viewContext
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        edit.backgroundColor = UIColor.blue
        return [delete,edit]
    }
}
