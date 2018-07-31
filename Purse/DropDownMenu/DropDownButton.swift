import UIKit


class DropDownButton: UIButton {
    
    weak var delegate : DropDownButtonProtocol?

    var dropView = DropDownView()
    var height: NSLayoutConstraint!
    var isOpen = false

    var focusedColor = UIColor.white.cgColor
    var normalColor = UIColor.white.cgColor

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.black, for: .normal)
        dropView = DropDownView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(borderWidth: CGFloat,
                   cornerRadius: CGFloat,
                   borderColor: UIColor,
                   normalBackgroundColor: CGColor,
                   focusedBackgoundColor: UIColor) {
        
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.normalColor = normalBackgroundColor
        self.focusedColor = focusedBackgoundColor.cgColor
        self.layer.backgroundColor = self.normalColor
        dropView.configure(
            borderWidth: borderWidth,
            cornerRadius: cornerRadius,
            borderColor: borderColor,
            backgroundColor: focusedBackgoundColor)
    }

    func didLayoutInSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)

        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dropView.dropDownOptions.isEmpty {
            return
        }
        
        if !isOpen {

            delegate?.viewWillAppear()

            isOpen = true
            
            self.height.isActive = false

            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            self.height.isActive = true

            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: { [weak self] in
                    guard let dropView = self?.dropView else {
                        return
                    }
                    dropView.layoutIfNeeded()
                    dropView.center.y += dropView.frame.height / 2
                    self?.layer.backgroundColor = self?.focusedColor
                }, completion: nil)
        } else {
            dismissDropDown()
        }
    }

    func dismissDropDown() {
        isOpen = false

        self.height.isActive = false
        self.height.constant = 0
        self.height.isActive = true
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let dropView = self?.dropView else {
                    return
                }
                self?.layer.backgroundColor = self?.normalColor 

                dropView.center.y -= dropView.frame.height / 2
                dropView.layoutIfNeeded()
                self?.delegate?.viewDidDisappear()
            }, completion: nil)
    }
    
    func setOptions(_ options: [String]) {
        dropView.dropDownOptions = options
        dropView.tableView.reloadData() 
    }
}

// MARK: - DropDownViewDelegateProtocol

extension DropDownButton: DropDownViewDelegateProtocol {
    func dropDownPressed(rowValue: Int) {
        self.dismissDropDown()
        delegate?.editingDidEnd(with: rowValue)
    }
}
