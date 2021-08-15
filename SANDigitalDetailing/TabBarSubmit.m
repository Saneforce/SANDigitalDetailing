//
//  TabBarSubmit.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 02/06/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "TabBarSubmit.h"

@implementation TabBarSubmit

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.MissedEntry=[MissedEntryData sharedDatas];
    self.meetData=[CallMeetData sharedDatas];
    if(self.meetData.MissedEntry==YES) [self setupMiddleButton];
}
-(void) setupMiddleButton {
    _btnSubmit=[[UIButton alloc] init];
    
    _btnSubmit.frame = CGRectMake(0, 0, 100, 40);
    // _btnSubmit.backgroundColor = [UIColor greenColor];
    _btnSubmit.layer.masksToBounds=YES;
    _btnSubmit.center = CGPointMake(UIScreen.mainScreen.bounds.size.width -55,  25);
    //_btnSubmit.layer.cornerRadius = 35;

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _btnSubmit.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithRed:255.0f/255.0f green:27.0f/255.0f blue:37.0f/255.0f alpha:1.0f].CGColor,
                            (id)[UIColor colorWithRed:255.0f/255.0f green:27.0f/255.0f blue:37.0f/255.0f alpha:0.5f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    gradientLayer.cornerRadius = _btnSubmit.layer.cornerRadius;

    [_btnSubmit.layer addSublayer:gradientLayer];
    [_btnSubmit setFont:[UIFont fontWithName:@"Poppins-SemiBold" size:13.0]];
    [_btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSubmit setTitle:NSLocalizedString(@"SubmitBTN", @"Submit") forState:UIControlStateNormal];
    [_btnSubmit addTarget:self action:@selector(SubmitData) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnSubmit];
}
-(void) SubmitData{
    NSLog(@"Submit Data : %@",[((CallMeetData *) _MissedEntry.MissDatas[0]) toNSDictionary]);
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Submitting Status",  @"Submitting Please Wait...")];
    
    NSMutableArray *CallDatas =[[NSMutableArray alloc] init];
    NSMutableDictionary *MissedData =[[NSMutableDictionary alloc] init];
    
    for (int ilc=0; ilc<[_MissedEntry.MissDatas count]; ilc++) {
    [CallDatas addObject:[[((CallMeetData *) _MissedEntry.MissDatas[ilc]) toNSDictionary] mutableCopy]];
    }
    [MissedData setObject:_meetData.EDate forKey:@"EDt"];
    [MissedData setObject:CallDatas forKey:@"EData"];
    [WBService SendServerRequest:@"SAVE/MissEntry" withParameter:[MissedData mutableCopy] withImages:nil
                          DataSF:nil
                      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
    {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         NSString *sMsg=[NSString stringWithFormat:@"%@",[receivedDta valueForKey:@"Msg"]];
         if(Success==YES){
             [BaseViewController Toast:NSLocalizedString(@"Call Submitted Successfully", @"Call Submitted Successfully")];
             
             [SVProgressHUD dismiss];
             NSArray *viewControllers = [self.NavCtrl viewControllers];
             [self.NavCtrl popToViewController:[viewControllers objectAtIndex:0] animated:NO];
         }
         else{
             [BaseViewController Toast:[NSString stringWithFormat:@"%@. %@",NSLocalizedString(@"Call Submission Failed", @"Call Submission Failed"),sMsg]];
         }
         [SVProgressHUD dismiss];
    }
    error:^(NSString *errorMsg,NSMutableDictionary *uData){
       [BaseViewController Toast:[NSString stringWithFormat:@"%@ \n %@",NSLocalizedString(@"Call Submission Failed.", @"Call Submission Failed."),errorMsg.description]];
       [SVProgressHUD dismiss];
    }];
}
@end
