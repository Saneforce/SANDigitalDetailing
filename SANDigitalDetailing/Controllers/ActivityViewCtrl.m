//
//  ActivityViewCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 24/12/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "ActivityViewCtrl.h"

@implementation ActivityViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.UserDet=[UserDetails sharedUserDetails];
    
    self.tvSelOpt.delegate = self;
    self.tvSelOpt.dataSource = self;
    self.tvPartiList.delegate = self;
    self.tvPartiList.dataSource = self;
    self.tvProdList.delegate = self;
    self.tvProdList.dataSource = self;
    self.tvInputList.delegate = self;
    self.tvInputList.dataSource = self;
    self.tvOTOEntry.delegate = self;
    self.tvOTOEntry.dataSource = self;
    _txtDoc.inputView = [[UIView alloc] initWithFrame:CGRectZero];
[self closeSelection];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.UserDet.SF];
    self.CustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.SpeakerList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"SpeakersList.SANAPP"] mutableCopy];
    self.ParticipantList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"ParticipantList.SANAPP"] mutableCopy];
    self.IndicationList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"IndicationList.SANAPP"] mutableCopy];
    self.ProductList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Products.SANAPP"] mutableCopy];
    self.InputList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Inputs.SANAPP"] mutableCopy];

    self.vwSGTCMEWin.hidden=NO;
    self.vwSTPWin.hidden=YES;
    self.vwOneToOneWin.hidden=YES;
    self.SelDoctorList =[[NSArray alloc]init];
    self.SelPartiList =[[NSArray alloc]init];
    self.SelProductList =[[NSArray alloc]init];
    self.SelInputList =[[NSArray alloc]init];
    self.OTOEntryList=[[NSMutableArray alloc] init];
    [self addOTOItem];
    [self addOTOItem];
   /* NSMutableDictionary *Item=[[NSMutableDictionary alloc] init];
    [Item setValue:@"" forKey:@"Code"];
    [Item setValue:@"No Gift" forKey:@"Name"];
    [self.InputList addObject:Item];*/
}
-(void) addOTOItem{
    NSMutableDictionary* itmOTOEntry=[[NSMutableDictionary alloc] init];
    [itmOTOEntry setValue:@"" forKey:@"CId"];
    [itmOTOEntry setValue:@"" forKey:@"CName"];
    [itmOTOEntry setValue:@"" forKey:@"DId"];
    [itmOTOEntry setValue:@"" forKey:@"DName"];
    [itmOTOEntry setValue:@"" forKey:@"PId"];
    [itmOTOEntry setValue:@"" forKey:@"PName"];
    [itmOTOEntry setValue:@"" forKey:@"STime"];
    [itmOTOEntry setValue:@"" forKey:@"ETime"];
    [itmOTOEntry setValue:@"" forKey:@"Inject"];
    [self.OTOEntryList addObject:itmOTOEntry];
}

-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl{
    _lblDrCap.text=NSLocalizedString(@"Speaker Name", @"Speaker Name");
    _lblOthCap.text=NSLocalizedString(@"Speaker From Other Zone", @"Speaker From Other Zone");
    _lblIndic.hidden=YES;
    _txtIndic.hidden=YES;
    self.vwSelWin.alpha=0;
    self.vwSelWin.hidden=NO;
    
    _lblNofVol.text=NSLocalizedString(@"No. Of. Volunteers", @"No. Of. Volunteers");
    _lblNofVol.hidden=YES;
    _txtNoOfVolunteer.hidden=YES;
    _vwInputDet.hidden=YES;
    self.vwSGTCMEWin.alpha=0;
    self.vwSTPWin.alpha=0;
    self.vwOneToOneWin.alpha=0;
       [self.view layoutIfNeeded];
       [UIView animateWithDuration:0.5
                             delay:0.0
                           options: 0
                        animations:^{

           self.vwSGTCMEWin.hidden=YES;
           self.vwSTPWin.hidden=YES;
           self.vwOneToOneWin.hidden=YES;
           self.vwSGTCMEWin.alpha=1;
           self.vwSTPWin.alpha=1;
           self.vwOneToOneWin.alpha=1;
    if(SControl.selectedSegmentIndex == 0) {
        _lblTitle.text=NSLocalizedString(@"SGT [ Small Group Training Programme]", @"SGT [ Small Group Training Programme]");
        self.eType=NSLocalizedString(@"SGT", @"SGT");
        _lblIndic.hidden=NO;
        _txtIndic.hidden=NO;
        _lblNofVol.hidden=NO;
        _txtNoOfVolunteer.hidden=NO;
        _vwInputDet.hidden=NO;
        self.vwParticipantDet.hidden=NO;
        self.vwProductDet.hidden=NO;
        self.vwDtDet.frame=CGRectMake(0, 302, self.vwDtDet.frame.size.width, self.vwDtDet.frame.size.height);
        self.vwParticipantDet.frame=CGRectMake(486, 61, self.vwParticipantDet.frame.size.width, self.vwParticipantDet.frame.size.height);
        self.vwProductDet.frame=CGRectMake(486, 341, self.vwProductDet.frame.size.width, self.vwProductDet.frame.size.height);
        self.vwSGTCMEWin.hidden=NO;
        
    }
    else{
        self.vwDtDet.frame=CGRectMake(0, 196, self.vwDtDet.frame.size.width, self.vwDtDet.frame.size.height);
        self.vwParticipantDet.hidden=NO;
        self.vwProductDet.hidden=NO;
    }
    if(SControl.selectedSegmentIndex == 1){
        _lblTitle.text=NSLocalizedString(@"STP", @"STP");
        self.eType=NSLocalizedString(@"STP", @"STP");
        self.vwSTPWin.hidden=NO;
    }
    if(SControl.selectedSegmentIndex == 2){
        _lblTitle.text=NSLocalizedString(@"CEP", @"CEP");
        self.eType=NSLocalizedString(@"CEP", @"CEP");
        _lblDrCap.text=NSLocalizedString(@"Doctor Name", @"Doctor Name");
        _lblOthCap.text=NSLocalizedString(@"Topic", @"Topic");
        _lblNofVol.hidden=NO;
        _txtNoOfVolunteer.hidden=NO;
        _lblNofVol.text=NSLocalizedString(@"No. Of. Client", @"No. Of. Client");
        self.lblNofVol.frame=CGRectMake(self.lblNofVol.frame.origin.x, 196, self.lblNofVol.frame.size.width, self.lblNofVol.frame.size.height);
        self.txtNoOfVolunteer.frame=CGRectMake(301, 196, self.txtNoOfVolunteer.frame.size.width, self.txtNoOfVolunteer.frame.size.height);
        self.vwDtDet.frame=CGRectMake(0, 240, self.vwDtDet.frame.size.width, self.vwDtDet.frame.size.height);
        self.vwParticipantDet.hidden=YES;
        self.vwProductDet.frame=CGRectMake(486, 61, self.vwProductDet.frame.size.width, self.vwProductDet.frame.size.height);
        self.vwSGTCMEWin.hidden=NO;
    }else{
        self.lblNofVol.frame=CGRectMake(self.lblNofVol.frame.origin.x, 264, self.lblNofVol.frame.size.width, self.lblNofVol.frame.size.height);
        self.txtNoOfVolunteer.frame=CGRectMake(301, 264, self.txtNoOfVolunteer.frame.size.width, self.txtNoOfVolunteer.frame.size.height);
        
    }
    if(SControl.selectedSegmentIndex == 3){
        _lblTitle.text=NSLocalizedString(@"ONE To ONE", @"ONE To ONE");
        self.eType=NSLocalizedString(@"OTO", @"OTO");

        self.vwOneToOneWin.hidden=NO;
    }
    if(SControl.selectedSegmentIndex == 4){
        _lblTitle.text=NSLocalizedString(@"CME", @"CME");
        self.eType=NSLocalizedString(@"CME", @"CME");
        _lblIndic.hidden=YES;
        self.vwProductDet.hidden=YES;
        self.vwSGTCMEWin.hidden=NO;
        
    }
           
           //self.vwScrbleWin.alpha=1;
        [self.view layoutIfNeeded];
    }
    completion:^(BOOL finished) {   }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.tvSelOpt) return 50;
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tvSelOpt)
    {
        return self.objOptList.count;
    }
    if(tableView==self.tvPartiList) return self.SelPartiList.count;
    if(tableView==self.tvProdList) return self.SelProductList.count;
    if(tableView==self.tvInputList) return self.SelInputList.count;
    if(tableView==self.tvOTOEntry) return self.OTOEntryList.count;
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;NSInteger tag = 0;
    NSDictionary *optLst=[[NSDictionary alloc] init];
    if(tableView==self.tvProdList) {optLst = [self.SelProductList[indexPath.row] mutableCopy];tag=1;}
    if(tableView==self.tvInputList){optLst = self.SelInputList[indexPath.row];tag=2;}
    if(tableView==self.tvPartiList){optLst = self.SelPartiList[indexPath.row];tag=3;}
    
    
if(tableView==self.tvOTOEntry) {
    cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableDictionary *optLst = [self.objOptList[indexPath.row] mutableCopy];
    cell.txtCName.text=[optLst valueForKey:@"CName"];
    cell.txtDName.text=[optLst valueForKey:@"DName"];
    cell.txtCPName.text=[optLst valueForKey:@"PName"];
    cell.txtSTime.text=[optLst valueForKey:@"STime"];
    cell.txtETime.text=[optLst valueForKey:@"ETime"];
    cell.txtInjected.text=[optLst valueForKey:@"Inject"];
    
}
else if(tableView==self.tvSelOpt) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSDictionary *optLst;
        if([self.objOptList count]>0){
       /* if(self.searchBox.tag==4){
             optLst = [self.objOptList[indexPath.section] objectForKey:@"Vals"] [indexPath.row];
        }
        else{*/
            optLst = self.objOptList[indexPath.row];
        //}
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        cell.btnCheked.tag = indexPath.row;
        }
        NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [optLst objectForKey:@"Code"]]] mutableCopy];
        if(Selitem.count>0){
            [cell.btnCheked setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            cell.Checked=YES;
        }else{
            [cell.btnCheked setImage:nil forState:UIControlStateNormal];
            cell.Checked=NO;
        }
        [cell.btnCheked addTarget:self action:@selector(setChecked:) forControlEvents:UIControlEventTouchUpInside];

    }
    else
    {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        cell.btnDel.tag = indexPath.row;
        cell.btnDel.titleLabel.tag=tag;
        
        cell.btnDel.enabled=YES;
        [cell.btnDel addTarget:self action:@selector(DeleteRow:) forControlEvents:UIControlEventTouchUpInside];
        if(tableView==self.tvProdList )
        {
            cell.txtRxQty.text=[optLst objectForKey:@"RxQty"];
            [cell.txtRxQty addTarget:self action:@selector(txtRxDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            cell.delegate=self;
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TBSelectionBxCell* cell;
    
    if(tableView==self.tvSelOpt) {
        cell =[tableView cellForRowAtIndexPath:indexPath];
        
        NSMutableDictionary *item ;
        /*if(self.searchBox.tag==7){
            item= [[[self.objOptList[indexPath.section] valueForKey:@"Vals"] objectAtIndex:indexPath.row] mutableCopy];
            
        }else {*/
            item= [[self.objOptList objectAtIndex:indexPath.row] mutableCopy];
        //}
        NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [item objectForKey:@"Code"]]] mutableCopy];
        
        if (Selitem.count<=0){
            NSMutableDictionary *selItem =[[NSMutableDictionary alloc] init];
            [selItem setValue:[item objectForKey:@"Code"] forKey:@"Code"];
            [selItem setValue:[item objectForKey:@"Name"] forKey:@"Name"];
            if(self.searchBox.tag==1)
            {
                [selItem setValue:[item objectForKey:@"NoofSamples"] forKey:@"NoofSamples"];
            }
            [self.SelOptList addObject:selItem];
            
            [cell.btnCheked setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            cell.Checked=YES;
       }
        else{
            [self.SelOptList removeObject:Selitem[0]];
            [cell.btnCheked setImage:nil forState:UIControlStateNormal];
            cell.Checked=NO;

        }
    }
}



-(IBAction)OpenConsult:(id)sender{
    UITableViewCell *Icell=[self getTableViewCell:sender];
    UITableView *tbView=[self getTableView:Icell];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    self.objOptList=[self.mConsultList mutableCopy];
    //  self.SelOptList=[self.SelProductList mutableCopy];

    self.searchBox.tag=8;
    self.vwSelWin.tag=indexPath.row;
    [self.tvSelOpt reloadData];
    [self ShowSelection:NSLocalizedString(@"Consultant Selection",@"Consultant Selection")];
}
-(IBAction)OpenOTODoctor:(id)sender{
    UITableViewCell *Icell=[self getTableViewCell:sender];
    UITableView *tbView=[self getTableView:Icell];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    self.objOptList=[self.CustomerList mutableCopy];
    //  self.SelOptList=[self.SelProductList mutableCopy];

    self.searchBox.tag=9;
    self.vwSelWin.tag=indexPath.row;
    [self.tvSelOpt reloadData];
    [self ShowSelection:NSLocalizedString(@"Doctor Selection",@"Doctor Selection")];
}
-(void)ShowSelection:(NSString*)sTitle{
    
    
   
     self.vwModal.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width/2 , UIScreen.mainScreen.bounds.size.height/2,0, 0);
    self.vwSelWin.alpha=0;
    //[self.lblTitle setText:sTitle];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.vwModal.frame=CGRectMake(0, 0,UIScreen.mainScreen.bounds.size.width , UIScreen.mainScreen.bounds.size.height);
                         self.vwSelWin.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}
-(IBAction)ShowStaffDets:(id)sender {
     self.vwModal.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width/2 , UIScreen.mainScreen.bounds.size.height/2,0, 0);
    self.vwStaffDetWin.alpha=0;
    //[self.lblTitle setText:sTitle];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{

                         self.vwModal.frame=CGRectMake(0, 0,UIScreen.mainScreen.bounds.size.width , UIScreen.mainScreen.bounds.size.height);
                         self.vwStaffDetWin.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}
-(void) closeSelection{

    self.vwModal.frame=CGRectMake(0, 0,UIScreen.mainScreen.bounds.size.width , UIScreen.mainScreen.bounds.size.height);
    self.vwSelWin.alpha=1;
    self.vwStaffDetWin.alpha=1;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
        self.vwModal.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width/2 , UIScreen.mainScreen.bounds.size.height/2,0, 0);
                          self.vwSelWin.alpha=0;
                          self.vwStaffDetWin.alpha=0;
                     }
                     completion:^(BOOL finished) {   }];
}
-(IBAction)OpenDoctorList:(id)sender{
    self.searchBox.tag=1;
    
    self.objOptList = self.SpeakerList;
    self.SelOptList=[self.SelDoctorList mutableCopy];
    [self.tvSelOpt reloadData];
    [self ShowSelection:NSLocalizedString(@"Speaker Name Selection",@"Speaker Name Selection")];
}
-(IBAction)OpenIndicationList:(id)sender{
    self.searchBox.tag=2;
    
    self.objOptList = self.IndicationList;
    self.SelOptList=[self.SelIndicationList mutableCopy];
    [self.tvSelOpt reloadData];
    [self ShowSelection:NSLocalizedString(@"Indication Selection",@"Indication Selection")];
}
-(IBAction)OpenParticipantList:(id)sender{
    self.searchBox.tag=3;
    
    self.objOptList = self.ParticipantList;
    self.SelOptList=[self.SelPartiList mutableCopy];
    [self.tvSelOpt reloadData];
    [self ShowSelection:NSLocalizedString(@"Participant Selection",@"Participant Selection")];
}
-(IBAction)OpenProductList:(id)sender{
    self.searchBox.tag=4;
    
    self.objOptList = self.ProductList;
    self.SelOptList=[self.SelProductList mutableCopy];
    [self.tvSelOpt reloadData];
    [self ShowSelection:NSLocalizedString(@"Product Selection",@"Product Selection")];
}
-(IBAction)OpenInputList:(id)sender{
    self.searchBox.tag=5;
    
    self.objOptList = self.InputList;
    self.SelOptList=[self.SelInputList mutableCopy];
    [self.tvSelOpt reloadData];
    [self ShowSelection:NSLocalizedString(@"Input Selection",@"Input Selection")];
}

-(IBAction) setSelOptsValues:(id)sender{
    if(self.searchBox.tag==1)
    {
        NSString* sSelVals=@"";
        self.SelDoctorList=[self.SelOptList mutableCopy];
        for(int il=0;il<[_SelDoctorList count];il++)
            sSelVals=[NSString stringWithFormat:@"%@%@, ",sSelVals,[_SelDoctorList[il] valueForKey:@"Name"]];
        _txtDoc.text=sSelVals;
        [self closeSelection];
    }
    if(self.searchBox.tag==2)
    {
        NSString* sSelVals=@"";
        self.SelIndicationList=[self.SelOptList mutableCopy];
        for(int il=0;il<[_SelIndicationList count];il++)
            sSelVals=[NSString stringWithFormat:@"%@%@, ",sSelVals,[_SelDoctorList[il] valueForKey:@"Name"]];
        _txtIndic.text=sSelVals;
        [self closeSelection];
    }
    if(self.searchBox.tag==3)
    {
        self.SelPartiList=[self.SelOptList mutableCopy];
        [_tvPartiList reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==4)
    {
        self.SelProductList=[self.SelOptList mutableCopy];
        [_tvProdList reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==5)
    {
        self.SelInputList=[self.SelOptList mutableCopy];
        [_tvInputList reloadData];
        [self closeSelection];
    }
}

- (void)didSetRating:(StarRatingView *)starRating andIndexPath:(NSIndexPath *)indexPath andUserEvent:(BOOL)userEvent {
    
}
-(UITableView *) getTableView:(UIView *)view{
    UITableView *tbView=(UITableView *) view;
    while(![tbView isKindOfClass: [UITableView class]])
    {
        tbView=(UITableView *) tbView.superview;
    }
    return tbView;
}
-(UITableViewCell *) getTableViewCell:(UIView *)view{
    UITableViewCell *tbCell=(UITableViewCell *) view;
    while(![tbCell isKindOfClass: [UITableViewCell class]])
    {
        tbCell=(UITableViewCell *) tbCell.superview;
    }
    return tbCell;
}
-(IBAction) CloseWin:(id)sender{
    [self closeSelection];
}
-(IBAction)GotoBack:(id)sender{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}
@end
