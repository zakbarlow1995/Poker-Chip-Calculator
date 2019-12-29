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

class ChipSetDetailVC: UIViewController {
    
    let titleLabel = UILabel(font: UIFont.systemFont(ofSize: 34.0, weight: .bold), textColor: Colors.blueGreen, textAlignment: .left, numberOfLines: 1, sizeToFit: true, adjustsFontSizeToFitWidth: true)
    
    private let tableView = UITableView()
    private let chipStackIdentifier = "chipStackIdentifier"
    var viewModel: ChipSetDetailViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavigationBarWithWhiteText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addChipSet))
        
//        navigationItem.title = viewModel?.chipSet.name
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        titleLabel.text = viewModel?.chipSet.name
        
        // Remove "Back" text from navigation bar, to be left with just " < " chevron
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        setupTopElements()
        setupTableView()
    }
    
    fileprivate func setupTopElements() {
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 24.0, left: 30, bottom: 0, right: 16))
    }
        
    fileprivate func setupTableView() {
        // Setup table view
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChipSetDetailCell.self, forCellReuseIdentifier: chipStackIdentifier)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        view.backgroundColor = Colors.crystalBlue
    }
    
    public func configure(with viewModel: ChipSetDetailViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ChipSetDetailVC: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.chipSet.stacks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: chipStackIdentifier, for: indexPath) as? ChipSetDetailCell else { return UITableViewCell() }
        
        guard let viewModel = self.viewModel, indexPath.row < viewModel.chipSet.stacks.count else { return cell }
        
        cell.configure(with: viewModel.chipSet.stacks[indexPath.row], delegate: self)
        
        return cell
    }

}

extension ChipSetDetailVC: ChipSetDetailCellDelegate {
    func chipStackCellPressed(chipStack: ChipStack) {
        print("DELEGATION - Chip stack button pressed - \(chipStack.formattedTotalValue)!")
    }
}
