//
//  ArrayExtension.swift
//  Purse
//
//  Created by Anastasia Tarasova on 24/07/2018.
//  Copyright © 2018 C3G9. All rights reserved.
//

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
