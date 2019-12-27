//
//  ChipSetTableVC.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import UIKit

class ChipSetTableVC: UITableViewController {
    
    private let chipSetIdentifier = "chipSetIdentifier"
    
    var chipSets: [ChipSet] = [ChipSet.monteCarloChipSet(currency: "$"), ChipSet.monteCarloChipSet(currency: "£")]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavigationBarWithWhiteText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addChipSet))
        
        navigationItem.title = "Poker Chip Sets"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        // Setup table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChipSetTableViewCell.self, forCellReuseIdentifier: chipSetIdentifier)
        tableView.bounces = false
    }
    
    @objc fileprivate func addChipSet() {
        print("addChipSetButtonPressed")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chipSets.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: chipSetIdentifier, for: indexPath) as? ChipSetTableViewCell else { return UITableViewCell() }

        guard indexPath.row < chipSets.count else { return cell }
//        cell.textLabel?.text = chipSets[indexPath.row].name
        
        cell.configure(with: chipSets[indexPath.row], delegate: self)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
}

extension ChipSetTableVC: ChipSetTableViewCellDelegate {
    func chipSetTableViewCellPressed(for chipSet: ChipSet) {
        print("DELEGATION - Chip set button pressed: \(chipSet.name)")
        let newVC = ChipSetDetailVC()
        newVC.configure(with: ChipSetDetailViewModel(chipSet: chipSet))
        navigationController?.pushViewController(newVC, animated: true)
    }
}
