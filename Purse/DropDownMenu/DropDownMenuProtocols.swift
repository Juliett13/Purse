// MARK: - Button

protocol DropDownButtonProtocol: class {
    func editingDidEnd(with rowValue: Int)
    func viewDidDisappear()
    func viewWillAppear()
}

// MARK: - ViewDelegate

protocol DropDownViewDelegateProtocol: class {
    func dropDownPressed(rowValue: Int)
}
