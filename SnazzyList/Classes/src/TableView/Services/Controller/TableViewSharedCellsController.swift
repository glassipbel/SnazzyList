//
//  TableViewSharedCellsController.swift
//  Nimble
//
//  Created by Santiago Delgado on 26/03/21.
//

import SnazzyAccessibility
import UIKit

final public class TableViewSharedCellsController {

    public init() {}
    
    // MARK: - Separator cells -
    /// This cell will fit the cases were you need to show or add spacings in the table view, or if you need to add lines for separations as well.
    /// The size can be define for yours needs.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/SpacingTableCell.png?raw=true
    public func getSpacingTableCellConfigFile(height: CGFloat, section: Int, lineColor: UIColor = .clear, backgroundColor: UIColor, leftMargin: CGFloat = 0.0, rightMargin: CGFloat = 0.0) -> GenericTableCellConfigurator {
        let item = SpacingTableCellConfigFile(lineColor: lineColor, backgroundColor: backgroundColor, leftMargin: leftMargin, rightMargin: rightMargin)
        
        return GenericTableCellConfigurator(classType: SpacingTableCell.self, item: item, section: section, sizingType: .specificHeight(height))
    }
    
    // MARK: - Separator cells -
    /// This cell will fit the cases were you need to show a Text for the user, but it may change depending on something else on the screen, in that case this will be a good fit, because you can pass the text dinamycally and just by reloading the tableview it will be displayed.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextTableCell.png?raw=true
    public func getTextTableCellConfigFile(section: Int, identifier: Any, backgroundColor: UIColor = .white, leftMargin: CGFloat = 24.0, rightMargin: CGFloat = 24.0, topMargin: CGFloat = 0.0, bottomMargin: CGFloat = 0.0, provider: TextTableProvider?, actions: TextTableActions?) -> GenericTableCellConfigurator {
        let item = TextTableCellConfigFile(identifier: identifier, backgroundColor: backgroundColor, leftMargin: leftMargin, rightMargin: rightMargin, topMargin: topMargin, bottomMargin: bottomMargin, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: TextTableCell.self, item: item, section: section)
    }
    
    /// This cell will fit the cases were you need to show a TextField so the user can enter information. This is the basic one, if you need one more complex with title, you should use TextFieldFormattedInputTableCell or FormEntryTextTitledTableCell.
    /// The size can be define for yours needs.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextFieldEntryTableCell.png?raw=true
    public func getTextFieldEntryTableCellConfigFile(section: Int, identifier: Any, titleFont: UIFont, titleColor: UIColor, placeholder: String, maxLength: Int?, cornerRadius: CGFloat = 0.0, keyboardType: UIKeyboardType = .default, autocapitalizationType: UITextAutocapitalizationType = .sentences, autocorrectionType: UITextAutocorrectionType = .default, returnKeyType: UIReturnKeyType = .default, showClearButton: Bool = false, provider: TextFieldEntryTableProvider?, actions: TextFieldEntryTableActions?) -> GenericTableCellConfigurator {
        let item = TextFieldEntryTableCellConfigFile(identifier: identifier, titleFont: titleFont, titleColor: titleColor, placeholder: placeholder, maxLength: maxLength, cornerRadius: cornerRadius, keyboardType: keyboardType, autocapitalizationType: autocapitalizationType, autocorrectionType: autocorrectionType, returnKeyType: returnKeyType, showClearButton: showClearButton, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: TextFieldEntryTableCell.self, item: item, section: section)
    }
    
    /// This cell will fit the cases were you need to show a TextView so the user can enter information.
    /// The size can be define for yours needs, it can also contain an scrim so you can use it as read only mode as well.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextViewEntryTableCell.png?raw=true
    public func getTextViewEntryTableCellConfigFile(section: Int, identifier: Any, entryTextFont:UIFont, entryTextColor: UIColor,  height: CGFloat, placeholder: String, maxLength: Int? = nil, isEditable: Bool = true, spellChecking: Bool = false, provider: TextViewEntryTableProvider?, actions: TextViewEntryTableActions?) -> GenericTableCellConfigurator {
        let item = TextViewEntryTableCellConfigFile(identifier: identifier, entryTextFont: entryTextFont, entryTextColor: entryTextColor, placeholder: placeholder, maxLength: maxLength, isEditable: isEditable, spellChecking: spellChecking, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: TextViewEntryTableCell.self, item: item, section: section, sizingType: .specificHeight(height))
    }
    
    /// This cell will fit the cases were you need to show TextField for your user to input data with a title on top but also having a format attach to it, for example like a number (123) 123-4567 or even sending a regex for the allowed characters (for example just numbers) it will also work when you need to input secure text.
    /// We also have another type of cell TextFieldFormattedInputTableCell that may fit your needs better.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextFieldFormattedInputTableCell.png?raw=true
    /// Screenshot 2: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TextFieldFormattedInputTableCell2.png?raw=true
    public func getTextFieldFormattedInputTableCell(section: Int, identifier: Any, title: String, titleFont: UIFont, titleColor: UIColor, entryTextFont: UIFont, entryTextColor: UIColor, entryPlaceholderFont: UIFont, entryPlaceholderColor: UIColor, isSecure: Bool, secureOnIcon: UIImage? = nil, secureOffIcon: UIImage? = nil, isEditable: Bool = true, textFormat: String?, keyboardType: UIKeyboardType, returnKeyType: UIReturnKeyType, autocapitalizationType: UITextAutocapitalizationType, allowedSymbolRegex: String? = nil, shouldShowEye: Bool? = nil, bottomLineColor: UIColor, bottomLineHeight: CGFloat = 2, shouldSkipSpaces: Bool = true, accessibilityInfo: AccessibilityInfo? = nil, provider: TextFieldFormattedInputTableProvider?, actions: TextFieldFormattedInputTableActions?) -> GenericTableCellConfigurator {
        let item = TextFieldFormattedInputTableCellConfigFile(identifier: identifier, title: title, titleFont: titleFont, titleColor: titleColor, entryTextFont: entryTextFont, entryTextColor: entryTextColor, entryPlaceholderFont: entryPlaceholderFont, entryPlaceholderColor: entryPlaceholderColor, isSecure: isSecure, secureOnIcon: secureOnIcon, secureOffIcon: secureOffIcon, isEditable: isEditable, textFormat: textFormat, keyboardType: keyboardType, returnKeyType: returnKeyType, autocapitalizationType: autocapitalizationType, allowedSymbolRegex: allowedSymbolRegex, shouldShowEye: shouldShowEye ?? isSecure, bottomLineColor: bottomLineColor, bottomLineHeight: bottomLineHeight, shouldSkipSpaces: shouldSkipSpaces, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: TextFieldFormattedInputTableCell.self, item: item, section: section, accessibilityInfo: accessibilityInfo)
    }
    
    /// This cell will fit the cases were you need to show text with  right  button
    public func getTextWithRightButtonTableCell(section: Int, identifier: Any?, text: String, textColor: UIColor, textFont: UIFont, buttonTitle: String, buttonTextColor: UIColor = .white, buttonBackgroundColor: UIColor, buttonShouldHaveRoundedBorders: Bool, backgroundColor: UIColor, actions: TextWithRightButtonTableCellActions?, provider: TextWithRightButtonTableCellProvider?) -> GenericTableCellConfigurator {
        let item = TextWithRightButtonTableCellConfigFile(identifier: identifier, text: text, textColor: textColor, textFont: textFont, buttonTitle: buttonTitle, buttonTextColor: buttonTextColor, buttonBackgroundColor: buttonBackgroundColor, buttonShouldHaveRoundedBorders: buttonShouldHaveRoundedBorders, backgroundColor: backgroundColor, actions: actions, provider: provider)
        
        return GenericTableCellConfigurator(classType: TextWithRightButtonTableCell.self, item: item, section: section)
    }
    
    /// This cell will fit the cases were you need to show a cell with a title and value, title aligned to the left and the value to the right.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/TitleWithValueTableCell.png?raw=true
    public func getTitleWithValueTableCell(section: Int, title: String, titleFont: UIFont, titleColor: UIColor, value: String, valueFont: UIFont, valueColor: UIColor) -> GenericTableCellConfigurator {
        let item = TitleWithValueTableCellConfigFile(title: title, titleFont: titleFont, titleColor: titleColor, value: value, valueFont: valueFont, valueColor: valueColor)
        
        return GenericTableCellConfigurator(classType: TitleWithValueTableCell.self, item: item, section: section)
    }
    
    /// This cell will fit the cases were you need to show a check with text.
    /// The behavior of this cell is hardcoded, and what i mean by that, is that when it's selected the font will be bold and when is not, the font will be book, so if it does not fit your needs, then you shouldn't use this cell and you may be interested in BasicCheckAlternativeTableCell.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicCheckTableCell.png?raw=true
    public func getBasicCheckTableCellConfigFile(section: Int, identifier: Any, isEditable: Bool = true, checkedTitleFont: UIFont, uncheckedTitleFont: UIFont, titleColor: UIColor, checkedIcon: UIImage? = nil, uncheckedIcon: UIImage? = nil, provider: BasicCheckTableProvider?, actions: BasicCheckTableActions?) -> GenericTableCellConfigurator {
        let item = BasicCheckTableCellConfigFile(identifier: identifier, isEditable: isEditable, checkedTitleFont: checkedTitleFont, uncheckedTitleFont: uncheckedTitleFont, titleColor: titleColor, checkedIcon: checkedIcon, uncheckedIcon: uncheckedIcon, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: BasicCheckTableCell.self, item: item, section: section)
    }
    
    // MARK: - Checks -
    /// This cell will fit the cases were you need to show a check with text.
    /// The behavior of this cell is hardcoded, and what i mean by that, the font wont change depending on it's selection, if this doesn't fit your needs, then you should check out the BasicCheckTableCell.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicCheckAlternativeTableCell.png?raw=true
    public func getBasicCheckAlternativeTableCellConfigFile(section: Int, identifier: Any, title: String, font: UIFont, textColor: UIColor, textCustomSpacing: CGFloat? = nil, isEditable: Bool = true, checkedIcon: UIImage? = nil, uncheckedIcon: UIImage? = nil, provider: BasicCheckAlternativeTableCellProvider?, actions: BasicCheckAlternativeTableCellActions?) -> GenericTableCellConfigurator {
        let item = BasicCheckAlternativeTableCellConfigFile(identifier: identifier, title: title, font: font, textColor: textColor, textCustomSpacing: textCustomSpacing, isEditable: isEditable, checkedIcon: checkedIcon, uncheckedIcon: uncheckedIcon, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: BasicCheckAlternativeTableCell.self, item: item, section: section)
    }
    
    /// This cell will fit the cases were you need to show a check with text.
    /// The behavior of this cell is hardcoded, and what i mean by that, the font wont change depending on it's selection, if this doesn't fit your needs, then you should check out the BasicCheckTableCell.
    public func getBasicCheckAlternativeSecondTableCellConfigFile(section: Int, identifier: String, title: String, titleColor: UIColor, checkedTitleFont: UIFont, uncheckedTitleFont: UIFont, checkedIcon: UIImage? = nil, uncheckedIcon: UIImage? = nil, checkedBorderColor: UIColor, uncheckedBorderColor: UIColor, provider: BasicCheckAlternativeSecondTableCellProvider?, actions: BasicCheckAlternativeSecondTableCellActions?) -> GenericTableCellConfigurator {
        let item = BasicCheckAlternativeSecondTableCellConfigFile(identifier: identifier, title: title, titleColor: titleColor, checkedTitleFont: checkedTitleFont, uncheckedTitleFont: uncheckedTitleFont, checkedIcon: checkedIcon, uncheckedIcon: uncheckedIcon, checkedBorderColor: checkedBorderColor, uncheckedBorderColor: uncheckedBorderColor, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: BasicCheckAlternativeSecondTableCell.self, item: item, section: section)
    }
  
    // MARK: - Button -
    /// This cell will fit the cases were you need to show a button that it will always be enabled. If that's the case then this will be a good fit, if the button can be dynamically change from enable to disable depending on the context, then you should take a look at ComplexButtonTableCell.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicButtonTableCell.png?raw=true
    public func getBasicButtonTableCell(section: Int, title: String, textColor: UIColor, backgroundColor: UIColor, target: Any?, action: Selector, underline: Bool = false, font: UIFont, leftMargin: CGFloat = 8.0, rightMargin: CGFloat = 8.0, buttonHeight: CGFloat = 64.0, accessibilityInfo: AccessibilityInfo? = nil) -> GenericTableCellConfigurator {
        let item = BasicButtonTableCellConfigFile(title: title, backgroundColor: backgroundColor, textColor: textColor, selector: action, target: target, underline: underline, font: font, leftMargin: leftMargin, rightMargin: rightMargin, buttonHeight: buttonHeight)
        
        return GenericTableCellConfigurator(classType: BasicButtonTableCell.self, item: item, section: section, accessibilityInfo: accessibilityInfo)
    }
    
    /// This cell will fit the cases were you need to show 2 buttons.
    /// The font, the titles and the colors can be customized.
    public func getBasicDoubleButtonSelectionTableCell(section: Int, identifier: Any?, leftTitle: String, rightTitle: String, buttonsFont: UIFont, buttonsTitleColor: UIColor, buttonsBackgroundColor: UIColor, buttonsSelectedFont: UIFont, buttonsSelectedTitleColor: UIColor, buttonsSelectedBackgroundColor: UIColor, buttonsHeight: CGFloat, provider: BasicDoubleButtonSelectionTableCellProvider?, actions: BasicDoubleButtonSelectionTableCellActions?) -> GenericTableCellConfigurator {
        let item = BasicDoubleButtonSelectionTableCellConfigFile(identifier: identifier, leftTitle: leftTitle, rightTitle: rightTitle, buttonsFont: buttonsFont, buttonsTitleColor: buttonsTitleColor, buttonsBackgroundColor: buttonsBackgroundColor, buttonsSelectedFont: buttonsSelectedFont, buttonsSelectedTitleColor: buttonsSelectedTitleColor, buttonsSelectedBackgroundColor: buttonsSelectedBackgroundColor, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(classType: BasicDoubleButtonSelectionTableCell.self, item: item, section: section, sizingType: .specificHeight(buttonsHeight))
    }

    /// This cell will fit the cases were you need to show a button that it can be enable and disable dynamically depending on the context of your view. If that's the case then this will be a good fit, if the button will always be enabled, then you should take a look at BasicButtonTableCell.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/ComplexButtonTableCell.png?raw=true
    public func getComplexButtonTableCell(section: Int, identifier: Any?, title: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor, textColorDisabled: UIColor, backgroundColorDisabled: UIColor, target: Any?, action: Selector, provider: ComplexButtonTableCellProvider?) -> GenericTableCellConfigurator {
        let item = ComplexButtonTableCellConfigFile(identifier: identifier, title: title, font: font, backgroundColor: backgroundColor, textColor: textColor, backgroundColorDisabled: backgroundColorDisabled, textColorDisabled: textColorDisabled, selector: action, target: target, provider: provider)

        return GenericTableCellConfigurator(classType: ComplexButtonTableCell.self, item: item, section: section)
    }

    /// This cell will fit the cases were you need to show a 2 buttons that it can be enable and disable dynamically depending on the context of your view. If that's the case then this will be a good fit, if the buttons will always be enabled, then you should take a look at BasicButtonTableCell.
    public func getComplexDoubleButtonTableCell(section: Int, identifier: Any?, leftTitle: String, leftFont: UIFont, leftTextColor: UIColor, leftBackgroundColor: UIColor, leftTextColorDisabled: UIColor, leftBackgroundColorDisabled: UIColor, leftTarget: Any?, leftAction: Selector, rightTitle: String, rightFont: UIFont, rightTextColor: UIColor, rightBackgroundColor: UIColor, rightTextColorDisabled: UIColor, rightBackgroundColorDisabled: UIColor, rightTarget: Any?, rightAction: Selector, provider: ComplexDoubleButtonTableCellProvider?) -> GenericTableCellConfigurator {
        let item = ComplexDoubleButtonTableCellConfigFile(identifier: identifier, leftTitle: leftTitle, leftFont: leftFont, leftBackgroundColor: leftBackgroundColor, leftTextColor: leftTextColor, leftBackgroundColorDisabled: leftBackgroundColorDisabled, leftTextColorDisabled: leftTextColorDisabled, leftSelector: leftAction, leftTarget: leftTarget, rightTitle: rightTitle, rightFont: rightFont, rightBackgroundColor: rightBackgroundColor, rightTextColor: rightTextColor, rightBackgroundColorDisabled: rightBackgroundColorDisabled, rightTextColorDisabled: rightTextColorDisabled, rightSelector: rightAction, rightTarget: rightTarget, provider: provider)

        return GenericTableCellConfigurator(classType: ComplexDoubleButtonTableCell.self, item: item, section: section)
    }
    
    /// This cell will fit the cases were you need to show a normal text for the user.
    /// The font can be defined and you can even add a callback for action if needed.
    public func getBasicDoubleTitleTableCellConfigFile(section: Int, identifier: Any = "", leftTitle: String, leftFont: UIFont, leftTitleColor: UIColor, rightTitle: String, rightFont: UIFont, rightTitleColor: UIColor, backgroundColor: UIColor = .white, leftMargin: CGFloat, rightMargin: CGFloat, topMargin: CGFloat = 8.0, bottomMargin: CGFloat = 8.0, accessibilityInfo: AccessibilityInfo? = nil, actions: BasicDoubleTitleTableCellActions? = nil, sizingType: TableSizingType = .automatic) -> GenericTableCellConfigurator {
        let item = BasicDoubleTitleTableCellConfigFile(identifier: identifier, leftTitle: leftTitle, leftFont: leftFont, leftTitleColor: leftTitleColor, rightTitle: rightTitle, rightFont: rightFont, rightTitleColor: rightTitleColor, backgroundColor: backgroundColor, leftMargin: leftMargin, rightMargin: rightMargin, topMargin: topMargin, bottomMargin: bottomMargin, actions: actions)

        return GenericTableCellConfigurator(classType: BasicDoubleTitleTableCell.self, item: item, section: section, sizingType: sizingType, accessibilityInfo: accessibilityInfo)
    }
    
    /// This cell will fit the cases were you need to show a normal text for the user.
    /// The font can be defined and you can even add a callback for action if needed.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/BasicTitleTableCell.png?raw=true
    public func getBasicTitleTableCellConfigFile(section: Int, identifier: Any = "", title: String, attributedTitle: NSAttributedString? = nil, font: UIFont, titleColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int, backgroundColor: UIColor = .white, leftMargin: CGFloat, rightMargin: CGFloat, topMargin: CGFloat = 8.0, bottomMargin: CGFloat = 8.0, customLineSpacing: CGFloat? = nil, accessibilityInfo: AccessibilityInfo? = nil, actions: BasicTitleTableCellActions? = nil) -> GenericTableCellConfigurator {
        let item = BasicTitleTableCellConfigFile(identifier: identifier, title: title, attributedTitle: attributedTitle, font: font, titleColor: titleColor, textAlignment: textAlignment, numberOfLines: numberOfLines, backgroundColor: backgroundColor, leftMargin: leftMargin, rightMargin: rightMargin, topMargin: topMargin, bottomMargin: bottomMargin, customLineSpacing: customLineSpacing, actions: actions)

        return GenericTableCellConfigurator(classType: BasicTitleTableCell.self, item: item, section: section, accessibilityInfo: accessibilityInfo)
    }

    /// This cell will fit the cases were you need to show multiline  text with  disclosure  button
    public func getBorderedButtonDisclosureTableCell(section: Int, identifier: Any, title: String, titleFont: UIFont, titleColor: UIColor, containerColor: UIColor, disclosureImage: UIImage? = nil, actions: BorderedButtonDisclosureTableCellActions?) -> GenericTableCellConfigurator {
        let item = BorderedButtonDisclosureTableCellConfigFile(identifier: identifier, title: title, titleFont: titleFont, titleColor: titleColor, containerColor: containerColor, disclosureImage: disclosureImage, actions: actions)

        return GenericTableCellConfigurator(classType: BorderedButtonDisclosureTableCell.self, item: item, section: section)
    }

    /// This cell will fit cases were you need to show multiline bordered text with custom left right margins and configurable text attributes
    public func getBorderedTextTableCell(section: Int, title: String, font: UIFont, titleColor: UIColor, textAlignment: NSTextAlignment, backgroundColor: UIColor, containerBackgroundColor: UIColor, containerBorderColor: UIColor, leftMargin: CGFloat, rightMargin: CGFloat, customLineSpacing: CGFloat?) -> GenericTableCellConfigurator {
        let item = BorderedTextTableCellConfigFile(title: title, font: font, titleColor: titleColor, textAlignment: textAlignment, backgroundColor: backgroundColor, containerBackgroundColor: containerBackgroundColor, containerBorderColor: containerBorderColor, leftMargin: leftMargin, rightMargin: rightMargin, customLineSpacing: customLineSpacing)

        return GenericTableCellConfigurator(classType: BorderedTextTableCell.self, item: item, section: section)
    }

    /// This cell will fit the cases were you need to show TextField for your user to input data with a title on top.
    /// We also have another type of cell TextFieldFormattedInputTableCell that may fit your needs better.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/FormEntryTextTitledTableCell.png?raw=true
    func getFormEntryTextTitledCellConfigFile(section: Int, identifier: Any, isEditable: Bool = true, titleFont: UIFont, titleColor: UIColor, entryTextFont: UIFont, entryTextColor: UIColor, entryTextPlaceholder: String, entryTextPlaceholderColor: UIColor, underlineColor: UIColor, maxLength: Int? = nil, keyboardType: UIKeyboardType = .default, autocapitalizationType: UITextAutocapitalizationType = .words, autocorrectionType: UITextAutocorrectionType = .no, returnKeyType: UIReturnKeyType = .default, shouldHideKeyboard: Bool = false, provider: FormEntryTextTitledTableProvider?, actions: FormEntryTextTitledTableActions?) -> GenericTableCellConfigurator {
           let item = FormEntryTextTitledTableCellConfigFile(identifier: identifier, isEditable: isEditable, titleFont: titleFont, titleColor: titleColor, entryTextFont: entryTextFont, entryTextColor: entryTextColor, entryTextPlaceholder: entryTextPlaceholder, entryTextPlaceholderColor: entryTextPlaceholderColor, underlineColor: underlineColor, maxLength: maxLength, keyboardType: keyboardType, autocapitalizationType: autocapitalizationType, autocorrectionType: autocorrectionType, returnKeyType: returnKeyType, shouldHideKeyboard: shouldHideKeyboard, provider: provider, actions: actions)

           return GenericTableCellConfigurator(
               classType: FormEntryTextTitledTableCell.self,
               item: item,
               section: section,
               sizingType: .automatic
           )
       }
    
    /// This cell will fit the cases were you need to show a document like style for your user to sign.
    /// The behavior may be a constraint, so just confirm with the PM that this is the behavior that they want to be sure.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/DocumentationRepresentationTableCell.png?raw=true
    func getDocumentationRepresentationTableCellConfigFile(section: Int, documentIdentifier: String, signedTitleText: String, notSignedTitleText: String, signedReviewText: String, notSignedReviewText: String, signedTitleColor: UIColor, notSignedTitleColor: UIColor, signedBackgroundColor: UIColor, notSignedBackgroundColor: UIColor, descriptionColor: UIColor, reviewColor: UIColor, containerBorderColor: UIColor, shadowColor: UIColor, titleFont: UIFont, descriptionFont: UIFont, reviewFont: UIFont, signedDocumentImage: UIImage?, notSignedDocumentImage: UIImage?, provider: DocumentationRepresentationTableProvider?, actions: DocumentationRepresentationTableActions?) -> GenericTableCellConfigurator {
        let item = DocumentationRepresentationTableCellConfigFile(documentIdentifier: documentIdentifier, signedTitleText: signedTitleText, notSignedTitleText: notSignedTitleText, signedReviewText: signedReviewText, notSignedReviewText: notSignedReviewText, signedTitleColor: signedTitleColor, notSignedTitleColor: notSignedTitleColor, signedBackgroundColor: signedBackgroundColor, notSignedBackgroundColor: notSignedBackgroundColor, descriptionColor: descriptionColor, reviewColor: reviewColor, containerBorderColor: containerBorderColor, shadowColor: shadowColor, titleFont: titleFont, descriptionFont: descriptionFont, reviewFont: reviewFont, signedDocumentImage: signedDocumentImage, notSignedDocumentImage: notSignedDocumentImage, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(
            classType: DocumentationRepresentationTableCell.self,
            item: item,
            section: section
        )
    }
    
    /// This cell will fit the cases were you need to show a dropdown, the dropdown can be full screen or partial screen depending on the title.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/DropdownOptionSelectionTableCell.png?raw=true
    func getDropdownOptionSelectionTableCellConfigFile(identifier: Any, title: String, titleColor: UIColor, titleFont: UIFont, optionColor: UIColor, optionFont: UIFont, downArrowImage: UIImage?, titleLineColor: UIColor, isEditable: Bool, adjustableToTitle: Bool, section: Int, provider: DropdownOptionSelectionTableProvider?, actions: DropdownOptionSelectionTableActions?) -> GenericTableCellConfigurator {
        let item = DropdownOptionSelectionTableCellConfigFile(identifier: identifier, title: title, titleColor: titleColor, titleFont: titleFont, optionColor: optionColor, optionFont: optionFont, downArrowImage: downArrowImage, titleLineColor: titleLineColor, isEditable: isEditable, adjustableToTitle: adjustableToTitle, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(
            classType: DropdownOptionSelectionTableCell.self,
            item: item,
            section: section,
            sizingType: .specificHeight(84)
        )
    }
    
    /// This cell will fit the cases were you need to show a gallery of images.
    /// The size can be define for yours needs, but you will need to calculate it depending on the size of the images that you will show in it.
    /// The height should be the height of the image inside * the number of rows + the separation between them + the top + bottom gap.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/ImageGalleryTableCell.png?raw=true
//    func getImageGalleryTableCellConfigFile(section: Int, height: CGFloat, provider: ImageGalleryTableProvider?, actions: ImageGalleryTableActions?) -> GenericTableCellConfigurator {
//        let item = ImageGalleryTableCellConfigFile(provider: provider, actions: actions)
//
//        return GenericTableCellConfigurator(
//            classType: ImageGalleryTableCell.self,
//            item: item,
//            section: section,
//            sizingType: .specificHeight(height)
//        )
//    }
    
    
    /// This cell will fit the cases were you need to show a slider for selecting between numbers, the range is defined by you.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/SliderTableCell.png?raw=true
//    func getSliderTableCell(section: Int, identifier: Any, isEditable: Bool = true, provider: SliderTableProvider?, actions: SliderTableActions?) -> GenericTableCellConfigurator {
//        let item = SliderTableCellConfigFile(identifier: identifier, isEditable: isEditable, provider: provider, actions: actions)
//
//        return GenericTableCellConfigurator(
//            classType: SliderTableCell.self,
//            item: item,
//            section: section
//        )
//    }
    
    /// This cell will fit the cases were you need to show stars for displaying some kind of ratings from 1 to 5.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/StarsRateTableCell.png?raw=true
//    func getStarsRateTableCell(section: Int, identifier: Any, provider: StarsRateTableCellProvider?, actions: StarsRateTableCellActions?) -> GenericTableCellConfigurator {
//        let item = StarsRateTableCellConfigFile(identifier: identifier, provider: provider, actions: actions)
//
//        return GenericTableCellConfigurator(
//            classType: StarsRateTableCell.self,
//            item: item,
//            section: section
//        )
//    }
    
    
    /// This cell will fit the cases were you need to show a double entry text for your user.
    /// The behavior of this cell can be really specific and it may not match your requirements, be sure that this cell behavior is a good fit for your needs before using it.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/FormDoubleEntryTableCell.png?raw=true
    func getFormDoubleEntryTableCell(section: Int, leftIdentifier: Any, rightIdentifier: Any, leftTextFormat: String?, leftKeyboardType: UIKeyboardType, leftAutocapitalizationType: UITextAutocapitalizationType, leftAllowedSymbolRegex: String?, leftTitleFont: UIFont, leftTitleColor: UIColor, leftInputTextColor: UIColor, leftInputTextFont: UIFont, leftAddText: String, leftAddTextColor: UIColor, leftAddTextFont: UIFont, leftAttentionImage: UIImage?, leftContainerBorderColor: UIColor, rightTextFormat: String?, rightKeyboardType: UIKeyboardType, rightAutocapitalizationType: UITextAutocapitalizationType, rightAllowedSymbolRegex: String?, rightTitleFont: UIFont, rightTitleColor: UIColor, rightInputTextColor: UIColor, rightInputTextFont: UIFont, rightAddTextColor: UIColor, rightAddText: String, rightAddTextFont: UIFont, rightAttencionImage: UIImage?, rightContainerBorderColor: UIColor, shouldShowBottomLine: Bool, middleLineColor: UIColor, underlineColor: UIColor, accessibilityInfo: AccessibilityInfo? = nil, provider: FormDoubleEntryTableCellProvider?, actions: FormDoubleEntryTableCellActions?) -> GenericTableCellConfigurator {
        let item = FormDoubleEntryTableCellConfigFile(leftIdentifier: leftIdentifier, rightIdentifier: rightIdentifier, leftTextFormat: leftTextFormat, leftKeyboardType: leftKeyboardType, leftAutocapitalizationType: leftAutocapitalizationType, leftAllowedSymbolRegex: leftAllowedSymbolRegex, leftTitleFont: leftTitleFont, leftTitleColor: leftTitleColor, leftInputTextColor: leftInputTextColor, leftInputTextFont: leftInputTextFont, leftAddText: leftAddText, leftAddTextColor: leftAddTextColor, leftAddTextFont: leftAddTextFont, leftAttentionImage: leftAttentionImage, leftContainerBorderColor: leftContainerBorderColor, rightTextFormat: rightTextFormat, rightKeyboardType: rightKeyboardType, rightAutocapitalizationType: rightAutocapitalizationType, rightAllowedSymbolRegex: rightAllowedSymbolRegex, rightTitleFont: rightTitleFont, rightTitleColor: rightTitleColor, rightInputTextColor: rightInputTextColor, rightInputTextFont: rightInputTextFont, rightAddTextColor: rightAddTextColor, rightAddText: rightAddText, rightAddTextFont: rightAddTextFont, rightAttencionImage: rightAttencionImage, rightContainerBorderColor: rightContainerBorderColor, shouldShowBottomLine: shouldShowBottomLine, middleLineColor: middleLineColor, underlineColor: underlineColor, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(
            classType: FormDoubleEntryTableCell.self,
            item: item,
            section: section,
            accessibilityInfo: accessibilityInfo
        )
    }
    
    /// This cell will fit the cases were you need to show a single entry text for your user.
    /// The behavior of this cell can be really specific and it may not match your requirements, be sure that this cell behavior is a good fit for your needs before using it.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/FormDoubleEntryTableCell.png?raw=true
    func getFormSingleEntryTableCell(section: Int, identifier: Any, titleFont: UIFont, titleColor: UIColor, inputTextFont: UIFont, inputTextColor: UIColor, attentionImage: UIImage?, addText: String, addTextColor: UIColor, addTextFont: UIFont, textFormat: String?, keyboardType: UIKeyboardType, autocapitalizationType: UITextAutocapitalizationType, allowedSymbolRegex: String?, accessibilityInfo: AccessibilityInfo? = nil, shouldShowBottomLine: Bool, underlineColor: UIColor = .clear, containerEditingColor: UIColor, containerNotEditingColor: UIColor, provider: FormSingleEntryTableCellProvider?, actions: FormSingleEntryTableCellActions?) -> GenericTableCellConfigurator {
        let item = FormSingleEntryTableCellConfigFile(identifier: identifier, titleFont: titleFont, titleColor: titleColor, inputTextFont: inputTextFont, inputTextColor: inputTextColor, attentionImage: attentionImage, addText: addText, addTextColor: addTextColor, addTextFont: addTextFont, textFormat: textFormat, keyboardType: keyboardType, autocapitalizationType: autocapitalizationType, allowedSymbolRegex: allowedSymbolRegex, shouldShowBottomLine: shouldShowBottomLine, underlineColor: underlineColor, containerEditingColor: containerEditingColor, containerNotEditingColor: containerNotEditingColor, provider: provider, actions: actions)
        
        return GenericTableCellConfigurator(
            classType: FormSingleEntryTableCell.self,
            item: item,
            section: section,
            accessibilityInfo: accessibilityInfo
        )
    }
    
    /// This cell will fit the cases were you need to show a cell with an icon, text and a detail arrow like in the screenshot.
    /// Screenshot: https://github.com/datamindedsolutions/noteworth-ios-documentation/blob/master/TableView%20Shared%20Cells/LeftIconWithTextAndArrowTableCell.png?raw=true
//    func getLeftIconWithTextAndArrowTableCell(section: Int, identifier: Any, title: String, icon: UIImage, backgroundColor: UIColor = .white, actions: LeftIconWithTextAndArrowTableCellActions?) -> GenericTableCellConfigurator {
//        let item = LeftIconWithTextAndArrowTableCellConfigFile(identifier: identifier, title: title, icon: icon, actions: actions, backgroundColor: backgroundColor)
//
//        return GenericTableCellConfigurator(classType: LeftIconWithTextAndArrowTableCell.self, item: item, section: section)
//    }
    
    
    
    

//    
//    /// This cell will fit the cases were you need to enter values for the readings using a textfield as an input.
//    func getReadingTextInputTableCell(section: Int, identifier: Any, icon: UIImage, name: String, isReadOnly: Bool, backgroundColor: UIColor, valueName: String, valueNameWidth: CGFloat?, minValue: Double?, maxValue: Double?, allowDecimal: Bool, inputTextfieldWidth: CGFloat = 86.0, isEditable: Bool = true, provider: ReadingTextInputTableCellProvider?, actions: ReadingTextInputTableCellActions?) -> GenericTableCellConfigurator {
//        let item = ReadingTextInputTableCellConfigFile(identifier: identifier, icon: icon, name: name, isReadOnly: isReadOnly, backgroundColor: backgroundColor, valueName: valueName, valueNameWidth: valueNameWidth, minValue: minValue, maxValue: maxValue, allowDecimal: allowDecimal, inputTextfieldWidth: inputTextfieldWidth, isEditable: isEditable, provider: provider, actions: actions)
//        
//        return GenericTableCellConfigurator(classType: ReadingTextInputTableCell.self, item: item, section: section)
//    }
//    
//    /// This cell will fit the cases were you need to enter numeric values for the readings.
//    func getReadingNumericInputTableCell(section: Int, identifier: Any, icon: UIImage, name: String, backgroundColor: UIColor, provider: ReadingNumericInputTableCellProvider?, actions: ReadingNumericInputTableCellActions?) -> GenericTableCellConfigurator {
//        let item = ReadingNumericInputTableCellConfigFile(identifier: identifier, icon: icon, name: name, backgroundColor: backgroundColor, provider: provider, actions: actions)
//        
//        return GenericTableCellConfigurator(classType: ReadingNumericInputTableCell.self, item: item, section: section)
//    }
//    
//    /// This cell will fit the cases were you need to show a tab with 2 buttons.
//    /// The font, the titles and the colors can be customized.
//    func getTabDoubleSelectionTableCell(section: Int, identifier: Any?, leftTitle: String, rightTitle: String, buttonsFont: UIFont, buttonsTitleColor: UIColor, buttonsBackgroundColor: UIColor, buttonsSelectedFont: UIFont, buttonsSelectedTitleColor: UIColor, buttonsSelectedBackgroundColor: UIColor, spacingBetweenButtons: CGFloat = 40.0, provider: TabDoubleSelectionTableCellProvider?, actions: TabDoubleSelectionTableCellActions?) -> GenericTableCellConfigurator {
//        let item = TabDoubleSelectionTableCellConfigFile(identifier: identifier, leftTitle: leftTitle, rightTitle: rightTitle, buttonsFont: buttonsFont, buttonsTitleColor: buttonsTitleColor, buttonsBackgroundColor: buttonsBackgroundColor, buttonsSelectedFont: buttonsSelectedFont, buttonsSelectedTitleColor: buttonsSelectedTitleColor, buttonsSelectedBackgroundColor: buttonsSelectedBackgroundColor, spacingBetweenButtons: spacingBetweenButtons, provider: provider, actions: actions)
//        return GenericTableCellConfigurator(classType: TabDoubleSelectionTableCell.self, item: item, section: section)
//    }
//    

//    
//    /// This cell will fit the cases were you need to show the days of the week so the user can select multiple days.
//    func getWeekSelectionTableCell(section: Int, identifier: Any? = nil, provider: WeekSelectionTableCellProvider?, actions: WeekSelectionTableCellActions?) -> GenericTableCellConfigurator {
//        let item = WeekSelectionTableCellConfigFile(identifier: identifier, provider: provider, actions: actions)
//        
//        return GenericTableCellConfigurator(classType: WeekSelectionTableCell.self, item: item, section: section)
//    }
    
//

//    
//    /// This cell will fit the cases were you need to show multiline text with title, description and checkbox icon with selected and  deselected  states
//    /// also  rounded border is shown if text is selectable
//    func getSelectableTextWithDescriptionTableCell(section: Int, identifier: Any, title: String, description: String, provider: SelectableTextWithDescriptionTableCellProvider?, actions: SelectableTextWithDescriptionTableCellActions?) -> GenericTableCellConfigurator {
//        let item = SelectableTextWithDescriptionTableCellConfigFile(identifier: identifier, title: title, description: description, provider: provider, actions: actions)
//        
//        return GenericTableCellConfigurator(classType: SelectableTextWithDescriptionTableCell.self, item: item, section: section)
//    }
//
//    func getSwitchTableCell(
//        section: Int,
//        identifier: Any,
//        leftTitle: String,
//        titleFont: UIFont,
//        textColor: UIColor,
//        switchBackgroundColor: UIColor,
//        provider: SwitchTableCellProvider?,
//        actions: SwitchTableCellActions?
//    ) -> GenericTableCellConfigurator {
//        return GenericTableCellConfigurator(
//            classType: SwitchTableCell.self,
//            typeCell: .cell,
//            item: SwitchTableCellConfigFile(
//                identifier: identifier,
//                leftTitle: leftTitle,
//                titleFont: titleFont,
//                textColor: textColor,
//                switchBackgroundColor: switchBackgroundColor,
//                provider: provider,
//                actions: actions
//            ),
//            section: section
//        )
//    }
//    
    
}
