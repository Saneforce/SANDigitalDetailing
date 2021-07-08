//
//  ViewController.h
//  SANAPP
//
//  Created by SANeForce.com on 26/05/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate,CLLocationManagerDelegate>{
    
    IBOutlet UIView* frameCaptureView;

    IBOutlet UIView *captureView;
    IBOutlet UIView *tkPhotoView;
    IBOutlet UILabel *longitudeLabel;
    IBOutlet UILabel *latitudeLabel;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lSubHeading;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic,strong) UserDetails* UserDet;
@property (nonatomic,strong) Config* config;
@property (nonatomic,strong) LocationDetail* locationData;
@property (nonatomic, strong) AppSetupData* SetupData;


@property (nonatomic,weak) IBOutlet UIImageView  *BgImg;
@property (nonatomic,weak) IBOutlet UIImageView  *profileImg;
@property (nonatomic,weak) IBOutlet UIImageView  *CmpLogoImg;
@property (nonatomic,weak) IBOutlet UIButton  *forgotButton;
@property (nonatomic,weak) IBOutlet UIButton  *loginButton;
@property (nonatomic,weak) IBOutlet UIButton  *ssoTMButton;
@property (nonatomic,weak) IBOutlet UITextField  *usernameField;
@property (nonatomic,weak) IBOutlet UITextField  *passwordField;
@property (nonatomic,weak) IBOutlet UIView  *logingVw;


- (IBAction)btnSignTapped:(id)sender;
- (IBAction)textFieldDidBeginEditing:(UITextField *) textField;
- (IBAction)dismissKeyboard:(id)sender;
@end

