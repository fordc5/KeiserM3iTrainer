//
//  WattTimeObject.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/28/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//

import Foundation

public class WattTimeObject: NSObject {
    private var watts : Int!
    private var offset : Double!
    
    public init(watts : Int, offset : Double) {
        super.init()
        self.watts = watts
        self.offset = offset
    }
    
    public func getWatts() -> Int {
        return self.watts
    }
    
    public func getOffset() -> Double {
        return self.offset
    }
}
