//
//  LaunchAppVwCtrlr.m
//  SANAPP
//
//  Created by SANeForce.com on 08/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "CustomerSelCtrl.h"
#import "mCustomerCell.h"
@interface CustomerSelCtrl ()
@property (nonatomic, strong) NSMutableArray* ObjCustomerList;
@property (nonatomic, strong) NSArray* CustomerList;
@property (nonatomic, strong) NSArray* HospitalsList;
@property (nonatomic,strong) NSArray *objClusterList;
@property (nonatomic, strong) NSDictionary* TP;
@property (nonatomic, weak) NSString* CustCode;
@property (nonatomic, weak) NSString* CustName;
@property (nonatomic, weak) NSString* SpecCode;
@property (nonatomic, weak) NSString* CateCode;
@property (nonatomic, weak) NSString* mappedProds;
@property (nonatomic, retain) NSString* ETm;
@property (nonatomic, retain) NSString* selHospitalID;
@end

/// <#Description#>
@implementation CustomerSelCtrl

/// <#Description#>
- (void)viewDidLoad {
    [super viewDidLoad];
    self.MissedEntry=[MissedEntryData sharedDatas];
    self.meetData=[CallMeetData sharedDatas];
    self.drPolicy=[DrPolicyData sharedDatas];
    self.UserDet=[UserDetails sharedUserDetails];
    self.locationData=[LocationDetail sharedLocationData];
    self.TdayPl=[TdayPlDetail sharedTdayPlDetail];
    self.SetupData=[AppSetupData sharedDatas];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.tbHQ.delegate = self;
    self.tbHQ.dataSource = self;
    
    self.tbVstType.delegate = self;
    self.tbVstType.dataSource = self;
    self.layout.minimumInteritemSpacing = 8;
    self.layout.minimumLineSpacing = 25;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self hideCutomerPolicy];
    _notifyInfo.hidden=YES;
    _lblCallType.hidden=NO;
    _lblCallTypCap.hidden=NO;
    _btnCallTyp.hidden=NO;
    _imgCallTyp.hidden=NO;
    if (_SetupData.DrCallType==0) {
        _lblCallType.hidden=YES;
        _lblCallTypCap.hidden=YES;
        _btnCallTyp.hidden=YES;
        _imgCallTyp.hidden=YES;
    }
    _lblNxtVst.hidden=NO;
    _dtPickNxtVst.hidden=NO;
    if (_SetupData.DrNextVisit==0) {
        _lblNxtVst.hidden=YES;
        _dtPickNxtVst.hidden=YES;
    }
    [self.signatureView ClearSign];
    _btnSkipDet.hidden=NO;
    if (_SetupData.SkipSlideDemo==0) {_btnSkipDet.hidden=YES;}
    if(_SetupData.DrActivityNeed==0){_btnActivity.hidden=YES;}
    //UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f];
    //self.collectionView.backgroundColor = darkColor;
    self.TP =[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
    self.meetData.DataSF=[self.TP valueForKey:@"SFMem"];
    self.meetData.DataSFHQ=[self.TP valueForKey:@"HQNm"];
    if([self.UserDet.Desig isEqualToString:@"MR"]) self.meetData.DataSF=self.UserDet.SF;
    
    CGFloat dis=_UserDet.DistRadius;
    CLLocationCoordinate2D currentLoction=CLLocationCoordinate2DMake([_locationData.latitude doubleValue], [_locationData.longitude doubleValue]);
    
    if([_locationData.latitude isEqualToString:@""] || [_locationData.latitude isEqualToString:@"(null)"] )
    {
            self.objClusterList= [[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",self.UserDet.SF]] mutableCopy];
        _objClusterList=[[_objClusterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code== %@", self.TdayPl.Pl]] mutableCopy];
        if([_objClusterList count]>0){
            currentLoction=CLLocationCoordinate2DMake([[self.objClusterList[0] objectForKey:@"Lat"] doubleValue], [[self.objClusterList[0] objectForKey:@"Long"] doubleValue]);
            
        }
    }
    NSPredicate *findDistance = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind){
        
        CLLocationCoordinate2D CusLoc=CLLocationCoordinate2DMake([[obj valueForKey:@"Lat"] doubleValue], [[obj valueForKey:@"Long"] doubleValue]);
        CGFloat cDis=[BaseViewController directMetersFromCoordinate:currentLoction toCoordinate:CusLoc];
        if([[obj valueForKey:@"Long"] doubleValue]>0){
            NSLog(@"%@",[obj valueForKey:@"ong"]);
        }
        NSLog(@"%f %d",cDis,(cDis>0 && cDis <= dis));
        return cDis>0 && cDis <= dis;
    }];
    _lblHeadTitle.text=[NSString stringWithFormat:@"%@ Selection",_SetupData.CapDr];
    _searchBox.placeholder=[NSString stringWithFormat:@"Search %@",_SetupData.CapDr];
    _HospitalsList=[[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"Hospital_%@.SANAPP",self.meetData.DataSF]] mutableCopy];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
    self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    
    NSMutableArray *MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", self.TdayPl.Pl]] mutableCopy];
    if(_UserDet.GEOTagNeed==1){
        MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
        
    }
    
    self.CustomerList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code!= %@", self.TdayPl.Pl]] mutableCopy];
    if(_UserDet.GEOTagNeed==1){
        MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
    }
    self.CustomerList = [[self.CustomerList arrayByAddingObjectsFromArray:[MkList sortedArrayUsingDescriptors:sortDescriptors]] mutableCopy];
    
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    /*NSMutableDictionary *itm=[[NSMutableDictionary alloc ]init];
    [itm setValue:@"1" forKey:@"id"];
    [itm setValue:NSLocalizedString(@"Drug", @"Drug") forKey:@"name"];
    NSMutableDictionary *itm2=[[NSMutableDictionary alloc ]init];
    [itm2 setValue:@"2" forKey:@"id"];
    [itm2 setValue:NSLocalizedString(@"Non Drug", @"Non Drug") forKey:@"name"];*/
    self.objCallType= [[[NSUserDefaults standardUserDefaults] objectForKey:@"VisitTypes.SANAPP"] mutableCopy];//@[itm,itm2]; //
    self.tbVstType.layer.borderColor=[UIColor colorWithRed:0.783 green:0.793 blue:0.802 alpha:1.00].CGColor;
    self.tbVstType.layer.borderWidth=1;
    
    _lblGPSSegCap.hidden=YES;
    _lblGPSSeg.hidden=YES;
    _btnSelHQ.hidden=YES;
    if(![_UserDet.Desig isEqualToString:@"MR"]) _btnSelHQ.hidden=NO;
    if(_SetupData.GPSSegNeed==1){
        _lblGPSSegCap.hidden=NO;
        _lblGPSSeg.hidden=NO;
    }
    
    [_btnSelHQ setTitle:self.meetData.DataSFHQ forState:UIControlStateNormal];
    if([self.meetData.DataSFHQ  isEqual:@""]) [_btnSelHQ setTitle:NSLocalizedString(@"SelectHeadquatersBTN", @"Select the Headquaters") forState:UIControlStateNormal];
    
    DataKey=[[NSString alloc] initWithFormat:@"DRVstDetails_%@.SANAPP",self.meetData.DataSF];
    self.VstDetList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    
    if(_SetupData.HospBased==1) [self addFilterView];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startLatLngUpd) userInfo:nil repeats:NO] ;
}

-(void) addFilterView{
    double eW=(self.view.frame.size.width-36)/4;
    double eH=self.searchBox.frame.size.height;
    [_searchBox setFrame:CGRectMake(18, _searchBox.frame.origin.y,eW*3, _searchBox.frame.size.height)];
    CAShapeLayer *maskTLayer = [CAShapeLayer layer];
    maskTLayer.borderWidth=0.5;
    maskTLayer.borderColor=[UIColor grayColor].CGColor;
    maskTLayer.path = [UIBezierPath bezierPathWithRoundedRect:_searchBox.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:(CGSize){5.0, 5.0}].CGPath;
    
    _searchBox.layer.mask = maskTLayer;
    _btnFilter=[[UIButton alloc] initWithFrame:CGRectMake(eW*3, self.searchBox.frame.origin.y,eW+18, self.searchBox.frame.size.height)];
    [_btnFilter setTitle:[NSString stringWithFormat:@"All %@", NSLocalizedString(self.SetupData.CapHos, self.SetupData.CapHos)] forState:UIControlStateNormal];
    _btnFilter.titleLabel.font=[UIFont fontWithName:@"Poppins-SemiBold" size:14.0];
    _btnFilter.backgroundColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];//[UIColor colorWithRed:89.0f/255 green:89.0f/255 blue:89.0f/255 alpha:1.0f];
    _btnFilter.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _btnFilter.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_btnFilter.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:(CGSize){5.0, 5.0}].CGPath;
    _btnFilter.layer.mask = maskLayer;
    
    UIImageView* btnImg=[[UIImageView alloc] initWithFrame:CGRectMake(_btnFilter.frame.size.width-18, (eH-10)/2,10, 10)];
    btnImg.image=[[UIImage imageNamed:@"DwnArrw"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    btnImg.tintColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];
    [_btnFilter addSubview:btnImg];
    [_btnFilter addTarget:self action:@selector(showHospitalFilter:) forControlEvents:UIControlEventTouchUpInside];
    [_selDrView addSubview:_btnFilter];
}
-(IBAction)searchHospital:(id)sender
{
    if([self.txtHospSearch.text isEqualToString:@""]){
        _objHospList=[_HospitalsList mutableCopy];
    }else{
    _objHospList=[[_HospitalsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.txtHospSearch.text]] mutableCopy];
    }
    [_selHospFltr reloadData];
}
-(IBAction) showHospitalFilter:(id)sender{
    _vwModeModal=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _vwModeModal.backgroundColor=[UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.6];
    UIView* vwMode=[[UIView alloc] initWithFrame:CGRectMake(_btnFilter.frame.origin.x, _btnFilter.frame.origin.y+_btnFilter.frame.size.height+70, _btnFilter.frame.size.width, 270)];
    vwMode.backgroundColor=[UIColor whiteColor];
    _txtHospSearch=[[UITextField alloc] initWithFrame:CGRectMake(5, 2, _btnFilter.frame.size.width-10, 30)];
    _txtHospSearch.backgroundColor=[UIColor colorWithRed:249.0f/255 green:249.0f/255 blue:249.0f/255 alpha:1.0f] ;
    _txtHospSearch.font=[UIFont fontWithName:@"Poppins-Regular" size:12.0];
    _txtHospSearch.borderStyle=UITextBorderStyleRoundedRect;
    _txtHospSearch.placeholder=[NSString stringWithFormat:@"Search %@",_SetupData.CapHos];
    [_txtHospSearch addTarget:self action:@selector(searchHospital:) forControlEvents:UIControlEventEditingChanged];
    [vwMode addSubview:_txtHospSearch];
    self.selHospFltr=[[UITableView alloc] initWithFrame:CGRectMake(0, 35, _btnFilter.frame.size.width, 200)];
    [self.selHospFltr registerClass:[TBSelectionBxCell class] forCellReuseIdentifier:@"Cell"];
        
    _selHospFltr.rowHeight = 42;
    _selHospFltr.scrollEnabled = YES;
    _selHospFltr.showsVerticalScrollIndicator = YES;
    _selHospFltr.userInteractionEnabled = YES;
    _selHospFltr.bounces = YES;
    _selHospFltr.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    _selHospFltr.separatorInset=UIEdgeInsetsZero;
    _selHospFltr.delegate = self;
    _selHospFltr.dataSource = self;
    [vwMode addSubview:self.selHospFltr];
    [_vwModeModal addSubview:vwMode];
    _btnAllHosp=[[UIButton alloc] initWithFrame:CGRectMake(0, 240,_btnFilter.frame.size.width, 30)];
    [_btnAllHosp setTitle:[NSString stringWithFormat:@"Show All %@",_SetupData.CapDr] forState:UIControlStateNormal];
    _btnAllHosp.titleLabel.font=[UIFont fontWithName:@"Poppins-Regular" size:12.0];
    _btnAllHosp.backgroundColor=[UIColor grayColor];
    [_btnAllHosp addTarget:self action:@selector(showAllHospDr:) forControlEvents:UIControlEventTouchUpInside];
    [vwMode addSubview:_btnAllHosp];
    _objHospList=[_HospitalsList mutableCopy];
    [_selHospFltr reloadData];
    [self.view addSubview:_vwModeModal];   //vwMode
   // [vwMode.centerXAnchor constraintEqualToAnchor:vwModeModal.centerXAnchor].active=YES;
    //[vwMode.centerYAnchor constraintEqualToAnchor:vwModeModal.centerYAnchor].active=YES;
}
-(IBAction) showAllHospDr:(id)sender{
    _selHospitalID=nil;
    [_btnFilter setTitle:[NSString stringWithFormat:@"All %@", NSLocalizedString(self.SetupData.CapHos, self.SetupData.CapHos)] forState:UIControlStateNormal];
    [self SearchAndFilterCustomer];
    [_vwModeModal removeFromSuperview];
}
- (NSArray *)allSubviewsOfView:(UIView *)view
{
    NSMutableArray *subviews = [[view subviews] mutableCopy];
    for (UIView *subview in [view subviews])
        [subviews addObjectsFromArray:[self allSubviewsOfView:subview]]; //recursive
    return subviews;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self updateDtLabels];
    [_dtPickNxtVst addTarget:self action:@selector(updateDtLabels) forControlEvents:UIControlEventValueChanged];
    
}
-(void) updateDtLabels{
    NSArray *allSubviewsOfWindow = [self allSubviewsOfView:self.dtPickNxtVst];
    for(UIView *subview in allSubviewsOfWindow)
    {
        if([subview isKindOfClass: [UILabel class]])
        {
            ((UILabel*)subview).font=[UIFont fontWithName:@"Poppins-Regular" size:12.0];
            //((UILabel*)subview).textColor=[UIColor greenColor];
            object_setClass(((UILabel*)subview), [CLMDtPicker class]);
            
            NSLog(@"Like : %@",subview);
        }
    }
}
-(void) startLatLngUpd{
    self.lLatLng.text= [NSString stringWithFormat:@"- ( %@ , %@ )",self.locationData.latitude, self.locationData.longitude];
    [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startLatLngUpd) userInfo:nil repeats:NO] ;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.CustomerList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mCustomerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    
   /* UIColor* mainColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0f];
    cell.backgroundColor=mainColor;*/
    cell.layer.cornerRadius=4.0f;
    NSString* Code=[self.CustomerList[indexPath.row] objectForKey:@"Town_Code"];
    cell.lCustName.text = [self.CustomerList[indexPath.row] objectForKey:@"Name"];
    if([Code isEqualToString:[NSString stringWithFormat:@"%@",_TdayPl.Pl]])
        //cell.lCustName.textColor=[UIColor colorWithRed:255.0f/255 green:108.0f/255 blue:83.0f/255 alpha:1.0f];
        cell.selImgID.image=[UIImage imageNamed:@"redCallID"];
    else
        cell.selImgID.image=[UIImage imageNamed:@"itemChm"];
    
    NSMutableArray *MkList=[[_MissedEntry.MissDatas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode== %@", [self.CustomerList[indexPath.row] objectForKey:@"Code"]]] mutableCopy];
    
    if ([MkList count]>0){
        cell.selCusImg.image=[UIImage imageNamed:@"chkoptRed"];
        cell.btnBtnDets.tag=[_MissedEntry.MissDatas indexOfObject:MkList[0]];
        cell.btnBtnDets.hidden=NO;
    }
    else{
        cell.selCusImg.image=nil;
        cell.btnBtnDets.hidden=YES;
    }
    
    
    cell.lCustName.textColor=[UIColor whiteColor];
    cell.lTownName.text = [self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
    cell.lCategory.text = [self.CustomerList[indexPath.row] objectForKey:@"Category"];
    cell.lSpeciality.text = [self.CustomerList[indexPath.row] objectForKey:@"Specialty"];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        if(self.meetData.MissedEntry==YES){
        NSMutableArray *MkList=[[_MissedEntry.MissDatas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode== %@", [self.CustomerList[indexPath.row] objectForKey:@"Code"]]] mutableCopy];
        if ([MkList count]>0){
            [_MissedEntry.MissDatas removeObject:MkList[0]];
        }else{
            CallMeetData *MissDocItem=[[CallMeetData alloc] init];
            NSString* WrkNm=@"F";
            NSDictionary* wrk =[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FWFlg ='F'", WrkNm]] mutableCopy];
            MissDocItem.MissedEntry=YES;
            MissDocItem.CustCode=[self.CustomerList[indexPath.row] objectForKey:@"Code"];;
            MissDocItem.CustName=[self.CustomerList[indexPath.row] objectForKey:@"Name"];;
            MissDocItem.CusType=@"1";
            MissDocItem.SpecCode=[self.CustomerList[indexPath.row] objectForKey:@"SpecialtyCode"];
            MissDocItem.CateCode=[self.CustomerList[indexPath.row] objectForKey:@"Category"];
            MissDocItem.vstTime=[BaseViewController getDateTime];
            MissDocItem.ModTime=[BaseViewController getDateTime];
            MissDocItem.mappedProds=[self.CustomerList[indexPath.row] objectForKey:@"MappProds"];
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
        self.CustCode=[self.CustomerList[indexPath.row] objectForKey:@"Code"];
        self.CustName=[self.CustomerList[indexPath.row] objectForKey:@"Name"];
        self.CateCode = [self.CustomerList[indexPath.row] objectForKey:@"CategoryCode"];
        self.SpecCode = [self.CustomerList[indexPath.row] objectForKey:@"SpecialtyCode"];
        if (self.SetupData.RatingBasedSlide==1){
            _meetData.RatingSlideIds=@"";
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showWithStatus:NSLocalizedString(@"Getting Slides For Rating",@"Getting Slides For Rating")];
           
            [WBService SendServerRequest:@"GET/RatingSlides" withParameter:[@{@"CusCode":self.CustCode} mutableCopy] withImages:nil DataSF:nil
                completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                     NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                    NSString *sSlNos=[[NSString alloc] init];
                    for(int il=0;il<[receivedDta count];il++){
                        sSlNos=[NSString stringWithFormat:@"%@%@,",sSlNos,[receivedDta[il] valueForKey:@"SI_NO"]];
                    }
                    _meetData.RatingSlideIds=[NSString stringWithFormat:@",%@",sSlNos];
                
                [SVProgressHUD dismiss];
                }
                error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                      NSLog(@"%@",errorMsg);
                
                [SVProgressHUD dismiss];
                }];
        }
        self.mappedProds=[self.CustomerList[indexPath.row] objectForKey:@"MappProds"];
       
        int PolicyFl=[[self.CustomerList[indexPath.row] objectForKey:@"PlcyAcptFl"] intValue];
        
        self.lSelCustName.text = self.CustName;
        self.lSelTownName.text = [self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
        self.lSelCategory.text = [self.CustomerList[indexPath.row] objectForKey:@"Category"];
        self.lSelSpeciality.text = [self.CustomerList[indexPath.row] objectForKey:@"Specialty"];
        self.lblGPSSeg.text = [self.CustomerList[indexPath.row] objectForKey:@"DrGPS"];
        
        self.lSelPolyCustName.text = self.CustName;
        
        [self genPreChart];
        /*
        [WBService SendServerRequest:@"GET/RatingSlide" withParameter:[@{@"CusCode":self.CustCode} mutableCopy] withImages:nil DataSF:nil
         completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                 NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                _meetData.RatingSlide=[receivedDta mutableCopy];
            }
            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                  NSLog(@"%@",errorMsg);
            }
        ];*/
        [WBService SendServerRequest:@"GET/CusMVst" withParameter:[@{@"CusCode":self.CustCode,@"typ":@"D"} mutableCopy] withImages:nil DataSF:nil
                          completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                              
                              NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                              [WBService saveData:receivedDta forKey:[NSString stringWithFormat:@"CusMVst_Cus%@D.SANAPP",self.CustCode]];
                              [self genPreChart];
                          }
                               error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                                   NSLog(@"%@",errorMsg);
                               }
         ];
        
        NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
        [objDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSString *dob=[[NSString alloc] initWithString:[self.CustomerList[indexPath.row] objectForKey:@"DOB"]];
        if (![dob isEqualToString:@""]){
            NSDate *sDate=[objDateFormatter dateFromString:dob];
            [objDateFormatter setDateFormat:@"dd - MMM"];
            dob = [objDateFormatter stringFromDate:sDate];
        }
        self.lSelDOB.text = dob;

        NSString *dow=[[NSString alloc] initWithString:[self.CustomerList[indexPath.row] objectForKey:@"DOW"]];
        if (![dow isEqualToString:@""]){
            NSDate *sDate=[objDateFormatter dateFromString:dow];
            [objDateFormatter setDateFormat:@"dd - MMM"];
            dow = [objDateFormatter stringFromDate:sDate];
        }
        self.lSelDOW.text = dow;
        
        self.lSelQual.text = [self.CustomerList[indexPath.row] objectForKey:@"DrDesig"];
        self.lSelMobile.text = [self.CustomerList[indexPath.row] objectForKey:@"Mobile"];
        self.lSelEmail.text = [self.CustomerList[indexPath.row] objectForKey:@"DrEmail"];
        self.lSelHosAddr.text = [self.CustomerList[indexPath.row] objectForKey:@"HosAddr"];
        self.lSelResAddr.text = [self.CustomerList[indexPath.row] objectForKey:@"ResAddr"];
        
        self.lSelPolyAddr.text = [self.CustomerList[indexPath.row] objectForKey:@"HosAddr"];
        self.lSelPolyQual.text = [self.CustomerList[indexPath.row] objectForKey:@"DrDesig"];
        self.lSelPolyLoc.text = [self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
        self.lSelPolyPin.text = [self.CustomerList[indexPath.row] objectForKey:@"DrPincode"];
        self.lSelPolyDist.text = [self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
        self.txtEmail.text = [self.CustomerList[indexPath.row] objectForKey:@"DrEmail"];
        
        [self genPreVst];
        [WBService SendServerRequest:@"GET/CusLVst" withParameter:[@{@"CusCode":self.CustCode,@"typ":@"D"} mutableCopy] withImages:nil DataSF:nil
                                               completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                                                   
                                                   NSMutableArray *VstData=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            [WBService saveData:VstData forKey:[NSString stringWithFormat:@"CLVst_Cus%@D.SANAPP",self.CustCode]];
            [self genPreVst];
                                               }
                               error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                                   NSLog(@"%@",errorMsg);
                               }
         ];
        
        
        
        
        [self assignValues];
        self.selDrView.hidden=YES;
        if((!(PolicyFl==1)) && self.SetupData.DrPolicy==1)
            [self showCutomerPolicy];
        else
            [self hideCutomerPolicy];
        [self.view endEditing:YES];
    }
}
-(void) genPreVst{

    self.lSelVstDt.text = @"";
    self.lSelProdPrmo.text=@"";
    self.lSelProdSamp.text=@"";
    self.lSelInput.text=@"";
    self.lSelFeedbk.text=@"";
    self.lSelRems.text=@"";
    [self updateifEmptLVstStatus];
    NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
    [objDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableArray *VstData=[[WBService getDataByKey:[NSString stringWithFormat:@"CLVst_Cus%@D.SANAPP",self.CustCode]] mutableCopy];
    if(VstData.count>0)
    {
        NSDictionary *vstDtDet=[VstData[0] valueForKey:@"Vst_Date"];
        NSDate *sDate=[objDateFormatter dateFromString:[vstDtDet valueForKey:@"date"]];
        [objDateFormatter setDateFormat:@"dd - MMMM - yyyy HH:mm:ss"];
        self.lSelVstDt.text = [objDateFormatter stringFromDate:sDate];
        self.lSelProdPrmo.text=[VstData[0] valueForKey:@"Prod_Det"];
        self.lSelProdSamp.text=[VstData[0] valueForKey:@"Prod_Samp"];
        self.lSelInput.text=[VstData[0] valueForKey:@"Inputs"];
        self.lSelFeedbk.text=[VstData[0] valueForKey:@"Feedbk"];
        self.lSelRems.text=[VstData[0] valueForKey:@"Remks"];
        [self updateifEmptLVstStatus];
    }
}
-(void)genPreChart{

    // _lineChart.backgroundColor=[UIColor colorWithRed:57.0/255 green:67.0/255 blue:96.0/255 alpha:1.0f];
     
     _lineChart.showSmoothLines = YES;
     _lineChart.showCoordinateAxis = true;
     
     _lineChart.showYGridLines=true;
     _lineChart.yGridLinesColor=[UIColor lightGrayColor];
    /* _lineChart.axisColor=[UIColor whiteColor];
     _lineChart.yLabelColor=[UIColor whiteColor];
     _lineChart.xLabelColor=[UIColor whiteColor];*/
     _lineChart.tintColor=[UIColor colorWithRed:57.0/255 green:67.0/255 blue:96.0/255 alpha:1.0f];
    
    NSMutableArray *receivedDta=[[WBService getDataByKey:[NSString stringWithFormat:@"CusMVst_Cus%@D.SANAPP",self.CustCode]] mutableCopy];
    NSMutableArray *xlbl=[[NSMutableArray alloc]init];
    NSMutableArray *ylbl=[[NSMutableArray alloc]init];
    NSMutableArray *ySmp=[[NSMutableArray alloc]init];
    self.lChartTitle.text=[NSString stringWithFormat:@"%@ - %@",NSLocalizedString(@"Visit Details", @"Visit Details"),[receivedDta[0] objectForKey:@"Yr"]];
    for(int il=0;il<[receivedDta count];il++){
        [xlbl addObject:[NSString stringWithFormat:@"%@",[receivedDta[il] objectForKey:@"Mon"]]]; //,[receivedDta[il] objectForKey:@"Yr"]
        [ylbl addObject:[receivedDta[il] objectForKey:@"Cnt"]];
        [ySmp addObject:[receivedDta[il] objectForKey:@"SamCnt"]];
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
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNDarkBlue;
    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
    data02.inflexionPointColor =PNDarkBlue; //[UIColor colorWithRed:79.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    data02.itemCount = _lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index)
    {
        CGFloat yValue = [ySmp[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };

    _lineChart.chartData = @[data01,data02];
    [_lineChart strokeChart];
}

-(void)updateifEmptLVstStatus{
    if([self.lSelProdPrmo.text isEqual:@""]) self.lSelProdPrmo.text=@"-";
    if([self.lSelProdSamp.text isEqual:@""]) self.lSelProdSamp.text=@"-";
    if([self.lSelInput.text isEqual:@""]) self.lSelInput.text=@"-";
    if([self.lSelFeedbk.text isEqual:@""]) self.lSelFeedbk.text=@"-";
    if([self.lSelRems.text isEqual:@""]) self.lSelRems.text=@"-";
    if([self.lSelVstDt.text isEqual:@""]) self.lSelVstDt.text =@"-";
    
   /* self.lSelHosAddr.textColor = [SANTheme foregroundColor];
    self.lSelHosAddr.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    
    self.lSelHosAddr.backgroundColor = [UIColor clearColor];
    
    self.lSelResAddr.textColor = [SANTheme foregroundColor];
    self.lSelResAddr.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelResAddr.backgroundColor = [UIColor clearColor];
    
    self.lSelProdPrmo.textColor = [SANTheme foregroundColor];
    self.lSelProdPrmo.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelProdPrmo.backgroundColor = [UIColor clearColor];
    
    self.lSelProdSamp.textColor = [SANTheme foregroundColor];
    self.lSelProdSamp.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelProdSamp.backgroundColor = [UIColor clearColor];
    
    self.lSelInput.textColor = [SANTheme foregroundColor];
    self.lSelInput.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelInput.backgroundColor = [UIColor clearColor];
    
    self.lSelFeedbk.textColor = [SANTheme foregroundColor];
    self.lSelFeedbk.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
   
    self.lSelFeedbk.backgroundColor = [UIColor clearColor];
    
    self.lSelRems.textColor = [SANTheme foregroundColor];
    self.lSelRems.font = [UIFont fontWithName:[SANTheme boldFont] size:17.0f];
    self.lSelRems.backgroundColor = [UIColor clearColor];*/
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tbHQ) return self.objHQList.count;
    if(tableView==self.tbVstType) return self.objCallType.count;
    if(tableView==self.selHospFltr) return self.objHospList.count;
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
    if(tableView==self.tbVstType) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [_objCallType[indexPath.row] objectForKey:@"name"];
    }
    if(tableView==self.selHospFltr) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        if(cell.lblDynText==nil){
            cell.lblDynText=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height)];
            cell.lblDynText.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
            [cell addSubview:cell.lblDynText];
        }//[cell.lOptText setFrame:CGRectMake(18, 9, cell.frame.size.width-18, cell.frame.size.height)];
        cell.lblDynText.text = [_objHospList[indexPath.row] objectForKey:@"Name"];
        
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tbHQ) {
        NSDictionary *HQ = self.objHQList[indexPath.row];
        [self.btnSelHQ setTitle:[HQ objectForKey:@"name"] forState:UIControlStateNormal];
        self.meetData.DataSF=[HQ objectForKey:@"id"];
        NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
        self.searchBox.text=@"";

        [BaseViewController loadMasterData:self.meetData.DataSF completion:^(){
            
            CGFloat dis=_UserDet.DistRadius;
            CLLocationCoordinate2D currentLoction=CLLocationCoordinate2DMake([_locationData.latitude doubleValue], [_locationData.longitude doubleValue]);
            
            
            NSPredicate *findDistance = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind){
                
                CLLocationCoordinate2D CusLoc=CLLocationCoordinate2DMake([[obj valueForKey:@"Lat"] doubleValue], [[obj valueForKey:@"Long"] doubleValue]);
                CGFloat cDis=[BaseViewController directMetersFromCoordinate:currentLoction toCoordinate:CusLoc];
                if([[obj valueForKey:@"Long"] doubleValue]>0){
                    NSLog(@"%@",[obj valueForKey:@"ong"]);
                }
                NSLog(@"%f %d",cDis,(cDis>0 && cDis <= dis));
                return cDis>0 && cDis <= dis;
            }];
            
            self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            
            NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
            
            NSMutableArray *MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", self.TdayPl.Pl]] mutableCopy];
            if(_UserDet.GEOTagNeed==1){
                MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
            }
            self.CustomerList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
            MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code!= %@", self.TdayPl.Pl]] mutableCopy];
            if(_UserDet.GEOTagNeed==1){
                MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
            }
            self.CustomerList = [[self.CustomerList arrayByAddingObjectsFromArray:[MkList sortedArrayUsingDescriptors:sortDescriptors]] mutableCopy];
            _HospitalsList=[[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"Hospital_%@.SANAPP",self.meetData.DataSF]] mutableCopy];
            [self.selHospFltr reloadData];
            [self.collectionView reloadData];
        } error:^(NSString* errMsg){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                message:errMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            CGFloat dis=_UserDet.DistRadius;
            CLLocationCoordinate2D currentLoction=CLLocationCoordinate2DMake([_locationData.latitude doubleValue], [_locationData.longitude doubleValue]);
            
            
            NSPredicate *findDistance = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind){
                
                CLLocationCoordinate2D CusLoc=CLLocationCoordinate2DMake([[obj valueForKey:@"Lat"] doubleValue], [[obj valueForKey:@"Long"] doubleValue]);
                CGFloat cDis=[BaseViewController directMetersFromCoordinate:currentLoction toCoordinate:CusLoc];
                if([[obj valueForKey:@"Long"] doubleValue]>0){
                    NSLog(@"%@",[obj valueForKey:@"Long"]);
                }
                NSLog(@"%f %d",cDis,(cDis>0 && cDis <= dis));
                return cDis>0 && cDis <= dis;
            }];
            
            self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            
            NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
            
            NSMutableArray *MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", self.TdayPl.Pl]] mutableCopy];
            
            if(_UserDet.GEOTagNeed==1){
                MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
            }
            self.CustomerList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
            MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code!= %@", self.TdayPl.Pl]] mutableCopy];
            
            if(_UserDet.GEOTagNeed==1){
                MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
            }
            self.CustomerList = [[self.CustomerList arrayByAddingObjectsFromArray:[MkList sortedArrayUsingDescriptors:sortDescriptors]] mutableCopy];
            _HospitalsList=[[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"Hospital_%@.SANAPP",self.meetData.DataSF]] mutableCopy];
            [self.selHospFltr reloadData];
            [self.collectionView reloadData];
        }];
    }
    if(tableView==self.tbVstType) {
        self.lblCallType.text=[NSString stringWithFormat:@"  %@",[self.objCallType[indexPath.row] valueForKey:@"name"]];
        _lblCallType.tag=(indexPath.row+1);
        _meetData.CallType=[self.objCallType[indexPath.row] valueForKey:@"id"];
    }
    if(tableView==self.selHospFltr) {
        NSDictionary *item = _objHospList[indexPath.row];
        [_btnFilter setTitle:NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"]) forState:UIControlStateNormal];
        _selHospitalID=[item objectForKey:@"Code"];
        [self SearchAndFilterCustomer];
        [_vwModeModal removeFromSuperview];
    
    }else{
        [self closeTableViews];
    }
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
}
*/

-(IBAction)searchDoctor:(id)sender
{
    [self SearchAndFilterCustomer];
}
-(void) SearchAndFilterCustomer{
    CGFloat dis=_UserDet.DistRadius;
    CLLocationCoordinate2D currentLoction=CLLocationCoordinate2DMake([_locationData.latitude doubleValue], [_locationData.longitude doubleValue]);
    
    
    NSPredicate *findDistance = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind){
        
        CLLocationCoordinate2D CusLoc=CLLocationCoordinate2DMake([[obj valueForKey:@"Lat"] doubleValue], [[obj valueForKey:@"Long"] doubleValue]);
        CGFloat cDis=[BaseViewController directMetersFromCoordinate:currentLoction toCoordinate:CusLoc];
        if([[obj valueForKey:@"Long"] doubleValue]>0){
            NSLog(@"%@",[obj valueForKey:@"ong"]);
        }
        NSLog(@"%f %d",cDis,(cDis>0 && cDis <= dis));
        return cDis>0 && cDis <= dis;
    }];
    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
    self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    
    if([self.searchBox.text isEqualToString:@""]==NO){
        NSMutableArray *MkList = [[self.ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]] mutableCopy];
        if(_UserDet.GEOTagNeed==1){
            MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
        }else if (_selHospitalID!=nil && ![_selHospitalID isEqualToString:@""]){
                MkList=[[MkList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hospital_code==%@", _selHospitalID]] mutableCopy];
        }
        self.CustomerList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }else{
        NSMutableArray *MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", self.TdayPl.Pl]] mutableCopy];
        if(_UserDet.GEOTagNeed==1){
            MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
        }else if (_selHospitalID!=nil && ![_selHospitalID isEqualToString:@""]){
            MkList=[[MkList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hospital_code==%@", _selHospitalID]] mutableCopy];
        }
        self.CustomerList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        
        MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code!= %@", self.TdayPl.Pl]] mutableCopy];
        if(_UserDet.GEOTagNeed==1){
            MkList=[[MkList filteredArrayUsingPredicate:findDistance] mutableCopy];
        }else if (_selHospitalID!=nil && ![_selHospitalID isEqualToString:@""]){
            MkList=[[MkList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hospital_code==%@", _selHospitalID]] mutableCopy];
        }        self.CustomerList = [[self.CustomerList arrayByAddingObjectsFromArray:[MkList sortedArrayUsingDescriptors:sortDescriptors]] mutableCopy];
    }
    
    
    [self.collectionView reloadData];
}

-(void) assignValues{
    self.meetData.CustCode=self.CustCode;
    self.meetData.CustName=self.CustName;
    self.meetData.CusType=@"1";
    self.meetData.SpecCode=self.SpecCode;
    self.meetData.CateCode=self.CateCode;
    self.meetData.vstTime=[BaseViewController getDateTime];
    self.meetData.ModTime=[BaseViewController getDateTime];
    self.meetData.mappedProds=self.mappedProds;
}
-(IBAction) openSelHQ:(id)sender{
    BOOL upState=!self.tbHQ.hidden;
    [self closeTableViews];
    self.tbHQ.hidden=upState;
}
-(IBAction) openSelCallType:(id)sender{
    BOOL upState=!self.tbVstType.hidden;
    [self closeTableViews];
    self.tbVstType.hidden=upState;
}
-(void) closeTableViews{
    self.tbHQ.hidden=YES;
    self.tbVstType.hidden=YES;
}
-(BOOL) validMvNextSet{
    if (self.lblCallType.tag<=0 && _SetupData.DrCallTypeMandate==1){
        [BaseViewController Toast:NSLocalizedString(@"CallTypeMandate", @"Select The Call Type")];
        return NO;
    }
    
    NSDate *Dt1=[BaseViewController str2date:[NSString stringWithFormat:@"%@ 00:00:00",[BaseViewController date2str:[NSDate date] onlyDate:YES]]];
    NSDate *Dt2=[BaseViewController str2date:[NSString stringWithFormat:@"%@ 00:00:00",[BaseViewController date2str:[self.dtPickNxtVst date] onlyDate:YES]]];
    if ( [Dt1 timeIntervalSinceReferenceDate]>=[Dt2 timeIntervalSinceReferenceDate] && _SetupData.DrNextVisitMandate==1 ){
        [BaseViewController Toast:NSLocalizedString(@"NextVstMandate", @"Select The Next Visit Date")];
        return NO;
    }
    return YES;
}
-(IBAction)goDetailEntry:(id)sender{
    long indx=((UIButton*) sender).tag;
    _MissedEntry.SelectedIndex=indx;
    [self performSegueWithIdentifier:@"skipPresent" sender:self];
}
-(IBAction)ShowActivityEntry:(id)sender{
    long indx=((UIButton*) sender).tag;
    _MissedEntry.SelectedIndex=indx;
    [self performSegueWithIdentifier:@"ShowDrActivity" sender:self];
}
-(IBAction)goSkipPresentaion:(id)sender{
    [self assignValues];
    if([self validMvNextSet])
        [self performSegueWithIdentifier:@"skipPresent" sender:self];
}
-(IBAction)goPreparePresentaion:(id)sender{
    [self assignValues];
    if([self validMvNextSet])
        [self performSegueWithIdentifier:@"goDrPreDemo" sender:self];
}
-(IBAction)CancelCallMeet:(id)sender{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}
-(IBAction)svCustomerPolicy:(id)sender{
    
    self.drPolicy.CustCode=self.CustCode;
    self.drPolicy.CustName=self.CustName;
    self.drPolicy.vstTime=self.ETm;
    self.drPolicy.Email=[NSString stringWithFormat:@"%@",self.txtEmail.text];
    self.drPolicy.Entry_location=[NSString stringWithFormat:@"%@:%@",self.locationData.latitude,self.locationData.longitude];
    self.drPolicy.PolicyAccept=self.swAcptPoci.on;
    self.drPolicy.PlcyCntMngt=self.swAcptMngmnt.on;
    self.drPolicy.PlcyProf=self.swAcptProf.on;
    self.drPolicy.PlcySemInv=self.swAcptInvi.on;
    int AcptFlag=0;
    if (self.drPolicy.PolicyAccept==YES && self.drPolicy.PlcyCntMngt==YES && self.drPolicy.PlcyProf==YES) AcptFlag=1;
    if([self.txtEmail.text isEqualToString:@""] && AcptFlag==1){
        [BaseViewController Toast:NSLocalizedString(@"EmailIDMandate", @"Enter the Email ID...")];
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Submitting Please Wait...", @"Submitting Please Wait...")];
    NSMutableDictionary *imgData=nil;
    NSData *imageData = UIImagePNGRepresentation(self.signatureView.mySignatureImage.image);
    
    if(self.signatureView.mySignatureImage.image!=nil){
        self.drPolicy.signName=[NSString stringWithFormat:@"Plsign%@%@",[self.drPolicy.CustCode stringByReplacingOccurrencesOfString:@"/" withString:@""],[[BaseViewController date2str:[NSDate date] onlyDate:true] stringByReplacingOccurrencesOfString:@"-" withString:@""]] ;
        [self.signatureView saveSignature:self.drPolicy.signName];
        self.drPolicy.signName=[NSString stringWithFormat:@"%@.png",self.drPolicy.signName];
        imgData=[[NSMutableDictionary alloc] init];
        [imgData setObject:imageData forKey:@"Image"];
        [imgData setValue:@"SignImg" forKey:@"Key"];
        [imgData setValue:self.drPolicy.signName forKey:@"Filename"];
        //[WBService uplodeImages:imageData];
        
    }
    
    [WBService SendServerRequest:@"SAVE/Policy" withParameter:[[self.drPolicy toNSDictionary] mutableCopy] withImages:[imgData mutableCopy]
                          DataSF:nil
                      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         if(Success==YES){
             [BaseViewController Toast:NSLocalizedString(@"PolicySuccessMSG", @"Policy Accepted Successfully....")];
             
             NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
             self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
             
             NSMutableArray *MkList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", self.CustCode]] mutableCopy];
             int indx=(int)[_ObjCustomerList indexOfObject:MkList[0]];
             NSMutableDictionary *drItm=[MkList[0] mutableCopy];
             [drItm setValue:[NSString stringWithFormat:@"%d",AcptFlag] forKey:@"PlcyAcptFl"];
             [_ObjCustomerList replaceObjectAtIndex:indx withObject:drItm];
             [WBService saveArrayData:_ObjCustomerList forKey:DataKey];
             [_collectionView reloadData];
         }
         else{
             [BaseViewController Toast:NSLocalizedString(@"PolicyFailedMSG", @"Policy Accepted Failed.")];
         }
       //  [self.SubmittedCallList addObject:[uData mutableCopy]];
       //  [WBService saveArrayData:self.SubmittedCallList forKey:@"SubmittedCalls.SANAPP"];
         [SVProgressHUD dismiss];
     }
       error:^(NSString *errorMsg,NSMutableDictionary *uData){
          // [self.SubmittedCallList addObject:[uData mutableCopy]];
          // [WBService saveArrayData:self.SubmittedCallList forKey:@"SubmittedCalls.SANAPP"];
           
        [BaseViewController Toast:[NSString stringWithFormat:@"%@ \n %@",NSLocalizedString(@"PolicyFailedError", @"Policy Accepted Failed."),errorMsg.description]];
           [SVProgressHUD dismiss];
       }
    ];
    [self hideCutomerPolicy];
}
-(void)showCutomerList:(id)sender{
    self.selDrView.hidden=NO;
}
-(IBAction)ChkDrPolicy:(id)sender{
    if(self.swAcptPoci.on==YES)
        self.swAcptMngmnt.enabled=YES;
    else{
        self.swAcptMngmnt.enabled=NO;
        self.swAcptProf.enabled=NO;
        self.swAcptInvi.enabled=NO;

        self.swAcptMngmnt.on=NO;
        self.swAcptProf.on=NO;
        self.swAcptInvi.on=NO;
    }
}
-(IBAction)ChkPlcyCntMngt:(id)sender{
    if(self.swAcptMngmnt.on==YES)
        self.swAcptProf.enabled=YES;
    else{
        self.swAcptProf.enabled=NO;
        self.swAcptInvi.enabled=NO;
        
        self.swAcptProf.on=NO;
        self.swAcptInvi.on=NO;
    }
}
-(IBAction)ChkPlcyProf:(id)sender{
    if(self.swAcptProf.on==YES)
        self.swAcptInvi.enabled=YES;
    else{
        self.swAcptInvi.enabled=NO;
        
        self.swAcptInvi.on=NO;
    }
}
-(void)showCutomerPolicy{
    
    _lblDate.text= [BaseViewController date2strDisplay:[NSDate date] onlyDate:false];
    self.ETm= [NSString stringWithFormat:@"%@",[BaseViewController date2str:[NSDate date] onlyDate:false]];
    self.swAcptPoci.on=NO;
    self.swAcptMngmnt.on=NO;
    self.swAcptProf.on=NO;
    self.swAcptInvi.on=NO;
    self.swAcptMngmnt.enabled=NO;
    self.swAcptProf.enabled=NO;
    self.swAcptInvi.enabled=NO;
    
    self.selDrPolicy.hidden=NO;
}
-(void)hideCutomerPolicy{
    self.selDrPolicy.hidden=YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ShowDrActivity"]){
        DynamicActivityCtrl *ActivityCTRL=[segue destinationViewController];
        [ActivityCTRL setEMode:@"1,"];
    }
}
@end
