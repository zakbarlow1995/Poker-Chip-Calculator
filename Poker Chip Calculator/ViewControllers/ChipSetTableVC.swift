//
//  ChipSetTableVC.swift
//  Poker Chip Calculator
//
//  Created by Zak Barlow on 27/12/2019.
//  Copyright © 2019 zb1995. All rights reserved.
//

import UIKit

class ChipSetTableVC: UIViewController {
    
    let tableView = UITableView()
    
    let titleLabel = UILabel(text: "Poker Chip Sets", font: UIFont.systemFont(ofSize: 34.0, weight: .bold), textColor: Colors.blueGreen, textAlignment: .left, numberOfLines: 1, sizeToFit: true, adjustsFontSizeToFitWidth: true)
    
    let chipSetTextField = CustomTextField(placeholder: "Enter Chip Set Name", font: UIFont.systemFont(ofSize: 19.0, weight: .regular), textAlignment: .left, textColor: .systemGray, tintColor: .systemGray, borderWidth: 1.0, borderColor: Colors.blueGreen, cornerRadius: 9.0)
    
    lazy var desiredButtonSize = CGSize(width: 120.0, height: 44.0)
    
    lazy var addChipSetButton: UIButton = {
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
        print("AccountEditVC - addChipSetButtonPressed")
        
        if let chipSetName = chipSetTextField.text, !chipSetName.isEmpty {
            chipSets.append(ChipSet(name: chipSetName))
            
            let indexPath = IndexPath(row: chipSets.count - 1, section: 0)
            
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            chipSetTextField.text = nil
            view.endEditing(true)
        }
    }
    
    private let chipSetIdentifier = "chipSetIdentifier"
    
    var chipSets: [ChipSet] = [ChipSet.monteCarloChipSet(currency: "$"), ChipSet.monteCarloChipSet(currency: "£"), ChipSet.random(), ChipSet.random(), ChipSet.random(), ChipSet.random(), ChipSet.random(), ChipSet.random()]
    
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
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addChipSet))
        
//        navigationItem.title = "Poker Chip Sets"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTopElements()
        setupTableView()
    }
    
    fileprivate func setupTopElements() {
        view.addSubviews(titleLabel, chipSetTextField, addChipSetButton)
        
        titleLabel.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 24.0, left: 16, bottom: 0, right: 16))
        
        addChipSetButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 16), size: desiredButtonSize)
        
        chipSetTextField.anchor(top: addChipSetButton.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: addChipSetButton.bottomAnchor, trailing: addChipSetButton.leadingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        chipSetTextField.delegate = self
    }
    
    fileprivate func setupTableView() {
        // Setup table view
        tableView.removeFromSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChipSetTableViewCell.self, forCellReuseIdentifier: chipSetIdentifier)
        tableView.keyboardDismissMode = .interactive
//        tableView.bounces = false
        
        view.addSubview(tableView)
        tableView.anchor(top: addChipSetButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        view.backgroundColor = Colors.crystalBlue
    }
    
//    @objc fileprivate func addChipSet() {
//        print("addChipSetButtonPressed")
//    }
    
}

extension ChipSetTableVC: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chipSets.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: chipSetIdentifier, for: indexPath) as? ChipSetTableViewCell else { return UITableViewCell() }

        guard indexPath.row < chipSets.count else { return cell }
//        cell.textLabel?.text = chipSets[indexPath.row].name
        
        cell.configure(with: chipSets[indexPath.row], delegate: self)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            chipSets.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
}

extension ChipSetTableVC: ChipSetTableViewCellDelegate {
    func chipSetTableViewCellPressed(for chipSet: ChipSet) {
        print("DELEGATION - Chip set button pressed: \(chipSet.name)")
        let newVC = ChipSetDetailVC()
        newVC.configure(with: ChipSetDetailViewModel(chipSet: chipSet))
        navigationController?.pushViewController(newVC, animated: true)
    }
}

extension ChipSetTableVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let selectedTextFieldIndex = (textFields as [UITextField]).firstIndex(of: textField), selectedTextFieldIndex < textFields.count - 1 {
//            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
//        } else {
            textField.resignFirstResponder()
//        }
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        print("textFieldDidEndEditing")
//        if let viewModel = viewModel {
//            viewModel.set(firstName: firstNameTextField.text, lastName: lastNameTextField.text, email: emailTextField.text, marketing: checkBox.isSelected)
//            updateViewsAccordingToFieldValidation()
//        }
//        updateSignUpButton()
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let selectedTextFieldIndex = (textFields as [UITextField]).firstIndex(of: textField), selectedTextFieldIndex < textFieldsHaveBeenModified.count, !textFieldsHaveBeenModified[selectedTextFieldIndex] {
//            switch selectedTextFieldIndex {
//            case 0: hasFirstNameTextFieldBeenModified = true
//            case 1: hasLastNameTextFieldBeenModified = true
//            case 2: hasEmailTextFieldBeenModified = true
//            default: break
//            }
//        }
//        return true
//    }
    
}

