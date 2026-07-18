//
//  UIComponentDemo.swift
//  architecture-swift-template
//
//  Created by Maula Izza Azizi on 18/07/26.
//

import SwiftUI

enum UIComponentDemo: String, CaseIterable, Identifiable, Hashable {
    case alert
    case actionSheet
    case contextMenu
    case faceID
    case keyboard
    case list
    case menus
    case picker
    case sheets
    case slider
    case stepper
    case tabBar
    case textFields
    case bottomToolbar
    case topToolbar

    var id: String { rawValue }

    var title: String {
        switch self {
        case .alert: "Alert"
        case .actionSheet: "Action Sheet"
        case .contextMenu: "Context Menu"
        case .faceID: "Face ID"
        case .keyboard: "Keyboard"
        case .list: "List"
        case .menus: "Menus"
        case .picker: "Picker"
        case .sheets: "Sheets"
        case .slider: "Slider"
        case .stepper: "Stepper"
        case .tabBar: "Tab Bar"
        case .textFields: "Text Fields"
        case .bottomToolbar: "Toolbars — Bottom"
        case .topToolbar: "Toolbars — Top"
        }
    }

    var systemImage: String {
        switch self {
        case .alert: "exclamationmark.bubble"
        case .actionSheet: "square.and.arrow.up.on.square"
        case .contextMenu: "hand.tap"
        case .faceID: "faceid"
        case .keyboard: "keyboard"
        case .list: "list.bullet"
        case .menus: "line.3.horizontal.circle"
        case .picker: "slider.horizontal.below.rectangle"
        case .sheets: "square.stack"
        case .slider: "slider.horizontal.3"
        case .stepper: "plusminus"
        case .tabBar: "square.grid.2x2"
        case .textFields: "textformat"
        case .bottomToolbar: "dock.rectangle"
        case .topToolbar: "menubar.rectangle"
        }
    }
}

extension UIComponentDemo {

    @ViewBuilder
    @MainActor
    func destination(container: AppContainer) -> some View {
        switch self {
        case .alert: AlertDemoView()
        case .actionSheet: ActionSheetDemoView()
        case .contextMenu: ContextMenuDemoView()
        case .faceID: FaceIDDemoView(viewModel: FaceIDDemoViewModel(container: container))
        case .keyboard: KeyboardDemoView()
        case .list: ListDemoView()
        case .menus: MenusDemoView()
        case .picker: PickerDemoView()
        case .sheets: SheetsDemoView()
        case .slider: SliderDemoView()
        case .stepper: StepperDemoView()
        case .tabBar: TabBarDemoView()
        case .textFields: TextFieldsDemoView()
        case .bottomToolbar: BottomToolbarDemoView()
        case .topToolbar: TopToolbarDemoView()
        }
    }
}
