//
//  TableViewSharedCellsController.swift
//  Nimble
//
//  Created by Santiago Delgado on 26/03/21.
//

import SnazzyAccessibility
import UIKit

final public class SLTableViewSharedCellsController {
    public init() {}
    
    // MARK: - Separator cells -
    /// This cell will fit the cases were you need to show or add spacings in the table view, or if you need to add lines for separations as well.
    /// The size can be define for yours needs.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/SpacingTableCell.png?raw=true
    public func getSpacingTableCellConfigFile(height: CGFloat, section: Int, lineColor: UIColor, backgroundColor: UIColor, leftMargin: CGFloat, rightMargin: CGFloat) -> GenericTableCellConfigurator {
        let item = SpacingTableCellConfigFile(lineColor: lineColor, backgroundColor: backgroundColor, leftMargin: leftMargin, rightMargin: rightMargin)
        
        return GenericTableCellConfigurator(classType: SpacingTableCell.self, item: item, section: section, sizingType: .specificHeight(height))
    }
    
    // MARK: - Separator cells -
    /// This cell will fit the cases were you need to show a Text for the user, but it may change depending on something else on the screen, in that case this will be a good fit, because you can pass the text dinamycally and just by reloading the tableview it will be displayed.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextTableCell.png?raw=true
    public func getTextTableCellConfigFile(section: Int, identifier: Any, backgroundColor: UIColor, leftMargin: CGFloat, rightMargin: CGFloat, topMargin: CGFloat, bottomMargin: CGFloat, provider: TextTableProvider?, actions: TextTableActions?) -> GenericTableCellConfigurator {
        let item = TextTableCellConfigFile(identifier: identifier, backgroundColor: backgroundColor, leftMargin: leftMargin, rightMargin: rightMargin, topMargin: topMargin, bottomMargin: bottomMargin, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: TextTableCell.self, item: item, section: section)
    }
    
    /// This cell will fit the cases were you need to show a TextField so the user can enter information. This is the basic one, if you need one more complex with title, you should use TextFieldFormattedInputTableCell or FormEntryTextTitledTableCell.
    /// The size can be define for yours needs.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextFieldEntryTableCell.png?raw=true
    public func getTextFieldEntryTableCellConfigFile(section: Int, identifier: Any, titleFont: UIFont, titleColor: UIColor, backgroundColor: UIColor, borderColor: UIColor, placeholder: String, placeholderFont: UIFont?, placeholderTextColor: UIColor, maxLength: Int?, cornerRadius: CGFloat, keyboardType: UIKeyboardType, autocapitalizationType: UITextAutocapitalizationType, autocorrectionType: UITextAutocorrectionType, returnKeyType: UIReturnKeyType, showClearButton: Bool, provider: TextFieldEntryTableProvider?, actions: TextFieldEntryTableActions?) -> GenericTableCellConfigurator {
        let item = TextFieldEntryTableCellConfigFile(identifier: identifier, titleFont: titleFont, titleColor: titleColor, backgroundColor: backgroundColor, borderColor: borderColor, placeholder: placeholder, placeholderFont: placeholderFont, placeholderTextColor: placeholderTextColor, maxLength: maxLength, cornerRadius: cornerRadius, keyboardType: keyboardType, autocapitalizationType: autocapitalizationType, autocorrectionType: autocorrectionType, returnKeyType: returnKeyType, showClearButton: showClearButton, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: TextFieldEntryTableCell.self, item: item, section: section)
    }
    
    /// This cell will fit the cases were you need to show a check with text.
    /// The behavior of this cell is hardcoded, and what i mean by that, is that when it's selected the font will be bold and when is not, the font will be book, so if it does not fit your needs, then you shouldn't use this cell and you may be interested in BasicCheckAlternativeTableCell.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicCheckTableCell.png?raw=true
    public func getBasicCheckTableCellConfigFile(section: Int, identifier: Any, isEditable: Bool, checkedTitleFont: UIFont, uncheckedTitleFont: UIFont, titleColor: UIColor, checkedIcon: UIImage?, uncheckedIcon: UIImage?, provider: BasicCheckTableProvider?, actions: BasicCheckTableActions?) -> GenericTableCellConfigurator {
        let item = BasicCheckTableCellConfigFile(identifier: identifier, isEditable: isEditable, checkedTitleFont: checkedTitleFont, uncheckedTitleFont: uncheckedTitleFont, titleColor: titleColor, checkedIcon: checkedIcon, uncheckedIcon: uncheckedIcon, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: BasicCheckTableCell.self, item: item, section: section)
    }
    
    // MARK: - Button -
    /// This cell will fit the cases were you need to show a button that it will always be enabled. If that's the case then this will be a good fit, if the button can be dynamically change from enable to disable depending on the context, then you should take a look at ComplexButtonTableCell.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicButtonTableCell.png?raw=true
    public func getBasicButtonTableCell(section: Int, title: String, textColor: UIColor, backgroundColor: UIColor, target: Any?, action: Selector, underline: Bool, font: UIFont, leftMargin: CGFloat, rightMargin: CGFloat, buttonHeight: CGFloat, accessibilityInfo: AccessibilityInfo?) -> GenericTableCellConfigurator {
        let item = BasicButtonTableCellConfigFile(title: title, backgroundColor: backgroundColor, textColor: textColor, selector: action, target: target, underline: underline, font: font, leftMargin: leftMargin, rightMargin: rightMargin, buttonHeight: buttonHeight)
        
        return GenericTableCellConfigurator(classType: BasicButtonTableCell.self, item: item, section: section, accessibilityInfo: accessibilityInfo)
    }
    
    /// This cell will fit the cases were you need to show a normal text for the user.
    /// The font can be defined and you can even add a callback for action if needed.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicTitleTableCell.png?raw=true
    public func getBasicTitleTableCellConfigFile(section: Int, identifier: Any, title: String, attributedTitle: NSAttributedString?, font: UIFont, titleColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int, backgroundColor: UIColor, leftMargin: CGFloat, rightMargin: CGFloat, topMargin: CGFloat, bottomMargin: CGFloat, customLineSpacing: CGFloat?, accessibilityInfo: AccessibilityInfo?, actions: BasicTitleTableCellActions?) -> GenericTableCellConfigurator {
        let item = BasicTitleTableCellConfigFile(identifier: identifier, title: title, attributedTitle: attributedTitle, font: font, titleColor: titleColor, textAlignment: textAlignment, numberOfLines: numberOfLines, backgroundColor: backgroundColor, leftMargin: leftMargin, rightMargin: rightMargin, topMargin: topMargin, bottomMargin: bottomMargin, customLineSpacing: customLineSpacing, actions: actions)

        return GenericTableCellConfigurator(classType: BasicTitleTableCell.self, item: item, section: section, accessibilityInfo: accessibilityInfo)
    }

    /// This cell will fit the cases were you need to show a dropdown, the dropdown can be full screen or partial screen depending on the title.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/DropdownOptionSelectionTableCell.png?raw=true
    public func getDropdownOptionSelectionTableCellConfigFile(identifier: Any, title: String, titleColor: UIColor, titleFont: UIFont, optionColor: UIColor, optionFont: UIFont, downArrowImage: UIImage?, titleLineColor: UIColor, isEditable: Bool, adjustableToTitle: Bool, section: Int, provider: DropdownOptionSelectionTableProvider?, actions: DropdownOptionSelectionTableActions?) -> GenericTableCellConfigurator {
        let item = DropdownOptionSelectionTableCellConfigFile(identifier: identifier, title: title, titleColor: titleColor, titleFont: titleFont, optionColor: optionColor, optionFont: optionFont, downArrowImage: downArrowImage, titleLineColor: titleLineColor, isEditable: isEditable, adjustableToTitle: adjustableToTitle, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: DropdownOptionSelectionTableCell.self, item: item, section: section, sizingType: .specificHeight(84))
    }
    
    /// This cell will fit the cases were you need to show a slider for selecting between numbers, the range is defined by you.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/SliderTableCell.png?raw=true
    public func getSliderTableCell(section: Int, identifier: Any, isEditable: Bool, leftNumberFont: UIFont, leftNumberColor: UIColor, rightNumberFont: UIFont, rightNumberColor: UIColor, resultNumberFont: UIFont, resultNumberColor: UIColor, resultUnderlineColor: UIColor, gradientSliderColors: [CGColor], provider: SliderTableProvider?, actions: SliderTableActions?) -> GenericTableCellConfigurator {
        let item = SliderTableCellConfigFile(identifier: identifier, isEditable: isEditable, leftNumberFont: leftNumberFont, leftNumberColor: leftNumberColor, rightNumberFont: rightNumberFont, rightNumberColor: rightNumberColor, resultNumberFont: resultNumberFont, resultNumberColor: resultNumberColor, resultUnderlineColor: resultUnderlineColor, gradientSliderColors: gradientSliderColors, provider: provider, actions: actions)

        return GenericTableCellConfigurator(classType: SliderTableCell.self, item: item, section: section)
    }
}
