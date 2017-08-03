//
//  EntryParamsPresentring.swift
//  VXTrade
//
//  Created by Yuriy on 12/29/16.
//  Copyright © 2016 VXmarkets. All rights reserved.
//

import UIKit
import Alamofire

typealias URLParameters = (url: String, addition: String?)
typealias Body = (path: String?, parameters: Parameters)
typealias EntryParameters = (URLParameters?, HTTPHeaders?, Body?)

protocol EntryParametersPresentable {}

protocol EntryParametersPresenting {
    var entryParameters: EntryParameters { get set }
    init(entryParameters: EntryParameters)
    func parameters() -> EntryParameters
}

extension EntryParametersPresenting where Self: EntryParametersPresentable {
    init(entryParameters: EntryParameters) {
        self.init(entryParameters: entryParameters)
    }
    func parameters() -> EntryParameters {
        return entryParameters
    }
}

struct MetaDataParams: EntryParametersPresenting, EntryParametersPresentable {
    internal var entryParameters: EntryParameters
}

struct ContentItemParams: EntryParametersPresenting, EntryParametersPresentable {
    internal var entryParameters: EntryParameters
}

