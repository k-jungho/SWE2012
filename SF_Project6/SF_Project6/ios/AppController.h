//
//  SF_Project6AppController.h
//  SF_Project6
//
//  Created by JungHo Kim on 12. 10. 25..
//  Copyright frf1226@nate.com 2012년. All rights reserved.
//
@class RootViewController;
extern RootViewController* pRootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate> {
    UIWindow *window;
    RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;

@end

