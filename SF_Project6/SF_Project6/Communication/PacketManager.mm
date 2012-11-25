//
//  PacketManager.m
//  SF_Project6
//
//  Created by Horangi on 11/25/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import "PacketManager.h"

@implementation PacketManager

- (void)AnalyzeReceivedPacket:(NSData*) packet
{
    Byte* buffer = (Byte*) [packet bytes];
    
    Byte flag = buffer[0];
    
    //move enemy to new position
    
    switch (flag) {
        case START:
            //timer start
            break;
        case SHOT:
            //give velocity, draw missile
        case END:
            //timer end
            break;
        default:
            break;
    }
}

- (NSData*) MakePacket:(int) flag:(SF_vector) position:(SF_vector) velocity
{
    Byte buffer[34];
    buffer[0] = (Byte)flag;
    
    memcpy(buffer+1, &position, sizeof(SF_vector));
    memcpy(buffer+1+sizeof(SF_vector), &velocity, sizeof(SF_vector));
    
    NSData* packet = [NSData dataWithBytes:buffer length:sizeof(buffer)];
    [packet getBytes:buffer];
    
    return packet;
}

@end
