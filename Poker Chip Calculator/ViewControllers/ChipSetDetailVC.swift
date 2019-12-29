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
    
    let chipValueTextField = NumericTextField(placeholder: "Enter Chip Value", font: UIFont.systemFont(ofSize: 19.0, weight: .regular), textAlignment: .left, textColor: .systemGray, tintColor: .systemGray, borderWidth: 1.0, borderColor: Colors.blueGreen, cornerRadius: 9.0)
    let chipNumberTextField = NumericTextField(placeholder: "Enter Number Of Chips", font: UIFont.systemFont(ofSize: 19.0, weight: .regular), textAlignment: .left, textColor: .systemGray, tintColor: .systemGray, borderWidth: 1.0, borderColor: Colors.blueGreen, cornerRadius: 9.0)
    
    lazy var desiredButtonSize = CGSize(width: 120.0, height: 44.0)
    lazy var desiredCurrencySelectedButtonSize = CGSize(width: 250.0, height: 44.0)
    
    lazy var addChipStackButton: UIButton = {
        let btn = UIButton(frame: CGRect(origin: .zero, size: desiredButtonSize))
        btn.backgroundColor = Colors.blueGreen
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 21.0, weight: .bold)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.white, for: .normal)
        btn.cornerRadius = desiredButtonSize.height/2.0
        btn.addTarget(self, action: #selector(addChipSetButtonPressed), for: .touchUpInside)
        return btn
    }()
        
    @objc func addChipSetButtonPressed() {
        print("addChipSetButtonPressed")
        view.endEditing(true)
        if let viewModel = self.viewModel, let chipValueText = chipValueTextField.text, let chipNumberText = chipNumberTextField.text, !chipValueText.isEmpty, !chipNumberText.isEmpty, let chipValue = Int(chipValueText), let chipNumber = Int(chipNumberText) {
            
            
            if let stackToUpdate = viewModel.chipSet.stacks.first(where: { $0.value == chipValue }), let index = viewModel.chipSet.stacks.firstIndex(where: { $0.value == chipValue }) {
                stackToUpdate.number += chipNumber
                let indexPath = IndexPath(row: index, section: 0)
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            } else {
                viewModel.chipSet.stacks.append(ChipStack(value: chipValue, number: chipNumber, currency: viewModel.chipSet.currency, title: nil, color: .random))
                
                let indexPath = IndexPath(row: viewModel.chipSet.stacks.count - 1, section: 0)
                
                tableView.beginUpdates()
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
            chipValueTextField.text = nil
            chipNumberTextField.text = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavigationBarWithWhiteText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel?.chipSet.name
        
        // Remove "Back" text from navigation bar, to be left with just " < " chevron
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        setupTopElements()
        setupTableView()
    }
    
    fileprivate func setupTopElements() {
        view.addSubviews(titleLabel, addChipStackButton, chipValueTextField, chipNumberTextField)
        
        titleLabel.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 24.0, left: 30, bottom: 0, right: 16))
        
        addChipStackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 16), size: desiredButtonSize)
        
        chipValueTextField.anchor(top: addChipStackButton.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: addChipStackButton.bottomAnchor, trailing: addChipStackButton.leadingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        chipNumberTextField.anchor(top: chipValueTextField.bottomAnchor, leading: chipValueTextField.leadingAnchor, bottom: nil, trailing: chipValueTextField.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: chipValueTextField.bounds.width, height: desiredButtonSize.height))
        
        chipValueTextField.delegate = self
        chipNumberTextField.delegate = self
    }
        
    fileprivate func setupTableView() {
        // Setup table view
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChipSetDetailCell.self, forCellReuseIdentifier: chipStackIdentifier)
        
        tableView.anchor(top: chipNumberTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
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
    
    // To support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // To support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel else { return }
        if editingStyle == .delete {
            // Delete the row from the data source
            viewModel.chipSet.stacks.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

extension ChipSetDetailVC: ChipSetDetailCellDelegate {
    func chipStackCellPressed(chipStack: ChipStack) {
        print("DELEGATION - Chip stack button pressed - \(chipStack.formattedTotalValue)!")
    }
}

extension ChipSetDetailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
