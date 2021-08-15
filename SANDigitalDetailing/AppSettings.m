//
//  AppSettings.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 08/04/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "AppSettings.h"
#import "AppDelegate.h"
#import "WBService.h"
#import "GraphManager.h"
#import "AuthenticationManager.h"
CGImageRef UIGetScreenImage(void);
@implementation AppSettings
- (void)viewDidLoad {
    [super viewDidLoad];
    self.SetupData=[AppSetupData sharedDatas];
    
    NSMutableDictionary *ConfigFileDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ConfigFile.SANConfigAPP"] mutableCopy];
    _txtWebUrl.text=[ConfigFileDet objectForKey:@"WebURL"];
    _txtCmpLKey.text=[ConfigFileDet objectForKey:@"LicKey"];
    
    _BaseCtrlr=[[BaseViewController alloc] init];
    if(_SetupData.MeetEventNeed==1){
        UIButton* btnTeams=[[UIButton alloc] initWithFrame:CGRectMake(18, _lblDivID.frame.origin.y+_lblDivID.frame.size.height+25, 200, 30)];
        btnTeams.titleLabel.font=[UIFont fontWithName:@"Poppins-SemiBold" size:14.0];
        btnTeams.backgroundColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        [btnTeams setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTeams setTitle:NSLocalizedString(@"LoginTeamsBTN", @"Login Teams") forState:UIControlStateNormal];
        [btnTeams addTarget:self action:@selector(signInTeams:) forControlEvents:UIControlEventTouchUpInside];
        
        [_lblDivID.superview addSubview:btnTeams];
    }
   // _ScrImg.image=[self blurredImageWithImage:_ScrImg.image];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    
    [self.view addGestureRecognizer:tap];
}
- (void)handleSingleTap
{
    [self.view endEditing:YES];
}
- (IBAction)signInTeams:(id)sender {
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


-(void)viewDidAppear:(BOOL)animated{
    
    /*NSMutableDictionary *ServDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerDet.SANConfigAPP"] mutableCopy];
    if(ServDet!=nil){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"MovetoLogin" sender:self];
    }*/
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    self.lblDivID.text=currentDeviceId;
}
-(IBAction)gotoLoginPg:(id)sender{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Connection Server...", @"Connection Server...")];
    NSMutableDictionary *configFile=[[NSMutableDictionary alloc] init];
    [configFile setValue:self.txtWebUrl.text forKey:@"WebURL"];
    [configFile setValue:self.txtCmpLKey.text forKey:@"LicKey"];
    [WBService saveData:configFile forKey:@"ConfigFile.SANConfigAPP"];
    NSString* sURL=[NSString stringWithFormat:@"http://%@/Apps/ConfigiOS.json",self.txtWebUrl.text];
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:sURL]];
    //NSmu* json = [NSJSONSerialization JSONObjectWithData:data
    //                                                     options:kNilOptions
    //                                                       error:nil];
   // [WBService getUrlData:sURL completion:^(BOOL success, id respData){
    if(data!=nil){
        NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        int flConfig=0;
        for(int il=0;il<[receivedDta count];il++)
        {
            NSString* sKey=[[receivedDta[il] valueForKey:@"key"] lowercaseString];
            if([sKey isEqualToString:[self.txtCmpLKey.text lowercaseString]])
            {
                flConfig=1;
                self.config=[Config sharedConfig];
                NSMutableDictionary *ConfigDta=[receivedDta[il] valueForKey:@"config"] ;
                self.config.WebUrl=[ConfigDta valueForKey:@"weburl"];
                self.config.BaseUrl=[NSString stringWithFormat:@"%@%@",self.config.WebUrl,[ConfigDta valueForKey:@"baseurl"]];
                self.config.SlideUrl=[NSString stringWithFormat:@"%@%@",self.config.WebUrl,[ConfigDta valueForKey:@"slideurl"]];
                self.config.ReportUrl=[NSString stringWithFormat:@"%@%@",self.config.WebUrl,[ConfigDta valueForKey:@"reportUrl"]];
                
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.config.WebUrl,[ConfigDta valueForKey:@"logoimg"]]];
                self.config.CmpLogo=[url lastPathComponent];
                self.config.iPadDevice=[[[AppDelegate alloc] init] iPadDevice];
                [Config SaveConfig];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                           if ( !error )
                                           {
                                               
                                               Config *config=[Config sharedConfig];
                                               NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",config.WebUrl,config.CmpLogo]];
                                               
                                               NSString *ext=[url pathExtension];
                                               UIImage *image = [[UIImage alloc] initWithData:data];
                                               [BaseViewController saveImage:image withFileName:config.CmpLogo ofType:ext inDirectory:@"images" ];
                                               
                                               [self dismissViewControllerAnimated:YES completion:nil];
                                               [self performSegueWithIdentifier:@"MovetoLogin" sender:self];
                                           } else{
                                               [BaseViewController Toast:NSLocalizedString(@"Check your internet connection and try again", @"Check your internet connection and try again")];
                                           }
                                       }];
                [SVProgressHUD dismiss];
            }
        }
        if(flConfig==0)
        {
            [BaseViewController Toast:NSLocalizedString(@"Invalid Licence Key", @"Invalid Licence Key")];
            [SVProgressHUD dismiss];
        }
    }else{
        [BaseViewController Toast:NSLocalizedString(@"Invalid Access Configuration Url / Connection Failed", @"Invalid Access Configuration Url / Connection Failed")];
        [SVProgressHUD dismiss];
    }
//    }
//    error:^(NSString *errorMsg){
//        NSLog(@"%@",errorMsg);
//    }];
    

}
- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:1.5f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    return retVal;
}
-(IBAction) CloseSettings:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction) ClearDatas:(id)sender{
    [AuthenticationManager.instance signOut];
    [WBService ClearAllData];
}
-(IBAction) showProfCama:(id)sender{
    self.vwMProfImg.hidden=NO;
    CapturedImage=nil;
    self.vwImgCapture.image=[self.BaseCtrlr getProfileImage:@"/images/profile.jpg"];
}

-(IBAction) hideProfCama:(id)sender{
    self.vwMProfImg.hidden=YES;
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
        CALayer *rootLyr=self.vwImgCapture.layer;
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
            _vwImgCapture.image=image;
            int Orint=4;
            if ([[UIDevice currentDevice] orientation]==3) Orint=5;
            
            CapturedImage = [UIImage imageWithCGImage:_vwImgCapture.image.CGImage scale:image.scale orientation:Orint];
            [self.session stopRunning];
            captureView.hidden=NO;
            tkPhotoView.hidden=YES;
        }
    }];
    
}
-(IBAction) setProfileImg:(id)sender{
    if(CapturedImage!=nil){
        [self.BaseCtrlr saveImageAsJPG:CapturedImage andWithFileName:@"profile" andDirectory:@"images"];
        [BaseViewController Toast:NSLocalizedString(@"Profile Picture has been updated", @"Profile Picture has been updated")];
    }
}
-(IBAction)CloseChangePWD:(id)sender{
    self.vwPWDMChange.hidden=YES;
}

-(IBAction)showChangePWD:(id)sender{
    NSMutableDictionary *UserDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails.SANAPP"] mutableCopy];
    self.lblUNM.text=[UserDet valueForKey:@"SF_Name"];
    self.txtOPW.text=@"";
    self.txtNPW.text=@"";
    self.txtCPW.text=@"";
    self.vwPWDMChange.hidden=NO;
}

-(IBAction)svChangePW:(id)sender{
    NSMutableDictionary *UserDet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails.SANAPP"] mutableCopy];
    if([self.txtOPW.text isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the Old Password", @"Enter the Old Password")];
        return;
    }
    if([self.txtNPW.text isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the New Password", @"Enter the New Password")];
        return;
    }
    if([self.txtCPW.text isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the Confirm Password", @"Enter the Confirm Password")];
        return;
    }
    NSString* sOPW=[UserDet valueForKey:@"SF_Password"];
    if(![self.txtOPW.text isEqualToString:sOPW]){
        [BaseViewController Toast:NSLocalizedString(@"Incorrect Old Password", @"Incorrect Old Password")];
        return;
    }
    if(![self.txtNPW.text isEqualToString:self.txtCPW.text]){
        [BaseViewController Toast:NSLocalizedString(@"Password Not Matched", @"Password Not Matched")];
        return;
    }
    NSLog(@"%@",UserDet);
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Creating Please Wait", @"Creating Please Wait...")];
    NSMutableDictionary* Data=[[NSMutableDictionary alloc] init];
    [Data setValue:self.txtOPW.text forKey:@"txOPW"];
    [Data setValue:self.txtNPW.text forKey:@"txNPW"];
    [Data setValue:self.txtCPW.text forKey:@"txCPW"];
    
    [WBService SendServerRequest:@"SAVE/CHPwd" withParameter:[Data mutableCopy] withImages:nil
          DataSF:nil
      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         if(Success==YES){
             [BaseViewController Toast:NSLocalizedString(@"Password has been Changed Successfully", @"Password has been Changed Successfully....")];
             [UserDet setValue:self.txtNPW.text forKey:@"SF_Password"];
             
             [WBService saveData:UserDet forKey:@"UserDetails.SANAPP"];
             [self CloseChangePWD:self];
         }
         else{
             [BaseViewController Toast:NSLocalizedString(@"Changing Failed.", @"Changing Failed.")];
             
         }
         [SVProgressHUD dismiss];
     }
                           error:^(NSString *errorMsg,NSMutableDictionary *uData){
                               [BaseViewController Toast:[NSString stringWithFormat:@"%@\n %@",NSLocalizedString(@"Changing FailedERR", @"Changing Failed."),errorMsg.description]];
                               [SVProgressHUD dismiss];
                           }];
    
    
}
@end
