//
//  TourPlanEntry.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 18/11/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "TourPlanEntry.h"
#import "BaseViewController.h"
#import "mSlideCell.h"

@interface TourPlanEntry ()

@property (nonatomic,strong) NSMutableDictionary* TPData;
@property (nonatomic,strong) NSMutableArray* CalnDates;
@property (nonatomic,strong) NSMutableArray* PrevDates;

@property (nonatomic, strong) NSArray* objOptList;

@property (nonatomic, strong) NSMutableArray* SelListData;
@property (nonatomic, strong) NSMutableArray* oSelListData;
@property (nonatomic,strong) NSArray *objWTList;
@property (nonatomic,strong) NSMutableArray *objClusterList;
@property (nonatomic,strong) NSMutableArray *objHospList;
@property (nonatomic,strong) NSArray *objHQList;

@property (nonatomic,strong) NSMutableArray *SelHQList;
@property (nonatomic,strong) NSMutableArray *SelClusterList;
@property (nonatomic,strong) NSMutableArray *SelHospList;
@property (nonatomic, strong) NSMutableArray* SelOptList;

@property (nonatomic, weak) NSString* SelMonth;
@property (nonatomic, weak) NSString* SelYear;

@property (nonatomic, weak) NSString* SelWTCode;
@property (nonatomic, weak) NSString* SelWTName;
@property (nonatomic, weak) NSString* WTFlw;

@property (nonatomic, weak) NSString* SelWTCode2;
@property (nonatomic, weak) NSString* SelWTName2;
@property (nonatomic, weak) NSString* WTFlw2;

@property (nonatomic, retain) IBOutlet UILabel* lblDrCnt;
@property (nonatomic, retain) IBOutlet UILabel* lblJWCnt;

@property (nonatomic, assign) int DrCnt;
@property (nonatomic, assign) int ChmCnt;
@property (nonatomic, assign) int JWCnt;
@property (nonatomic) BOOL isSyncCalled;

@end

@implementation TourPlanEntry
    int tagIndex;
   // @synthesize selJWCds,selJWNms,selDrsCds,selDrsNms,selChmCds,selChmNms;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.UserDet=[UserDetails sharedUserDetails];
    self.TPEntryDet=[TPEntryData sharedDatas];
    self.SetupData=[AppSetupData sharedDatas];
    self.CalenderView.delegate=self;
    self.CalenderView.dataSource=self;
    [self closeDayPlan];
    [self closeSelection];
    
    _TPData=[[NSMutableDictionary alloc] init];
    [_TPData setValue:_UserDet.SF forKey:@"SFCode"];
    
    
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    self.objWTList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy];
    
    self.SelHQList =[[NSMutableArray alloc]init];
    self.SelClusterList =[[NSMutableArray alloc]init];
    self.SelHospList =[[NSMutableArray alloc]init];
    self.objClusterList =[[NSMutableArray alloc]init];
    self.objHospList =[[NSMutableArray alloc]init];
    [self ClearDayPlan];
    self.vwMMultiSel.hidden=YES;
    
    self.tvOptList.dataSource=self;
    self.tvOptList.delegate=self;
    
    self.tvHQList.dataSource=self;
    self.tvHQList.delegate=self;
    
    self.tvMultiSel.dataSource=self;
    self.tvMultiSel.delegate=self;
    
    self.tvClusterList.dataSource=self;
    self.tvClusterList.delegate=self;
    
    self.layout.minimumInteritemSpacing =0;
    self.layout.minimumLineSpacing = 0;
    self.layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    
    self.btJointWk.layer.cornerRadius=18.5f;
    self.btDoctor.layer.cornerRadius=18.5f;
    self.btChm.layer.cornerRadius=18.5f;
    self.selJWCds=@"";self.selJWNms=@"";
    self.selDrsCds=@"";self.selDrsNms=@"";
    self.selChmCds=@"";self.selChmNms=@"";
    
    
    _DrCnt=0;_ChmCnt=0;_JWCnt=0;
    NSDate* TPDate=[self GetNextMonth];
    if(_TPEntryDet.Flag==1){
        TPDate=[BaseViewController str2date:[NSString stringWithFormat:@"%d-%d-01 00:00:00",_TPEntryDet.Year,_TPEntryDet.Month]];
        [_TPData setValue:_TPEntryDet.SF forKey:@"SFCode"];
        [_TPData setValue:_TPEntryDet.SFName forKey:@"SFName"];
        self.btnNxtMnTP.hidden=YES;
        self.btnCurrMnTP.hidden=YES;
    }
    [self prepareCalender:TPDate];
    self.btnBack.layer.cornerRadius=20.0f;
    self.tvHospList=[[UITableView alloc] initWithFrame:CGRectMake(_tvClusterList.frame.origin.x, _tvClusterList.frame.origin.y, _tvClusterList.frame.size.width, _tvClusterList.frame.size.height)];
    _tvClusterList.hidden=NO;
    _btnCluster.hidden=NO;
    
    _lblDoctor.text=_SetupData.CapDr;
    
    UIView* vwbuget1=[[UIView alloc] initWithFrame:CGRectMake(_btJointWk.frame.origin.x+((_btJointWk.frame.size.width/4)*3)-2, _btJointWk.frame.origin.y-3, 18, 18)];
    _lblJWCnt=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 18, 18)];
    _lblJWCnt.font=[UIFont fontWithName:@"Poppins-SemiBold" size:10.0];
    _lblJWCnt.textAlignment=NSTextAlignmentCenter;
    _lblJWCnt.textColor=[UIColor whiteColor];
    _lblJWCnt.text=[NSString stringWithFormat:@"%d", _JWCnt];
    vwbuget1.clipsToBounds=YES;
    vwbuget1.layer.cornerRadius=9.0f;
    [vwbuget1 addSubview:_lblJWCnt];
    vwbuget1.backgroundColor=[UIColor redColor];
    [_btJointWk.superview addSubview:vwbuget1];
    
    
    UIView* vwbuget2=[[UIView alloc] initWithFrame:CGRectMake(_btDoctor.frame.origin.x+((_btDoctor.frame.size.width/4)*3)-2, _btDoctor.frame.origin.y-3, 18, 18)];
    _lblDrCnt=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 18, 18)];
    _lblDrCnt.font=[UIFont fontWithName:@"Poppins-SemiBold" size:10.0];
    _lblDrCnt.textAlignment=NSTextAlignmentCenter;
    _lblDrCnt.textColor=[UIColor whiteColor];
    _lblDrCnt.text=[NSString stringWithFormat:@"%d", _DrCnt];
    vwbuget2.clipsToBounds=YES;
    vwbuget2.layer.cornerRadius=9.0f;
    [vwbuget2 addSubview:_lblDrCnt];
    vwbuget2.backgroundColor=[UIColor redColor];
    [_btDoctor.superview addSubview:vwbuget2];
    
    if (_SetupData.HospBased==1) {
        _tvClusterList.hidden=YES;
        _lblCluster.text=_SetupData.CapHos;
        _btnHosp=[[UIButton alloc] initWithFrame:CGRectMake(_btnCluster.frame.origin.x, _btnCluster.frame.origin.y, _btnCluster.frame.size.width, _btnCluster.frame.size.height)];
        [_btnHosp addTarget:self action:@selector(OpenHosps:) forControlEvents:UIControlEventTouchUpInside];
        [_btnCluster.superview addSubview:_btnHosp];
        _btnCluster.hidden=YES;
        [self.tvHospList registerClass:[TBSelectionBxCell class] forCellReuseIdentifier:@"Cell"];
        
        _tvHospList.rowHeight = 42;
        _tvHospList.scrollEnabled = YES;
        _tvHospList.showsVerticalScrollIndicator = YES;
        _tvHospList.userInteractionEnabled = YES;
        _tvHospList.bounces = YES;

        _tvHospList.delegate = self;
        _tvHospList.dataSource = self;
        [_tvClusterList.superview addSubview:self.tvHospList];
    }
    
}
-(void) setGetClusters:(NSString *) SF andSFName:(NSString *)sSFNm
{
     NSMutableArray *Selitem = [[self.objClusterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", SF]] mutableCopy];
    if([Selitem count]<1){
        NSMutableDictionary *mItem=[[NSMutableDictionary alloc] init];
        NSMutableArray *mArry=[[NSMutableArray alloc] init];
        mArry=[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"TerritoryDetails_%@.SANAPP",SF]] mutableCopy];
        if(mArry!=nil){
            [mItem setValue:SF forKey:@"SFCode"];
            [mItem setValue:sSFNm forKey:@"SFName"];
            [mItem setObject:mArry forKey:@"Clusters"];
        
            [self.objClusterList addObject:mItem];
        }
        else{
            [BaseViewController loadMasterData:SF completion:^(){
                
                NSMutableDictionary *mItem=[[NSMutableDictionary alloc] init];
                NSMutableArray *mArry=[[NSMutableArray alloc] init];
                mArry=[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"TerritoryDetails_%@.SANAPP",SF]] mutableCopy];
                if(mArry!=nil){
                    [mItem setValue:SF forKey:@"SFCode"];
                    [mItem setValue:sSFNm forKey:@"SFName"];
                    [mItem setObject:mArry forKey:@"Clusters"];
                
                    [self.objClusterList addObject:mItem];
                }
            } error:^(NSString* errMsg){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                    message:errMsg
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }];
        }
    }
}
-(void) setGetHosps:(NSString *) SF andSFName:(NSString *)sSFNm
{
     NSMutableArray *Selitem = [[self.objHospList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", SF]] mutableCopy];
    if([Selitem count]<1){
        NSMutableDictionary *mItem=[[NSMutableDictionary alloc] init];
        NSMutableArray *mArry=[[NSMutableArray alloc] init];
        mArry=[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Hospital_%@.SANAPP",SF]] mutableCopy];
        if(mArry!=nil){
            [mItem setValue:SF forKey:@"SFCode"];
            [mItem setValue:sSFNm forKey:@"SFName"];
            [mItem setObject:mArry forKey:@"Hosps"];
        
            [self.objHospList addObject:mItem];
        }
        else{
            [BaseViewController loadMasterData:SF completion:^(){
                
                NSMutableDictionary *mItem=[[NSMutableDictionary alloc] init];
                NSMutableArray *mArry=[[NSMutableArray alloc] init];
                mArry=[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Hospital_%@.SANAPP",SF]] mutableCopy];
                if(mArry!=nil){
                    [mItem setValue:SF forKey:@"SFCode"];
                    [mItem setValue:sSFNm forKey:@"SFName"];
                    [mItem setObject:mArry forKey:@"Hosps"];
                
                    [self.objHospList addObject:mItem];
                }
            } error:^(NSString* errMsg){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                                    message:errMsg
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }];
        }
    }
}

- (int) getMaxDate:(int)month andYear:(int) year{
    int mxDy=31;
    if(month==2){
        mxDy=28;
        if((year % 4)==0) mxDy=29;
    }
    else if(month==4 || month==6 || month==9 || month==11)
        mxDy=30;
    return mxDy;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)CloseTPWindow:(id)sender{
    [self CloseWindow];
}
-(void) CloseWindow{
    [_TPEntryDet clearTPData];
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}
-(IBAction)setCurrentMonth:(id)sender{
    
    NSDate* TPDate=[self GetCurrentMonth];
    [self prepareCalender:TPDate];
    self.btnNxtMnTP.hidden=NO;
    self.btnCurrMnTP.hidden=YES;
}
-(IBAction)setNextMonth:(id)sender{
    
    NSDate* TPDate=[self GetNextMonth];
    [self prepareCalender:TPDate];
    self.btnNxtMnTP.hidden=YES;
    self.btnCurrMnTP.hidden=NO;
}
-(NSDate *) GetCurrentMonth
{
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [myFormatter setDateFormat:@"yyyy"];
    int Yr=(int)[[myFormatter stringFromDate:[NSDate date]] intValue];
    [myFormatter setDateFormat:@"MM"];
    int Mnth=(int)[[myFormatter stringFromDate:[NSDate date]] intValue];
    return [BaseViewController str2date:[NSString stringWithFormat:@"%d-%d-01 00:00:00",Yr,Mnth]];
}
-(NSDate *) GetNextMonth
{
    
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [myFormatter setDateFormat:@"yyyy"];
    int Yr=(int)[[myFormatter stringFromDate:[NSDate date]] intValue];
    [myFormatter setDateFormat:@"MM"];
    int Mnth=(int)[[myFormatter stringFromDate:[NSDate date]] intValue];
    Mnth=Mnth+1;
    if (Mnth>12) {Mnth=1;Yr=Yr+1;}
    return [BaseViewController str2date:[NSString stringWithFormat:@"%d-%d-01 00:00:00",Yr,Mnth]];
}
-(void) prepareCalender:(NSDate *)ClnDate{
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    _CalnDates=[[NSMutableArray alloc]init];
    _PrevDates=[[NSMutableArray alloc]init];
    [myFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    [myFormatter setDateFormat:@"yyyy"];
    int Yr=(int)[[myFormatter stringFromDate:ClnDate] intValue];
    [myFormatter setDateFormat:@"MM"];
    int mon=(int)[[myFormatter stringFromDate:ClnDate] intValue];
    
    self.SelMonth=[NSString stringWithFormat:@"%d",mon];
    self.SelYear=[NSString stringWithFormat:@"%d",Yr];
    [myFormatter setDateFormat:@"MMMM"];
    NSString *MonthNm = [myFormatter stringFromDate:ClnDate];
    self.MonYrCaption.text=[NSString stringWithFormat:@"%@ - %d", MonthNm,Yr];
    
    [_TPData setValue:[NSString stringWithFormat:@"%d",mon] forKey:@"TPMonth"];
    [_TPData setValue:[NSString stringWithFormat:@"%d",Yr] forKey:@"TPYear"];
    [_TPData setValue:@"0" forKey:@"TPFlag"];
    int flg=0;
    int maxDy=[self getMaxDate:mon andYear:Yr];
    [self getTPfromLocal];
    [self renderCalender:mon year:Yr];
}
-(void) renderCalender:(int) mon year:(int) Yr {
    NSDate * ClnDate=[BaseViewController str2date:[NSString stringWithFormat:@"%d-%d-01 00:00:00",Yr,mon]];
    int maxDy=[self getMaxDate:mon andYear:Yr];
    int flg=0;
    if( [self.CalnDates count]<1 || _isSyncCalled || _TPEntryDet.Flag==1 || [[_TPData valueForKey:@"TPFlag"] intValue]==1)
    {
        _isSyncCalled= NO;
            
        _CalnDates=[[NSMutableArray alloc]init];
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:ClnDate];
        
        //[myFormatter setDateFormat:@"c"];
        NSString *dayOfWeek = [NSString stringWithFormat:@"%ld", (long)[comp weekday] ];//[myFormatter stringFromDate:ClnDate];
        for(int il=0;il<[dayOfWeek intValue]-1;il++){
            NSMutableDictionary* itm=[[NSMutableDictionary alloc] init];
            [itm setValue:@"" forKey:@"dayno"];
            [itm setValue:@"0" forKey:@"access"];
            [self.CalnDates addObject:itm];
        }
        NSMutableArray *Datas=[[NSMutableArray alloc] init];
        if(_TPEntryDet.Flag==1){
            Datas=[_TPEntryDet.TPDates[0] objectForKey:@"TPDatas"];
        }else if([[_TPData valueForKey:@"TPFlag"] intValue]==1){
            Datas=_PrevDates;
            flg=1;
        }
        for(int il=1;il<=maxDy;il++){
            
            NSMutableDictionary* itm=[[NSMutableDictionary alloc] init];
            int Flag=0;
            if(_TPEntryDet.Flag==1 || [[_TPData valueForKey:@"TPFlag"] intValue]==1){
                NSString *sDay=[NSString stringWithFormat:@"%i", il];
                NSMutableArray* FData=[[Datas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"dayno==%@",sDay]] mutableCopy];
                if ([FData count]>0) {
                    itm=FData[0];
                    Flag=1;
                }
            }
            if(Flag==0)
            {
                [itm setValue:[NSString stringWithFormat:@"%d",il] forKey:@"dayno"];
                [itm setValue:[NSString stringWithFormat:@"%d-%d-%d 00:00:00",Yr,mon,il] forKey:@"TPDt"];
                [itm setValue:@"1" forKey:@"access"];
            }
            [self.CalnDates addObject:itm];
        }
        _TPData=[[NSMutableDictionary alloc] init];
        [_TPData setValue:_UserDet.SF forKey:@"SFCode"];
        [_TPData setValue:_UserDet.SFName forKey:@"SFName"];
        [_TPData setValue:_UserDet.DivCode forKey:@"DivCode"];
        [_TPData setValue:self.SelMonth forKey:@"TPMonth"];
        [_TPData setValue:self.SelYear forKey:@"TPYear"];
        [_TPData setValue:[NSString stringWithFormat:@"%i", flg] forKey:@"TPFlag"];
        [_TPData setObject:_CalnDates forKey:@"TPDatas"];
    }
    
    self.submitTP.hidden=NO;
    self.saveDayPl.hidden=NO;
    self.ApproveTP.hidden=YES;
    self.RejectTP.hidden=YES;
    
    if([[_TPData valueForKey:@"TPFlag"] isEqualToString:@"1"])
    {
        self.submitTP.hidden=YES;
        self.saveDayPl.hidden=YES;
    }
    if(_TPEntryDet.Flag==1)
    {
        self.submitTP.hidden=YES;
        self.ApproveTP.hidden=NO;
        self.RejectTP.hidden=NO;
    }
    [self.CalenderView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(collectionView.bounds)/7)-0.1f, (CGRectGetHeight(collectionView.bounds)/6));
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.CalnDates.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mSlideCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    NSDictionary *item=self.CalnDates[indexPath.row];
    cell.bkCap.text = [item objectForKey:@"dayno"];
    cell.layer.borderWidth=0.0f;
    cell.ImgView.hidden=YES;
    if (![[item objectForKey:@"dayno"] isEqualToString:@""]){
        cell.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        cell.layer.borderWidth=0.3f;
        cell.bkCap.textColor=[UIColor lightGrayColor];
        if ([[item objectForKey:@"EFlag"] isEqualToString:@"1"]){
            cell.ImgView.hidden=NO;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* Item=_CalnDates[indexPath.row];
    NSString* DyNo=[Item objectForKey:@"dayno"];
    if (![DyNo isEqualToString:@""]){
        [self openDayPlan:DyNo andTPDt:[Item objectForKey:@"TPDt"] andIndex:(int)indexPath.row];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==self.tvOptList && (self.searchBox.tag==3 || self.searchBox.tag==5))
        return self.objOptList.count;
    else if(tableView==self.tvClusterList)
        return self.SelClusterList.count;
    else if(tableView==self.tvHospList)
        return self.SelHospList.count;
    else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tvOptList && self.searchBox.tag==3)
        return [[self.objOptList[section] objectForKey:@"Clusters"] count];
    if(tableView==self.tvOptList && self.searchBox.tag==5)
        return [[self.objOptList[section] objectForKey:@"Hosps"] count];
    if(tableView==self.tvOptList && self.searchBox.tag!=3) return self.objOptList.count;
    if(tableView==self.tvHQList) return self.SelHQList.count;
    if(tableView==self.tvMultiSel) return self.SelListData.count;
    if(tableView==self.tvClusterList && _SelClusterList.count>0){
        return [[self.SelClusterList[section] objectForKey:@"SelClusters"] count];
    }
    if(tableView==self.tvHospList && _SelHospList.count>0){
        return [[self.SelHospList[section] objectForKey:@"SelHosps"] count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=44;
    //if(self==self.tvMultiSel) h=93;
    //if(self.searchBox.tag==3) h=44;
   // if(self==self.tvRCPAList) h=93;
    //if(tableView==self.tvOptList) h=60;
    
    return h;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchBox.tag == 3||self.searchBox.tag == 5||tableView==self.tvClusterList || tableView==self.tvHospList)
        return 40.0f;
    return 0.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView;
    if( ((self.searchBox.tag==3 || self.searchBox.tag==5) && tableView==self.tvOptList) || tableView==self.tvClusterList || tableView==self.tvHospList){
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,40)];
        sectionView.tag=section;
        UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        viewLabel.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0f];
        viewLabel.textColor=[UIColor blackColor];
        viewLabel.font=[UIFont systemFontOfSize:16];
        if(tableView==self.tvClusterList){
            viewLabel.text=[NSString stringWithFormat:@"  %@",[[_SelClusterList objectAtIndex:section] valueForKey:@"SFName"]];
        }
        else if(tableView==self.tvHospList){
            viewLabel.text=[NSString stringWithFormat:@"  %@",[[_SelHospList objectAtIndex:section] valueForKey:@"SFName"]];
        }else{
            viewLabel.text=[NSString stringWithFormat:@"  %@",[[_objOptList objectAtIndex:section] valueForKey:@"SFName"]];
        }
        [sectionView addSubview:viewLabel];
        return sectionView;
    }
    else{
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
       // sectionView.hidden=YES;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    NSInteger tag = 0;
    NSDictionary *optLst=[[NSDictionary alloc] init];
    NSArray*ArryJW=[self.selJWCds componentsSeparatedByString:@","];
    if([ArryJW count]>0) _JWCnt=(int)[ArryJW count]-1;
    NSArray*ArryDr=[self.selDrsCds componentsSeparatedByString:@","];
    if([ArryDr count]>0) _DrCnt=(int)[ArryDr count]-1;
    
    _lblJWCnt.text=[NSString stringWithFormat:@"%d",_JWCnt];
    _lblDrCnt.text=[NSString stringWithFormat:@"%d",_DrCnt];
    //if(tableView==self.tvChemistList) {optLst = self.SelChemistList[indexPath.row];tag=2;}
    
    if(tableView==self.tvOptList) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        if(self.searchBox.tag==3)
            optLst = [self.objOptList[indexPath.section] objectForKey:@"Clusters"][indexPath.row];
        else if(self.searchBox.tag==5)
            optLst = [self.objOptList[indexPath.section] objectForKey:@"Hosps"][indexPath.row];
        else
            optLst = self.objOptList[indexPath.row];
        if(self.searchBox.tag==2)
            cell.lOptText.text = [optLst objectForKey:@"name"];
        else
            cell.lOptText.text = [optLst objectForKey:@"Name"];
        
        cell.lOptVal.text = [optLst objectForKey:@"Town_Name"];
        cell.lOptVal.hidden=YES;
        
        cell.btnCheked.tag = indexPath.row;
        NSMutableArray *Selitem = [[NSMutableArray alloc] init];
        if ([self.SelOptList count]>0){
            if(self.searchBox.tag==2){
                Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [optLst objectForKey:@"id"]]] mutableCopy];
            } else if(self.searchBox.tag==3){
                
                NSMutableArray *selMitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", [optLst valueForKey:@"SF_Code"]]] mutableCopy];
                if([selMitem count]>0){
                    Selitem = [[[selMitem[0] objectForKey:@"SelClusters"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [optLst objectForKey:@"Code"]]] mutableCopy];
                }
            }else{
                
                NSMutableArray *selMitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", [optLst valueForKey:@"SF_Code"]]] mutableCopy];
                if([selMitem count]>0){
                    Selitem = [[[selMitem[0] objectForKey:@"SelHosps"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [optLst objectForKey:@"Code"]]] mutableCopy];
                }
                
            }
        }
        if(Selitem.count>0){
            [cell.btnCheked setImage:[UIImage imageNamed:@"OptChecked"] forState:UIControlStateNormal];
            cell.Checked=YES;
        }else{
            [cell.btnCheked setImage:nil forState:UIControlStateNormal];
            cell.Checked=NO;
        }
        [cell.btnCheked addTarget:self action:@selector(setChecked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(tableView==self.tvClusterList){
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst =
        optLst = [self.SelClusterList[indexPath.section] objectForKey:@"SelClusters"][indexPath.row];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        cell.tag=3;
        cell.btnDel.tag = indexPath.row;
        cell.btnDel.titleLabel.tag=indexPath.section;
        
        [cell.btnDel addTarget:self action:@selector(DeleteRow:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(tableView==self.tvHospList){
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst =
        optLst = [self.SelHospList[indexPath.section] objectForKey:@"SelHosps"][indexPath.row];
        if(cell.lblDynText==nil){
            cell.lblDynText=[[UILabel alloc] initWithFrame:CGRectMake(8, 8, cell.frame.size.width-8, cell.frame.size.height-8)];
            cell.lblDynText.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
            cell.btnDynJoin=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-38, 0, 38, cell.frame.size.height)];
            
            [cell.btnDynJoin setTitle:NSLocalizedString(@"-", @"-") forState:UIControlStateNormal];
            [cell.btnDynJoin.titleLabel setFont:[UIFont fontWithName:@"Poppins-Regular" size:13.0]];
            cell.btnDynJoin.backgroundColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
            [cell addSubview:cell.lblDynText];
            [cell addSubview:cell.btnDynJoin];
        }
        cell.lblDynText.text = [optLst objectForKey:@"Name"];
        cell.tag=5;
        cell.btnDynJoin.tag = indexPath.row;
        cell.btnDynJoin.titleLabel.tag=indexPath.section;
        
        [cell.btnDynJoin addTarget:self action:@selector(DeleteRow:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(tableView==self.tvHQList){
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst = self.SelHQList[indexPath.row];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        cell.tag=2;
        cell.btnDel.tag = indexPath.row;
        cell.btnDel.titleLabel.tag=tag;
        [cell.btnDel addTarget:self action:@selector(DeleteRow:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(tableView==self.tvMultiSel){
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst = self.SelListData[indexPath.row];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        
        //cell.lOptVal.text = [optLst objectForKey:@"Town_Name"];
        cell.lOptImgStatus.image =[UIImage imageNamed:@"unchkOptB"];

        NSUInteger l=0;
        if(tagIndex==1)
            l=[self.selJWCds rangeOfString:[NSString stringWithFormat:@"%@,",[optLst valueForKey:@"Code"]]].length;
        else if(tagIndex==2)
            l=[self.selDrsCds rangeOfString:[NSString stringWithFormat:@"%@,",[optLst valueForKey:@"Code"]]].length;
        else if(tagIndex==3)
            l=[self.selChmCds rangeOfString:[NSString stringWithFormat:@"%@,",[optLst valueForKey:@"Code"]]].length;
        if(l>0) cell.lOptImgStatus.image=[UIImage imageNamed:@"OptChecked"];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TBSelectionBxCell* cell;
    
    NSInteger tag=self.searchBox.tag;
    if(tableView==self.tvMultiSel) {
        NSMutableDictionary *item= [self.SelListData[indexPath.row] mutableCopy];
        cell =[tableView cellForRowAtIndexPath:indexPath];
        if(cell.lOptImgStatus.image==[UIImage imageNamed:@"OptChecked"]){
            cell.lOptImgStatus.image=[UIImage imageNamed:@"unchkOptB"];
            if(tagIndex==1){
                self.selJWCds =  [self.selJWCds stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",[item valueForKey:@"Code"]] withString:@""];
                self.selJWNms =  [self.selJWNms stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",[item valueForKey:@"Name"]] withString:@""];
            }
            else if(tagIndex==2){
                self.selDrsCds =  [self.selDrsCds stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",[item valueForKey:@"Code"]] withString:@""] ;
                self.selDrsNms =  [self.selDrsNms stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",[item valueForKey:@"Name"]] withString:@""];
            }
            else if(tagIndex==3){
                self.selChmCds =  [self.selChmCds stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",[item valueForKey:@"Code"]] withString:@""];
                self.selChmNms =  [self.selChmNms stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",[item valueForKey:@"Name"]] withString:@""];
            }
        }else{
            cell.lOptImgStatus.alpha=0;
            [UIView animateWithDuration:1.2
                                  delay:0.0
                                options: 0
                             animations:^{
                                 cell.lOptImgStatus.image=[UIImage imageNamed:@"OptChecked"];
                                 cell.lOptImgStatus.alpha=1;
                             }
                             completion:^(BOOL finished) {   }];
            
            if(tagIndex==1){
                self.selJWCds =  [self.selJWCds stringByAppendingFormat:@"%@,",[item valueForKey:@"Code"]];
                self.selJWNms =  [self.selJWNms stringByAppendingFormat:@"%@,",[item valueForKey:@"Name"]];
            }
            else if(tagIndex==2){
                self.selDrsCds =  [self.selDrsCds stringByAppendingFormat:@"%@,",[item valueForKey:@"Code"]];
                self.selDrsNms =  [self.selDrsNms stringByAppendingFormat:@"%@,",[item valueForKey:@"Name"]];
            }
            else if(tagIndex==3){
                self.selChmCds =  [self.selChmCds stringByAppendingFormat:@"%@,",[item valueForKey:@"Code"]];
                self.selChmNms =  [self.selChmNms stringByAppendingFormat:@"%@,",[item valueForKey:@"Name"]];
            }
        }
        
        NSArray*ArryJW=[self.selJWCds componentsSeparatedByString:@","];
        if([ArryJW count]>0) _JWCnt=(int)[ArryJW count]-1;
        NSArray*ArryDr=[self.selDrsCds componentsSeparatedByString:@","];
        if([ArryDr count]>0) _DrCnt=(int)[ArryDr count]-1;
        
        _lblJWCnt.text=[NSString stringWithFormat:@"%d",_JWCnt];
        _lblDrCnt.text=[NSString stringWithFormat:@"%d",_DrCnt];
    }
    if(tableView==self.tvOptList) {
        NSMutableDictionary *item ;
        cell =[tableView cellForRowAtIndexPath:indexPath];
        if(tag==3){
            NSMutableDictionary *itemMain = self.objOptList[indexPath.section];
            item = [[[itemMain objectForKey:@"Clusters"] objectAtIndex:indexPath.row] mutableCopy];
            
            NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", [item valueForKey:@"SF_Code"]]] mutableCopy];
            if([Selitem count]<1){
                NSMutableDictionary *mItem=[[NSMutableDictionary alloc] init];
                [mItem setValue:[itemMain valueForKey:@"SFCode"] forKey:@"SFCode"];
                [mItem setValue:[itemMain valueForKey:@"SFName"] forKey:@"SFName"];
                NSMutableArray *sClus=[[NSMutableArray alloc] initWithObjects:item, nil];
                [mItem setObject:sClus forKey:@"SelClusters"];
                
                [cell.btnCheked setImage:[UIImage imageNamed:@"OptChecked"] forState:UIControlStateNormal];
                cell.Checked=YES;
                
                [self.SelOptList addObject:mItem];
            }else{
                NSMutableArray *itms = [Selitem[0] objectForKey:@"SelClusters"];
                NSMutableArray *SItem = [[itms filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [item objectForKey:@"Code"]]] mutableCopy];
                if ([SItem count]<1) {
                    
                    [cell.btnCheked setImage:[UIImage imageNamed:@"OptChecked"] forState:UIControlStateNormal];
                    cell.Checked=YES;
                    [itms addObject:item];
                }else{
                    [cell.btnCheked setImage:nil forState:UIControlStateNormal];
                    cell.Checked=NO;
                    [itms removeObject:item];
                }
                
                [Selitem[0] setObject:itms forKey:@"SelClusters"];
            }
            //[self.SelOptList addObject:selItems];
        }
        else if(tag==5){
            NSMutableDictionary *itemMain = self.objOptList[indexPath.section];
            item = [[[itemMain objectForKey:@"Hosps"] objectAtIndex:indexPath.row] mutableCopy];
            
            NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", [item valueForKey:@"SF_Code"]]] mutableCopy];
            if([Selitem count]<1){
                NSMutableDictionary *mItem=[[NSMutableDictionary alloc] init];
                [mItem setValue:[itemMain valueForKey:@"SFCode"] forKey:@"SFCode"];
                [mItem setValue:[itemMain valueForKey:@"SFName"] forKey:@"SFName"];
                NSMutableArray *sClus=[[NSMutableArray alloc] initWithObjects:item, nil];
                [mItem setObject:sClus forKey:@"SelHosps"];
                
                [cell.btnCheked setImage:[UIImage imageNamed:@"OptChecked"] forState:UIControlStateNormal];
                cell.Checked=YES;
                
                [self.SelOptList addObject:mItem];
            }else{
                NSMutableArray *itms = [Selitem[0] objectForKey:@"SelHosps"];
                NSMutableArray *SItem = [[itms filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [item objectForKey:@"Code"]]] mutableCopy];
                if ([SItem count]<1) {
                    
                    [cell.btnCheked setImage:[UIImage imageNamed:@"OptChecked"] forState:UIControlStateNormal];
                    cell.Checked=YES;
                    [itms addObject:item];
                }else{
                    [cell.btnCheked setImage:nil forState:UIControlStateNormal];
                    cell.Checked=NO;
                    [itms removeObject:item];
                }
                
                [Selitem[0] setObject:itms forKey:@"SelHosps"];
            }
            //[self.SelOptList addObject:selItems];
        }
        else if(tag==2){
            item = [[self.objOptList objectAtIndex:indexPath.row] mutableCopy];
            NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [item objectForKey:@"id"]]] mutableCopy];
            if (Selitem.count<=0){
                NSMutableDictionary *selItem =[[NSMutableDictionary alloc] init];
                [selItem setValue:[item objectForKey:@"id"] forKey:@"Code"];
                [selItem setValue:[item objectForKey:@"name"] forKey:@"Name"];
                if (_SetupData.HospBased==1) {
                    [self setGetHosps:[item objectForKey:@"id"] andSFName:[item objectForKey:@"name"]];
                }else{
                    [self setGetClusters:[item objectForKey:@"id"] andSFName:[item objectForKey:@"name"]];
                }
                [self.SelOptList addObject:selItem];
                
                [cell.btnCheked setImage:[UIImage imageNamed:@"OptChecked"] forState:UIControlStateNormal];
                cell.Checked=YES;
            }
            else{
                [self.SelOptList removeObject:Selitem[0]];
                [cell.btnCheked setImage:nil forState:UIControlStateNormal];
                cell.Checked=NO;
                
            }
        }
        else if(tag==1){
            item = [[self.objOptList objectAtIndex:indexPath.row] mutableCopy];
            self.SelWTCode=[item objectForKey:@"Code"];
            self.SelWTName=[item objectForKey:@"Name"];
            self.WTFlw=[item objectForKey:@"FWFlg"];
            [self.btnWTName setTitle:[NSString stringWithFormat:@"   %@",self.SelWTName] forState:UIControlStateNormal];
            [self closeSelection];
        }
        else if(tag==4){
            item = [[self.objOptList objectAtIndex:indexPath.row] mutableCopy];
            self.SelWTCode2=[item objectForKey:@"Code"];
            self.SelWTName2=[item objectForKey:@"Name"];
            self.WTFlw2=[item objectForKey:@"FWFlg"];
            [self.btnWTName2 setTitle:[NSString stringWithFormat:@"   %@",self.SelWTName2] forState:UIControlStateNormal];
            [self closeSelection];
        }
    }
}

-(IBAction) openMMSelect:(id)sender
{
    UIButton *btn=(UIButton *) sender;
    tagIndex=(int)btn.tag;
    if(btn.tag==1){
        self.lblTit.text=NSLocalizedString(@"Jointwork Selection", @"Jointwork Selection");
        self.SelListData= [[NSMutableArray alloc] init];
       
        if([self.SelHQList count]>0){
            for(int il=0;il<[self.SelHQList count];il++){
                NSMutableArray *itms =[[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"JointWork_%@.SANAPP",[self.SelHQList[il] valueForKey:@"Code"]]] mutableCopy];
                for(int ij=0;ij<[itms count];ij++){
                    NSMutableArray *Selitem = [[self.SelListData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [itms[ij] valueForKey:@"Code"] ]] mutableCopy];
                    if([Selitem count]<1){
                        [self.SelListData addObject:itms[ij]];
                    }
                }
            }
        }
    }
    else if(btn.tag==2){
        self.lblTit.text=[NSString stringWithFormat:@"%@ %@",_SetupData.CapDr,NSLocalizedString(@"Selection", @"Selection")];
        self.SelListData= [[NSMutableArray alloc] init];
        if([self.SelHQList count]>0){
            for(int il=0;il<[self.SelHQList count];il++){
                NSMutableArray *Drlist =[[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",[self.SelHQList[il] valueForKey:@"Code"]]] mutableCopy];
                NSMutableArray *itms1 =[[NSMutableArray alloc] init];
                if(_SetupData.HospBased==1){
                    itms1 =[[self.SelHospList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", [self.SelHQList[il] valueForKey:@"Code"]]] mutableCopy];
                }else{
                    itms1 =[[self.SelClusterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", [self.SelHQList[il] valueForKey:@"Code"]]] mutableCopy];
                }
                if([itms1 count]>0){
                    NSMutableArray *slHops =[[NSMutableArray alloc] init];
                    if(_SetupData.HospBased==1)
                        slHops =[[itms1[0] objectForKey:@"SelHosps"] mutableCopy];
                    else
                        slHops =[[itms1[0] objectForKey:@"SelClusters"] mutableCopy];
                    for(int ij=0;ij<[slHops count];ij++){
                        NSMutableArray *itms =[[NSMutableArray alloc] init];
                        if(_SetupData.HospBased==1)
                            itms =[[Drlist filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hospital_code contains[c] %@", [slHops[ij] valueForKey:@"Code"]]] mutableCopy];
                        else
                            itms =[[Drlist filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", [slHops[ij] valueForKey:@"Code"]]] mutableCopy];
                        
                        for(int ij=0;ij<[itms count];ij++){
                            [self.SelListData addObject:[itms[ij] mutableCopy]];
                        }
                    }
                 }
                
            }
        }
    }
    else if(btn.tag==3){
        self.lblTit.text=[NSString stringWithFormat:@"%@ %@",_SetupData.CapChm,NSLocalizedString(@"Selection", @"Selection")];
        self.SelListData= [[NSMutableArray alloc] init];
        if([self.SelHQList count]>0){
            for(int il=0;il<[self.SelHQList count];il++){
                NSMutableArray *itms =[[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",[self.SelHQList[il] valueForKey:@"Code"]]] mutableCopy];
                for(int ij=0;ij<[itms count];ij++){
                    [self.SelListData addObject:[itms[ij] mutableCopy]];
                }
            }
        }
    }
    _oSelListData=[_SelListData mutableCopy];
    [self.tvMultiSel reloadData];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.vwMMultiSel.hidden=NO;
                         self.vwMMultiSel.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
    
}
-(IBAction)closeMMSelect:(id)sender
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.vwMMultiSel.hidden=YES;
                         self.vwMMultiSel.alpha=0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
    
}

-(void) openDayPlan:(NSString *) sTpDT andTPDt:(NSString *) sTpDt andIndex:(int) cellIndex
{
    NSDate *dtTPDt=[BaseViewController str2date:sTpDt];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    
    [myFormatter setDateFormat:@"MMM-yyyy"];
    self.lblDyMonYr.text=[myFormatter stringFromDate:dtTPDt];
    self.lblDyDay.text=sTpDT;
    [myFormatter setDateFormat:@"EEEE"];
    self.lblDyWeekNm.text=[myFormatter stringFromDate:dtTPDt];
    self.saveDayPl.tag=cellIndex;
    NSMutableDictionary *DayPlanDet=[self.CalnDates[cellIndex] objectForKey:@"DayPlan"];
    
    self.selJWCds=@"";self.selJWNms=@"";
    self.selDrsCds=@"";self.selDrsNms=@"";
    self.selChmCds=@"";self.selChmNms=@"";
    self.SelClusterList=[[NSMutableArray alloc] init];
    self.SelHospList=[[NSMutableArray alloc] init];
    self.SelHQList=[[NSMutableArray alloc] init];
    if(DayPlanDet!=nil){
        self.SelWTCode= [DayPlanDet valueForKey:@"WTCode"];
        self.SelWTName= [DayPlanDet valueForKey:@"WTName"];
        self.WTFlw=[DayPlanDet valueForKey:@"FWFlg"];
        self.selJWCds=[DayPlanDet valueForKey:@"JWCodes"];
        self.selJWNms=[DayPlanDet valueForKey:@"JWNames"];
        
        self.selDrsCds=[DayPlanDet valueForKey:@"DrsCodes"];
        self.selDrsNms=[DayPlanDet valueForKey:@"DrsNames"];
        
        self.selChmCds=[DayPlanDet valueForKey:@"ChmCodes"];
        self.selChmNms=[DayPlanDet valueForKey:@"ChmNames"];
        
        [self.btnWTName setTitle:[NSString stringWithFormat:@"   %@",self.SelWTName] forState:UIControlStateNormal];
        
        self.SelWTCode2= [DayPlanDet valueForKey:@"WTCode2"];
        self.SelWTName2= [DayPlanDet valueForKey:@"WTName2"];
        self.WTFlw2=[DayPlanDet valueForKey:@"FWFlg2"];
        [self.btnWTName2 setTitle:[NSString stringWithFormat:@"   %@",self.SelWTName2] forState:UIControlStateNormal];
        
        NSString *sClusCodes=[[NSString alloc] init];
        NSString *sClusNames=[[NSString alloc] init];
        if(_SetupData.HospBased==1){
            sClusCodes=[DayPlanDet valueForKey:@"HospCode"];
            sClusNames=[DayPlanDet valueForKey:@"HospName"];
        }else{
            sClusCodes=[DayPlanDet valueForKey:@"ClusterCode"];
            sClusNames=[DayPlanDet valueForKey:@"ClusterName"];
        }
        NSString *sClusSFs=[DayPlanDet valueForKey:@"ClusterSFs"];
        NSString *sClusSFNms=[DayPlanDet valueForKey:@"ClusterSFNms"];
        
        NSArray *PlCds=[sClusCodes componentsSeparatedByString:@","];
        NSArray *PlNms=[sClusNames componentsSeparatedByString:@","];
        NSArray *PlSFs=[sClusSFs componentsSeparatedByString:@","];
        NSArray *PlSFNms=[sClusSFNms componentsSeparatedByString:@","];
        for(int il=0;il<[PlCds count];il++){
            if (![PlCds[il] isEqualToString:@""]){
                NSMutableDictionary *item=[[NSMutableDictionary alloc] init];
                [item setValue:PlCds[il] forKey:@"Code"];
                [item setValue:PlNms[il] forKey:@"Name"];
                NSMutableArray *Selitem =[[NSMutableArray alloc] init];
                if(_SetupData.HospBased==1){
                    Selitem = [[self.SelHospList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", PlSFs[il]]] mutableCopy];
                }else{
                    Selitem = [[self.SelClusterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode contains[c] %@", PlSFs[il]]] mutableCopy];
                }
                if([Selitem count]<1){
                    NSMutableDictionary *mItem=[[NSMutableDictionary alloc] init];
                    [mItem setValue:PlSFs[il] forKey:@"SFCode"];
                    [mItem setValue:PlSFNms[il] forKey:@"SFName"];
                    NSMutableArray *sClus=[[NSMutableArray alloc] initWithObjects:item, nil];
                    
                    if(_SetupData.HospBased==1){
                        [mItem setObject:sClus forKey:@"SelHosps"];
                        [self.SelHospList addObject:mItem];
                    }else{
                        [mItem setObject:sClus forKey:@"SelClusters"];
                        [self.SelClusterList addObject:mItem];
                    }
                }else{
                    NSMutableArray *itms =[[NSMutableArray alloc] init];
                    if(_SetupData.HospBased==1)
                        itms = [Selitem[0] objectForKey:@"SelHosps"];
                    else
                        itms = [Selitem[0] objectForKey:@"SelClusters"];
                    NSMutableArray *SItem = [[itms filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [item objectForKey:@"Code"]]] mutableCopy];
                    if ([SItem count]<1) {
                        [itms addObject:item];
                    }else{
                        [itms removeObject:item];
                    }
                    
                    if(_SetupData.HospBased==1)
                        [Selitem[0] setObject:itms forKey:@"SelHosps"];
                    else
                        [Selitem[0] setObject:itms forKey:@"SelClusters"];
                    
                   // [self.CalnDates removeObjectAtIndex:self.saveDayPl.tag];
                    //[self.CalnDates insertObject:Item atIndex:self.saveDayPl.tag];
                }
            }
        }
        
        NSString *sHQCodes=[DayPlanDet valueForKey:@"HQCodes"];
        NSString *sHQNames=[DayPlanDet valueForKey:@"HQNames"];
        NSArray *HCds=[sHQCodes componentsSeparatedByString:@","];
        NSArray *HNms=[sHQNames componentsSeparatedByString:@","];
        for(int il=0;il<[HCds count];il++){
            if(![HCds[il] isEqualToString:@""]){
                NSMutableDictionary *Item=[[NSMutableDictionary alloc] init];
                [Item setValue:HCds[il] forKey:@"Code"];
                [Item setValue:HNms[il] forKey:@"Name"];
                if(_SetupData.HospBased==1){
                    [self setGetHosps:HCds[il] andSFName:HNms[il]];
                }else{
                    [self setGetClusters:HCds[il] andSFName:HNms[il]];
                }
                [self.SelHQList addObject:Item];
            }
        }
        self.txtRemarks.text=[DayPlanDet valueForKey:@"DayRemarks"];
    }
    else{
        
        [self ClearDayPlan];
    }
    [self.tvHQList reloadData];
    [self.tvClusterList reloadData];
    [self.tvHospList reloadData];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.vwPlPerDayModal.hidden=NO;
                         self.vwPlPerDayModal.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
    
}

-(void) closeDayPlan
{
    self.lblDyMonYr.text=@"";
    self.lblDyDay.text=@"";
    self.lblDyWeekNm.text=@"";
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.vwPlPerDayModal.hidden=YES;
                         self.vwPlPerDayModal.alpha=0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
    
}
-(IBAction)SaveDayTP:(id)sender{
    if([self.SelWTCode isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Select the worktype", @"Select the worktype")];
        return;
    }
    if([self.WTFlw isEqualToString:@"F"]){
        if([self.SelHQList count]<1){
            [BaseViewController Toast:NSLocalizedString(@"Select the Headquaters", @"Select the Headquaters")];
            return;
        }
        if(self.SetupData.HospBased==1){
            if([self.SelHospList count]<1){
                [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Select the", @"Select the"),_SetupData.CapHos]];
                return;
            }
        }else{
            if([self.SelClusterList count]<1){
                [BaseViewController Toast:NSLocalizedString(@"Select the Clusters", @"Select the Clusters")];
                return;
            }
        }
    }
    NSMutableDictionary* DayPlanDet=[[NSMutableDictionary alloc] init];
    [DayPlanDet setValue:self.SelWTCode forKey:@"WTCode"];
    [DayPlanDet setValue:self.SelWTName forKey:@"WTName"];
    [DayPlanDet setValue:self.WTFlw forKey:@"FWFlg"];
    [DayPlanDet setValue:self.SelWTCode2 forKey:@"WTCode2"];
    [DayPlanDet setValue:self.SelWTName2 forKey:@"WTName2"];
    
    [DayPlanDet setValue:self.selJWCds forKey:@"JWCodes"];
    [DayPlanDet setValue:self.selJWNms forKey:@"JWNames"];
    
    [DayPlanDet setValue:self.selDrsCds forKey:@"DrsCodes"];
    [DayPlanDet setValue:self.selDrsNms forKey:@"DrsNames"];
    
    [DayPlanDet setValue:self.selChmCds forKey:@"ChmCodes"];
    [DayPlanDet setValue:self.selChmNms forKey:@"ChmNames"];
    
    [DayPlanDet setValue:self.WTFlw2 forKey:@"FWFlg2"];
    NSString *sClusCodes=@"";
    NSString *sClusNames=@"";
    NSString *sClusSFs=@"";
    NSString *sClusSFNms=@"";
    
    self.selJWCds=@"";self.selJWNms=@"";
    self.selDrsCds=@"";self.selDrsNms=@"";
    self.selChmCds=@"";self.selChmNms=@"";
    if(_SetupData.HospBased==1){
        for(int il=0;il<[self.SelHospList count];il++){
            NSMutableArray *itemsClus=[self.SelHospList[il] objectForKey:@"SelHosps"];
            for(int ij=0;ij<[itemsClus count];ij++){
                NSMutableDictionary *itemPL=[itemsClus[ij] mutableCopy];
                
                sClusCodes=[NSString stringWithFormat:@"%@%@,",sClusCodes,[itemPL valueForKey:@"Code"]];
                sClusNames=[NSString stringWithFormat:@"%@%@,",sClusNames,[itemPL valueForKey:@"Name"]];;
                sClusSFs=[NSString stringWithFormat:@"%@%@,",sClusSFs,[self.SelHospList[il] valueForKey:@"SFCode"]];
                sClusSFNms=[NSString stringWithFormat:@"%@%@,",sClusSFNms,[self.SelHospList[il] valueForKey:@"SFName"]];
            }
        }
        
        [DayPlanDet setValue:sClusCodes forKey:@"HospCode"];
        [DayPlanDet setValue:sClusNames forKey:@"HospName"];
    }
    else{
    for(int il=0;il<[self.SelClusterList count];il++){
        NSMutableArray *itemsClus=[self.SelClusterList[il] objectForKey:@"SelClusters"];
        for(int ij=0;ij<[itemsClus count];ij++){
            NSMutableDictionary *itemPL=[itemsClus[ij] mutableCopy];
            
            sClusCodes=[NSString stringWithFormat:@"%@%@,",sClusCodes,[itemPL valueForKey:@"Code"]];
            sClusNames=[NSString stringWithFormat:@"%@%@,",sClusNames,[itemPL valueForKey:@"Name"]];;
            sClusSFs=[NSString stringWithFormat:@"%@%@,",sClusSFs,[itemPL valueForKey:@"SF_Code"]];
            sClusSFNms=[NSString stringWithFormat:@"%@%@,",sClusSFNms,[self.SelClusterList[il] valueForKey:@"SFName"]];
        }
    }
    
    [DayPlanDet setValue:sClusCodes forKey:@"ClusterCode"];
    [DayPlanDet setValue:sClusNames forKey:@"ClusterName"];
    }
    [DayPlanDet setValue:sClusSFs forKey:@"ClusterSFs"];
    [DayPlanDet setValue:sClusSFNms forKey:@"ClusterSFNms"];
    NSString *sHQCodes=@"";
    NSString *sHQNames=@"";
    for(int il=0;il<[self.SelHQList count];il++){
        sHQCodes=[NSString stringWithFormat:@"%@%@,",sHQCodes,[self.SelHQList[il] valueForKey:@"Code"]];
        sHQNames=[NSString stringWithFormat:@"%@%@,",sHQNames,[self.SelHQList[il] valueForKey:@"Name"]];
    }
    [DayPlanDet setValue:sHQCodes forKey:@"HQCodes"];
    [DayPlanDet setValue:sHQNames forKey:@"HQNames"];
    [DayPlanDet setValue:self.txtRemarks.text forKey:@"DayRemarks"];
    NSMutableDictionary* Item=[self.CalnDates[self.saveDayPl.tag] mutableCopy];
    [Item setObject:DayPlanDet forKey:@"DayPlan"];
    [Item setValue:@"1" forKey:@"EFlag"];
    
    [self.CalnDates removeObjectAtIndex:self.saveDayPl.tag];
    [self.CalnDates insertObject:Item atIndex:self.saveDayPl.tag];
    
    [self ClearDayPlan];
    if(_TPEntryDet.Flag!=1){
        [self SaveTPtoLocal];
    }
    [self.tvHQList reloadData];
    [self.tvClusterList reloadData];
    [self.tvHospList reloadData];
    [self.CalenderView reloadData];
    [self closeDayPlan];
    
}
-(void) SaveTPtoLocal{
    [_TPData setObject:self.CalnDates forKey:@"TPDatas"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.TPData forKey:[NSString stringWithFormat:@"TPDetails_%@_%@_%@.SANAPP",_UserDet.SF,self.SelMonth,self.SelYear]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void) getTPfromLocal{
    
   NSMutableDictionary *mData=[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"TPDetails_%@_%@_%@.SANAPP",_UserDet.SF,self.SelMonth,self.SelYear]] mutableCopy];
    if (mData!=nil){
        _TPData=[mData mutableCopy];
        self.CalnDates=[[mData objectForKey:@"TPDatas"] mutableCopy];
        _PrevDates=[[mData objectForKey:@"TPDatas"] mutableCopy];
    }else{
        NSMutableDictionary* TPParam=[[NSMutableDictionary alloc] init];
        [TPParam setValue:self.SelMonth forKey:@"Month"];
        [TPParam setValue:self.SelYear forKey:@"Year"];
        [WBService SendServerRequest:@"GET/TPDetails" withParameter:TPParam withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
            NSMutableArray *mDatas=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            if([mDatas count]>0)
            {
                _PrevDates=[[NSMutableArray alloc]init];
                self.CalnDates=[[mDatas[0] objectForKey:@"TPDatas"] mutableCopy];
                _PrevDates=[[mDatas[0] objectForKey:@"TPDatas"] mutableCopy];
                [_TPData setValue:[mDatas[0] objectForKey:@"TPFlag"] forKey:@"TPFlag"];
                _isSyncCalled = YES;

                [self SaveTPtoLocal];
                [self renderCalender:[self.SelMonth intValue] year:[self.SelYear intValue]];
                
            }
        } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
         
        }];
         
         }
}
- (IBAction)syncCalander:(id)sender {
   
    [BaseViewController Toast:NSLocalizedString(@"Syncing Calendar",@"Syncing Calendar")];

    NSMutableDictionary* TPParam=[[NSMutableDictionary alloc] init];
    [TPParam setValue:self.SelMonth forKey:@"Month"];
    [TPParam setValue:self.SelYear forKey:@"Year"];
    [WBService SendServerRequest:@"GET/TPDetails" withParameter:TPParam withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        NSMutableArray *mDatas=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        if([mDatas count]>0)
        {
            _isSyncCalled = YES;
            _PrevDates=[[NSMutableArray alloc]init];
            self.CalnDates=[[mDatas[0] objectForKey:@"TPDatas"] mutableCopy];
            _PrevDates=[[mDatas[0] objectForKey:@"TPDatas"] mutableCopy];
            _TPEntryDet.Flag=3;
            [_TPData setValue:[mDatas[0] objectForKey:@"TPFlag"]  forKey:@"TPFlag"];
            [self SaveTPtoLocal];
            [self renderCalender:[self.SelMonth intValue] year:[self.SelYear intValue]];
            
        }
    } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
     
    }];
     
}

-(IBAction) sendToApproval:(id)sender
{
    BOOL EFlag=YES;
    
    for(int il=0;il<[self.CalnDates count];il++){
        NSString* DyNo=[self.CalnDates[il] objectForKey:@"dayno"];
        if (![DyNo isEqualToString:@""]){
            if (![[self.CalnDates[il] objectForKey:@"EFlag"] isEqualToString:@"1"]){
                EFlag=NO;
            }
        }
    }
    if(EFlag==NO){
        [BaseViewController Toast:NSLocalizedString(@"Few Days TP Entry Missing", @"Few Days TP Entry Missing")];
        return;
    }
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Submitting Please Wait...", @"Submitting Please Wait...")];
    
    [WBService SendServerRequest:@"SAVE/TourPlan" withParameter:[_TPData mutableCopy] withImages:nil
                          DataSF:nil
                      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
             {
                 [BaseViewController Toast:NSLocalizedString(@"Tourplan Submitted For Approval Successfully....", @"Tourplan Submitted For Approval Successfully....")];
                 
                 [_TPData setValue:@"1" forKey:@"TPFlag"];
                 self.submitTP.hidden=YES;
                 self.saveDayPl.hidden=YES;
                 [self SaveTPtoLocal];
                 [SVProgressHUD dismiss];
                 //[self ClearandCloseView];
             }
       error:^(NSString *errorMsg,NSMutableDictionary *uData){
           [BaseViewController Toast:[NSString stringWithFormat:@"%@.\n %@",NSLocalizedString(@"Tourplan Submission Failed", @"Tourplan Submission Failed"),errorMsg.description]];
           [SVProgressHUD dismiss];
           //[self ClearandCloseView];
       }];
    
}
-(IBAction) svApproveTourPlan:(id)sender
{
    BOOL EFlag=YES;
    
    for(int il=0;il<[self.CalnDates count];il++){
        NSString* DyNo=[self.CalnDates[il] objectForKey:@"dayno"];
        if (![DyNo isEqualToString:@""]){
            if (![[self.CalnDates[il] objectForKey:@"EFlag"] isEqualToString:@"1"]){
                EFlag=NO;
            }
        }
    }
    if(EFlag==NO){
        [BaseViewController Toast:NSLocalizedString(@"Few Days TP Entry Missing", @"Few Days TP Entry Missing")];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SAN Digital Detailing", @"SAN Digital Detailing")
                                                        message:NSLocalizedString(@"Do you want to Approve the Tour Plan ?", @"Do you want to Approve the Tour Plan ?")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Yes", @"Yes")
                                              otherButtonTitles:NSLocalizedString(@"No", @"No"), nil];
    alertView.tag=1;
    [alertView show];
}
-(IBAction) svRejectTourPlan:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SAN Digital Detailing", @"SAN Digital Detailing")
                                                        message:NSLocalizedString(@"Do you want to Reject the Tour Plan ?", @"Do you want to Reject the Tour Plan ?")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Yes", @"Yes")
                                              otherButtonTitles:NSLocalizedString(@"No", @"No"), nil];
    alertView.tag=2;
    [alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && alertView.tag==2)
    {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Rejecting Please Wait...", @"Rejecting Please Wait...")];
    
    [WBService SendServerRequest:@"SAVE/TPReject" withParameter:[_TPData mutableCopy] withImages:nil
                          DataSF:_TPEntryDet.SF
                      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
        {
             [BaseViewController Toast:NSLocalizedString(@"Tourplan Rejected Successfully....", @"Tourplan Rejected Successfully....")];
             [SVProgressHUD dismiss];
             [self.TPEntryDet clearTPData];
             NSArray *viewControllers = [self.navigationController viewControllers];
             [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
        }
        error:^(NSString *errorMsg,NSMutableDictionary *uData){
           [BaseViewController Toast:[NSString stringWithFormat:@"%@.\n %@",NSLocalizedString(@"Tourplan Rejection Failed", @"Tourplan Rejection Failed"),errorMsg.description]];
           [SVProgressHUD dismiss];
        }];
    }
    else if(buttonIndex == 0 && alertView.tag==1){
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Approving Please Wait...", @"Approving Please Wait...")];
        
        [WBService SendServerRequest:@"SAVE/TPApproval" withParameter:[_TPData mutableCopy] withImages:nil
                              DataSF:_TPEntryDet.SF
                          completion:^(BOOL success, id respData,NSMutableDictionary *uData)
         {
             [BaseViewController Toast:NSLocalizedString(@"Tourplan Approved Successfully....", @"Tourplan Approved Successfully....")];
             [SVProgressHUD dismiss];
             [self.TPEntryDet clearTPData];
             NSArray *viewControllers = [self.navigationController viewControllers];
             [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
         }
                               error:^(NSString *errorMsg,NSMutableDictionary *uData){
                                   [BaseViewController Toast:[NSString stringWithFormat:@"%@\n %@",NSLocalizedString(@"Tourplan Submission Failed", @"Tourplan Submission Failed"),errorMsg.description]];
                                   [SVProgressHUD dismiss];
                                   //[self ClearandCloseView];
                               }];
        
    }
}
-(IBAction) btnCloseDayPlan:(id)sender
{
    [self closeDayPlan];
}
-(void) ClearDayPlan{
    self.SelHQList=[[NSMutableArray alloc] init];
    self.SelClusterList=[[NSMutableArray alloc] init];
    self.SelHospList=[[NSMutableArray alloc] init];
    self.SelWTCode=@"";
    self.SelWTName=@"";
    self.WTFlw=@"";
    self.SelWTCode2=@"";
    self.SelWTName2=@"";
    self.WTFlw2=@"";
    self.txtRemarks.text=@"";
    [self.btnWTName setTitle:@"" forState:UIControlStateNormal];
    [self.btnWTName2 setTitle:@"" forState:UIControlStateNormal];
    if([_UserDet.Desig isEqualToString:@"MR"])
    {
        NSMutableDictionary *selItem =[[NSMutableDictionary alloc] init];
        [selItem setValue:_UserDet.SF forKey:@"Code"];
        [selItem setValue:_UserDet.SFName forKey:@"Name"];
        [self.SelHQList addObject:selItem];
        if(_SetupData.HospBased==1)
        [self setGetHosps:_UserDet.SF andSFName:_UserDet.HQName];
        else
        [self setGetClusters:_UserDet.SF andSFName:_UserDet.HQName];
    }
}
-(IBAction)setChecked:(id)sender{
    UIButton *btn=(UIButton *)sender;
    TBSelectionBxCell* cell;
    cell =[self.tvOptList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0] ];
    if(cell.Checked==YES){
        [cell.btnCheked setImage:nil forState:UIControlStateNormal];
        cell.Checked=NO;
    }else{
        [cell.btnCheked setImage:[UIImage imageNamed:@"OptChecked"] forState:UIControlStateNormal];
        cell.Checked=YES;
        // [self.SelProductList set]
    }
}
-(void)ShowSelection:(NSString*)sTitle{
    
    [self.lblTitle setText:sTitle];
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
    
    self.searchBox.tag=0;
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
-(IBAction)searchOpts:(id)sender
{
    NSInteger tag=self.searchBox.tag;
    if(tag==1 || tag==4 ) self.objOptList=[self.objWTList mutableCopy];
    if(tag==2) self.objOptList=[self.objHQList mutableCopy];
    if(tag==3) self.objOptList=[self.objClusterList mutableCopy];
    if(tag==5) self.objOptList=[self.objHospList mutableCopy];
    
    if([self.searchBox.text isEqualToString:@""]==NO){
        self.objOptList = [self.objOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]];
    }
    [self.tvOptList reloadData];
}
-(IBAction) setSelOptsValues:(id)sender{
    if(self.searchBox.tag==2)
    {
        self.SelHQList=[self.SelOptList mutableCopy];
        [self.tvHQList reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==3)
     {
         self.SelClusterList=[self.SelOptList mutableCopy];
         [_tvClusterList reloadData];
         [self closeSelection];
     }
    if(self.searchBox.tag==5)
     {
         self.SelHospList=[self.SelOptList mutableCopy];
         [_tvHospList reloadData];
         [self closeSelection];
     }
}

-(IBAction)DeleteRow:(id)sender{
    UIButton *btn=(UIButton *)sender;
    UITableViewCell *Icell=(UITableViewCell *)((UIButton *)sender).superview;
    if(![Icell isKindOfClass: [UITableViewCell class]]) Icell=(UITableViewCell *)((UIButton *)sender).superview.superview;
    if(![Icell isKindOfClass: [UITableViewCell class]]) Icell=(UITableViewCell *)((UIButton *)sender).superview.superview.superview;
    
    NSMutableArray* tmpArr=[[NSMutableArray alloc]init];
    UITableView *TBView;
    
    NSInteger tbvId=Icell.tag;
    if(tbvId==2){
        tmpArr=[self.SelHQList mutableCopy];
        TBView=self.tvHQList;
    }
    if(tbvId==3){
        tmpArr=[self.SelClusterList mutableCopy];
        TBView=self.tvClusterList;
        [[tmpArr[btn.titleLabel.tag] objectForKey:@"SelClusters"] removeObjectAtIndex:btn.tag];
        if ([[tmpArr[btn.titleLabel.tag] objectForKey:@"SelClusters"] count]<1){
            [tmpArr removeObjectAtIndex:btn.titleLabel.tag];
        }
    }
    else if(tbvId==5){
        tmpArr=[self.SelHospList mutableCopy];
        TBView=self.tvHospList;
        [[tmpArr[btn.titleLabel.tag] objectForKey:@"SelHosps"] removeObjectAtIndex:btn.tag];
        if ([[tmpArr[btn.titleLabel.tag] objectForKey:@"SelHosps"] count]<1){
            [tmpArr removeObjectAtIndex:btn.titleLabel.tag];
        }
    }
    else{
        NSMutableArray* Items =[[NSMutableArray alloc]init];
        
        Items = [[self.SelClusterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SFCode=%@", [tmpArr[btn.tag] valueForKey:@"Code"]]] mutableCopy];
        if([Items count]>0){
            [self.SelClusterList removeObject:Items[0]];
            [self.tvClusterList reloadData];
        }
        [tmpArr removeObjectAtIndex:btn.tag];
    }
    if(tbvId==2) self.SelHQList=tmpArr;
    if(tbvId==3) self.SelClusterList=tmpArr;
    if(tbvId==5) self.SelHospList=tmpArr;
    [TBView reloadData];
}
-(IBAction)CloseSelWin:(id)sender{
    [self closeSelection];
}
-(IBAction)OpenWorkType:(id)sender{
    UIButton* btnWT =(UIButton *) sender;
    self.objOptList=[self.objWTList mutableCopy];
    //  self.SelOptList=[self.SelProductList mutableCopy];
    self.searchBox.tag=btnWT.tag;
    [self.tvOptList reloadData];
    [self ShowSelection:@"Work Type Selection"];
}
-(IBAction)OpenHeadquaters:(id)sender{
    self.objOptList=[self.objHQList mutableCopy];
    self.SelOptList=[self.SelHQList mutableCopy];
    self.searchBox.tag=2;
    [self.tvOptList reloadData];
    [self ShowSelection:@"Headquater Selection"];
}
-(IBAction)OpenClusters:(id)sender{
    self.objOptList=[self.objClusterList mutableCopy];
    self.SelOptList=[self.SelClusterList mutableCopy];
    self.searchBox.tag=3;
    [self.tvOptList reloadData];
    [self ShowSelection:@"Cluster Selection"];
}
-(IBAction)OpenHosps:(id)sender{
    self.objOptList=[self.objHospList mutableCopy];
    self.SelOptList=[self.SelHospList mutableCopy];
    self.searchBox.tag=5;
    [self.tvOptList reloadData];
    [self ShowSelection:[NSString stringWithFormat:@"%@ Selection",self.SetupData.CapHos]];
}

-(IBAction)searchMOpts:(id)sender
{
    self.SelListData=[self.oSelListData mutableCopy];
    if([self.msearchBox.text isEqualToString:@""]==NO){
        self.SelListData = [[self.SelListData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.msearchBox.text]] mutableCopy];
    }
    [self.tvMultiSel reloadData];
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
