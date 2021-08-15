//
//  ToDyTPvwCtrl.m
//  SANAPP
//
//  Created by SANeForce.com on 16/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "ToDyTPvwCtrl.h"
#import "CVColor.h"
#import "MainHomeController.h"
@implementation ToDyTPvwCtrl
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    if(_OBJErr==nil){
        _OBJErr=[[BaseViewController alloc] init];
    }
    self.TdayPl=[TdayPlDetail sharedTdayPlDetail];
    self.locationData=[LocationDetail sharedLocationData];
    self.meetData=[CallMeetData sharedDatas];
    
    
    self.tbCluster.delegate = self;
    self.tbCluster.dataSource = self;
    
    self.tbWorkType.delegate = self;
    self.tbWorkType.dataSource = self;
    
    self.tbHQ.delegate = self;
    self.tbHQ.dataSource = self;

    _btnSelHQ.enabled=YES;
    
    [self.btnSelWT setTitleEdgeInsets:UIEdgeInsetsMake(0.0,15.0, 0.0, 15.0)];
    [self.btnSelHQ setTitleEdgeInsets:UIEdgeInsetsMake(0.0,15.0, 0.0, 15.0)];
    [self.btnSelCluster setTitleEdgeInsets:UIEdgeInsetsMake(0.0,15.0, 0.0, 15.0)];
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    if([_UserDet.Desig isEqualToString:@"MR"]){
        [_btnSelHQ setTitle:_UserDet.HQName forState:UIControlStateNormal];
        self.TdayPl.SFMem=_UserDet.SF;
        _btnSelHQ.enabled=NO;
    }
    else if(![_TdayPl.HQNm isEqualToString:@""]){
            [self.btnSelHQ setTitle:_TdayPl.HQNm forState:UIControlStateNormal];
    }
    
    if(![_TdayPl.PlNm isEqualToString:@""]){
        [self.btnSelCluster setTitle:_TdayPl.PlNm forState:UIControlStateNormal];
    }
    if(![_TdayPl.WTNm isEqualToString:@""]){
        [self.btnSelWT setTitle:_TdayPl.WTNm forState:UIControlStateNormal];
    }
    if(![_TdayPl.Rem isEqualToString:@""]){
    self.tRemarks.text=self.TdayPl.Rem;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm a"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"IST"];
    self.TdayPl.TPDt=[dateFormatter stringFromDate:[NSDate date]];
    
    
    [self.objAppSvData setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"TPDt"];
    
    self.objWTList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy];
    self.objClusterList= [[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",self.UserDet.SF]] mutableCopy];

    self.bSvTP.layer.cornerRadius=4.0f;
    [_lblTitle setText:@"TODAY WORK PLAN"];
    if(self.meetData.MissedEntry==YES)
    {
        self.TdayPl.TPDt=self.meetData.EDate;
        
        [self.objAppSvData setValue:self.meetData.EDate forKey:@"TPDt"];
        self.objWTList=[self.objWTList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FWFlg!='F'"]];
        [_lblTitle setText:@"Missed Entry - Other Work"];
    }
    
    [_lblEDt setText:[dateFormatter stringFromDate:[BaseViewController str2date:self.TdayPl.TPDt]]];
    [self closeTableViews];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tbWorkType) return self.objWTList.count;
    if(tableView==self.tbCluster) return self.objClusterList.count;
    if(tableView==self.tbHQ) return self.objHQList.count;
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    if(tableView==self.tbCluster) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"CellCluster" forIndexPath:indexPath];
        NSDictionary *cluster = self.objClusterList[indexPath.row];
        cell.lOptText.text = [cluster objectForKey:@"Name"];
    }
    else if(tableView==self.tbHQ) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"CellHQ" forIndexPath:indexPath];
        NSDictionary *HQ = self.objHQList[indexPath.row];
        cell.lOptText.text = [HQ objectForKey:@"name"];
    }
    else
    {
        cell =[tableView dequeueReusableCellWithIdentifier:@"CellWT" forIndexPath:indexPath];
        NSDictionary *WorkTypes = self.objWTList[indexPath.row];
        cell.lOptText.text = [WorkTypes objectForKey:@"Name"];
    }
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tbCluster){
        NSDictionary *Cluster = self.objClusterList[indexPath.row];

        self.TdayPl.Pl=[Cluster objectForKey:@"Code"];
        self.TdayPl.PlNm=[Cluster objectForKey:@"Name"];
        
        [self.btnSelCluster setTitle:[Cluster objectForKey:@"Name"] forState:UIControlStateNormal];
    }
    else if(tableView==self.tbHQ) {
        NSDictionary *HQ = self.objHQList[indexPath.row];
        
        self.TdayPl.SFMem=[HQ objectForKey:@"id"];
        self.TdayPl.HQNm=[HQ objectForKey:@"name"];
        [self.btnSelHQ setTitle:[HQ objectForKey:@"name"] forState:UIControlStateNormal];
        NSString *DataKey=[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",self.TdayPl.SFMem];
        
        [BaseViewController loadMasterData:self.TdayPl.SFMem completion:^(){
            self.objClusterList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            [self.tbCluster reloadData];
        } error:^(NSString* errMsg){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                message:errMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            self.objClusterList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            [self.tbCluster reloadData];
        }];
    }
    else{
        NSDictionary *WorkTypes = self.objWTList[indexPath.row];
        
        self.TdayPl.WT=[WorkTypes objectForKey:@"Code"];
        self.TdayPl.WTNm=[WorkTypes objectForKey:@"Name"];
        self.TdayPl.FWFlg=[WorkTypes objectForKey:@"FWFlg"];
        
        [self.btnSelWT setTitle:[WorkTypes objectForKey:@"Name"] forState:UIControlStateNormal];
        self.TdayPl.Pl=@"";
        self.TdayPl.PlNm=@"";
        
        [self.btnSelCluster setTitle:@"" forState:UIControlStateNormal];
    }
    [self closeTableViews];
}
-(IBAction) openSelWorkType:(id)sender{
    BOOL upState=!self.tbWorkType.hidden;
    [self closeTableViews];
    self.tbWorkType.hidden=upState;
}
-(IBAction) openSelHQ:(id)sender{
    BOOL upState=!self.tbHQ.hidden;
    [self closeTableViews];
    self.tbHQ.hidden=upState;
}
-(IBAction) openSelCluster:(id)sender{
    BOOL upState=!self.tbCluster.hidden;
    [self closeTableViews];
    self.tbCluster.hidden=upState;
}

-(void) closeTableViews{
    
    self.tbWorkType.hidden=YES;
    self.tbHQ.hidden=YES;
    self.tbCluster.hidden=YES;
}

-(BOOL) validateForm
{
    if([self.TdayPl.WT isEqualToString:@""] || self.TdayPl.WT==nil){[_OBJErr FocusErrorSrc:_btnSelWT];return NO;}
    //if([self.TdayPl.FWFlg isEqualToString:@"F"]){
    NSMutableArray *WTL= [[self.objWTList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code==%@",self.TdayPl.WT]] mutableCopy];
    if(([self.TdayPl.Pl isEqualToString:@""] || self.TdayPl.Pl==nil) && [[WTL[0] valueForKey:@"TerrSlFlg"] isEqualToString:@"Y"]){[_OBJErr FocusErrorSrc:_btnSelCluster];return NO; }
    if([self.TdayPl.SFMem isEqualToString:@""] || self.TdayPl.SFMem==nil){[_OBJErr FocusErrorSrc:_btnSelHQ];return NO;}
    /*}else{
        self.TdayPl.Pl=@"";
        self.TdayPl.SFMem=@"";
    }*/
    return YES;
}
-(void)saveTodayPlan:(id)sender{
    NSLog(@"%@:%@", self.locationData.latitude,self.locationData.longitude);
    if(![self validateForm]) return;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Submitting Status", @"Submitting Please Wait...")];
    self.TdayPl.Rem=self.tRemarks.text;
    
    self.TdayPl.location=@"";
    if(self.locationData.latitude!=nil){
        self.TdayPl.location=[NSString stringWithFormat:@"%@:%@", self.locationData.latitude,self.locationData.longitude];
    }
    self.objAppSvData=[self.TdayPl toNSDictionary];
    [self.objAppSvData setValue:@"0" forKey:@"InsMode"];
    [self svTodayPlan];
}
-(void) svTodayPlan{
    [WBService SendServerRequest:@"SAVE/MyTP" withParameter:self.objAppSvData withImages:nil DataSF:nil completion:^(BOOL success, id respData,NSMutableDictionary* uData) {
        NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        [SVProgressHUD dismiss];

        NSString* rMsg=[receivedDta valueForKey:@"Msg"];
        if([[receivedDta valueForKey:@"update"] boolValue]==YES){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SAN Digital Detailing"
                    message:NSLocalizedString(rMsg,rMsg)
                   delegate:self
          cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
    otherButtonTitles:NSLocalizedString(@"Overwrite",@"Overwrite"),NSLocalizedString(@"Half Day Work",@"Half Day Work"), nil];
            
            [alertView show];
        
        }
        else if([[receivedDta valueForKey:@"success"] boolValue]==YES){
            [self.objAppSvData setValue:@"0" forKey:@"drfMode"];
            [WBService saveData:self.objAppSvData forKey:@"MyTodayplan.SANAPP"];
            
            if(![rMsg isEqualToString:@""]){
                [BaseViewController Toast:rMsg];
            }else{
                [BaseViewController Toast:NSLocalizedString(@"Today Work Plan Submitted Successfully", @"Today Work Plan Submitted Successfully")];
            }
            
            [self.objAppSvData removeAllObjects];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            if(![rMsg isEqualToString:@""]){
                [BaseViewController Toast:rMsg];
            }else{
                [BaseViewController Toast:NSLocalizedString(@"Something went to wrong.\n Try Again!.", @"Something went to wrong.\n Try Again!.")];
                [self.objAppSvData setValue:@"1" forKey:@"drfMode"];
                [WBService saveData:self.objAppSvData forKey:@"MyTodayplan.SANAPP"];
                NSMutableArray *Arry=[[WBService getDataByKey:@"offMyTdypl.SANAPP"] mutableCopy];
                if(Arry==nil) Arry=[[NSMutableArray alloc] init];
                [Arry addObject:self.objAppSvData];
                [WBService saveData:Arry forKey:@"offMyTdypl.SANAPP"];
                [self.objAppSvData removeAllObjects];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    error:^(NSString *errorMsg, NSMutableDictionary* uData){
        [BaseViewController Toast:[NSString stringWithFormat:@"%@ \n %@",NSLocalizedString(@"Today Work Plan Submission Failed.", @"Today Work Plan Submission Failed.") ,errorMsg.description]];
        [SVProgressHUD dismiss];
        [self.objAppSvData setValue:@"1" forKey:@"drfMode"];
        [WBService saveData:self.objAppSvData forKey:@"MyTodayplan.SANAPP"];
        NSMutableArray *Arry=[[WBService getDataByKey:@"offMyTdypl.SANAPP"] mutableCopy];
        if(Arry==nil) Arry=[[NSMutableArray alloc] init];
        [Arry addObject:self.objAppSvData];
        [WBService saveData:Arry forKey:@"offMyTdypl.SANAPP"];
        [self.objAppSvData removeAllObjects];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"%@",errorMsg);
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex>0){
        [self.objAppSvData setValue:[NSNumber numberWithInteger:buttonIndex] forKey:@"InsMode"];
        [self svTodayPlan];
    }
}
-(IBAction) CloseTPEntry:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
        
        

@end
