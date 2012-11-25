//
//  SpeechTest3AppController.h
//  SpeechTest3
//
//  Created by 김정호 on 12. 11. 24..
//  Copyright __MyCompanyName__ 2012년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>

enum __transactionState{
    TS_IDLE,
    TS_INITIAL,
    TS_RECORDING,
    TS_PROCESSING,
};

typedef enum __transactionState _transactionState;

@interface RootViewController : UIViewController <SpeechKitDelegate, SKRecognizerDelegate, UITextFieldDelegate> {
    SKRecognizer* voiceSearch;
}

+ (void)startRecognition;
+ (void)initialize;
+ (char *)getResponse;

@property(readonly)         SKRecognizer* voiceSearch;

@end
