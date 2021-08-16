//
//  ChemistSelCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 05/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "ChemistSelCtrl.h"
#import "mCustomerCell.h"

@interface ChemistSelCtrl ()
@property (nonatomic, strong) NSArray* ObjChemistList;
@property (nonatomic, strong) NSArray* ChemistList;
@property (nonatomic, strong) NSDictionary* TP;
@property (nonatomic, weak) NSString* CustCode;
@property (nonatomic, weak) NSString* CustName;
@end


@implementation ChemistSelCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    self.MissedEntry=[MissedEntryData sharedDatas];
    self.meetData=[CallMeetData sharedDatas];
    self.UserDet=[UserDetails sharedUserDetails];
    self.SetupData=[AppSetupData sharedDatas];
    
    self.TdayPl=[TdayPlDetail sharedTdayPlDetail];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.tbHQ.delegate = self;
    self.tbHQ.dataSource = self;
    
    self.layout.minimumInteritemSpacing = 8;
    self.layout.minimumLineSpacing = 25;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if(_SetupData.ChmActivityNeed==0){_btnActivity.hidden=YES;}
    //UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f];
    //self.collectionView.backgroundColor = darkColor;
    self.TP =[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
    self.meetData.DataSF=[self.TP valueForKey:@"SFMem"];
    if([self.UserDet.Desig isEqualToString:@"MR"]) self.meetData.DataSF=self.UserDet.SF;
    
    
    _lblHeadTitle.text=[NSString stringWithFormat:@"%@ Selection",_SetupData.CapChm];
    _searchBox.placeholder=[NSString stringWithFormat:@"Search %@",_SetupData.CapChm];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.meetData.DataSF];
    self.ObjChemistList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    
    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    
    NSMutableArray *MkList=[[_ObjChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", self.TdayPl.Pl]] mutableCopy];
    self.ChemistList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    MkList=[[_ObjChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code!= %@", self.TdayPl.Pl]] mutableCopy];
    self.ChemistList = [[self.ChemistList arrayByAddingObjectsFromArray:[MkList sortedArrayUsingDescriptors:sortDescriptors]] mutableCopy];
    
    
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    _btnSelHQ.hidden=YES;
    if(![_UserDet.Desig isEqualToString:@"MR"]) _btnSelHQ.hidden=NO;
    
    [_btnSelHQ setTitle:self.meetData.DataSFHQ forState:UIControlStateNormal];
    if([self.meetData.DataSFHQ  isEqual:@""]) [_btnSelHQ setTitle:NSLocalizedString(@"Select tht Headquaters", @"Select the Headquaters") forState:UIControlStateNormal];
    DataKey=[[NSString alloc] initWithFormat:@"DRVstDetails_%@.SANAPP",self.meetData.DataSF];
    self.VstDetList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ChemistList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mCustomerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    
    /*UIColor* mainColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0f];
    cell.backgroundColor=mainColor;*/
    cell.layer.cornerRadius=4.0f;
    NSString* Code=[self.ChemistList[indexPath.row] objectForKey:@"Town_Code"];
    if([Code isEqualToString:[NSString stringWithFormat:@"%@",_TdayPl.Pl]])
        //cell.lCustName.textColor=[UIColor colorWithRed:107.0f/255 green:172.0f/255 blue:251.0f/255 alpha:1.0f];
        //cell.lCustName.textColor=[UIColor colorWithRed:255.0f/255 green:108.0f/255 blue:83.0f/255 alpha:1.0f];
        cell.selImgID.image=[UIImage imageNamed:@"redCallID"];
    else
        cell.selImgID.image=[UIImage imageNamed:@"itemChm"];
    
    cell.lCustName.textColor=[UIColor whiteColor];
    cell.lCustName.text = [self.ChemistList[indexPath.row] objectForKey:@"Name"];
    cell.lTownName.text = [self.ChemistList[indexPath.row] objectForKey:@"Town_Name"];
    //cell.lCategory.text = [self.ChemistList[indexPath.row] objectForKey:@"Category"];
    //cell.lSpeciality.text = [self.ChemistList[indexPath.row] objectForKey:@"Specialty"];
    
    NSMutableArray *MkList=[[_MissedEntry.MissDatas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode== %@", [self.ChemistList[indexPath.row] objectForKey:@"Code"]]] mutableCopy];
    
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
        NSMutableArray *MkList=[[_MissedEntry.MissDatas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode== %@", [self.ChemistList[indexPath.row] objectForKey:@"Code"]]] mutableCopy];
        if ([MkList count]>0){
            [_MissedEntry.MissDatas removeObject:MkList[0]];
        }else{
            CallMeetData *MissDocItem=[[CallMeetData alloc] init];
            NSString* WrkNm=@"F";
            NSDictionary* wrk =[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FWFlg ='F'", WrkNm]] mutableCopy];
            MissDocItem.MissedEntry=YES;
            MissDocItem.CustCode=[self.ChemistList[indexPath.row] objectForKey:@"Code"];;
            MissDocItem.CustName=[self.ChemistList[indexPath.row] objectForKey:@"Name"];;
            MissDocItem.CusType=@"2";
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
        self.CustCode=[self.ChemistList[indexPath.row] objectForKey:@"Code"];
        self.CustName=[self.ChemistList[indexPath.row] objectForKey:@"Name"];
        self.lSelCustName.text = [self.ChemistList[indexPath.row] objectForKey:@"Name"];
        self.lSelTownName.text = [self.ChemistList[indexPath.row] objectForKey:@"Town_Name"];
        self.lSelAddr.text = [self.ChemistList[indexPath.row] objectForKey:@"Addr"];
        self.lSelContact.text = [self.ChemistList[indexPath.row] objectForKey:@"Chemists_Contact"];
        //self.lSelSpeciality.text = [self.ChemistList[indexPath.row] objectForKey:@"Specialty"];
        
        
       // _lineChart.backgroundColor=[UIColor colorWithRed:57.0/255 green:67.0/255 blue:96.0/255 alpha:1.0f];
        
        _lineChart.showSmoothLines = YES;
        _lineChart.showCoordinateAxis = true;
        
        _lineChart.showYGridLines=true;
        _lineChart.yGridLinesColor=[UIColor lightGrayColor];
        /*_lineChart.axisColor=[UIColor whiteColor];
        _lineChart.yLabelColor=[UIColor whiteColor];
        _lineChart.xLabelColor=[UIColor whiteColor];*/
        _lineChart.showGenYLabels=YES;
        _lineChart.tintColor=[UIColor colorWithRed:57.0/255 green:67.0/255 blue:96.0/255 alpha:1.0f];
        
        [WBService SendServerRequest:@"GET/CusMVst" withParameter:[@{@"CusCode":self.CustCode,@"typ":@"C"} mutableCopy] withImages:nil DataSF:nil
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
        
        self.lSelPhone.text = [self.ChemistList[indexPath.row] objectForKey:@"Chemists_Phone"];
        self.lSelMobile.text = [self.ChemistList[indexPath.row] objectForKey:@"Chemists_Mobile"];
        self.lSelFax.text = [self.ChemistList[indexPath.row] objectForKey:@"Chemists_Fax"];
        self.lSelEmail.text = [self.ChemistList[indexPath.row] objectForKey:@"Chemists_Email"];
        //self.lSelResAddr.text = [self.ChemistList[indexPath.row] objectForKey:@"ResAddr"];
        
        
        
        self.lSelVstDt.text = @"";
        self.lSelProd.text=@"";
        self.lSelInput.text=@"";
        self.lSelFeedbk.text=@"";
        self.lSelRems.text=@"";
        [self updateifEmptLVstStatus];
        [WBService SendServerRequest:@"GET/CusLVst" withParameter:[@{@"CusCode":self.CustCode,@"typ":@"C"} mutableCopy] withImages:nil DataSF:nil
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
        
        self.selChmView.hidden=YES;
        [self.view endEditing:YES];
    }
}

-(void)updateifEmptLVstStatus{
    if([self.lSelVstDt.text isEqual:@""]) self.lSelVstDt.text =@"-";
    if([self.lSelProd.text isEqual:@""]) self.lSelProd.text=@"-";
    if([self.lSelInput.text isEqual:@""]) self.lSelInput.text=@"-";
    if([self.lSelFeedbk.text isEqual:@""]) self.lSelFeedbk.text=@"-";
    if([self.lSelRems.text isEqual:@""]) self.lSelRems.text=@"-";
    
  /*  self.lSelAddr.textColor = [SANTheme foregroundColor];
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
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tbHQ) {
        NSDictionary *HQ = self.objHQList[indexPath.row];
        [self.btnSelHQ setTitle:[HQ objectForKey:@"name"] forState:UIControlStateNormal];
        self.meetData.DataSF=[HQ objectForKey:@"id"];
        NSString *DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.meetData.DataSF];
        self.searchBox.text=@"";
        
        [BaseViewController loadMasterData:self.meetData.DataSF completion:^(){
            self.ObjChemistList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
            
            NSMutableArray *MkList=[[_ObjChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", self.TdayPl.Pl]] mutableCopy];
            self.ChemistList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
            MkList=[[_ObjChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code!= %@", self.TdayPl.Pl]] mutableCopy];
            self.ChemistList = [[self.ChemistList arrayByAddingObjectsFromArray:[MkList sortedArrayUsingDescriptors:sortDescriptors]] mutableCopy];
            [self.collectionView reloadData];
        } error:^(NSString* errMsg){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                message:errMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            self.ObjChemistList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
            
            NSMutableArray *MkList=[[_ObjChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", self.TdayPl.Pl]] mutableCopy];
            self.ChemistList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
            MkList=[[_ObjChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code!= %@", self.TdayPl.Pl]] mutableCopy];
            self.ChemistList = [[self.ChemistList arrayByAddingObjectsFromArray:[MkList sortedArrayUsingDescriptors:sortDescriptors]] mutableCopy];
            [self.collectionView reloadData];
        }];
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

-(IBAction)searchDoctor:(id)sender
{
    
    NSString *DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.meetData.DataSF];
    self.ChemistList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    if([self.searchBox.text isEqualToString:@""]==NO){
        self.ChemistList = [self.ChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]];
    }
    [self.collectionView reloadData];
}

-(void) assignValues{
    self.meetData.CustCode=self.CustCode;
    self.meetData.CustName=self.CustName;
    self.meetData.CusType=@"2";
    self.meetData.vstTime=[BaseViewController getDateTime];
    self.meetData.ModTime=[BaseViewController getDateTime];
}
-(IBAction) openSelHQ:(id)sender{
    BOOL upState=!self.tbHQ.hidden;
    [self closeTableViews];
    self.tbHQ.hidden=upState;
}
-(void) closeTableViews{
    self.tbHQ.hidden=YES;
}
-(IBAction)ShowActivityEntry:(id)sender{
    [self performSegueWithIdentifier:@"ShowChmActivity" sender:self];
}
-(IBAction)goDetailEntry:(id)sender{
    long indx=((UIButton*) sender).tag;
    _MissedEntry.SelectedIndex=indx;
    [self performSegueWithIdentifier:@"skipChmPresent" sender:self];
}
-(IBAction)goSkipPresentaion:(id)sender{
    [self assignValues];
    [self performSegueWithIdentifier:@"skipChmPresent" sender:self];
}
-(IBAction)goPreparePresentaion:(id)sender{
    [self assignValues];
    [self performSegueWithIdentifier:@"goChmPreDemo" sender:self];
}
-(IBAction)CancelCallMeet:(id)sender{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}
-(IBAction)showCutomerList:(id)sender{
    self.selChmView.hidden=NO;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ShowChmActivity"]){
        DynamicActivityCtrl *ActivityCTRL=[segue destinationViewController];
        [ActivityCTRL setEMode:@"2,"];
    }
}
@end
