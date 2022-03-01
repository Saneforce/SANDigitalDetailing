//
//  ApprovalsViewCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/12/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "ApprovalsViewCtrl.h"
#import "WBService.h"

@interface ApprovalsViewCtrl ()
@property (nonatomic, strong) NSArray* LvlApproval;
@property (nonatomic, strong) NSArray* TPApproval;

@end

@implementation ApprovalsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UserDet=[UserDetails sharedUserDetails];
    self.TPEntryDet=[TPEntryData sharedDatas];
    self.tvLvApprvList.delegate=self;
    self.tvLvApprvList.dataSource=self;
    self.tvTPPendingList.delegate=self;
    self.tvTPPendingList.dataSource=self;
    
    self.btnBack.layer.cornerRadius=20.0f;
    [self closeSelection];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [WBService SendServerRequest:@"GET/LvlApproval" withParameter:nil withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        _LvlApproval=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        [self.tvLvApprvList reloadData];
    }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }];
    [WBService SendServerRequest:@"GET/TPApproval" withParameter:nil withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        _TPApproval=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        [self.tvTPPendingList reloadData];
    }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TBSelectionBxCell * cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.tvTPPendingList==tableView){
        cell.lOptText.text=[_TPApproval[indexPath.row] valueForKey:@"SFName"];
        cell.lOptFDate.text=[_TPApproval[indexPath.row] valueForKey:@"Mnth"];
        cell.lOptTDate.text=[_TPApproval[indexPath.row] valueForKey:@"Yr"];
        cell.btnCnf.tag=indexPath.row;
        [cell.btnCnf addTarget:self action:@selector(GotoTPEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.tvLvApprvList==tableView){
        cell.lOptText.text=[_LvlApproval[indexPath.row] valueForKey:@"SFName"];
        cell.lOptFDate.text=[_LvlApproval[indexPath.row] valueForKey:@"FDate"];
        cell.lOptTDate.text=[_LvlApproval[indexPath.row] valueForKey:@"TDate"];
        cell.lOptLDays.text=[_LvlApproval[indexPath.row] valueForKey:@"No_of_Days"];
        cell.lOptTextvw.text=[_LvlApproval[indexPath.row] valueForKey:@"Reason"];
        cell.lOptTVwAddOnLv.text=[_LvlApproval[indexPath.row] valueForKey:@"Address"];
        cell.lOptLType.text=[_LvlApproval[indexPath.row] valueForKey:@"LType"];
        cell.lOptLAva.text=[_LvlApproval[indexPath.row] valueForKey:@"LAvail"];
        cell.btnCnf.tag=indexPath.row;
        cell.btnInfo.tag=indexPath.row;
        [cell.btnCnf addTarget:self action:@selector(ApproveLeave:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnInfo addTarget:self action:@selector(showRejectRemk:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tvTPPendingList==tableView) return [_TPApproval count];
    if (self.tvLvApprvList==tableView) return [_LvlApproval count];
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=44;
    if(tableView==self.tvLvApprvList) h=170;
    
    return h;
}
-(IBAction) GotoTPEdit:(id)sender{
    long indx=((UIButton*)sender).tag;
    _TPEntryDet.SF=[_TPApproval[indx] valueForKey:@"Sf_Code"];
    _TPEntryDet.SFName=[_TPApproval[indx] valueForKey:@"SFName"];
    _TPEntryDet.Month=[[_TPApproval[indx] valueForKey:@"Mn"] intValue];
    _TPEntryDet.Year=[[_TPApproval[indx] valueForKey:@"Yr"] intValue];
    _TPEntryDet.Flag=1;
    
    /*NSMutableDictionary *Param=[[NSMutableDictionary alloc] init];
    
    [Param setValue:SF forKey:@"TPSF"];
    [Param setValue:[NSString stringWithFormat:@"%i",_TPEntryDet.Month ] forKey:@"Mnth"];
    [Param setValue:[NSString stringWithFormat:@"%i",_TPEntryDet.Year ] forKey:@"Yr"];*/
    [WBService SendServerRequest:@"GET/TPDetails" withParameter:[_TPEntryDet toNSDictionary] withImages:nil DataSF:_TPEntryDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        _TPEntryDet.TPDates=[[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
        if(_TPEntryDet.TPDates.count >0 )
        {
        [self performSegueWithIdentifier:@"NavApprovalEditTP" sender:self];
        }
        else
            [BaseViewController Toast:@"TPDetail Empty"];
    }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }];
}
-(IBAction)ApproveLeave:(id)sender{
    long indx=((UIButton*)sender).tag;
    NSMutableDictionary *Param=[[NSMutableDictionary alloc] init];
    
    [Param setValue:[_LvlApproval[indx] valueForKey:@"LvID"] forKey:@"LvID"];
    [Param setValue:@"0" forKey:@"LvAPPFlag"];
    [WBService SendServerRequest:@"Save/LvApproval" withParameter:Param withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        [BaseViewController Toast:NSLocalizedString(@"Leave has been Approved Successfully.", @"Leave has been Approved Successfully.")];
        
        [self refreshLvApproval];
    }
   error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
       [BaseViewController Toast:NSLocalizedString(@"Leave has been Approval Failed", @"Leave has been Approval Failed.")];
       NSLog(@"%@",errorMsg);
   }];
}

-(IBAction)showRejectRemk:(id)sender{
    long indx=((UIButton*)sender).tag;
    self.txRejRem.tag=indx;
    [self ShowSelection:@""];
}

-(IBAction)CloseRejectRemk:(id)sender{
    [self closeSelection];
}
-(IBAction)RejectLeave:(id)sender{
    if([self.txRejRem.text isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the Reject Reason", @"Enter the Reject Reason")];
        return;
    }
    long indx=self.txRejRem.tag;
    NSMutableDictionary *Param=[[NSMutableDictionary alloc] init];
     
    [Param setValue:[_LvlApproval[indx] valueForKey:@"LvID"] forKey:@"LvID"];
    [Param setValue:@"1" forKey:@"LvAPPFlag"];
    [Param setValue:self.txRejRem.text forKey:@"RejRem"];
    [WBService SendServerRequest:@"Save/LvReject" withParameter:Param withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        [BaseViewController Toast:NSLocalizedString(@"Leave has been Rejected Successfully.", @"Leave has been Rejected Successfully.")];
        [self refreshLvApproval];
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
            [BaseViewController Toast:NSLocalizedString(@"Leave has been Rejection Failed.", @"Leave has been Rejection Failed.")];
            NSLog(@"%@",errorMsg);
        }];
}
-(void) refreshLvApproval{
    
    [WBService SendServerRequest:@"GET/LvlApproval" withParameter:nil withImages:nil DataSF:_UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        _LvlApproval=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        [self.tvLvApprvList reloadData];
        [self closeSelection];
    }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }];
}
-(void)ShowSelection:(NSString*)sTitle{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.nsVfselTop.constant=0;
                         self.VfBottomLayout.constant=0;
                         self.vfSelWindow.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}
-(void) closeSelection{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.nsVfselTop.constant=self.vfSelWindow.frame.size.height;
                         [self.view layoutIfNeeded];
                         
                         self.VfBottomLayout.constant=-self.vfSelWindow.frame.size.height;
                         [self.view layoutIfNeeded];
                         self.vfSelWindow.alpha=0;
                         
                     }
                     completion:^(BOOL finished) {   }];
}
-(IBAction) CloseWindow:(id)sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
