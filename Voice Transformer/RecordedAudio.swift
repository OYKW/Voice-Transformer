//
//  RecordedAudio.swift
//  Voice Transformer
//
//  Created by Olivia Wang on 3/17/15.
//  Copyright (c) 2015 Halfspace. All rights reserved.
//

import UIKit

class RecordedAudio: NSObject {
    var filePathURL:NSURL!
    var title:String!
    init(filePathURL:NSURL!, title:String!){
        self.filePathURL = filePathURL
        self.title = title
        
        
    }
   
}
