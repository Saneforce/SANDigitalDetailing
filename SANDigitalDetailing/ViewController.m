//
//  ViewController.m
//  SANAPP
//
//  Created by SANeForce.com on 26/05/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "ViewController.h"
#import "MainHomeController.h"
#import "WBService.h"
#import "SSZipArchive.h"
#import "KeyboardView.h"
#import "AppSettings.h"
#import "AppDelegate.h"
#import "GraphManager.h"
#import "AuthenticationManager.h"
//#import "LocationTracker.h"
@interface ViewController ()

@property(nonatomic,strong) AVCaptureSession *session;
@property(nonatomic,strong) AVCaptureStillImageOutput *stillImageOutput;

@property(nonatomic,strong) BaseViewController *BaseCtrlr;
@property(nonatomic,assign) CGSize keyboardSize;
@property(nonatomic,assign) CGFloat animatedDistance;
@property(nonatomic,assign) CGFloat frameHeight;
@property(nonatomic,strong) UITextField* CtxtFld;
@property(nonatomic,assign) BOOL LocationStarted;
@property(nonatomic,assign) BOOL PopShow;
@property(nonatomic,strong) NSString* lUpdTime;

@end

@implementation ViewController
    static const CGFloat ANIMATION_DURATION = 0.4;
    static const CGFloat LITTLE_SPACE = 25;
    static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
    
@synthesize locationManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //LocationTracker *locationTracker=[[LocationTracker alloc] init];
    _BaseCtrlr=[[BaseViewController alloc] init];
    self.SetupData=[AppSetupData sharedDatas];
    self.locationData=[LocationDetail sharedLocationData];
    _config=[Config sharedConfig];
    UIColor* imageBorderColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    self.logingVw.layer.cornerRadius= 25.0f;
    self.loginButton.layer.cornerRadius= 5.0f;
    self.usernameField.layer.cornerRadius= 5.0f;
    self.passwordField.layer.cornerRadius= 5.0f;
    self.ssoTMButton.layer.cornerRadius= 5.0f;
    NSString* fontName = @"Avenir-black";
    NSMutableDictionary *UserDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails.SANAPP"] mutableCopy];
    self.UserDet=[UserDetails sharedUserDetails:UserDet];
    NSString *sUID=[UserDet objectForKey:@"SF_User_Name"];
    self.usernameField.text=sUID;
    
    
    self.CmpLogoImg.image=[self.BaseCtrlr getProfileImage:[NSString stringWithFormat:@"/images/%@",self.config.CmpLogo]];
    self.CmpLogoImg.clipsToBounds = YES;
    
    self.profileImg.image=[self.BaseCtrlr getProfileImage:@"/images/profile.jpg"];
    self.profileImg.clipsToBounds = YES;
    self.profileImg.layer.cornerRadius= (self.config.iPadDevice==YES)?100.0f:78.0f;
    self.profileImg.layer.borderWidth = 4.0f;
    self.profileImg.layer.borderColor= imageBorderColor.CGColor;
    /*self.usernameField.hidden=YES;
    self.passwordField.hidden=YES;
    self.loginButton.hidden=YES;
    
    self.ssoTMButton.hidden=NO;
    */
    NSString *string = @"ENHANCING  INTERACTION  WITH  PHYSICIAN";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    self.lSubHeading.attributedText = attributedString;
    
    UIImageView* usernameIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 24, 24)];
    usernameIconImage.image = [UIImage imageNamed:@"User"];
    UIView* usernameIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    [usernameIconContainer addSubview:usernameIconImage];
    
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView = usernameIconContainer;
    
    UIImageView* passIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 24, 24)];
    passIconImage.image = [UIImage imageNamed:@"Lock"];
    UIView* passIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    [passIconContainer addSubview:passIconImage];
    
    
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = passIconContainer;
    
    
    self.forgotButton.backgroundColor = [UIColor clearColor];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:17.0f];
    [self.forgotButton setTitle:NSLocalizedString(@"ForgotPasswordBTN", @"Forgot Password?") forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    [self validGPSSetting];
    //self.logingVw.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    _CtxtFld=NULL;
    [self.view addGestureRecognizer:tap];
    
    self.lUpdTime=[BaseViewController date2str:[NSDate date] onlyDate:NO];
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(LocationStartandStop) userInfo:nil repeats:YES] ;
    [timer fire];
    NSTimer *tmLTracker=[NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(sendTrackerLocation) userInfo:nil repeats:YES] ;
    [tmLTracker fire];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"SignMsg",@"Sign In...")];
    [AuthenticationManager.instance
     getTokenSilentlyWithCompletionBlock:^(NSString * _Nullable accessToken, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];

             if (error || !accessToken) {
                 // If there is no token or if there's an error,
                 // no user is signed in, so stay here
                 return;
             }

             // Since we got a token, user is signed in
             // Go to welcome page
             
             NSMutableDictionary *UserDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails.SANAPP"] mutableCopy];
             if(UserDet!=nil)
             {
                 [self performSegueWithIdentifier: @"login_success" sender: nil];
             }
         });
    }];
}
- (void)handleSingleTap
{
    [self.view endEditing:YES];
}
-(void)LocationStartandStop{
    if(_PopShow==NO){
    if (self.locationData.userSignedIn && !self.LocationStarted) {
        [self checkLocationServicesAndStartUpdates];
    }else if (!self.locationData.userSignedIn && self.LocationStarted) {
        [locationManager stopUpdatingLocation];
        self.LocationStarted=NO;
    }else if(self.locationData.userSignedIn && self.LocationStarted==YES ){
        [self validGPSSetting];
    }
        
    }
}
-(BOOL) validGPSSetting{
    if (self.SetupData.GeoNeed==0 &&  ([CLLocationManager locationServicesEnabled]==NO || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        self.LocationStarted=NO;
        _PopShow=YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LocMsgTitle",@"Location Services Disabled!")
            message:NSLocalizedString(@"msgLocEnable",@"Please enable Location Based Services for better results! We promise to keep your location private")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Settings",@"Settings")
                                                  otherButtonTitles:nil, nil];
        
        //TODO if user has not given permission to device
       /* if (![CLLocationManager locationServicesEnabled])
        {
            alertView.tag = 100;
        }
        //TODO if user has not given permission to particular app
        else
        {*/
            alertView.tag = 200;
        //}
        
       // [alertView show];
        
      //  return false;
        
    }
    
    return true;
}
-(void) checkLocationServicesAndStartUpdates
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.activityType=CLActivityTypeFitness;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;//constant update of device location
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    
    //Checking authorization status
    if (![self validGPSSetting])
    {
        return;
    }
    else
    {
        //Location Services Enabled, let's start location updates
        [locationManager startUpdatingLocation];
        self.LocationStarted=YES;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0) //Settings button pressed
    {
        /*if (alertView.tag == 100)
        {
            //This will open ios devices location settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            _PopShow=NO;
        }
        else */
        if (alertView.tag == 200)
        {
            //This will open particular app location settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
            _PopShow=NO;
        }
    }
    else if(buttonIndex == 1)//Cancel button pressed.
    {
        //TODO for cancel
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location Failed : %@", error.debugDescription);
    //UIAlertView *errorAlert = [[UIAlertView alloc]
    //                           initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[errorAlert show];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        //NSLog(@"New Location: %f , %f", theLocation.latitude,theLocation.longitude);
        if (locationAge > 10.0)
        {
            continue;
        }
        
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0)) &&
           self.locationData.userSignedIn==YES){
            
            //self.myLastLocation = theLocation;
            //self.myLastLocationAccuracy= theAccuracy;
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
            [dict setObject:[NSDate date] forKey:@"date"];
            
            longitudeLabel.text = [NSString stringWithFormat:@"%.8f", theLocation.longitude];
            latitudeLabel.text = [NSString stringWithFormat:@"%.8f", theLocation.latitude];
            
            self.locationData.latitude=[NSString stringWithFormat:@"%.8f", theLocation.latitude];
            self.locationData.longitude=[NSString stringWithFormat:@"%.8f", theLocation.longitude];
            
            [self.locationData.TrackedLocationList addObject:dict];
            //NSLog(@"%@",dict);
            /*UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
                if([topController isKindOfClass: [CDVViewController class]])
                {
                    [((CDVViewController*)topController) SendData:[NSString stringWithFormat:@"%f;%f;%@;;%f;;",newLocation.coordinate.latitude,newLocation.coordinate.longitude,[BaseViewController date2str:[NSDate date]  onlyDate:false],theAccuracy]];
                    //[((UIWebView*)subview) stringByEvaluatingJavaScriptFromString:@"getLocation()"];
                }
            }*/
            
        }
    }
    
}
-(void) sendTrackerLocation{
    NSMutableArray *LArry=[[self.locationData.TrackedLocationList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"date>%@", [BaseViewController str2date:self.lUpdTime]]] mutableCopy];
    if([LArry count]>0){
        self.lUpdTime=[BaseViewController date2str:[LArry[LArry.count-1] objectForKey:@"date"] onlyDate:NO];
        NSMutableArray* NLArry =[[NSMutableArray alloc] init];
        for(int il=0;il<[LArry count];il++){
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[LArry[il] objectForKey:@"latitude"] forKey:@"latitude"];
            [dict setObject:[LArry[il] objectForKey:@"longitude"] forKey:@"longitude"];
            [dict setObject:[LArry[il] objectForKey:@"theAccuracy"] forKey:@"theAccuracy"];
            NSString *sDate=[BaseViewController date2str:[LArry[il] objectForKey:@"date"] onlyDate:NO];
            [dict setValue:sDate forKey:@"date"];
            
            [NLArry addObject:dict];
        }
        [WBService SendServerRequest:@"Save/Track" withParameter:[NLArry mutableCopy] withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            self.locationData.TrackedLocationList=[[self.locationData.TrackedLocationList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"date>%@", [BaseViewController str2date:self.lUpdTime]]] mutableCopy];
            }
            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
               NSLog(@"%@",errorMsg);
            }
         ];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (IBAction)dismissKeyboard:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)signIn:(id)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"SignMsg",@"Sign In...")];

    [AuthenticationManager.instance
     getTokenInteractivelyWithParentView:self
     andCompletionBlock:^(NSString * _Nullable accessToken, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];

             if (error || !accessToken) {
                 // Show the error and stay on the sign-in page
                 UIAlertController* alert = [UIAlertController
                                             alertControllerWithTitle:@"Error signing in"
                                             message:error.debugDescription
                                             preferredStyle:UIAlertControllerStyleAlert];

                 UIAlertAction* okButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:nil];

                 [alert addAction:okButton];
                 [self presentViewController:alert animated:true completion:nil];
                 return;
             }

             //self.userProfilePhoto.image = [UIImage imageNamed:@"DefaultUserPhoto"];

             [GraphManager.instance
              getMeWithCompletionBlock:^(MSGraphUser * _Nullable user, NSError * _Nullable error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[self.spinner stop];

                     if (error) {
                         // Show the error
                         UIAlertController* alert = [UIAlertController
                                                     alertControllerWithTitle:@"Error getting user profile"
                                                     message:error.debugDescription
                                                     preferredStyle:UIAlertControllerStyleAlert];

                         UIAlertAction* okButton = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:nil];

                         [alert addAction:okButton];
                         [self presentViewController:alert animated:true completion:nil];
                         return;
                     }
                     [WBService SendServerRequest:@"Login/Email" withParameter:[@{@"Email":user.mail ? : user.userPrincipalName} mutableCopy] withImages:nil DataSF:nil
                       completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                         NSMutableDictionary *receivedDta=[[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
                                if([[receivedDta objectForKey:@"success"] boolValue]==YES){
                                     NSData *encypPwd=[BaseViewController  encryptString:[receivedDta valueForKey:@"SF_Password"] withKey:@"0a1b2c3d4e5f@" ];
                                     [receivedDta setObject:encypPwd forKey:@"SF_PDA"];
                                     [WBService saveData:receivedDta forKey:@"UserDetails.SANAPP"];
                                     self.UserDet=[UserDetails sharedUserDetails:receivedDta];
                                     
                                     self.locationData.userSignedIn=YES;
                                     [self performSegueWithIdentifier:@"login_success" sender:self];
                                     
                                     [SVProgressHUD dismiss];
                                }
                                else
                                {
                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                                         message:[receivedDta objectForKey:@"msg"]
                                                                                        delegate:self
                                                                               cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil, nil];
                                     [alertView show];
                                     [SVProgressHUD dismiss];
                                }
                            } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                            }
                     ];
                     NSLog(@"%@", user.mail ? : user.userPrincipalName);
                     // Set display name
                     /*self.userDisplayName.text = user.displayName ? : @"Mysterious Stranger";
                     [self.userDisplayName sizeToFit];

                     // AAD users have email in the mail attribute
                     // Personal accounts have email in the userPrincipalName attribute
                     self.userEmail.text = user.mail ? : user.userPrincipalName;
                     [self.userEmail sizeToFit];*/
                 });
              }];
             
             // Since we got a token, user is signed in
             // Go to welcome page
             //[self performSegueWithIdentifier: @"login_success" sender: nil];
         });
     }];
}

- (IBAction)btnSignTapped:(id)sender {
    if(![self validGPSSetting]){
        return;
    }
    [self checkLocationServicesAndStartUpdates];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"SignMsg",@"Sign In...")];
    
    WBService* WBServ=[[WBService alloc] init];
    NSMutableDictionary *UserDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails.SANAPP"] mutableCopy];
    if(UserDet==nil)
    {
        [WBServ authenticateUser:self.usernameField.text withUserPassword:self.passwordField.text completion:^(BOOL success, id respData) {
            NSMutableDictionary *receivedDta=[[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
            if([[receivedDta objectForKey:@"success"] boolValue]==YES){
                NSData *encypPwd=[BaseViewController  encryptString:self.passwordField.text.lowercaseString withKey:@"0a1b2c3d4e5f@" ];
                [receivedDta setObject:encypPwd forKey:@"SF_PDA"];
                [WBService saveData:receivedDta forKey:@"UserDetails.SANAPP"];
                self.UserDet=[UserDetails sharedUserDetails:receivedDta];
                
                self.locationData.userSignedIn=YES;
                [self performSegueWithIdentifier:@"login_success" sender:self];
                
                [SVProgressHUD dismiss];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                    message:[receivedDta objectForKey:@"msg"]
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil, nil];
                [alertView show];
                [SVProgressHUD dismiss];
            }
        } error:^(NSString *errMsg){
            if([errMsg isEqualToString:@""]){
                errMsg=NSLocalizedString(@"InvalidConfig",@"Invalid APP Configuration / Your Device is Offline");
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                message:errMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [SVProgressHUD dismiss];
        }];
    }
    else{
        NSString *UID=self.usernameField.text.lowercaseString;
        NSString *Pwd=self.passwordField.text.lowercaseString;
        
        self.UserDet=[UserDetails sharedUserDetails:UserDet];
        NSString *sUID=[UserDet objectForKey:@"SF_Code"];
        NSString *sUNm=[UserDet objectForKey:@"SF_User_Name"];
        
        NSString *sPwd=[BaseViewController decryptData:[UserDet objectForKey:@"SF_PDA"] withKey:@"0a1b2c3d4e5f@"];
        
        if(([sUID.lowercaseString isEqualToString:UID]==YES || [sUNm.lowercaseString isEqualToString:UID]==YES )&& [sPwd.lowercaseString isEqualToString:Pwd]==YES)
        {
            self.locationData.userSignedIn=YES;
            [WBServ authenticateUser:UID withUserPassword:sPwd completion:^(BOOL success, id respData) {
                NSMutableDictionary *receivedDta=[[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
                if([[receivedDta objectForKey:@"success"] boolValue]==YES){
                    NSData *encypPwd=[BaseViewController  encryptString:self.passwordField.text.lowercaseString withKey:@"0a1b2c3d4e5f@" ];
                    [receivedDta setObject:encypPwd forKey:@"SF_PDA"];
                    [WBService saveData:receivedDta forKey:@"UserDetails.SANAPP"];
                    self.UserDet=[UserDetails sharedUserDetails:receivedDta];
                    
                }
            } error:^(NSString *errMsg){
            }];
            [self performSegueWithIdentifier:@"login_success" sender:self];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                message:NSLocalizedString(@"InvalidUser",@"Invalid User ID / Password")
                                                               delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        [SVProgressHUD dismiss];
    }
}
    
- (IBAction)openCameraButton:(id)sender {
    if (!self.session){
        self.session=[[AVCaptureSession alloc] init];
        [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
        AVCaptureDevice *inputDevice=[self frontCamera];//[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *err;
    
        AVCaptureDeviceInput *deviceInput=[AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&err];
        if([self.session canAddInput:deviceInput]){
            [self.session addInput:deviceInput];
        }
    
        AVCaptureVideoPreviewLayer *prevwLyr=[[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [prevwLyr setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        CALayer *rootLyr=[[self profileImg] layer];
        [rootLyr setMasksToBounds:YES];
        CGRect frame=captureView.bounds;
        [prevwLyr setFrame:frame];
        
        prevwLyr.orientation = [[UIDevice currentDevice] orientation];
        [rootLyr insertSublayer:prevwLyr atIndex:0];
        
        self.stillImageOutput =[[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings=[[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        [self.stillImageOutput setOutputSettings:outputSettings];
        [self.session addOutput:self.stillImageOutput];
    }
    [self.session startRunning];
    
    captureView.hidden=YES;
    tkPhotoView.hidden=NO;
}
- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

-(IBAction)StartCam:(id)sender{
    
    AVCaptureConnection *videoConn=nil;
    for(AVCaptureConnection *connection in self.stillImageOutput.connections){
        for(AVCaptureInputPort *port in [connection inputPorts]){
            if([[port mediaType] isEqual:AVMediaTypeVideo]){
                videoConn=connection;
            }
        }
    }
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConn completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer!=NULL){
            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image=[UIImage imageWithData:imageData];
            _profileImg.image=image;
            int Orint=4;
            if ([[UIDevice currentDevice] orientation]==3) Orint=5;
            
            UIImage *fixed = [UIImage imageWithCGImage:_profileImg.image.CGImage scale:image.scale orientation:Orint];
            [self.BaseCtrlr saveImageAsJPG:fixed andWithFileName:@"profile" andDirectory:@"images"];
            [self.session stopRunning];
            captureView.hidden=NO;
            tkPhotoView.hidden=YES;
        }
    }];
    
}
-(IBAction) ShowSettings:(id)sender{

    
    [self performSegueWithIdentifier:@"ShowSetting" sender:self];
}
- (NSArray *)allSubviewsOfView:(UIView *)view
{
    NSMutableArray *subviews = [[view subviews] mutableCopy];
    for (UIView *subview in [view subviews])
        [subviews addObjectsFromArray:[self allSubviewsOfView:subview]]; //recursive
    return subviews;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{}
-(void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _CtxtFld=NULL;
    if(self.usernameField.isEditing) _CtxtFld=self.usernameField;
    if(self.passwordField.isEditing) _CtxtFld=self.passwordField;
    
    if (_CtxtFld!=NULL){
        CGRect viewFrame = self.view.window.frame;
        CGRect textFieldRect = [self.view.window convertRect:_CtxtFld.bounds fromView:_CtxtFld];
        CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
        CGFloat textFieldBottomLine = textFieldRect.origin.y + textFieldRect.size.height + LITTLE_SPACE;
        
        CGFloat keyboardHeight = _keyboardSize.height;
        
        BOOL isTextFieldHidden = textFieldBottomLine > (viewRect.size.height - keyboardHeight)? TRUE :FALSE;
        if (isTextFieldHidden) {
            viewFrame.origin.y=0;
            _animatedDistance = textFieldBottomLine - (viewRect.size.height - keyboardHeight) ;
            viewFrame.origin.y -= _animatedDistance;
            if(viewFrame.origin.y>0) viewFrame.origin.y=0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:ANIMATION_DURATION];
            //[self.view.window layoutIfNeeded];
            [self.view.window setFrame:viewFrame];
            [UIView commitAnimations];
        }
    }
}
    // Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
    {
        CGRect viewFrame = self.view.window.frame;
        viewFrame.origin.y=0;
        //viewFrame.origin.y += _animatedDistance;

        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        
        //[self.view.window layoutIfNeeded];
        
        [self.view.window setFrame:viewFrame];
        [UIView commitAnimations];
}
@end
