//
//  PacketManager.m
//  SF_Project6
//
//  Created by Horangi on 11/25/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import "PacketManager.h"
#import "AppController.h"
#import "RootViewController.h"

@implementation PacketManager

+ (void)AnalyzeReceivedPacket:(NSData*) packet
{
    Byte* buffer = (Byte*) [packet bytes];
    
    Byte flag = buffer[0];
    
    //move enemy to new position
    
    switch (flag) {
        case PROTOCOL_START:
            break;
        case PROTOCOL_END:
            break;
        case PROTOCOL_SYNC:
            break;
        case PROTOCOL_SHOT:
            break;
        case PROTOCOL_HIT:
            break;
        case PROTOCOL_DOUBLE:
            break;
        case PROTOCOL_HEAL:
            break;
    }
}

+ (NSData*) MakePacket:(int) flag:(SF_vector) position:(SF_vector) velocity
{
    Byte buffer[34];
    buffer[0] = (Byte)flag;
    
    memcpy(buffer+1+0*sizeof(double), &position.x, sizeof(double));
    memcpy(buffer+1+1*sizeof(double), &position.y, sizeof(double));
    memcpy(buffer+1+2*sizeof(double), &velocity.x, sizeof(double));
    memcpy(buffer+1+3*sizeof(double), &velocity.y, sizeof(double));
    
    NSData* packet = [NSData dataWithBytes:buffer length:sizeof(buffer)];
    [packet getBytes:buffer];
    
    return packet;
}

+ (void) SendPacket:(int)flag pos:(SF_vector)position vel:(SF_vector)velocity
{
    NSData* packet = [self MakePacket:flag :position :velocity];
    
    [pRootViewController.fartSession sendData:packet toPeers:pRootViewController.fartPeers withDataMode:GKSendDataReliable error:nil];
}

@end
