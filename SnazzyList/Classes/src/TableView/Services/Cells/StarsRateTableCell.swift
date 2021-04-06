//
//  StarsRateTableCell.swift
//  Dms
//
//  Created by Kevin on 12/19/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show stars for displaying some kind of ratings from 1 to 5.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/StarsRateTableCell.png?raw=true
final class StarsRateTableCell: UITableViewCell {
    private let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 20.0)
    private var starsButtons = [UIButton]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapStar(button: UIButton) {
        guard let configFile = self.configFile else { return }
        
        let starNumber = button.tag + 1
        configFile.actions?.tapStar(number: starNumber, forIdentifier: configFile.identifier)
        configureStarsSelection()
    }
    
    private var configFile: StarsRateTableCellConfigFile?
}

extension StarsRateTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? StarsRateTableCellConfigFile else { return }
        self.configFile = configFile
        
        configureStarsSelection()
    }
    
    private func configureStarsSelection() {
        guard let configFile = self.configFile else { return }
        
        for index in 0...4 {
            let starImage = configFile.starEmptyImage ?? UIImage(named: "star_gray", in: Bundle.resourceBundle(for: StarsRateTableCell.self), compatibleWith: nil)
            starsButtons[index].setImage(starImage, for: .normal)
        }
        
        guard let starSelectedNumber = configFile.provider?.getStarNumberSelected(forIdentifier: configFile.identifier),
            starsButtons.count - 1 >= starSelectedNumber - 1 else { return }
        
        for index in 0...starSelectedNumber-1 {
            let starImage: UIImage?
            
            if starSelectedNumber > 3 {
                starImage = configFile.starMoreThan3SelectedImage ?? UIImage(named: "star_gold", in: Bundle.resourceBundle(for: StarsRateTableCell.self), compatibleWith: nil)
            } else {
                starImage = configFile.starLessThan3SelectedImage ?? UIImage(named: "star_blue", in: Bundle.resourceBundle(for: StarsRateTableCell.self), compatibleWith: nil)
            }
                
            starsButtons[index].setImage(starImage, for: .normal)
        }
    }
}

private extension StarsRateTableCell {
    private func setupViews() {
        setupBackground()
        setupStackView()
        setupStarsButtons()
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
    }
    
    private func setupStarsButtons() {
        for index in 0...4 {
            let button = UIButton(image: UIImage(named: "star_gray", in: Bundle.resourceBundle(for: StarsRateTableCell.self), compatibleWith: nil)!, contentMode: .scaleAspectFit)
            button.tag = index
            button.addTarget(self, action: #selector(StarsRateTableCell.tapStar(button:)), for: .touchUpInside)
            button.assignSize(width: 42.0, height: 42.0)
            stackView.addArrangedSubview(button)
            starsButtons.append(button)
        }
    }
    
    private func setupConstraints() {
        stackView.bind(withConstant: 8.0, boundType: .vertical)
        stackView.assignSize(height: 42.0)
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
}

struct StarsRateTableCellConfigFile {
    let identifier: Any
    let starEmptyImage: UIImage?
    let starMoreThan3SelectedImage: UIImage?
    let starLessThan3SelectedImage: UIImage?
    
    weak var provider: StarsRateTableCellProvider?
    weak var actions: StarsRateTableCellActions?
    
    init(identifier: Any, starEmptyImage: UIImage?, starMoreThan3SelectedImage: UIImage?, starLessThan3SelectedImage: UIImage?, provider: StarsRateTableCellProvider?, actions: StarsRateTableCellActions?) {
        self.identifier = identifier
        self.starEmptyImage = starEmptyImage
        self.starMoreThan3SelectedImage = starMoreThan3SelectedImage
        self.starLessThan3SelectedImage = starLessThan3SelectedImage
        
        self.provider = provider
        self.actions = actions
    }
}

public protocol StarsRateTableCellProvider: class {
    func getStarNumberSelected(forIdentifier identifier: Any) -> Int?
}

public protocol StarsRateTableCellActions: class {
    func tapStar(number: Int, forIdentifier identifier: Any)
}
