//
//  SpeechTest3AppController.h
//  SpeechTest3
//
//  Created by 김정호 on 12. 11. 24..
//  Copyright __MyCompanyName__ 2012년. All rights reserved.
//

#import "RootViewController.h"
#import "AppController.h"

const unsigned char SpeechKitApplicationKey[] = {0x1d, 0xc7, 0xce, 0x0c, 0x30, 0xe0, 0x81, 0x54, 0xaf, 0x86, 0xae, 0x61, 0xec, 0xd8, 0x2f, 0x95, 0x20, 0xa4, 0xb7, 0x76, 0xdc, 0x3a, 0x91, 0xd3, 0x37, 0xd5, 0x20, 0x34, 0x5c, 0x9e, 0xf5, 0x79, 0x66, 0xc3, 0x85, 0x96, 0xa3, 0x07, 0xea, 0x53, 0x8d, 0x99, 0xb4, 0x79, 0x71, 0xe4, 0x0e, 0x91, 0x88, 0xc6, 0x07, 0x64, 0x00, 0x98, 0x37, 0x37, 0x6d, 0x58, 0x6c, 0xc9, 0xf6, 0x61, 0x43, 0x5c};

@implementation RootViewController

static _transactionState transactionState = TS_IDLE;
static char text[256] = "Hi";

//@synthesize recordButton,searchBox,alternativesDisplay,voiceSearch;
@synthesize voiceSearch;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        [self viewDidLoad];
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SpeechKit setupWithID:@"NMDPTRIAL_Plulena20120913202347"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:self];
    
    //	// Set earcons to play
	SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
	SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
	SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
	
	[SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
	[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
	[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
    
    
    fartPicker = [[GKPeerPickerController alloc] init];
    fartPicker.delegate = self;
    
    fartPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    fartPeers=[[NSMutableArray alloc] init];
    
    UIButton *btnConnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnConnect addTarget:self action:@selector(connectToPeers:) forControlEvents:UIControlEventTouchUpInside];
    [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
    btnConnect.frame = CGRectMake(20, 100, 280, 30);
    btnConnect.tag = 12;
    [self.view addSubview:btnConnect];
}

// Connect to other peers by displayign the GKPeerPicker
- (void) connectToPeers:(id) sender{
    [fartPicker show];
}

- (void) sendALoudFart:(id)sender{
    // Making up the Loud Fart sound <img src="http://vivianaranha.com/wp-includes/images/smilies/icon_razz.gif" alt=":P" class="wp-smiley">
    NSString *loudFart = @"Brrrruuuuuummmmmmmppppppppp";
    
    // Send the fart to Peers using teh current sessions
    [fartSession sendData:[loudFart dataUsingEncoding: NSASCIIStringEncoding] toPeers:fartPeers withDataMode:GKSendDataReliable error:nil];
    
}

- (void) sendASilentAssassin:(id)sender{
    // Making up the Silent Assassin <img src="http://vivianaranha.com/wp-includes/images/smilies/icon_razz.gif" alt=":P" class="wp-smiley">
    NSString *silentAssassin = @"Puuuuuuuusssssssssssssssss";
    
    // Send the fart to Peers using teh current sessions
    [fartSession sendData:[silentAssassin dataUsingEncoding: NSASCIIStringEncoding] toPeers:fartPeers withDataMode:GKSendDataReliable error:nil];
    
}

// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
    return UIInterfaceOrientationMaskAllButUpsideDown;
#endif
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [voiceSearch release];
    [fartPeers release];
    
    [super dealloc];
}

+ (void)initialize
{
    transactionState = TS_IDLE;
}

+ (void)startRecognition {
    if (transactionState == TS_RECORDING) {
        [pRootViewController->voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) {
        SKEndOfSpeechDetection detectionType = SKShortEndOfSpeechDetection;
        NSString* recoType = SKSearchRecognizerType;
        NSString* langType = @"ko_KR";
        
        transactionState = TS_INITIAL;
        
        if (pRootViewController->voiceSearch) [pRootViewController->voiceSearch release];
		
        pRootViewController->voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                                                    detection:detectionType
                                                                     language:langType
                                                                     delegate:pRootViewController.self];
        
        
        NSLog(@"[%@], [%@]", self, pRootViewController.self);
    }
}

+ (char *)getResponse {
    return text;
}

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording started.");
    
    transactionState = TS_RECORDING;
    memcpy(text, [@"Recording..." UTF8String], 256);
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    transactionState = TS_PROCESSING;
    memcpy(text, [@"Processing..." UTF8String], 256);
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    
    memcpy(text, [[results firstResult] UTF8String], 256);
    
	[voiceSearch release];
	voiceSearch = nil;
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"Got error.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    transactionState = TS_IDLE;
    
	[voiceSearch release];
	voiceSearch = nil;
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

// Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    //Convert received NSData to NSString to display
    NSString *whatDidIget = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    //memcpy(text, [whatDidIget UTF8String], 256);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fart Received" message:whatDidIget delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [whatDidIget release];
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
        [session setDataReceiveHandler:self withContext:nil];
        
        [[self.view viewWithTag:12] removeFromSuperview];
        
        UIButton *btnLoudFart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnLoudFart addTarget:self action:@selector(sendALoudFart:) forControlEvents:UIControlEventTouchUpInside];
        [btnLoudFart setTitle:@"Loud Fart" forState:UIControlStateNormal];
        btnLoudFart.frame = CGRectMake(20, 150, 280, 30);
        btnLoudFart.tag = 13;
        [self.view addSubview:btnLoudFart];
        
        UIButton *btnSilentFart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnSilentFart addTarget:self action:@selector(sendASilentAssassin:) forControlEvents:UIControlEventTouchUpInside];
        [btnSilentFart setTitle:@"Silent Assassin" forState:UIControlStateNormal];
        btnSilentFart.frame = CGRectMake(20, 200, 280, 30);
        btnSilentFart.tag = 14;
        [self.view addSubview:btnSilentFart];
    }
    
}
@end
