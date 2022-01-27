//
//  ReportViewer.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 08/05/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "ReportViewer.h"

@implementation ReportViewer
-(void)viewDidLoad{
    
    _BaseCtrlr=[[BaseViewController alloc] init];
    self.UserDet=[UserDetails sharedUserDetails];
    self.lblDispSF.text=self.UserDet.SFName;
    
    self.profileImg.image=[self.BaseCtrlr getProfileImage:@"/images/profile.jpg"];
    self.profileImg.clipsToBounds = YES;
    self.profileImg.layer.cornerRadius= 8.5f;
    self.profileImg.layer.borderWidth = 1.0f;
    self.profileImg.layer.borderColor= [UIColor whiteColor].CGColor;
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@?SF=%@&Div_Code=%@&SFTyp=%@",_sUrl,self.UserDet.SF,self.UserDet.DivCode,self.UserDet.Desig];
    NSLog(@"%@",urlAddress);
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [_webRptViewer loadRequest:requestObj];
}
-(void) setWebUrl:(NSString* ) webUrl {
    _sUrl=webUrl;
}
-(IBAction) gotoHome:(id)sender{
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}

- (IBAction)share:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        NSString* fileName=@"";
        NSURL  *url = _webRptViewer.request.URL;
        NSArray *DataTypes=[[url absoluteString] componentsSeparatedByString:@","];
        
        if([DataTypes[0] rangeOfString:@"data:text/csv"].location!=NSNotFound){
            fileName=@"Export.csv";
        }else if([DataTypes[0] rangeOfString:@"data:application/vnd.ms-excel;base64"].location!=NSNotFound){
                fileName=@"Export.xls";
        }else{
            NSArray *pathlist=[[url absoluteString] componentsSeparatedByString:@"/"];
            fileName=pathlist[[pathlist count]-1];
        }
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                [self sharefile:filePath];
                NSLog(@"File Saved !");
            });
        }
        
    });
}

-(void) sharefile:(NSString *) filePath{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSArray *activityItems = [NSArray arrayWithObjects: url, nil];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    }
    //if iPad
    else {
        
        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [activityController popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popController.delegate = self;
        
        // in case we don't have a bar button as reference
        popController.sourceView = self.view;
        popController.sourceRect = CGRectMake(self.btnShare.frame.origin.x, self.btnShare.frame.origin.y, 0, 0);
        
        popController.delegate = self; //18
        [self presentViewController:activityController animated:YES completion:nil]; // 19
        
        // Change Rect to position Popover
        /*UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
         [popup presentPopoverFromRect:CGRectMake(self.vwWinMenu.frame.origin.x+150, self.vwWinMenu.frame.origin.y, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];*/
    }
}
@end
