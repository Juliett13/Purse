import UIKit

// MARK: - Reusable

protocol Reusable: class
{
    static var reuseIdentifier: String { get }
}

extension Reusable
{
    static var reuseIdentifier: String
    {
        return String(describing: self)
    }
}

// MARK: -  NibLoadableView

protocol NibLoadableView: class
{
    static var nibName: String { get }
    static var nib: UINib? { get }
}

extension NibLoadableView where Self: UIView
{
    static var nibName: String
    {
        return String(describing: self)
    }
    
    static var nib: UINib?
    {
        return UINib(nibName: nibName, bundle: Bundle.main)
    }
}

// MARK: - UITableView

extension UITableView
{
    func register<T: UITableViewCell>(_: T.Type) where T: Reusable
    {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: Reusable & NibLoadableView
    {
        guard let nib = T.nib else
        {
            fatalError("Failed to register cell with type: \(String(describing: T.self)) and identifier: \(T.reuseIdentifier). Unable to load nib named: \(T.nibName)")
        }
        
        self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T?  where T: Reusable
    {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }
}

// MARK: - UIStoryboard

extension UIStoryboard
{
    enum Storyboard: String {
        case main

        var filename: String {
            return rawValue.capitalized
        }
    }

    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    func instantiateViewController<T: UIViewController>() -> T?  where T: Reusable
    {
        return self.instantiateViewController(withIdentifier: T.reuseIdentifier) as? T
    }
}



