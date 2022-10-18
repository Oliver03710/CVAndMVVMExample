//
//  SimpleTableViewController.swift
//  CVAndMVVMExample
//
//  Created by Junhee Yoon on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let list = ["슈비버거", "프랭크", "자갈치", "고래밥"]
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Helper Functions
    
    
    
    
    // MARK: - TableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "")!
        
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    
    
    
}
