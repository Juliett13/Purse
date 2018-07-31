import Foundation

extension Array
{
    func item(at index: Int) -> Element?
    {
        guard Range(0..<self.count).contains(index) else
        {
            return nil
        }
        
        return self[index]
    }
}
