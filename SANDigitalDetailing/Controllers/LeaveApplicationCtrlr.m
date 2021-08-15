//
//  LeaveApplicationCtrlr.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 19/11/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "LeaveApplicationCtrlr.h"
#import "BaseViewController.h"
@interface LeaveApplicationCtrlr ()
@property (nonatomic,weak) NSString* LeaveType;
@property (nonatomic,strong) NSMutableArray* LeaveStatus;
@end

@implementation LeaveApplicationCtrlr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnBack.layer.cornerRadius=20.0f;
    [self.FDate setDate:[NSDate date]];
    [self.TDate setDate:[NSDate date]];
    self.LeaveType=@"CL";
    _LeaveStatus=[[NSMutableArray alloc] init];
    [self RefreshLeaveDetail];
    self.LvStatus.delegate=self;
    self.LvStatus.dataSource=self;
    self.NODL.text = @"1";
}
-(void) RefreshLeaveDetail{
    [WBService SendServerRequest:@"GET/LeaveStatus" withParameter:nil withImages:nil DataSF:nil
                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                          _LeaveStatus=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                          [_LvStatus reloadData];
                          NSLog(@"%@",_LeaveStatus);
                      }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }
     ];
    
}
-(IBAction)CloseTPWindow:(id)sender{
    [self CloseVindow];
}
-(void) CloseVindow{
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)DateDiff:(id)sender{
    NSDateComponents *components;
    int days;
    
    NSDate *Dt1=[BaseViewController str2date:[NSString stringWithFormat:@"%@ 00:00:00",[BaseViewController date2str:[self.FDate date] onlyDate:YES]]];
    NSDate *Dt2=[BaseViewController str2date:[NSString stringWithFormat:@"%@ 00:00:00",[BaseViewController date2str:[self.TDate date] onlyDate:YES]]];
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay
                                                 fromDate:Dt1 toDate:Dt2 options:0];
    days=(int)[components day];
    self.NODL.text = [NSString stringWithFormat:@"%d",(int)(days+1)];
    [self validateDateLvl];
    
}
-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl{
    if(SControl.selectedSegmentIndex == 0) self.LeaveType=@"CL";
    if(SControl.selectedSegmentIndex == 1) self.LeaveType=@"PL";
    if(SControl.selectedSegmentIndex == 2) self.LeaveType=@"SL";
    if(SControl.selectedSegmentIndex == 3) self.LeaveType=@"LOP";
}
-(void) validateDateLvl
{
    NSMutableDictionary *LvInf=[[NSMutableDictionary alloc] init];
    [LvInf setValue:[BaseViewController date2str:[self.FDate date]  onlyDate:YES] forKey:@"Fdt"];
    [LvInf  setValue:[BaseViewController date2str:[self.TDate date]  onlyDate:YES] forKey:@"Tdt"];
    [LvInf  setValue:self.LeaveType forKey:@"LTy"];
    [WBService SendServerRequest:@"GET/LvlValid" withParameter:LvInf withImages:nil DataSF:nil
          completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                NSMutableArray *LvlValidDet=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                    if (LvlValidDet !=nil && [LvlValidDet count]>0){
                            NSString *sMsg=[LvlValidDet[0] valueForKey:@"Msg"];
                            NSLog(@"%@",LvlValidDet);
                        if(![sMsg isEqualToString:@""]){
                              [BaseViewController Toast:[NSString stringWithFormat:@"%@",sMsg]];
                              return;
                        }
                    }
            }
            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
               NSLog(@"%@",errorMsg);
            }
     ];
                          
}

-(IBAction) SaveLeaveApp:(id)sender{
    if([self.NODL.text intValue]<1){
        [BaseViewController Toast:NSLocalizedString(@"Your Leave Period is Invalid", @"Your Leave Period is Invalid")];
        return;
    }
    
    NSMutableArray *MkList=[[_LeaveStatus filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] \"Available\""]] mutableCopy];
    
    NSMutableArray *Item=[[[MkList[0] objectForKey:@"values"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@",self.LeaveType]] mutableCopy];
    if([[Item[0] valueForKey:@"Value"] floatValue]<[self.NODL.text floatValue]){
        [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@.",self.LeaveType,NSLocalizedString(@"Availability Exceeded", @"Availability Exceeded")]];
        return;
    }
    if([self.txtRem.text isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the Reason For Leave.", @"Enter the Reason For Leave.")];
        return;
    }
    
    NSMutableDictionary *LvInf=[[NSMutableDictionary alloc] init];
    [LvInf setValue:[BaseViewController date2str:[self.FDate date]  onlyDate:YES] forKey:@"Fdt"];
    [LvInf  setValue:[BaseViewController date2str:[self.TDate date]  onlyDate:YES] forKey:@"Tdt"];
    [LvInf  setValue:self.LeaveType forKey:@"LTy"];
    [WBService SendServerRequest:@"GET/LvlValid" withParameter:LvInf withImages:nil DataSF:nil
       completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
           NSMutableArray *LvlValidDet=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
           if (LvlValidDet !=nil && [LvlValidDet count]>0){
               NSString *sMsg=[LvlValidDet[0] valueForKey:@"Msg"];
               NSLog(@"%@",LvlValidDet);
               if(![sMsg isEqualToString:@""]){
                   [BaseViewController Toast:[NSString stringWithFormat:@"%@",sMsg]];
                   return;
               }
           }
            NSMutableDictionary *LvInfData=[[NSMutableDictionary alloc] init];
            [LvInfData setValue:[BaseViewController date2str:[self.FDate date]  onlyDate:YES] forKey:@"FDate"];
            [LvInfData setValue:[BaseViewController date2str:[self.TDate date]  onlyDate:YES] forKey:@"TDate"];
            [LvInfData setValue:self.NODL.text forKey:@"NOD"];
            [LvInfData setValue:self.LeaveType forKey:@"LeaveType"];
            [LvInfData setValue:self.txtRem.text forKey:@"LvRem"];
            [LvInfData setValue:self.txtAddOnLv.text forKey:@"LvAdd"];
            
            
            [SVProgressHUD showWithStatus:NSLocalizedString(@"SubmittingStatus", @"Submitting Please Wait...")];
            
            [WBService SendServerRequest:@"SAVE/Leave" withParameter:[LvInfData mutableCopy] withImages:nil
                                  DataSF:nil
                              completion:^(BOOL success, id respData,NSMutableDictionary *uData)
             {
                 [self RefreshLeaveDetail];
                [BaseViewController Toast:NSLocalizedString(@"Leave Application has been Sent For Approval Successfully", @"Leave Application has been Sent For Approval Successfully....")];
                 [SVProgressHUD dismiss];
                 //[self ClearandCloseView];
             }
                           error:^(NSString *errorMsg,NSMutableDictionary *uData){
                               [BaseViewController Toast:[NSString stringWithFormat:@"%@.\n %@",NSLocalizedString(@"Leave Application Submission Failed", @"Leave Application Submission Failed"),errorMsg.description]];
                               [SVProgressHUD dismiss];
                               //[self ClearandCloseView];
                           }];
                       }
                            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                                NSLog(@"%@",errorMsg);
                            }
      ];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.LeaveStatus.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.LeaveStatus[section] objectForKey:@"values"] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=38;
    
    return h;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView;
    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,40)];
    sectionView.tag=section;
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    viewLabel.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0f];
    viewLabel.textColor=[UIColor blackColor];
    viewLabel.font=[UIFont systemFontOfSize:16];
    viewLabel.text=[NSString stringWithFormat:@"  %@",[[_LeaveStatus objectAtIndex:section] valueForKey:@"Name"]];
    
    [sectionView addSubview:viewLabel];
    return sectionView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    NSDictionary *optLst=[[NSDictionary alloc] init];
    cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    optLst = [[self.LeaveStatus[indexPath.section] objectForKey:@"values"][indexPath.row] mutableCopy];
    cell.lOptText.text = [optLst objectForKey:@"Name"];
    cell.lOptVal.text = [optLst objectForKey:@"Value"];
        
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
