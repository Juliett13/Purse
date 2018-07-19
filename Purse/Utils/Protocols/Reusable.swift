import UIKit

// REVIEW: Use protocol with default implementation to add reuseId to object. This way allows you to use it in generic functions. 

// MARK: - Reusable

protocol Reusable: class
{
    static var reuseIdentifier: String { get }
}

extension Reusable
{
    /// Returns object's class name
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


/**
 REVIEW: For example, you can write an extension for UITableView for cells management.
 */

// MARK: - UITableView

extension UITableView
{
    /**
     Register cell which doesn't require nib
     */
    func register<T: UITableViewCell>(_: T.Type) where T: Reusable
    {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Register cell which requires nib.
     */
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
