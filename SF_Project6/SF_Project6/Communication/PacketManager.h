//
//  PacketManager.h
//  SF_Project6
//
//  Created by Horangi on 11/25/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SF_Object.h"


#define START   1<<7
#define END     1<<6
#define MOVE    1<<5
#define SHOT    1<<4

@interface PacketManager : NSObject
{
    int m_playerNum;
    int m_enemyNum;
    
}

- (void) SetPlayerNumber:(int) pNum;
- (void) AnalyzeReceivedPacket:(char[]) packet;


@end
