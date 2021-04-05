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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadViewController() {
//        setupAccessibilityIdentifiersForViewProperties()
//
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
        let controller = TableViewSharedCellsController()
        
        configFiles.append(controller.getSpacingTableCellConfigFile(height: 50.0, section: 0, lineColor: .green, backgroundColor: .blue))
        configFiles.append(controller.getTextTableCellConfigFile(section: 0, identifier: 1, backgroundColor: .clear, leftMargin: 0.0, rightMargin: 0.0, topMargin: 0.0, bottomMargin: 0.0, provider: self, actions: nil) )
        configFiles.append(controller.getTextFieldEntryTableCellConfigFile(section: 0, identifier: 2, titleFont: .systemFont(ofSize: 12.0, weight: .regular), titleColor: .green, placeholder: "Thats all...", maxLength: nil, cornerRadius: 10.0, keyboardType: .alphabet, autocapitalizationType: .allCharacters, autocorrectionType: .no, returnKeyType: .default, showClearButton: true, provider: nil, actions: nil))
        configFiles.append(controller.getTextViewEntryTableCellConfigFile(section: 0, identifier: 3, entryTextFont: .systemFont(ofSize: 12.0, weight: .regular), entryTextColor: .blue, height: 80, placeholder: "Message", maxLength: nil, isEditable: true, spellChecking: true, provider: nil, actions: nil))
        configFiles.append(controller.getTextFieldFormattedInputTableCell(section: 0, identifier: 4, title: "Hello world 2", titleFont: .systemFont(ofSize: 12.0, weight: .regular), titleColor: .red, entryTextFont: .systemFont(ofSize: 12.0, weight: .regular), entryTextColor: .gray, entryPlaceholderFont: .systemFont(ofSize: 12.0, weight: .regular), entryPlaceholderColor: .black, isSecure: true, isEditable: true, textFormat: nil, keyboardType: .alphabet, returnKeyType: .default, autocapitalizationType: .allCharacters, allowedSymbolRegex: nil, shouldShowEye: true, bottomLineColor: .green, bottomLineHeight: 5.0, shouldSkipSpaces: false, accessibilityInfo: nil, provider: nil, actions: nil))
        configFiles.append(controller.getTextWithRightButtonTableCell(section: 0, identifier: 5, text: "Santi", textColor: .green, textFont: .systemFont(ofSize: 12.0, weight: .regular), buttonTitle: "Title button", buttonBackgroundColor: .red, buttonShouldHaveRoundedBorders: true, backgroundColor: .blue, actions: self, provider: nil))
        configFiles.append(controller.getTitleWithValueTableCell(section: 0, title: "New title", titleFont: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .orange, value: "new value", valueFont: .systemFont(ofSize: 12.0, weight: .semibold), valueColor: .yellow))
        
        configFiles.append(controller.getBasicButtonTableCell(section: 0, title: "boton basico", textColor: .blue, backgroundColor: .black, target: nil, action: #selector(helloWorld), underline: false, font: .systemFont(ofSize: 12.0, weight: .regular), leftMargin: 0.0, rightMargin: 0.0, buttonHeight: 40.0, accessibilityInfo: nil))
        configFiles.append(controller.getBasicCheckAlternativeTableCellConfigFile(section: 0, identifier: 6, title: "Alternative cell", font: .systemFont(ofSize: 12.0, weight: .bold), textColor: .black, textCustomSpacing: nil, isEditable: true, checkedIcon: nil, uncheckedIcon: nil, provider: nil, actions: nil))
        configFiles.append(controller.getBasicCheckAlternativeSecondTableCellConfigFile(section: 0, identifier: "7", title: "Secondary cell", titleColor: .black, checkedTitleFont: .systemFont(ofSize: 12.0, weight: .bold), uncheckedTitleFont: .systemFont(ofSize: 12.0, weight: .bold), checkedBorderColor: .green, uncheckedBorderColor: .white, provider: nil, actions: nil))
        configFiles.append(controller.getBasicCheckTableCellConfigFile(section: 0, identifier: 8, isEditable: true, checkedTitleFont: .systemFont(ofSize: 12.0, weight: .bold), uncheckedTitleFont: .systemFont(ofSize: 10.0, weight: .regular), titleColor: .red, checkedIcon: nil, uncheckedIcon: nil, provider: self, actions: nil))
        
        configFiles.append(controller.getBasicDoubleButtonSelectionTableCell(section: 0, identifier: 9, leftTitle: "Left title", rightTitle: "Right title", buttonsFont: .systemFont(ofSize: 12.0, weight: .bold), buttonsTitleColor: .red, buttonsBackgroundColor: .white, buttonsSelectedFont: .systemFont(ofSize: 12.0, weight: .regular), buttonsSelectedTitleColor: .blue, buttonsSelectedBackgroundColor: .gray, buttonsHeight: 30.0, provider: nil, actions: nil))
        configFiles.append(controller.getBasicDoubleTitleTableCellConfigFile(section: 0, identifier: 10, leftTitle: "Left title", leftFont: .systemFont(ofSize: 12.0, weight: .bold), leftTitleColor: .blue, rightTitle: "Right title", rightFont: .systemFont(ofSize: 12.0, weight: .bold), rightTitleColor: .green, backgroundColor: .gray, leftMargin: 0.0, rightMargin: 0.0, topMargin: 0.0, bottomMargin: 0.0, accessibilityInfo: nil, actions: nil, sizingType: .automatic))
        
        configFiles.append(controller.getBasicTitleTableCellConfigFile(section: 0, identifier: 11, title: "basic title", attributedTitle: nil, font: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .blue, textAlignment: .center, numberOfLines: 0, backgroundColor: .gray, leftMargin: 0, rightMargin: 0, topMargin: 0, bottomMargin: 0, customLineSpacing: nil, accessibilityInfo: nil, actions: nil))
        configFiles.append(controller.getBorderedButtonDisclosureTableCell(section: 0, identifier: 12, title: "Bordered button", titleFont: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .blue, containerColor: .blue, disclosureImage: nil, actions: nil))
        configFiles.append(controller.getBorderedTextTableCell(section: 0, title: "13", font: .systemFont(ofSize: 12.0, weight: .bold), titleColor: .red, textAlignment: .center, backgroundColor: .darkGray, containerBackgroundColor: .darkGray, containerBorderColor: .darkGray, leftMargin: 0, rightMargin: 0, customLineSpacing: nil))
        
        configFiles.append(controller.getComplexButtonTableCell(section: 0, identifier: 14, title: "Complex Button", font: .systemFont(ofSize: 12.0, weight: .bold), textColor: .blue, backgroundColor: .yellow, textColorDisabled: .lightGray, backgroundColorDisabled: .darkGray, target: nil, action: #selector(helloWorld), provider: nil))
        configFiles.append(controller.getComplexDoubleButtonTableCell(section: 0, identifier: 15, leftTitle: "Complex double button", leftFont: .systemFont(ofSize: 12.0, weight: .bold), leftTextColor: .red, leftBackgroundColor: .blue, leftTextColorDisabled: .gray, leftBackgroundColorDisabled: .lightGray, leftTarget: nil, leftAction: #selector(helloWorld), rightTitle: "right button", rightFont: .systemFont(ofSize: 14.0, weight: .regular), rightTextColor: .blue, rightBackgroundColor: .red, rightTextColorDisabled: .lightGray, rightBackgroundColorDisabled: .darkGray, rightTarget: nil, rightAction: #selector(helloWorld), provider: nil))
        
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

extension ViewController: TextWithRightButtonTableCellActions {
    func tapTextWithRightButtonActionButton(withIdentifier identifier: Any?) {
        print("Tap on button!!")
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
