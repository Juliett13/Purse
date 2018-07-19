import UIKit

// REVIEW: Use PascalCase for type names. See swift style guideline:
// https://github.com/linkedin/swift-style-guide#2-naming
// Delegate protocols must conform to `class`, othervise their inctances cannot be declared weak.
protocol dropDownProtocol: class {
    func dropDownPressed(title: String)
}

// REVIEW: Use PascalCase for type names.
class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    // REVIEW: Delegate must be weak to avoid retain cycle.
    weak var delegate : dropDownProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.layer.cornerRadius = 15
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor(red: 121.0 / 255.0, green: 190.0 / 255.0, blue: 112.0 / 255.0, alpha: 1).cgColor

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.dropDownPressed(title: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}


