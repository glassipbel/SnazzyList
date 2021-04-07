//
//  ViewController.swift
//  SnazzyList
//
//  Created by Santiago Apaza on 03/09/2021.
//  Copyright (c) 2021 Santiago Apaza. All rights reserved.
//
import SnazzyList
import SnazzyAccessibility
import UIKit

class ViewController: UIViewController {
    private(set) var tableView = UITableView.getDefault()
    
    private var datasource: GenericTableViewDataSource!
    private var delegate: GenericTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViewController()
    }

    func loadViewController() {
        setupViews()
        setupConstraints()
        setupDatasourceAndDelegate()
        showItems()
    }
    
    private func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .gray
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let margins = view.layoutMarginsGuide
        
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func setupDatasourceAndDelegate() {
        datasource = GenericTableViewDataSource(tableView: tableView, configFiles: [])
        delegate = GenericTableViewDelegate(dataSource: datasource, actions: self)
    }
    
    func showItems() {
        var configFiles = [GenericTableCellConfigurator]()
        let controller = SLTableViewSharedCellsController()
        
        configFiles.append(controller.getSpacingTableCellConfigFile(height: 50.0, section: 0, lineColor: .green, backgroundColor: .blue, leftMargin: 0.0, rightMargin: 0.0))
        configFiles.append(controller.getTextTableCellConfigFile(section: 0, identifier: 1, backgroundColor: .clear, leftMargin: 0.0, rightMargin: 0.0, topMargin: 0.0, bottomMargin: 0.0, provider: self, actions: nil) )
        configFiles.append(controller.getTextFieldEntryTableCellConfigFile(section: 0, identifier: 2, titleFont: .systemFont(ofSize: 12.0, weight: .regular), titleColor: .green, placeholder: "Thats all...", maxLength: nil, cornerRadius: 10.0, keyboardType: .alphabet, autocapitalizationType: .allCharacters, autocorrectionType: .no, returnKeyType: .default, showClearButton: true, provider: nil, actions: nil))
        configFiles.append(controller.getBasicButtonTableCell(section: 0, title: "boton basico", textColor: .blue, backgroundColor: .black, target: nil, action: #selector(helloWorld), underline: false, font: .systemFont(ofSize: 12.0, weight: .regular), leftMargin: 0.0, rightMargin: 0.0, buttonHeight: 40.0, accessibilityInfo: nil))
        configFiles.append(controller.getBasicCheckTableCellConfigFile(section: 0, identifier: 8, isEditable: true, checkedTitleFont: .systemFont(ofSize: 12.0, weight: .bold), uncheckedTitleFont: .systemFont(ofSize: 10.0, weight: .regular), titleColor: .red, checkedIcon: nil, uncheckedIcon: nil, provider: self, actions: self))
        configFiles.append(controller.getBasicTitleTableCellConfigFile(section: 0, identifier: 11, title: "basic title", attributedTitle: nil, font: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .blue, textAlignment: .center, numberOfLines: 0, backgroundColor: .gray, leftMargin: 0, rightMargin: 0, topMargin: 0, bottomMargin: 0, customLineSpacing: nil, accessibilityInfo: nil, actions: nil))
        
        datasource.configFiles = configFiles
        datasource.reload()
    }
    
    @objc func helloWorld() {
        print("hello world")
    }
}

extension ViewController: GenericTableActions {
    
}

extension ViewController: TextTableProvider {
    func getTextTableText(forIdentifier identifier: Any) -> TextTableCellType {
        return .normal(text: "Hola Mundo", font: .systemFont(ofSize: 16.0, weight: .bold), titleColor: .red, textAlignment: .center)
    }
}

extension ViewController: BasicCheckTableProvider {
    func getCheckIsChecked(forIdentifier identifier: Any) -> Bool {
        true
    }
    
    func getCheckTitle(forIdentifier identifier: Any) -> String {
        "Check Title"
    }
}

extension ViewController: BasicCheckTableActions {
    func tapOnCheck(forIdentifier identifier: Any) {
        print("checked")
    }
}
