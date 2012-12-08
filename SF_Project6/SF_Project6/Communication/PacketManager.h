//
//  PacketManager.h
//  SF_Project6
//
//  Created by Horangi on 11/25/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SF_Object.h"

enum GAME_PROTOCOL { PROTOCOL_START, PROTOCOL_END, PROTOCOL_SYNC, PROTOCOL_SHOT, PROTOCOL_HIT, PROTOCOL_DOUBLE, PROTOCOL_HEAL };

@interface PacketManager : NSObject
{
    
}

+ (void) AnalyzeReceivedPacket:(NSData*) packet;
+ (NSData*) MakePacket:(int) flag pos:(SF_vector) position vel:(SF_vector) velocity;
+ (void) SendPacket:(int) flag pos:(SF_vector) position vel:(SF_vector) velocity;

@end
