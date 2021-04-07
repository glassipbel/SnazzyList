//
//  SliderTableCell.swift
//  Dms
//
//  Created by Kevin on 11/22/18.
//  Copyright © 2018 DMS. All rights reserved.
//

/// This cell will fit the cases were you need to show a slider for selecting between numbers, the range is defined by you.
/// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/SliderTableCell.png?raw=true
final class SliderTableCell: UITableViewCell {
    private let sliderBackgroundView = UIView(backgroundColor: .clear)
    private let sliderView = UISlider(backgroundColor: .white)
    private let leftNumberLabel = UILabel(font: .systemFont(ofSize: 17.0, weight: .bold), textColor: .darkGray, textAlignment: .center)
    private let rightNumberLabel = UILabel(font: .systemFont(ofSize: 17.0, weight: .bold), textColor: .darkGray, textAlignment: .center)
    private let resultNumberLabel = UILabel(font: .systemFont(ofSize: 34.0, weight: .medium), textColor: .darkGray, textAlignment: .center)
    private let resultBottomLineView = UIView(backgroundColor: .darkGray)
    private let sliderBackgroundViewGradientLayer = CAGradientLayer()
    private let scrimView = UIView(backgroundColor: UIColor.white.withAlphaComponent(0.6))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        contentView.layoutIfNeeded()
        sliderBackgroundViewGradientLayer.frame = sliderBackgroundView.bounds
        CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderValueChanged() {
        guard let configFile = self.configFile else { return }
        
        let newValue = sliderView.value.rounded(.toNearestOrEven)
        if let previousValue = configFile.provider?.getSliderSelectedValue(forIdentifier: configFile.identifier) {
            if previousValue != newValue {
                UISelectionFeedbackGenerator().selectionChanged()
            }
        }
        
        configFile.actions?.onSliderValueChanged(withIdentifier: configFile.identifier, value: newValue)
        resultNumberLabel.text = String(format: "%.0f", newValue)
        sliderView.setValue(newValue, animated: true)
    }
    
    private var configFile: SliderTableCellConfigFile?
}

extension SliderTableCell: GenericTableCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, with item: Any) {
        guard let configFile = item as? SliderTableCellConfigFile else { return }
        self.configFile = configFile
        
        let minimumValue: Float = configFile.provider?.getSliderMinimumValue(forIdentifier: configFile.identifier) ?? 0
        let maximumValue: Float = configFile.provider?.getSliderMaximumValue(forIdentifier: configFile.identifier) ?? 0
        let selectedValue: Float = configFile.provider?.getSliderSelectedValue(forIdentifier: configFile.identifier) ?? 0
        
        sliderView.minimumValue = minimumValue
        sliderView.maximumValue = maximumValue
        sliderView.setValue(selectedValue.rounded(.toNearestOrEven), animated: false)
        sliderView.setNeedsDisplay()
        leftNumberLabel.text = String(format: "%.0f", minimumValue)
        leftNumberLabel.font = configFile.leftNumberFont
        leftNumberLabel.textColor = configFile.leftNumberColor
        rightNumberLabel.text = String(format: "%.0f", maximumValue)
        rightNumberLabel.font = configFile.rightNumberFont
        rightNumberLabel.textColor = configFile.rightNumberColor
        resultNumberLabel.text = String(format: "%.0f", selectedValue)
        resultNumberLabel.font = configFile.resultNumberFont
        resultNumberLabel.textColor = configFile.resultNumberColor
        sliderView.isUserInteractionEnabled = configFile.isEditable
        scrimView.isHidden = configFile.isEditable
        resultBottomLineView.backgroundColor = configFile.resultUnderlineColor
        
        if !configFile.gradientSliderColors.isEmpty {
            sliderBackgroundViewGradientLayer.colors = configFile.gradientSliderColors
        }
    }
}

extension SliderTableCell {
    private func setupViews() {
        setupBackground()
        setupLeftNumberLabel()
        setupRightNumberLabel()
        setupResultNumberLabel()
        setupResultBottomLineView()
        setupSliderBackgroundView()
        setupSliderView()
        setupScrimView()
    }
    
    private func setupSliderBackgroundView() {
        sliderBackgroundViewGradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor]
        sliderBackgroundViewGradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        sliderBackgroundViewGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        sliderBackgroundView.layer.addSublayer(sliderBackgroundViewGradientLayer)
        sliderBackgroundView.layer.cornerRadius = 5.0
        contentView.addSubview(sliderBackgroundView)
    }
    
    private func setupSliderView() {
        sliderView.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        sliderView.isContinuous = true
        sliderView.setThumbImage(#imageLiteral(resourceName: "slider_dot"), for: .normal)
        sliderView.tintColor = .clear
        sliderView.minimumTrackTintColor = .clear
        sliderView.maximumTrackTintColor = .clear
        sliderView.backgroundColor = .clear
        contentView.addSubview(sliderView)
    }
    
    private func setupLeftNumberLabel() {
        leftNumberLabel.numberOfLines = 1
        contentView.addSubview(leftNumberLabel)
    }
    
    private func setupRightNumberLabel() {
        rightNumberLabel.numberOfLines = 1
        contentView.addSubview(rightNumberLabel)
    }
    
    private func setupResultNumberLabel() {
        resultNumberLabel.numberOfLines = 1
        contentView.addSubview(resultNumberLabel)
    }
    
    private func setupResultBottomLineView() {
        contentView.addSubview(resultBottomLineView)
    }
    
    private func setupScrimView() {
        contentView.addSubview(scrimView)
    }
    
    private func setupConstraints() {
        sliderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0).isActive = true
        sliderView.leftAnchor.constraint(equalTo: leftNumberLabel.rightAnchor, constant: 14.0).isActive = true
        sliderView.rightAnchor.constraint(equalTo: rightNumberLabel.leftAnchor, constant: -14.0).isActive = true
        sliderView.assignSize(height: 42.0)
        
        sliderBackgroundView.assignSize(height: 10)
        sliderBackgroundView.leftAnchor.constraint(equalTo: sliderView.leftAnchor).isActive = true
        sliderBackgroundView.rightAnchor.constraint(equalTo: sliderView.rightAnchor).isActive = true
        sliderBackgroundView.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor).isActive = true
        
        leftNumberLabel.setContentHuggingPriority(.max, for: .horizontal)
        leftNumberLabel.setContentCompressionResistancePriority(.max, for: .horizontal)
        leftNumberLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24.0).isActive = true
        leftNumberLabel.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor).isActive = true
        
        rightNumberLabel.setContentHuggingPriority(.max, for: .horizontal)
        rightNumberLabel.setContentCompressionResistancePriority(.max, for: .horizontal)
        rightNumberLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24.0).isActive = true
        rightNumberLabel.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor).isActive = true
        
        resultNumberLabel.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor).isActive = true
        resultNumberLabel.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 15.0).isActive = true
        
        resultBottomLineView.topAnchor.constraint(equalTo: resultNumberLabel.bottomAnchor, constant: 15.0).isActive = true
        resultBottomLineView.assignSize(height: 1.0)
        resultBottomLineView.leftAnchor.constraint(equalTo: resultNumberLabel.leftAnchor, constant: -24.0).isActive = true
        resultBottomLineView.rightAnchor.constraint(equalTo: resultNumberLabel.rightAnchor, constant: 24.0).isActive = true
        resultBottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0).isActive = true
        
        scrimView.bind(withConstant: 0.0, boundType: .full)
    }
}

struct SliderTableCellConfigFile {
    let identifier: Any
    let isEditable: Bool
    let leftNumberFont: UIFont
    let leftNumberColor: UIColor
    let rightNumberFont: UIFont
    let rightNumberColor: UIColor
    let resultNumberFont: UIFont
    let resultNumberColor: UIColor
    let resultUnderlineColor: UIColor
    let gradientSliderColors: [CGColor]
    
    weak var provider: SliderTableProvider?
    weak var actions: SliderTableActions?
    
    init(identifier: Any, isEditable: Bool, leftNumberFont: UIFont, leftNumberColor: UIColor, rightNumberFont: UIFont, rightNumberColor: UIColor, resultNumberFont: UIFont, resultNumberColor: UIColor, resultUnderlineColor: UIColor, gradientSliderColors: [CGColor], provider: SliderTableProvider?, actions: SliderTableActions?) {
        self.identifier = identifier
        self.isEditable = isEditable
        self.leftNumberFont = leftNumberFont
        self.leftNumberColor = leftNumberColor
        self.rightNumberFont = rightNumberFont
        self.rightNumberColor = rightNumberColor
        self.resultNumberFont = resultNumberFont
        self.resultNumberColor = resultNumberColor
        self.resultUnderlineColor = resultUnderlineColor
        self.gradientSliderColors = gradientSliderColors
        
        self.provider = provider
        self.actions = actions
    }
}

public protocol SliderTableProvider: class {
    func getSliderMinimumValue(forIdentifier identifier: Any) -> Float
    func getSliderMaximumValue(forIdentifier identifier: Any) -> Float
    func getSliderSelectedValue(forIdentifier identifier: Any) -> Float
}

public protocol SliderTableActions: class {
    func onSliderValueChanged(withIdentifier identifier: Any, value: Float)
}
