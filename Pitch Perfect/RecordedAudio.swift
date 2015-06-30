//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ryan Armstrong on 6/11/15.
//  Copyright (c) 2015 Ryan Armstrong. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {

    var filePathUrl: NSURL!
    var title: String!

    init(url: NSURL, lastPathComponent: String) {
        filePathUrl = url
        title = lastPathComponent
    }

}