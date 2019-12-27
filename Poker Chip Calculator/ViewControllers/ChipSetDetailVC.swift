//
//  ChipSetDetailVC.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import UIKit

class ChipSetDetailViewModel {
    let chipSet: ChipSet
    
    init(chipSet: ChipSet) {
        self.chipSet = chipSet
    }
}

class ChipSetDetailVC: UITableViewController {
    
    private let chipStackIdentifier = "chipStackIdentifier"
    var viewModel: ChipSetDetailViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavigationBarWithWhiteText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addChipSet))
        
        navigationItem.title = viewModel?.chipSet.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
    }
        
        fileprivate func setupTableView() {
            // Setup table view
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(ChipSetDetailCell.self, forCellReuseIdentifier: chipStackIdentifier)
            tableView.bounces = false
        }
    
    public func configure(with viewModel: ChipSetDetailViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.chipSet.stacks.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: chipStackIdentifier, for: indexPath) as? ChipSetDetailCell else { return UITableViewCell() }
        
        guard let viewModel = self.viewModel, indexPath.row < viewModel.chipSet.stacks.count else { return cell }
        
        cell.configure(with: viewModel.chipSet.stacks[indexPath.row], delegate: self)
        
        return cell
    }

}

extension ChipSetDetailVC: ChipSetDetailCellDelegate {
    func chipStackCellPressed(chipStack: ChipStack) {
        print("DELEGATION - Chip stack button pressed - \(chipStack)!")
    }
}
