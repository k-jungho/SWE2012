//
//  SpeechTest3AppController.h
//  SpeechTest3
//
//  Created by 김정호 on 12. 11. 24..
//  Copyright __MyCompanyName__ 2012년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>
#import <GameKit/GameKit.h>

enum __transactionState{
    TS_IDLE,
    TS_INITIAL,
    TS_RECORDING,
    TS_PROCESSING,
};

typedef enum __transactionState _transactionState;

@interface RootViewController : UIViewController <SpeechKitDelegate, SKRecognizerDelegate, UITextFieldDelegate, GKSessionDelegate, GKPeerPickerControllerDelegate>
{
    SKRecognizer* voiceSearch;

    GKSession *fartSession;
    GKPeerPickerController *fartPicker;
    NSMutableArray *fartPeers;
}

- (void) sendALoudFart:(id) sender;
- (void) setConnectionVaries:(GKSession*)session second:(GKPeerPickerController*)picker third:(NSMutableArray*)peers;

+ (void)startRecognition;
+ (void)initialize;
+ (char *)getResponse;

@property(readonly)     SKRecognizer    *voiceSearch;
@property(retain)       GKSession       *fartSession;
@property(retain)       NSMutableArray  *fartPeers;

@end
