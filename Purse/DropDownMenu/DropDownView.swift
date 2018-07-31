import UIKit

class DropDownView: UIView {
    weak var delegate : DropDownViewDelegateProtocol?
    var tableView = UITableView()

    var dropDownOptions = [String]()
    var cellBackgroundColor = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func configure(borderWidth: CGFloat,
                   cornerRadius: CGFloat,
                   borderColor: UIColor,
                   backgroundColor: UIColor) {
        tableView.layer.borderWidth = borderWidth
        tableView.layer.cornerRadius = cornerRadius
        tableView.layer.borderColor = borderColor.cgColor
        tableView.backgroundColor = backgroundColor
        self.cellBackgroundColor = backgroundColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DropDownView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.backgroundColor = cellBackgroundColor
        cell.layer.backgroundColor = cellBackgroundColor.cgColor
        cell.contentView.layer.backgroundColor = cellBackgroundColor.cgColor
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.dropDownPressed(rowValue: indexPath.row)
    }
}


