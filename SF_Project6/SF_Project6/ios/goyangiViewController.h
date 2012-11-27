//
//  goyangiViewController.h
//  SF_Project6
//
//  Created by Horangi on 11/24/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>

@interface GoyangiViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate>
{
    GKSession *fartSession;
    GKPeerPickerController *fartPicker;
    NSMutableArray *fartPeers;
}

@property (retain) GKSession *fartSession;

- (void) connectToPeers:(id) sender;

@end
