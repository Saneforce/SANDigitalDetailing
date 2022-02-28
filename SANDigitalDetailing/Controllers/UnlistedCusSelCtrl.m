//
//  UnlistedCusSelCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 05/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "UnlistedCusSelCtrl.h"
#import "mCustomerCell.h"

@interface UnlistedCusSelCtrl ()
@property (nonatomic, strong) NSArray* NwCustList;
@property (nonatomic, strong) NSDictionary* TP;
@property (nonatomic, weak) NSString* CustCode;
@property (nonatomic, weak) NSString* CustName;
@property (nonatomic, weak) NSString* SpecCode;
@property (nonatomic, weak) NSString* CateCode;

@property (nonatomic, strong) NSArray* objOptList;
@property (nonatomic, strong) NSArray* QualList;
@property (nonatomic, strong) NSArray* ClassList;
@property (nonatomic, strong) NSArray* CateList;
@property (nonatomic, strong) NSArray* SpecList;
@property (nonatomic, strong) NSArray* TerrList;

@end

@implementation UnlistedCusSelCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.MissedEntry=[MissedEntryData sharedDatas];
    self.meetData=[CallMeetData sharedDatas];
    self.UserDet=[UserDetails sharedUserDetails];
    self.TdayPl=[TdayPlDetail sharedTdayPlDetail];
    self.SetupData=[AppSetupData sharedDatas];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.tbHQ.delegate = self;
    self.tbHQ.dataSource = self;
    self.tbOptSel.delegate = self;
    self.tbOptSel.dataSource = self;
    
    self.layout.minimumInteritemSpacing = 8;
    self.layout.minimumLineSpacing = 25;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.nwUnDrView.hidden=YES;
    self.nwUnDrOptSels.hidden=YES;
    //UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f];
    //self.collectionView.backgroundColor = darkColor;
    self.TP =[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
    self.meetData.DataSF=[self.TP valueForKey:@"SFMem"];
    if([self.UserDet.Desig isEqualToString:@"MR"]) self.meetData.DataSF=self.UserDet.SF;
    
    _lblNewDrCap.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Add New", @"Add New"),_SetupData.CapUdr];
    _lblHeadTitle.text=[NSString stringWithFormat:@"%@ %@",_SetupData.CapUdr,NSLocalizedString(@"Selection", @"Selection")];
    _searchBox.placeholder=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Search", @"Search"),_SetupData.CapUdr];
    
    NSString *DataKey=[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",self.meetData.DataSF];
    self.NwCustList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    _btnSelHQ.hidden=YES;
    if(![_UserDet.Desig isEqualToString:@"MR"]) _btnSelHQ.hidden=NO;
    
    [_btnSelHQ setTitle:self.meetData.DataSFHQ forState:UIControlStateNormal];
    if([self.meetData.DataSFHQ  isEqual:@""]) [_btnSelHQ setTitle:NSLocalizedString(@"Select the Headquaters", @"Select the Headquaters") forState:UIControlStateNormal];
    DataKey=[[NSString alloc] initWithFormat:@"DRVstDetails_%@.SANAPP",self.meetData.DataSF];
    self.VstDetList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    
    self.QualList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Qualifics.SANAPP"] mutableCopy];
    self.ClassList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"DocClass.SANAPP"] mutableCopy];
    self.CateList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Category.SANAPP"] mutableCopy];
    self.SpecList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Specialitys.SANAPP"] mutableCopy];
    DataKey=[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",self.meetData.DataSF];
    self.TerrList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    
    _nwDrsAddr.layer.borderWidth=0.5f;
    _nwDrsAddr.layer.borderColor=[UIColor colorWithRed:0.647 green:0.651 blue:0.675 alpha:1.00].CGColor;
    _nwDrsAddr.layer.cornerRadius=5;
//    _btnNew.hidden=YES;
//    if(_SetupData.AddNewDrNeed==1){_btnNew.hidden=NO;}
    if(_SetupData.NdrActivityNeed==0){_btnActivity.hidden=YES;}
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.NwCustList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mCustomerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    
    /*UIColor* mainColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0f];
    cell.backgroundColor=mainColor;*/
    cell.layer.cornerRadius=4.0f;
    NSString* Code=[self.NwCustList[indexPath.row] objectForKey:@"Town_Code"];
    if([Code isEqualToString:[NSString stringWithFormat:@"%@",_TdayPl.Pl]])
        //cell.lCustName.textColor=[UIColor colorWithRed:107.0f/255 green:172.0f/255 blue:251.0f/255 alpha:1.0f];
        //cell.lCustName.textColor=[UIColor colorWithRed:255.0f/255 green:108.0f/255 blue:83.0f/255 alpha:1.0f];
        cell.selImgID.image=[UIImage imageNamed:@"redCallID"];
    else
        cell.selImgID.image=[UIImage imageNamed:@"itemChm"];
    cell.lCustName.textColor=[UIColor whiteColor];
    cell.lCustName.text = [self.NwCustList[indexPath.row] objectForKey:@"Name"];
    cell.lTownName.text = [self.NwCustList[indexPath.row] objectForKey:@"Town_Name"];
    cell.lCategory.text = [self.NwCustList[indexPath.row] objectForKey:@"CategoryName"];
    cell.lSpeciality.text = [self.NwCustList[indexPath.row] objectForKey:@"SpecialtyName"];
    
    NSMutableArray *MkList=[[_MissedEntry.MissDatas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode== %@", [self.NwCustList[indexPath.row] objectForKey:@"Code"]]] mutableCopy];
    
    if ([MkList count]>0){
        cell.selCusImg.image=[UIImage imageNamed:@"chkoptRed"];
        cell.btnBtnDets.tag=[_MissedEntry.MissDatas indexOfObject:MkList[0]];
        cell.btnBtnDets.hidden=NO;
    }
    else{
        cell.selCusImg.image=nil;
        cell.btnBtnDets.hidden=YES;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.meetData.MissedEntry==YES){
        NSMutableArray *MkList=[[_MissedEntry.MissDatas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode== %@", [self.NwCustList[indexPath.row] objectForKey:@"Code"]]] mutableCopy];
        if ([MkList count]>0){
            [_MissedEntry.MissDatas removeObject:MkList[0]];
        }else{
            CallMeetData *MissDocItem=[[CallMeetData alloc] init];
            NSString* WrkNm=@"F";
            NSDictionary* wrk =[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FWFlg ='F'", WrkNm]] mutableCopy];
            MissDocItem.MissedEntry=YES;
            MissDocItem.CustCode=[self.NwCustList[indexPath.row] objectForKey:@"Code"];;
            MissDocItem.CustName=[self.NwCustList[indexPath.row] objectForKey:@"Name"];;
            MissDocItem.CusType=@"4";
            MissDocItem.SpecCode=[self.NwCustList[indexPath.row] objectForKey:@"SpecialtyCode"];
            MissDocItem.CateCode=[self.NwCustList[indexPath.row] objectForKey:@"Category"];
            MissDocItem.vstTime=[BaseViewController getDateTime];
            MissDocItem.ModTime=[BaseViewController getDateTime];
            MissDocItem.Pl=@"DDet";
            MissDocItem.WT=[[wrk valueForKey:@"Code"][0] mutableCopy];
            MissDocItem.WTNm=[[wrk valueForKey:@"Name"][0] mutableCopy];;
            MissDocItem.SF=_UserDet.SF;
            MissDocItem.SFName=_UserDet.SFName;
            MissDocItem.DivCode=_UserDet.DivCode;
            LocationDetail *locationData=[LocationDetail sharedLocationData];
            MissDocItem.Entry_location=[NSString stringWithFormat:@"%@:%@",locationData.latitude,locationData.longitude];
            [_MissedEntry.MissDatas addObject: MissDocItem ];
        }
        [collectionView reloadData];
        
    }else{
        self.CustCode=[self.NwCustList[indexPath.row] objectForKey:@"Code"];
        self.CustName=[self.NwCustList[indexPath.row] objectForKey:@"Name"];
        self.CateCode = [self.NwCustList[indexPath.row] objectForKey:@"Category"];
        self.SpecCode = [self.NwCustList[indexPath.row] objectForKey:@"Specialty"];
        
        self.lSelCustName.text = [self.NwCustList[indexPath.row] objectForKey:@"Name"];
        self.lSelTownName.text = [self.NwCustList[indexPath.row] objectForKey:@"Town_Name"];
        self.lSelAddr.text = [self.NwCustList[indexPath.row] objectForKey:@"Addrs"];
        self.lSelQual.text = [self.NwCustList[indexPath.row] objectForKey:@"Qual"];
        
        
        //_lineChart.backgroundColor=[UIColor colorWithRed:57.0/255 green:67.0/255 blue:96.0/255 alpha:1.0f];
        
        _lineChart.showSmoothLines = YES;
        _lineChart.showCoordinateAxis = true;
        
        _lineChart.showYGridLines=true;
        _lineChart.yGridLinesColor=[UIColor lightGrayColor];
        /*_lineChart.axisColor=[UIColor whiteColor];
        _lineChart.yLabelColor=[UIColor whiteColor];
        _lineChart.xLabelColor=[UIColor whiteColor];*/
        _lineChart.showGenYLabels=YES;
        _lineChart.tintColor=[UIColor colorWithRed:57.0/255 green:67.0/255 blue:96.0/255 alpha:1.0f];
        
        [WBService SendServerRequest:@"GET/CusMVst" withParameter:[@{@"CusCode":self.CustCode,@"typ":@"U"} mutableCopy] withImages:nil DataSF:nil
                          completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                              
                              NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                              NSMutableArray *xlbl=[[NSMutableArray alloc]init];
                              NSMutableArray *ylbl=[[NSMutableArray alloc]init];
                              self.lChartTitle.text=[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(@"Visit Details", @"Visit Details"),[receivedDta[0] objectForKey:@"Yr"]];
                              for(int il=0;il<[receivedDta count];il++){
                                  [xlbl addObject:[NSString stringWithFormat:@"%@",[receivedDta[il] objectForKey:@"Mon"]]];
                                  [ylbl addObject:[receivedDta[il] objectForKey:@"Cnt"]];
                              }
                              
                              [_lineChart setXLabels:xlbl];
                              PNLineChartData *data01 = [PNLineChartData new];
                              data01.color = PNFreshGreen;
                              data01.inflexionPointStyle = PNLineChartPointStyleCircle;
                              data01.inflexionPointColor = PNDeepGreen; //[UIColor colorWithRed:79.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
                              data01.itemCount = _lineChart.xLabels.count;
                              data01.getData = ^(NSUInteger index)
                              {
                                  CGFloat yValue = [ylbl[index] floatValue];
                                  return [PNLineChartDataItem dataItemWithY:yValue];
                              };
                              
                              _lineChart.chartData = @[data01];
                              [_lineChart strokeChart];
                          }
                               error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                                   NSLog(@"%@",errorMsg);
                               }
         ];
        [_lineChart strokeChart];
        
       
        NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
        [objDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        self.lSelPhone.text = [self.NwCustList[indexPath.row] objectForKey:@"Phone"];
        self.lSelMobile.text = [self.NwCustList[indexPath.row] objectForKey:@"Mobile"];
        self.lSelCate.text = [self.NwCustList[indexPath.row] objectForKey:@"CategoryName"];
        self.lSelSpec.text = [self.NwCustList[indexPath.row] objectForKey:@"SpecialtyName"];
        
        
        self.lSelVstDt.text = @"";
        self.lSelProd.text=@"";
        self.lSelInput.text=@"";
        self.lSelFeedbk.text=@"";
        self.lSelRems.text=@"";
        [self updateifEmptLVstStatus];
        [WBService SendServerRequest:@"GET/CusLVst" withParameter:[@{@"CusCode":self.CustCode,@"typ":@"N"} mutableCopy] withImages:nil DataSF:nil
                          completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                              
                              NSMutableArray *VstData=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                              if(VstData.count>0)
                              {
                                  NSDictionary *vstDtDet=[VstData[0] valueForKey:@"Vst_Date"];
                                  NSDate *sDate=[objDateFormatter dateFromString:[vstDtDet valueForKey:@"date"]];
                                  [objDateFormatter setDateFormat:@"dd - MMMM - yyyy HH:mm:ss"];
                                  self.lSelVstDt.text = [objDateFormatter stringFromDate:sDate];
                                  
                                  self.lSelProd.text=[VstData[0] valueForKey:@"Prod_Samp"];
                                  self.lSelInput.text=[VstData[0] valueForKey:@"Inputs"];
                                  self.lSelFeedbk.text=[VstData[0] valueForKey:@"Feedbk"];
                                  self.lSelRems.text=[VstData[0] valueForKey:@"Remks"];
                                  
                              }
                          }
                               error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                                   NSLog(@"%@",errorMsg);
                               }
         ];
        
        self.selUnDrView.hidden=YES;
        [self.view endEditing:YES];
    }
}

-(void)updateifEmptLVstStatus{
    if([self.lSelVstDt.text isEqual:@""]) self.lSelVstDt.text =@"-";
    if([self.lSelProd.text isEqual:@""]) self.lSelProd.text=@"-";
    if([self.lSelInput.text isEqual:@""]) self.lSelInput.text=@"-";
    if([self.lSelFeedbk.text isEqual:@""]) self.lSelFeedbk.text=@"-";
    if([self.lSelRems.text isEqual:@""]) self.lSelRems.text=@"-";
    
    /*self.lSelAddr.textColor = [SANTheme foregroundColor];
    self.lSelAddr.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelAddr.backgroundColor = [UIColor clearColor];
    
    self.lSelProd.textColor = [SANTheme foregroundColor];
    self.lSelProd.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelProd.backgroundColor = [UIColor clearColor];
    
    self.lSelInput.textColor = [SANTheme foregroundColor];
    self.lSelInput.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelInput.backgroundColor = [UIColor clearColor];
    
    self.lSelFeedbk.textColor = [SANTheme foregroundColor];
    self.lSelFeedbk.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelFeedbk.backgroundColor = [UIColor clearColor];
    
    self.lSelRems.textColor = [SANTheme foregroundColor];
    self.lSelRems.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelRems.backgroundColor = [UIColor clearColor];
    
    self.lSelVstDt.textColor = [SANTheme foregroundColor];
    self.lSelVstDt.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelVstDt.backgroundColor = [UIColor clearColor];*/
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tbHQ) return self.objHQList.count;
    if(tableView==self.tbOptSel) return self.objOptList.count;
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    
    if(tableView==self.tbHQ) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"CellHQ" forIndexPath:indexPath];
        NSDictionary *HQ = self.objHQList[indexPath.row];
        cell.lOptText.text = [HQ objectForKey:@"name"];
    }
    if(tableView==self.tbOptSel) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst = self.objOptList[indexPath.row];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tbHQ) {
        NSDictionary *HQ = self.objHQList[indexPath.row];
        [self.btnSelHQ setTitle:[HQ objectForKey:@"name"] forState:UIControlStateNormal];
        self.meetData.DataSF=[HQ objectForKey:@"id"];
        NSString *DataKey=[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",self.meetData.DataSF];
        self.searchBox.text=@"";
        
        [BaseViewController loadMasterData:self.meetData.DataSF completion:^(){
            self.NwCustList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            [self.collectionView reloadData];
        } error:^(NSString* errMsg){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                message:errMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            self.NwCustList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            [self.collectionView reloadData];
        }];
    }
    if(tableView==self.tbOptSel) {
        NSDictionary *SelOpt = self.objOptList[indexPath.row];
        [self.SelCmbBtn setTitle:[SelOpt objectForKey:@"Name"] forState:UIControlStateNormal];
        self.SelCmbBtn.tCmbCode=[SelOpt objectForKey:@"Code"];
    }
    [self closeTableViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(collectionView.bounds)/3)-7, 135);
}*/

-(IBAction)searchUnDoctor:(id)sender
{
    
    NSString *DataKey=[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",self.meetData.DataSF];
    self.NwCustList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    if([self.searchBox.text isEqualToString:@""]==NO){
        self.NwCustList = [self.NwCustList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]];
    }
    [self.collectionView reloadData];
}

-(void) assignValues{
    self.meetData.CustCode=self.CustCode;
    self.meetData.CustName=self.CustName;
    self.meetData.CusType=@"4";
    self.meetData.vstTime=[BaseViewController getDateTime];
    self.meetData.ModTime=[BaseViewController getDateTime];
    self.meetData.SpecCode=self.SpecCode;
    self.meetData.CateCode=self.CateCode;
}

-(IBAction) openSelHQ:(id)sender{
    BOOL upState=!self.tbHQ.hidden;
    [self closeTableViews];
    self.tbHQ.hidden=upState;
}
-(void) closeTableViews{
    self.tbHQ.hidden=YES;
    self.nwUnDrOptSels.hidden=YES;
}
-(IBAction)CloseOptSel:(id)sender{
    self.nwUnDrOptSels.hidden=YES;
}
-(IBAction)CloseNewDoctor:(id)sender{
    self.nwUnDrView.hidden=YES;
}
-(IBAction)ShowNewDoctor:(id)sender{
    self.nwUnDrView.hidden=NO;
}
-(IBAction)ShowDropdown:(id)sender{
    DropdownTheme *btn=(DropdownTheme *) sender;
    int typNo=(int) btn.tag;
    if(typNo==0) self.objOptList=[self.QualList mutableCopy];
    if(typNo==1) self.objOptList=[self.ClassList mutableCopy];
    if(typNo==2) self.objOptList=[self.CateList mutableCopy];
    if(typNo==3) self.objOptList=[self.SpecList mutableCopy];
    if(typNo==4) self.objOptList=[self.TerrList mutableCopy];
    
    self.SelCmbBtn=btn;
    self.nwUnDrOptSels.hidden=NO;
    [self.tbOptSel reloadData];
}
-(IBAction)ShowActivityEntry:(id)sender{
    [self performSegueWithIdentifier:@"ShowNdrActivity" sender:self];
}
-(IBAction)goDetailEntry:(id)sender{
    long indx=((UIButton*) sender).tag;
    _MissedEntry.SelectedIndex=indx;
    [self performSegueWithIdentifier:@"skipNdrPresent" sender:self];
}
-(IBAction)goSkipPresentaion:(id)sender{
    [self assignValues];
    [self performSegueWithIdentifier:@"skipNdrPresent" sender:self];
}
-(IBAction)goPreparePresentaion:(id)sender{
    [self assignValues];
   // [self performSegueWithIdentifier:@"skipNdrPresent" sender:self];
    [self performSegueWithIdentifier:@"goUnDrPreDemo" sender:self];
}
-(IBAction)CancelCallMeet:(id)sender{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}
-(IBAction)showUnCutomerList:(id)sender{
    
    self.QualList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Qualifics.SANAPP"] mutableCopy];
    self.ClassList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"DocClass.SANAPP"] mutableCopy];
    self.CateList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Category.SANAPP"] mutableCopy];
    self.SpecList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Specialitys.SANAPP"] mutableCopy];
    NSString* DataKey=[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",self.meetData.DataSF];
    self.TerrList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.selUnDrView.hidden=NO;
}
-(IBAction) SaveNwUnlistedDr:(id)sender{
    if([self.nwDrName.text isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the Doctor Name", @"Enter the Doctor Name")];
        return;
    }
    
    if([[NSString stringWithFormat:@"%@",self.CmbQual.tCmbCode]  isEqualToString:@""] || self.CmbQual.tCmbCode==nil){
        [BaseViewController Toast:NSLocalizedString(@"Select the Qualification", @"Select the Qualification")];
        return;
    }
   /* if([self.CmbClass.tCmbCode isEqualToString:@""] || self.CmbClass.tCmbCode==nil){
        [BaseViewController Toast:@"Select the Class"];
        return;
    }
    if([self.CmbCate.tCmbCode isEqualToString:@""] || self.CmbCate.tCmbCode==nil){
        [BaseViewController Toast:@"Select the Category"];
        return;
    }
    if([self.CmbSpec.tCmbCode isEqualToString:@""] || self.CmbSpec.tCmbCode==nil){
        [BaseViewController Toast:@"Select the Speciality"];
        return;
    }*/
    /*if([self.nwDrsAddr.text isEqualToString:@""]){
        [BaseViewController Toast:@"Enter the Address"];
        return;
    }*/
    if([self.CmbTerr.tCmbCode isEqualToString:@""] || self.CmbTerr.tCmbCode==nil){
        [BaseViewController Toast:NSLocalizedString(@"Select the Territory", @"Select the Territory")];
        return;
    }
    /*if([self.nwDrMobile.text isEqualToString:@""]){
        [BaseViewController Toast:@"Enter the Mobile No"];
        return;
    }*/
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Creating Please Wait..", @"Creating Please Wait...")];
    NSMutableDictionary* NWDRData=[[NSMutableDictionary alloc] init];
    [NWDRData setValue:self.nwDrName.text forKey:@"DrName"];
    [NWDRData setValue:self.CmbQual.tCmbCode forKey:@"DrQCd"];
    [NWDRData setValue:self.CmbQual.titleLabel.text forKey:@"DrQNm"];
    [NWDRData setValue:self.CmbClass.tCmbCode forKey:@"DrClsCd"];
    [NWDRData setValue:self.CmbClass.titleLabel.text forKey:@"DrClsNm"];
    [NWDRData setValue:self.CmbCate.tCmbCode forKey:@"DrCatCd"];
    [NWDRData setValue:self.CmbCate.titleLabel.text forKey:@"DrCatNm"];
    [NWDRData setValue:self.CmbSpec.tCmbCode forKey:@"DrSpcCd"];
    [NWDRData setValue:self.CmbSpec.titleLabel.text forKey:@"DrSpcNm"];
    [NWDRData setValue:self.nwDrsAddr.text forKey:@"DrAddr"];
    [NWDRData setValue:self.CmbTerr.tCmbCode forKey:@"DrTerCd"];
    [NWDRData setValue:self.CmbTerr.titleLabel.text forKey:@"DrTerNm"];
    [NWDRData setValue:self.nwDrPincd.text forKey:@"DrPincd"];
    [NWDRData setValue:self.nwDrPhone.text forKey:@"DrPhone"];
    [NWDRData setValue:self.nwDrMobile.text forKey:@"DrMob"];
    
    [WBService SendServerRequest:@"SAVE/NewDR" withParameter:[NWDRData mutableCopy] withImages:nil
                          DataSF:nil
                      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         if(Success==YES){
             [BaseViewController Toast:NSLocalizedString(@"New Unlisted Doctor Created Successfully.", @"New Unlisted Doctor Created Successfully....")];
             [WBService SendServerRequest:@"GET/UnlistedDR" withParameter:nil withImages:nil DataSF:self.meetData.DataSF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                 
                 NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];

                 NSString *DataKey=[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",self.meetData.DataSF];
                 [WBService saveData:receivedDta forKey:DataKey];
                self.NwCustList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
                 [self.collectionView reloadData];
                 self.nwUnDrView.hidden=YES;
            }
            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                NSLog(@"%@",errorMsg);
            }
            ];
         }
         else{
             [BaseViewController Toast:NSLocalizedString(@"New Unlisted Doctor Creation Failed.", @"New Unlisted Doctor Creation Failed.")];
             
         }
         [SVProgressHUD dismiss];
     }
    error:^(NSString *errorMsg,NSMutableDictionary *uData){
       [BaseViewController Toast:[NSString stringWithFormat:@"%@ .\n %@",NSLocalizedString(@"New Unlisted Doctor Creation Failed", @"New Unlisted Doctor Creation Failed"),errorMsg.description]];
       [SVProgressHUD dismiss];
    }];
}
 
-(void)clearNewDrForm
{ 
    self.nwDrName.text = @"";
    self.CmbQual.titleLabel.text = @"Select the Qualification";
    self.CmbClass.titleLabel.text = @"Select the Class";
    self.CmbCate.titleLabel.text = @"Select the Category";
    self.CmbSpec.titleLabel.text = @"Select the Specality";
    self.nwDrsAddr.text = @"";
    self.CmbTerr.titleLabel.text= @"";
    self.CmbTerr.titleLabel.text = @"";
    self.nwDrPincd.text = @"";
    self.nwDrPhone.text = @"";
    self.nwDrMobile.text = @""; 
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ShowNdrActivity"]){
        DynamicActivityCtrl *ActivityCTRL=[segue destinationViewController];
        [ActivityCTRL setEMode:@"4,"];
    }
}
@end
