//
//  SF_Project6AppController.h
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 25..
//  Copyright frf1226@nate.com 2012년. All rights reserved.
//
@class GoyangiViewController;
@class RootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate> {
    UIWindow *window;
    GoyangiViewController *goyangiViewController;
    RootViewController	*viewController;
}

@end

