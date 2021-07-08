//
//  AppSettings.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 08/04/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Config.h"
#import "BaseViewController.h"

@interface AppSettings : UIViewController <UIImagePickerControllerDelegate>
{
    IBOutlet UIView* frameCaptureView;
    
    IBOutlet UIView *captureView;
    IBOutlet UIView *tkPhotoView;
    UIImage* CapturedImage;
    
}
@property(nonatomic,strong) BaseViewController *BaseCtrlr;
@property (nonatomic, strong) AppSetupData* SetupData;
@property (nonatomic,weak) IBOutlet UIImageView* ScrImg;
@property (nonatomic,weak) IBOutlet UITextField* txtWebUrl;
@property (nonatomic,weak) IBOutlet UITextField* txtCmpLKey;
@property (nonatomic,weak) IBOutlet UILabel* lblDivID;
@property (nonatomic,weak) IBOutlet UILabel* lblUNM;
@property (nonatomic,weak) IBOutlet UIButton* btnProfImg;
@property (nonatomic,weak) IBOutlet UIImageView* profileImg;

@property (nonatomic,weak) IBOutlet UIImageView* vwImgCapture;
@property (nonatomic,weak) IBOutlet UIView* vwMProfImg;
@property (nonatomic,weak) IBOutlet UIView* vwPWDMChange;
@property (nonatomic,strong) Config* config;

@property (nonatomic,weak) IBOutlet UITextField* txtOPW;
@property (nonatomic,weak) IBOutlet UITextField* txtNPW;
@property (nonatomic,weak) IBOutlet UITextField* txtCPW;
@property(nonatomic,strong) AVCaptureSession *session;
@property(nonatomic,strong) AVCaptureStillImageOutput *stillImageOutput;
@end
