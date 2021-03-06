//
//  GCDAsyncWritePacket.swift
//  SwiftAsyncSocket
//
//  Created by Joel Saltzman on 1/10/16.
//  Copyright © 2016 Joel Saltzman. All rights reserved.
//

import Foundation

/**
 * The GCDAsyncWritePacket encompasses the instructions for any given write.
 **/

class GCDAsyncWritePacket : GCDAsyncSpecialPacket {
    var buffer : NSData
    var bytesDone : Int
    var tag : Int
    var timeout : NSTimeInterval
    
    init(withData d : NSData, timeout t : NSTimeInterval, tag i : Int){
        buffer = d
        bytesDone = 0
        timeout = t
        tag = i
        super.init()
    }
}