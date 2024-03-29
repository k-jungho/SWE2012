//
//  goyangiViewController.m
//  SF_Project6
//
//  Created by Horangi on 11/24/12.
//  Copyright (c) 2012 frf1226@nate.com. All rights reserved.
//

#import "GoyangiViewController.h"
#import "RootViewController.h"
#import "AppController.h"
#import "cocos2d.h"

@interface GoyangiViewController ()

@end

@implementation GoyangiViewController

@synthesize fartSession;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    fartPicker = [[GKPeerPickerController alloc] init];
    fartPicker.delegate = self;
    
    //There are 2 modes of connection type
    // - GKPeerPickerConnectionTypeNearby via BlueTooth
    // - GKPeerPickerConnectionTypeOnline via Internet
    // We will use Bluetooth Connectivity for this example
    
    fartPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    fartPeers=[[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    // Create the buttons
    UIButton *btnConnect = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnConnect addTarget:self action:@selector(connectToPeers:) forControlEvents:UIControlEventTouchUpInside];
    [btnConnect setImage:[UIImage imageNamed:@"Bluetooth.png"] forState:UIControlStateNormal];
    //[btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
    btnConnect.frame = CGRectMake(397, 269, 231, 231);
    btnConnect.tag = 12;
    [self.view addSubview:btnConnect];
    
    UIButton *btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTest addTarget:self action:@selector(goTestPage:) forControlEvents:UIControlEventTouchUpInside];
    [btnTest setImage:[UIImage imageNamed:@"Fighter.png"] forState:UIControlStateNormal];
    btnTest.frame = CGRectMake(896, 640, 128, 128);
    [self.view addSubview:btnTest];
}

// Connect to other peers by displayign the GKPeerPicker
- (void) connectToPeers:(id) sender{
    [fartPicker show];
}

- (void) goTestPage:(id) sender
{
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [self.view removeFromSuperview];
    }
    else
    {
        // use this method on ios6
        [pWindow setRootViewController:(UIViewController*)pRootViewController];
    }
    
    cocos2d::CCApplication::sharedApplication().run();
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark GKPeerPickerControllerDelegate

// This creates a unique Connection Type for this particular applictaion
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
    // Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
    GKSession* session = [[GKSession alloc] initWithSessionID:@"com.vivianaranha.sendfart" displayName:nil sessionMode:GKSessionModePeer];
    return [session autorelease];
}

// Tells us that the peer was connected
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    
    // Get the session and assign it locally
    self.fartSession = session;
    session.delegate = self;
    
    //No need of teh picekr anymore
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
    if(state == GKPeerStateConnected){
        // Add the peer to the Array
        [fartPeers addObject:peerID];
        
        NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        // Used to acknowledge that we will be sending data
        [session setDataReceiveHandler:pRootViewController.self withContext:nil];
        
        [[self.view viewWithTag:12] removeFromSuperview];
        
        UIButton *btnLoudFart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnLoudFart addTarget:self action:@selector(sendALoudFart:) forControlEvents:UIControlEventTouchUpInside];
        [btnLoudFart setTitle:@"Loud Fart" forState:UIControlStateNormal];
        btnLoudFart.frame = CGRectMake(20, 150, 280, 30);
        btnLoudFart.tag = 13;
        [self.view addSubview:btnLoudFart];
        
        [pRootViewController setConnectionVaries:fartSession second:fartPicker third:fartPeers];
        
        if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
        {
            // warning: addSubView doesn't work on iOS6
            [self.view removeFromSuperview];
        }
        else
        {
            // use this method on ios6
            [pWindow setRootViewController:(UIViewController*)pRootViewController];
        }
        
        cocos2d::CCApplication::sharedApplication().run();
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
