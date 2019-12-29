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
    
    let pickerBlurView = UIView(backgroundColor: .black)
    var containerView = UIView()
    let picker = UIPickerView()
    
    lazy var currencySelectedButton: UIButton = {
        let btn = UIButton(frame: CGRect(origin: .zero, size: desiredCurrencySelectedButtonSize))
        btn.backgroundColor = Colors.blueGreen
        btn.setTitle("Currency Selected", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 21.0, weight: .bold)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(.white, for: .normal)
        btn.cornerRadius = desiredButtonSize.height/2.0
        btn.addTarget(self, action: #selector(currencySelectedButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc func currencySelectedButtonPressed() {
        print("currencySelectedButtonPressed")
        
        if let chipSetName = chipSetTextField.text, !chipSetName.isEmpty, picker.selectedRow(inComponent: 0) < pickerCurrencyData.count {
            chipSets.append(ChipSet(name: chipSetName, currency: picker.selectedRow(inComponent: 0) == 0 ? nil : pickerCurrencyData[picker.selectedRow(inComponent: 0)] ))
            
            let indexPath = IndexPath(row: chipSets.count - 1, section: 0)
            
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            chipSetTextField.text = nil
        }
        
        [pickerBlurView, containerView, currencySelectedButton].forEach { $0.isHidden = true }
    }
    
    let titleLabel = UILabel(text: "Poker Chip Sets", font: UIFont.systemFont(ofSize: 34.0, weight: .bold), textColor: Colors.blueGreen, textAlignment: .left, numberOfLines: 1, sizeToFit: true, adjustsFontSizeToFitWidth: true)
    
    let chipSetTextField = CustomTextField(placeholder: "Enter Chip Set Name", font: UIFont.systemFont(ofSize: 19.0, weight: .regular), textAlignment: .left, textColor: .systemGray, tintColor: .systemGray, borderWidth: 1.0, borderColor: Colors.blueGreen, cornerRadius: 9.0)
    
    lazy var desiredButtonSize = CGSize(width: 120.0, height: 44.0)
    lazy var desiredCurrencySelectedButtonSize = CGSize(width: 250.0, height: 44.0)
    
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
        print("addChipSetButtonPressed")
        view.endEditing(true)
        if let chipSetName = chipSetTextField.text, !chipSetName.isEmpty {
            [pickerBlurView, containerView, currencySelectedButton].forEach { $0.isHidden = false }
        }
    }
    
    private let chipSetIdentifier = "chipSetIdentifier"
    
    var chipSets: [ChipSet] = [ChipSet.monteCarloChipSet(currency: "$"), ChipSet.monteCarloChipSet(currency: "£"), ChipSet.random(), ChipSet.random(), ChipSet.random(), ChipSet.random(), ChipSet.random(), ChipSet.random()]
    
    private var pickerCurrencyData = ["None", "$", "¢", "£", "€", "¥", "֏", "৳", "৲", "৻", "૱", "௹", "฿", "៛", "₠", "₡", "₢", "₣", "₤", "₥", "₦", "₧", "₨", "₩", "₪", "₫", "₭", "₮", "₯", "gn", "₰", "ny", "₱", "₲", "₳", "₴", "₵", "₶", "₷", "₸", "₹", "₺", "₻", "₼", "₽", "₾", "₿", "රු", "Rs", "Fr", "ƒ", "NT$", "C$", "CHF", "Дин.", "ден", "kr", "zł", "L", "c", "n", "q", "فلس" ,"ملّيم" ,"ر.س"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavigationBarWithWhiteText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopElements()
        setupTableView()
        setupPickerView()
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
        
        view.addSubview(tableView)
        tableView.anchor(top: addChipSetButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        view.backgroundColor = Colors.crystalBlue
    }
    
    fileprivate func setupPickerView() {
        [pickerBlurView, containerView, currencySelectedButton].forEach { $0.isHidden = true }
        
        view.addSubviews(pickerBlurView, containerView, currencySelectedButton)
        
        pickerBlurView.fillSuperview()
        pickerBlurView.alpha = 0.5
        
        containerView.centerInSuperview()
        containerView.constrainWidth(desiredCurrencySelectedButtonSize.width)
        containerView.constrainHeight(desiredCurrencySelectedButtonSize.width)
        
        containerView.cornerRadius = 9.0
        
        containerView.addSubview(picker)
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.backgroundColor = .systemGray
        picker.fillSuperview()
        
        currencySelectedButton.anchor(top: containerView.bottomAnchor, leading: containerView.centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: -0.5*desiredCurrencySelectedButtonSize.width, bottom: 0, right: 0), size: desiredCurrencySelectedButtonSize)
    }
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
        
        cell.configure(with: chipSets[indexPath.row], delegate: self)
        
        return cell
    }

    // To support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // To support editing the table view.
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
        textField.resignFirstResponder()
        return true
    }
}

extension ChipSetTableVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerCurrencyData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row < pickerCurrencyData.count else { return nil }
        return pickerCurrencyData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Do something...
        guard row < pickerCurrencyData.count else { return }
        print(pickerCurrencyData[row])
    }
}
