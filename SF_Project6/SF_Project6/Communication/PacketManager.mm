//
//  PacketManager.m
//  SF_Project6
//
//  Created by Horangi on 11/25/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import "PacketManager.h"

@implementation PacketManager

- (void) SetPlayerNumber:(int)pNum
{
    m_playerNum = pNum;
    m_enemyNum = 3 - m_playerNum;
}

- (void)AnalyzeReceivedPacket:(char[]) packet
{
    unsigned char flag = packet[0];
    
    switch (flag) {
        case START:
            //timer start
            break;
        case END:
            //timer end
            break;
        case MOVE:
            //move enemy to new position
            break;
        case SHOT:
            //give velocity, draw missile
            break;
        default:
            break;
    }
}

@end
