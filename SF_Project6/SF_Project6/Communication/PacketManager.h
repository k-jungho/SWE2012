//
//  PacketManager.h
//  SF_Project6
//
//  Created by Horangi on 11/25/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PacketManager : NSObject


- (void) AnalyzeReceivedPacket:(char[]) packet;

@end
