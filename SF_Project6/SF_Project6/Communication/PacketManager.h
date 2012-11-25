//
//  PacketManager.h
//  SF_Project6
//
//  Created by Horangi on 11/25/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SF_Object.h"

#define START   4
#define END     2
#define SHOT    1

@interface PacketManager : NSObject
{
    
}

- (void) AnalyzeReceivedPacket:(NSData*) packet;

+ (NSData*) MakePacket:(int) flag:(SF_vector) position:(SF_vector) velocity;

@end
