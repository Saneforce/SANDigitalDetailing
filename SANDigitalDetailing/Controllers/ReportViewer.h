//
//  ReportViewer.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 08/05/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ReportViewer : UIViewController
@property (nonatomic, strong) NSString* sUrl;
@property (nonatomic,strong) BaseViewController *BaseCtrlr;
@property (nonatomic,strong) UserDetails* UserDet;

@property (nonatomic, weak) IBOutlet UIImageView  *profileImg;
@property (nonatomic, weak) IBOutlet UILabel* lblDispSF;
@property (nonatomic, weak) IBOutlet UIButton* btnShare;

@property (nonatomic,weak) IBOutlet UIWebView* webRptViewer;

-(void) setWebUrl:(NSString* ) webUrl;
@end
