//
//  ViewController.swift
//  TestRealm
//
//  Created by Yura Granchenko on 8/3/17.
//  Copyright © 2017 Yura Granchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let metaData = MetaDataParams(entryParameters: (baseURL: (MainURL.base.rawValue, nil),
//                                                        headerParameters: Header.data,
//                                                        bodyParameters: nil))
//        
//        Request.getMetaData(metaData) { json, success in
//            print (">>self - \(json)<<")
//        }
        
        let contentItemData = ContentItemParams(entryParameters: (baseURL:(MainURL.base.rawValue, nil),
                                                                  headerParameters: Header.data,
                                                                  bodyParameters: nil))
        
        Request.getContentItem(contentItemData) { json, success in
            print (">>self - \(json)<<")
        }
    }
}

