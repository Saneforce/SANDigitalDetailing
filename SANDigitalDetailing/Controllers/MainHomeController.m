//
//  MainHomeController.m
//  SANAPP
//
//  Created by SANeForce.com on 04/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "MainHomeController.h"
#import "ToDyTPvwCtrl.h"
#import "FileDownloadInfo.h"
#import "downloaderView.h"
#import "mMenuCell.h"
#import "TBSelectionBxCell.h"
#import "CVColor.h"
#import "PresentationSelCtrl.h"
#import "FeedbackCtrl.h"
#import "EditDateSelectionCtrl.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+RoudedCorners.h"
#import "xAxisLabelFormatter.h"
#import "NotificationListViewController.h"
//#import "NotifyListPopViewController.h"
#import "AuthenticationManager.h"
#import "Reachability.h"
#import "MeetingCalenderVC.h"
#import "userLabel.h"

@interface MainHomeController() <ChartViewDelegate>{
    Reachability *internetReachability;
}

@property (nonatomic, strong) NSMutableArray* menulist;
@property (nonatomic, strong) NSArray* SlideList;
@property (nonatomic, strong) NSMutableArray* UniqueSlides;
@property (nonatomic, strong) NSMutableArray* SlidesFileLists;
@property (nonatomic, strong) NSMutableArray* SubmittedCallsList;
@property (nonatomic, strong) NSMutableArray* PendingCallsList;
@property (nonatomic, strong) NSMutableArray* TodayCallsList;
@property (nonatomic, strong) NSMutableArray* CallsSectionsList;
@property (nonatomic, strong) NSMutableArray* SectionsHeders;
@property (nonatomic, strong) NSMutableArray* MeetDatas;
@property (nonatomic, assign) BOOL viewAppeared;
@property (nonatomic, assign) BOOL dataLoaded;
@property (nonatomic, assign) BOOL slideLoaded;
@property (nonatomic, assign) BOOL lsyncTp;
@property (nonatomic, assign) BOOL lsyncCall;
@property (nonatomic, assign) BOOL slidesDownloaded;
@property (nonatomic, assign) int numberLoaded;
@property (nonatomic, assign) int nSlideLoaded;
@property (nonatomic, assign) int nSFMasLoaded;
@property (nonatomic, strong) NSMutableArray* Sidemenulist;
@property (nonatomic, assign) NSString* DataSF;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong) BaseViewController *BaseCtrlr;
@property (nonatomic,strong) NSTimer *tmr;
@property (nonatomic,strong) NSIndexPath *cIndexPath;
@property (nonatomic, strong) IBOutlet BarChartView *SFEKPIChart;
@property (nonatomic, strong) IBOutlet BarChartView *TRKPIChart;
@property (nonatomic, strong) IBOutlet BarChartView *SmpProdChart;

@property (nonatomic, retain) UITableView* tbvwMeetings;
@end
@implementation MainHomeController
@synthesize UserDet;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    _BaseCtrlr=[[BaseViewController alloc] init];
    self.UserDet=[UserDetails sharedUserDetails];
    self.meetData=[CallMeetData sharedDatas];
    self.MissedEntry=[MissedEntryData sharedDatas];
    self.locationData=[LocationDetail sharedLocationData];
    self.config=[Config sharedConfig];
    self.SetupData=[AppSetupData sharedDatas];

    self.lsyncTp=NO;
    self.lsyncCall=NO;
    self.SlidesFileLists = [[NSMutableArray alloc] init];
    self.meetData.MissedEntry=NO;
    [self setSetupValues];
    [self loadSetups];
    MasterList=@[
        [[List alloc] initWithName:@"WorktypeDetails.SANAPP" andApiPath:@"GET/WorkType" Parameters:nil],
        [[List alloc] initWithName:@"HQDetails.SANAPP" andApiPath:@"GET/HQ" Parameters:nil],
        [[List alloc] initWithName:@"CompetitorDetails.SANAPP" andApiPath:@"GET/CompDet" Parameters:nil],
        [[List alloc] initWithName:@"Inputs.SANAPP" andApiPath:@"GET/Inputs" Parameters:nil],
        [[List alloc] initWithName:@"Products.SANAPP" andApiPath:@"GET/Products" Parameters:nil],
        [[List alloc] initWithName:@"ProdSlides.SANAPP" andApiPath:@"GET/ProdSlides" Parameters:nil],
        [[List alloc] initWithName:@"Brands.SANAPP" andLabel:@"Brands" andApiPath:@"GET/Brands" Parameters:nil],
        [[List alloc] initWithName:@"Departs.SANAPP" andApiPath:@"GET/Departs" Parameters:nil],
        [[List alloc] initWithName:@"Specialitys.SANAPP" andApiPath:@"GET/Speciality" Parameters:nil],
        [[List alloc] initWithName:@"Category.SANAPP" andApiPath:@"GET/Categorys" Parameters:nil],
        [[List alloc] initWithName:@"Qualifics.SANAPP" andApiPath:@"GET/Quali" Parameters:nil],
        [[List alloc] initWithName:@"DocClass.SANAPP" andApiPath:@"GET/Class" Parameters:nil],
        [[List alloc] initWithName:@"DocTypes.SANAPP" andApiPath:@"GET/Types" Parameters:nil],
        [[List alloc] initWithName:@"VisitTypes.SANAPP" andApiPath:@"GET/VisitTypes" Parameters:nil],
        [[List alloc] initWithName:@"RatingInfo.SANAPP" andApiPath:@"GET/RatingInf" Parameters:nil],
        [[List alloc] initWithName:@"Ratingfeedbk.SANAPP" andApiPath:@"GET/RatingFeedbk" Parameters:nil]
    ];
    if([self.UserDet.Desig isEqualToString:@"MR"]){
        SFsMaster=@[
            [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",self.UserDet.SF] andApiPath:@"GET/Territory" Parameters:nil],
            [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.UserDet.SF] andApiPath:@"GET/Doctors" Parameters:nil],
            [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.UserDet.SF] andApiPath:@"GET/Chemist" Parameters:nil],
            [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"StockistDetails_%@.SANAPP",self.UserDet.SF] andApiPath:@"GET/Stockist" Parameters:nil],
            [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",self.UserDet.SF] andApiPath:@"GET/UnlistedDR" Parameters:nil],
            [[List alloc] initWithName:[[NSString alloc]  initWithFormat:@"Hospital_%@.SANAPP",self.UserDet.SF] andApiPath:@"GET/Hospitals" Parameters:nil],
            [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"JointWork_%@.SANAPP",self.UserDet.SF] andApiPath:@"GET/JntWrk" Parameters:[@{@"Data_SF":self.UserDet.SF} mutableCopy]]
        ];
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //self.clViewCalls.delegate = self;
    //self.clViewCalls.dataSource = self;
    
    self.clViewCalls.delegate = self;
    self.clViewCalls.dataSource = self;
    
    self.tvSideMenu.delegate = self;
    self.tvSideMenu.dataSource = self;
    
    self.vwCallsList.layer.cornerRadius=5.0f;
    self.clViewCalls.layer.cornerRadius=5.0f;
    
    _vwNotifyImg.layer.cornerRadius=5.0f;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
   
    internetReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [internetReachability startNotifier];
/*
    self.layout.minimumInteritemSpacing = 1;
    self.layout.minimumLineSpacing = 1;
    self.layout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
*/
    self.vwMenu.layer.cornerRadius=5.0f;
    self.vwMenu.layer.borderWidth = 1.0f;
    self.vwMenu.layer.borderColor= [UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f].CGColor;
    
    
    self.vwTPView.layer.cornerRadius=15.0f;
    self.vwTPView.layer.borderWidth = 1.0f;
    self.vwTPView.layer.borderColor= [UIColor grayColor].CGColor;
    
    self.tvRemk.layer.borderWidth = 1.0f;
    self.tvRemk.layer.borderColor= [UIColor grayColor].CGColor;
    
    self.lblDispSF.text=self.UserDet.SFName;
    
    
    self.nSlideLoaded=0;
    
    self.profileImg.image=[self.BaseCtrlr getProfileImage:@"/images/profile.jpg"];
    self.profileImg.clipsToBounds = YES;
    self.profileImg.layer.cornerRadius= 8.5f;
    self.profileImg.layer.borderWidth = 1.0f;
    self.profileImg.layer.borderColor= [UIColor whiteColor].CGColor;
    [self loadMenus];
    self.viewAppeared=NO;
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showWTType) userInfo:nil repeats:YES] ;
    [timer fire];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.dataLoaded=[[[WBService getDataByKey:@"dataLoaded"] objectForKey:@"flag"] boolValue];
    self.slidesDownloaded=[[[WBService getDataByKey:@"SlideDownloaded"] objectForKey:@"flag"] boolValue];
    if(!self.dataLoaded) [self loadDatas];
    float scrWidthBy3=([UIScreen mainScreen].bounds.size.width-80)/3;
    _vwTodyCallWidth.constant=scrWidthBy3;
    
    _tmr=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(ShowNotification) userInfo:nil repeats:NO] ;
    [_tmr fire];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(AutoSyncCall) userInfo:nil repeats:NO] ;
    [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startLatLngUpd) userInfo:nil repeats:NO] ;
    //[ltmr fire];
    
    //Dashboard Chart Second Page ( For Allergen )
    self.scrlDashboard.delegate=self;
    
    NSLog(@"Height before : %f , %f",self.vwCallsList.bounds.size.height,self.vwCallsList.frame.size.height);
    [self.vwCallsList layoutIfNeeded];
    [self.vwDashboard layoutIfNeeded];
    [self.scrlDashboard layoutIfNeeded];
    NSLog(@"Height after : %f , %f",self.vwCallsList.bounds.size.height,self.vwCallsList.frame.size.height);
    float scrlViewWidth=(scrWidthBy3*2)+22;
    float scrlViewHeight=self.vwCallsList.bounds.size.height-((self.vwCallsList.bounds.size.height>508)?20:0);
    float scrlHlfHeight=scrlViewHeight/2;
    NSLog(@"Height after : %f ",scrlHlfHeight);//(194+self.scrlDashboard.bounds.origin.y+(_lblhBarChart.frame.size.height*2)));
    [self.PageIndicator addTarget:self action:@selector(changeDashbordPage:) forControlEvents:UIControlEventTouchUpInside];
    _vwChartCallAvg.frame=CGRectMake(0, 0, scrlViewWidth, scrlHlfHeight-10);
    _barChart.frame=CGRectMake(0, _lblhBarChart.frame.size.height, scrlViewWidth,scrlHlfHeight-(_lblhBarChart.frame.size.height));
    
    _vwPieChart.frame=CGRectMake(0, scrlHlfHeight+10, scrlViewWidth, scrlHlfHeight-10);
    
    [self.lblhBarChart setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:5.0];
    [self.barChart setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5.0];
    
    self.vwPieChart.layer.cornerRadius=5.0f;
    [self.lblhPieChart setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:5.0];
    
    UIView* chartCntr=[[UIView alloc] initWithFrame:CGRectMake(scrlViewWidth+10, 0, scrlViewWidth, scrlViewHeight)];
    float LblHeight=_lblhBarChart.frame.size.height;
    _SFEKPIChart=[[BarChartView alloc] initWithFrame:CGRectMake(0, LblHeight, scrlViewWidth, (scrlViewHeight/2)-LblHeight)];
    _TRKPIChart=[[BarChartView alloc] initWithFrame:CGRectMake(0,  (scrlViewHeight/2)+LblHeight+10, scrlViewWidth, (scrlViewHeight/2)-(LblHeight+10))];
    [chartCntr addSubview: _SFEKPIChart];
    [chartCntr addSubview: _TRKPIChart];
    
    [self setBarChartProperty:_SFEKPIChart andTitle:NSLocalizedString(@"SFE KPI", @"SFE KPI")];
    [self setBarChartProperty:_TRKPIChart andTitle:NSLocalizedString(@"Training KPI", @"Training KPI")];
    
    [self.vwDashboard addSubview: chartCntr];
    float x=scrlViewWidth+10;
    x=x+scrlViewWidth+10;
    
    UIView* SampleChart=[[UIView alloc] initWithFrame:CGRectMake((scrlViewWidth*2)+20, 0, scrlViewWidth, scrlViewHeight)];
    //float LblHeight=_lblhBarChart.frame.size.height;
    _SmpProdChart=[[BarChartView alloc] initWithFrame:CGRectMake(0, LblHeight, scrlViewWidth, (scrlViewHeight)-LblHeight)];
    //_TRKPIChart=[[BarChartView alloc] initWithFrame:CGRectMake(0,  (scrlViewHeight/2)+LblHeight+10, scrlViewWidth, (scrlViewHeight/2)-(LblHeight+10))];
    [SampleChart addSubview: _SmpProdChart];
    //[chartCntr addSubview: _TRKPIChart];
    
    [self setBarChartProperty:_SmpProdChart andTitle:NSLocalizedString(@"Samples Detail", @"Samples Detail")];
    //[self setBarChartProperty:_TRKPIChart andTitle:@"Training KPI"];
    [self.lblCLuster setText:NSLocalizedString(@"Cluster", @"Cluster")];
    
    [self.vwDashboard addSubview: SampleChart];
    x=x+scrlViewWidth+10;
    [self loadTodayMeets];
    //}
    [self getMeetingDatas];
    self.nsScrollWidth.constant=x;
    self.vwDashboard.frame=CGRectMake(0, 0, x, self.scrlDashboard.bounds.size.height);
    self.scrlDashboard.contentSize=CGSizeMake(x, self.scrlDashboard.bounds.size.height);
    self.scrlDashboard.contentOffset=CGPointMake(0, 0);
    self.PageIndicator.numberOfPages=3;
    [self.vwDashboard layoutIfNeeded];
    [self.scrlDashboard layoutIfNeeded];
}
-(void) loadTodayMeets{
    if(_SetupData.MeetEventNeed==1 && _tbvwMeetings==nil){
        [_clViewCalls setFrame:CGRectMake(0, 0, _vwCallsList.frame.size.width, _vwCallsList.frame.size.height/2-4)];
        userLabel* lblMeet=[[userLabel alloc] initWithFrame:CGRectMake(0, (_vwCallsList.frame.size.height/2)+14, _vwCallsList.frame.size.width, 42)];
        lblMeet.text=NSLocalizedString(@"Today Meetings", @"Today Meetings");
        lblMeet.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
        lblMeet.backgroundColor=[UIColor colorWithRed:92.0f/255 green:92.0f/255 blue:92.0f/255 alpha:1.0f];
        lblMeet.textColor=[UIColor whiteColor];
        [_vwCallsList addSubview:lblMeet];
        _tbvwMeetings=[[UITableView alloc] initWithFrame:CGRectMake(0, (_vwCallsList.frame.size.height/2)+56, _vwCallsList.frame.size.width, (_vwCallsList.frame.size.height/2)-56)];
        [_tbvwMeetings registerClass:[TBSelectionBxCell class] forCellReuseIdentifier:@"Cell"];
        
        _tbvwMeetings.rowHeight = 42;
        _tbvwMeetings.scrollEnabled = YES;
        _tbvwMeetings.showsVerticalScrollIndicator = YES;
        _tbvwMeetings.userInteractionEnabled = YES;
        _tbvwMeetings.allowsSelection=NO;
        _tbvwMeetings.bounces = YES;
        _tbvwMeetings.delegate=self;
        _tbvwMeetings.dataSource=self;
        
        [_vwCallsList addSubview:_tbvwMeetings];
    }
    
}
-(void) loadMenus{
    
    self.Sidemenulist = [[NSMutableArray alloc] init];//WithObjects:
    [self AddMenuItem:@"Change Cluster" id:@7 image:@"sMnuChClstr"];
    [self AddMenuItem:@"Calls" id:@1 image:@"sMnuCalls"];
    [self AddMenuItem:@"Outbox" id:@17 image:@"sMnuLogout"];

    if(_SetupData.MissedEntry==1){
        [self AddMenuItem:@"Missed Date Entry" id:@12 image:@"sMnuDrProf"];
    }
    [self AddMenuItem:@"Create Presentation" id:@2 image:@"sMnuPrsnt"];
    [self AddMenuItem:@"Tour Plan" id:@4 image:@"sMnuTP"];
    [self AddMenuItem:@"Leave Application" id:@5 image:@"sMnuLeave"];
    if(![self.UserDet.Desig isEqualToString:@"MR"]){
        [self AddMenuItem:@"Approvals" id:@9 image:@"Approval"];
    }
    [self AddMenuItem:NSLocalizedString(@"Profiling", @"Profiling")  id:@10 image:@"sMnuDrProf"];
    //[self AddMenuItem:@"Chemist Profiling" id:@11 image:@"sMnuDrProf"];
    
    if(self.SetupData.GeoNeed==0 || self.SetupData.GeoFencing==1){
        [self AddMenuItem:@"GEO Tag / Explore " id:@13 image:@"GEOtag"];}
    if(_SetupData.NActivityNeed==1){[self AddMenuItem:@"Activity" id:@14 image:@"sMnuDrProf"];}
    if(_SetupData.MeetEventNeed==1){[self AddMenuItem:@"Events" id:@15 image:@"sMnuDrProf"];}
    [self AddMenuItem:@"Reports" id:@3 image:@"sMnuRpts"];
    //[self AddMenuItem:@"Settings" id:@8 image:@"sMnuRpts"];
    
    self.menulist=[[NSMutableArray alloc] init];
    [self AddMMenuItem:@"Calls" id:@1 image:@"mnuCalls" bgColor:@"#ffffff"];
    if(_SetupData.MeetEventNeed==1){
        [self AddMMenuItem:@"Events" id:@15 image:@"sMnuDrProf" bgColor:@"#ffffff"];
        [self loadTodayMeets];
    }
    if(_SetupData.ActivityNeed==1){
        [self AddMMenuItem:@"Activity" id:@12 image:@"mnuPrsnt" bgColor:@"#ffffff"];
    }
    if(_SetupData.NActivityNeed==1){
        [self AddMMenuItem:@"Activity" id:@14 image:@"mnuPrsnt" bgColor:@"#ffffff"];
    }
    if(_SetupData.showSurvey==0){
        [self AddMenuItem:@"Survey" id:@16 image:@"mnuPrsnt"];
    }
    [self AddMMenuItem:@"Create Presentation" id:@2 image:@"mnuPrsnt" bgColor:@"#ffffff"];
    [self AddMMenuItem:@"Reports" id:@3 image:@"mnuReport" bgColor:@"#ffffff"];
    [self AddMenuItem:@"Logout" id:@6 image:@"sMnuLogout"];

     
    [self.collectionView reloadData];
    [self.tvSideMenu reloadData];
}
-(void) AddMenuItem:(NSString *) label id:(NSNumber*) mId image:(NSString*) sImage {
    [self.Sidemenulist addObject:@{@"name" : label,@"image":sImage,@"tag":mId}];
}
-(void) AddMMenuItem:(NSString *) label id:(NSNumber*) mId image:(NSString*) sImage bgColor:(NSString*) sBgColor{
    [self.menulist addObject:@{@"name" : label,@"image":sImage,@"tag":mId,@"bgColor":sBgColor}];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int pageIndex = round(scrollView.contentOffset.x/scrollView.frame.size.width);
    _PageIndicator.currentPage = pageIndex;
}
-(void) changeDashbordPage:(id)sender{
    int page = (int) self.PageIndicator.currentPage;
    CGRect frame = self.scrlDashboard.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrlDashboard scrollRectToVisible:frame animated:YES];
}
-(void) setBarChartProperty:(BarChartView*) chartView andTitle:(NSString*) sChartTitle
{
    
    UILabel *lblTitle=[[UIBorderLabel alloc] initWithFrame:CGRectMake(0, chartView.frame.origin.y-47, chartView.frame.size.width, 47)];
    lblTitle.text=sChartTitle;
    lblTitle.backgroundColor=[UIColor colorWithRed:102.0f/255 green:102.0f/255 blue:102.0f/255 alpha:1.0f];
    [lblTitle setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:5.0];
    //[lblTitle setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5.0];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.font = [UIFont fontWithName:@"Poppins-SemiBold" size:14.f];
    [chartView.superview addSubview:lblTitle];
    
    chartView.delegate = self;
    chartView.chartDescription.enabled = NO;
    chartView.pinchZoomEnabled = NO;
    chartView.drawBarShadowEnabled = NO;
    chartView.drawGridBackgroundEnabled = NO;
    chartView.backgroundColor=[UIColor whiteColor];
    chartView.layer.cornerRadius=10.0f;
    
    ChartLegend *legend = chartView.legend;
    legend.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    legend.verticalAlignment = ChartLegendVerticalAlignmentTop;
    legend.orientation = ChartLegendOrientationHorizontal;
    legend.drawInside = YES;
    legend.font = [UIFont fontWithName:@"Poppins-SemiBold" size:8.f];
    legend.yOffset = 10.0;
    legend.xOffset = 10.0;
    legend.yEntrySpace = 0.0;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelFont = [UIFont fontWithName:@"Poppins-Regular" size:9.f];
    xAxis.granularity = 1.f;
    xAxis.centerAxisLabelsEnabled = YES;
    xAxis.labelPosition=XAxisLabelPositionBottom;
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.maximumFractionDigits = 1;
    
    ChartYAxis *leftAxis = chartView.leftAxis;
    leftAxis.labelFont = [UIFont fontWithName:@"Poppins-Regular" size:9.f];
    //leftAxis.valueFormatter = [[LargeValueFormatter alloc] init];
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.spaceTop = 0.35;
    leftAxis.axisMinimum = 0;
    chartView.rightAxis.enabled = NO;
}
- (void)handleSingleTap
{
    [self closeMenuView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"CheckTPMsg",@"Checking Master TP")];
    if(self.dataLoaded==NO){
        [SVProgressHUD showWithStatus:NSLocalizedString(@"CheckTPMsg",@"Master List Downloading...")];
        self.viewAppeared=YES;
    }
    
    self.meetData.MissedEntry=NO;
    if(self.dataLoaded) [self openTourPlan];
    
    self.profileImg.image=[self.BaseCtrlr getProfileImage:@"/images/profile.jpg"];
    [self reloadSubCalls];
    [WBService SendServerRequest:@"GET/CallAvgYrCht" withParameter:nil withImages:nil DataSF:nil
                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                          NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                          NSMutableArray *xlbl=[[NSMutableArray alloc]init];
                          NSMutableArray *ylbl=[[NSMutableArray alloc]init];
                          for(int il=0;il<[receivedDta count];il++){
                              [xlbl addObject:[NSString stringWithFormat:@"%@-%@",[receivedDta[il] objectForKey:@"Mon"],[receivedDta[il] objectForKey:@"Yr"]]];
                              [ylbl addObject:[receivedDta[il] objectForKey:@"cnt"]];
                          }
                          /*self.barChart.legendFontColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];*/
                          self.barChart.strokeColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
                          
                         // [self.barChart setStrokeColor:PNRed];
                          [self drawBarChart:self.barChart xLabels:xlbl yLabels:ylbl];
                      }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }
     ];
    
    _circleChart=[_circleChart initWithFrame:CGRectMake(0, 80.0, self.circleChart.frame.size.width, 100.0) total:[NSNumber numberWithInt:10] current:[NSNumber numberWithInt:0] clockwise:YES shadow:YES shadowColor:[UIColor grayColor] displayCountingLabel:YES overrideLineWidth:@15.0f];
    self.circleChart.backgroundColor = [UIColor clearColor];
    self.circleChart.displayCountingLabel=YES;
    [self.circleChart setStrokeColor:PNGreen];
    [self.circleChart strokeChart];
    [WBService SendServerRequest:@"GET/Callvst" withParameter:nil withImages:nil DataSF:nil
        completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            NSNumber *CntValue = [NSNumber numberWithFloat:[[receivedDta[0] objectForKey:@"cnt"]  floatValue]];
            NSNumber *TotValue = [NSNumber numberWithFloat:[[receivedDta[0] objectForKey:@"totcnt"]  floatValue]];
            if ([TotValue isEqual:@0.00f]) TotValue=@100.00f;
            [self.circleChart updateChartByCurrent:CntValue byTotal:TotValue];
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
            NSLog(@"%@",errorMsg);
        }
     ];
    
    NSArray *items = @[];
    
    [self.pieChart updateChartData:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    [self.pieChart strokeChart];
    [WBService SendServerRequest:@"GET/CatVst" withParameter:nil withImages:nil DataSF:nil
        completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            NSMutableArray *items = [[NSMutableArray alloc]init];
            NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            for(int ij=0;ij<[receivedDta count];ij++){
                [items addObject:[PNPieChartDataItem dataItemWithValue:[[receivedDta[ij] objectForKey:@"cnt"] floatValue] color:[self randomColor] description:[receivedDta[ij] objectForKey:@"Category"]]];
            }
            [self.pieChart updateChartData:items];
            [self.pieChart strokeChart];
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
            NSLog(@"%@",errorMsg);
        }
     ];

    [self UpdateChartData];
    
    [self UpdateSamplesChartData];
    
    [self.vwTPView setFrame:CGRectMake(-self.vwTPView.frame.size.width, self.vwTPView.frame.origin.y, self.vwTPView.frame.size.width, self.vwTPView.frame.size.height)];
}
-(void) moveMeetingVC{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Meeting" bundle:nil];
    MeetingCalenderVC *popVC = [storyboard instantiateViewControllerWithIdentifier:@"meetSchduleCtrl"];
    //[self presentViewController:popVC animated:YES completion:nil];
    [self showViewController:popVC sender:self];
    
}

- (void)UpdateChartData
{
    // (0.2 + 0.03) * 4 + 0.08 = 1.00 -> interval per "group"
    
    NSMutableArray *yValsC11 = [[NSMutableArray alloc] init];
    NSMutableArray *yValsC12 = [[NSMutableArray alloc] init];
    NSMutableArray *yValsC21 = [[NSMutableArray alloc] init];
    NSMutableArray *yValsC22 = [[NSMutableArray alloc] init];
    NSMutableArray *xLblC1 = [[NSMutableArray alloc] init];
    NSMutableArray *xLblC2 = [[NSMutableArray alloc] init];
    [WBService SendServerRequest:@"GET/KPI" withParameter:nil withImages:nil DataSF:nil
              completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                  int iC1=1;int iC2=1;
                  for(int ij=0;ij<[receivedDta count];ij++){
                    if([[receivedDta[ij] objectForKey:@"flag"] isEqualToString:@"0"]){
                        [yValsC11 addObject:[[BarChartDataEntry alloc]
                            initWithX:[[receivedDta[ij] objectForKey:@"id"] floatValue]
                            y:[[receivedDta[ij] objectForKey:@"yval"] floatValue]]];
                        [yValsC12 addObject:[[BarChartDataEntry alloc]
                            initWithX:[[receivedDta[ij] objectForKey:@"id"] floatValue]
                            y:[[receivedDta[ij] objectForKey:@"mval"] floatValue]]];
                        NSMutableDictionary* item=[[NSMutableDictionary alloc] init];
                        [item setValue:[NSString stringWithFormat:@"%i",iC1] forKey:@"id"];
                        [item setValue:[NSString stringWithFormat:@"%@",[receivedDta[ij] objectForKey:@"label"]] forKey:@"label"];
                        [xLblC1 addObject:item];
                        iC1++;
                    }
                    if([[receivedDta[ij] objectForKey:@"flag"] isEqualToString:@"1"]){
                        [yValsC21 addObject:[[BarChartDataEntry alloc]
                            initWithX:[[receivedDta[ij] objectForKey:@"id"] floatValue]
                            y:[[receivedDta[ij] objectForKey:@"yval"] floatValue]]];
                        [yValsC22 addObject:[[BarChartDataEntry alloc]
                            initWithX:[[receivedDta[ij] objectForKey:@"label"] floatValue]
                            y:[[receivedDta[ij] objectForKey:@"mval"] floatValue]]];
                        NSMutableDictionary* item=[[NSMutableDictionary alloc] init];
                        [item setValue:[NSString stringWithFormat:@"%i",iC2] forKey:@"id"];
                        [item setValue:[NSString stringWithFormat:@"%@",[receivedDta[ij] objectForKey:@"label"]] forKey:@"label"];
                        [xLblC2 addObject:item];
                        iC2++;
                    }
                }
                ChartXAxis *xAxisC1 = _SFEKPIChart.xAxis;
                xAxisC1.valueFormatter = [[xAxisLabelFormatter alloc] initWithData:xLblC1];
                  NSMutableArray* C1Colors=[[NSMutableArray alloc] init];
                  [C1Colors addObject:[UIColor colorWithRed:0.224 green:0.400 blue:0.659 alpha:1.00]];
                  [C1Colors addObject:[UIColor colorWithRed:0.557 green:0.812 blue:0.392 alpha:1.00]];
                [self renderBarChart:yValsC11 andyVal2:yValsC12 andChartview:_SFEKPIChart andGroupCount:[xLblC1 count] andBarColors:C1Colors];
                 
                  NSMutableArray* C2Colors=[[NSMutableArray alloc] init];
                  [C2Colors addObject:[UIColor colorWithRed:0.412 green:0.016 blue:0.384 alpha:1.00]];
                  [C2Colors addObject:[UIColor colorWithRed:1.000 green:0.592 blue:0.282 alpha:1.00]];
                ChartXAxis *xAxisC2 = _TRKPIChart.xAxis;
                xAxisC2.valueFormatter = [[xAxisLabelFormatter alloc] initWithData:xLblC2];
                [self renderBarChart:yValsC21 andyVal2:yValsC22 andChartview:_TRKPIChart andGroupCount:[xLblC2 count] andBarColors:C2Colors];
          }
          error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
              NSLog(@"%@",errorMsg);
          }
     ];
}
-(void) renderBarChart:(NSMutableArray *)yVals1 andyVal2:(NSMutableArray *)yVals2 andChartview:(BarChartView*) chartView andGroupCount:(float)grpCnt andBarColors:(NSMutableArray *) BarColors;
{
    
    float groupSpace = 0.10f;
    float barSpace = 0.05f;
    float barWidth = 0.4f;
    float startYear=1;
    float groupCount=grpCnt;
    BarChartDataSet *set1 = nil, *set2 = nil;
    if (chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)chartView.data.dataSets[0];
        set2 = (BarChartDataSet *)chartView.data.dataSets[1];
        set1.values = yVals1;
        set2.values = yVals2;
        
        BarChartData *data = chartView.barData;
        
        chartView.xAxis.axisMinimum = 1;
        chartView.xAxis.axisMaximum = startYear + [data groupWidthWithGroupSpace:groupSpace barSpace: barSpace] * groupCount;
        
        [data groupBarsFromX:1 groupSpace: groupSpace barSpace: barSpace];
        
        [chartView.data notifyDataChanged];
        [chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals1 label:@"YTD"];
        
        [set1 setColor:BarColors[0]];
        //[set1 setColor:[UIColor colorWithRed:104/255.f green:241/255.f blue:175/255.f alpha:1.f]];
        
        set2 = [[BarChartDataSet alloc] initWithValues:yVals2 label:@"Month"];
        [set2 setColor:BarColors[1]];
       // [set2 setColor:[UIColor colorWithRed:164/255.f green:228/255.f blue:251/255.f alpha:1.f]];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        [dataSets addObject:set2];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        //[data setValueFormatter:[[LargeValueFormatter alloc] init]];
        
        // specify the width each bar should have
        data.barWidth = barWidth;
        
        // restrict the x-axis range
        chartView.xAxis.axisMinimum = 1;
        
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        chartView.xAxis.axisMaximum = startYear + [data groupWidthWithGroupSpace:groupSpace barSpace: barSpace] * groupCount;
        
        [data groupBarsFromX:1 groupSpace: groupSpace barSpace: barSpace];
        
        chartView.data = data;
    }
}
-(void) getMeetingDatas{
    [WBService SendServerRequest:@"GET/Meetings" withParameter:nil withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        
            self.MeetDatas=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        [_tbvwMeetings reloadData];
            
        } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
    }];
}
- (void)UpdateSamplesChartData
{
    // (0.2 + 0.03) * 4 + 0.08 = 1.00 -> interval per "group"
    [self setupBarLineChartView:_SmpProdChart];
    
    _SmpProdChart.delegate = self;
    
    _SmpProdChart.drawBarShadowEnabled = NO;
    _SmpProdChart.drawValueAboveBarEnabled = YES;
    
    _SmpProdChart.maxVisibleCount = 60;
    
    //xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:_chartView];
    
    NSMutableArray *yValsC11 = [[NSMutableArray alloc] init];
    NSMutableArray *xLblC1 = [[NSMutableArray alloc] init];
    [WBService SendServerRequest:@"GET/SamplesChart" withParameter:nil withImages:nil DataSF:nil
                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                          NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                          int iC1=1;
                          if([receivedDta count]>0){
                              for(int ij=0;ij<[receivedDta count];ij++){
                                      [yValsC11 addObject:[[BarChartDataEntry alloc]
                                                           initWithX:iC1//[[receivedDta[ij] objectForKey:@"id"] intValue]
                                                           y:[[receivedDta[ij] objectForKey:@"yval"] floatValue]]];
                                  
                                      NSMutableDictionary* item=[[NSMutableDictionary alloc] init];
                                      [item setValue:[NSString stringWithFormat:@"%i",iC1] forKey:@"id"];
                                      [item setValue:[NSString stringWithFormat:@"%@",[receivedDta[ij] objectForKey:@"label"]] forKey:@"label"];
                                      [xLblC1 addObject:item];
                                      iC1++;
                                  
                              }
                              ChartXAxis *xAxis = _SmpProdChart.xAxis;
                              xAxis.labelPosition = XAxisLabelPositionBottom;
                              xAxis.labelFont = [UIFont systemFontOfSize:10.f];
                              xAxis.drawGridLinesEnabled = NO;
                             // xAxis.granularity = 1.0; // only intervals of 1 day
                              xAxis.labelCount = [xLblC1 count];
                              xAxis.valueFormatter = [[xAxisLabelFormatter alloc] initWithData:xLblC1];
                              
                             /*
                              NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
                              leftAxisFormatter.minimumFractionDigits = 0;
                              leftAxisFormatter.maximumFractionDigits = 1;
                              leftAxisFormatter.negativeSuffix = @" $";
                              leftAxisFormatter.positiveSuffix = @" $";
                              
                              ChartYAxis *leftAxis = _SmpProdChart.leftAxis;
                              leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
                              leftAxis.labelCount = 8;
                              leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
                              leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
                              leftAxis.spaceTop = 0.15;
                              leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
                              
                              ChartYAxis *rightAxis = _SmpProdChart.rightAxis;
                              rightAxis.enabled = YES;
                              rightAxis.drawGridLinesEnabled = NO;
                              rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
                              rightAxis.labelCount = 8;
                              rightAxis.valueFormatter = leftAxis.valueFormatter;
                              rightAxis.spaceTop = 0.15;
                              rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
                              */
                             ChartLegend *l = _SmpProdChart.legend;
                              l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
                              l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
                              l.orientation = ChartLegendOrientationHorizontal;
                              l.drawInside = NO;
                              l.form = ChartLegendFormSquare;
                              l.formSize = 9.0;
                              l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
                              l.xEntrySpace = 10.0;
                              
                              NSMutableArray* C1Colors=[[NSMutableArray alloc] init];
                              [C1Colors addObject:[UIColor colorWithRed:0.224 green:0.400 blue:0.659 alpha:1.00]];
                              [self renderSampBarChart:yValsC11 andChartview:_SmpProdChart andBarColors:C1Colors];
                          }
      }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }
     ];
}

- (UIColor *)randomColor
{
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    NSLog(@"%@", color);
    return color;
}
-(void) renderSampBarChart:(NSMutableArray *)yVals1 andChartview:(BarChartView*) chartView andBarColors:(NSMutableArray *) BarColors;
{
    
    BarChartDataSet *set1 = nil;
    if (chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)chartView.data.dataSets[0];
        set1.values = yVals1;
        [chartView.data notifyDataChanged];
        [chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals1 label:@"ISSUED PRODUCT SAMPLES"];
        //[set1 setColors:ChartColorTemplates.material];
        [set1 setColors:BarColors];
        set1.drawIconsEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        //data.barWidth = 5.0f;
        
        chartView.data = data;
    }
}


- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.chartDescription.enabled = NO;
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = NO;
    
    // ChartYAxis *leftAxis = chartView.leftAxis;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    chartView.rightAxis.enabled = NO;
}


-(void) drawBarChart:(PNBarChart*) Chart xLabels:(NSMutableArray*)xlbl yLabels:(NSMutableArray*)ylbl {
    
    Chart.yChartLabelWidth = 20.0;
    Chart.chartMarginLeft = 30.0;
    Chart.chartMarginRight = 10.0;
    Chart.chartMarginTop = 5.0;
    Chart.chartMarginBottom = 10.0;
    
    
    Chart.labelMarginTop = 5.0;
    Chart.showChartBorder = NO;
    [Chart setXLabels:xlbl];
    [Chart setYValues:ylbl];
    Chart.isGradientShow = YES;
    Chart.isShowNumbers = YES;
    
    [Chart strokeChart];
    
    Chart.delegate = self;

}


-(void) checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];

    switch (internetStatus) {
        case NotReachable: {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWWAN:
        case ReachableViaWiFi:{
            NSLog(@"Checking internet Status...");/*
            //Remove Observer
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];*/
           // [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(InternetChecking) userInfo:nil repeats:NO];
        }
       /* case ReachableViaWiFi: {
            NSLog(@"The internet is working via WIFI.");
            //Remove Observer
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];

            break;
        }

        case ReachableViaWWAN: {
            NSLog(@"The internet is working via WWAN.");
            break;
        }*/
    }
}
-(void) InternetChecking{
    
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(InternetChecking) userInfo:nil repeats:NO];
}
-(void) ShowNotification{
    [_tmr invalidate];
    _tmr = nil;
    NSMutableArray *NotifyMsgsList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"NotifyMsgs.SANAPP"] mutableCopy];
    NSMutableArray *NotifyMsgs=[[NotifyMsgsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Flag==%@",@"0"]] mutableCopy];
    _vwNotifyImg.hidden=YES;
    if([NotifyMsgs count]>0){
        _vwNotifyImg.hidden=NO;
        NSString *NotifyMsg=[NotifyMsgs[0] valueForKey:@"msg"];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NotifyHead",@"Notification Message")
                                                                       message:NotifyMsg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSMutableDictionary* dist=[NotifyMsgs[0] mutableCopy];
                                                                  [dist setValue:@"1" forKey:@"Flag"];
                                                                  [NotifyMsgsList removeObject:NotifyMsgs[0]];
                                                                  [NotifyMsgsList addObject:dist];
                                                                  [WBService saveData:[NotifyMsgsList mutableCopy] forKey:@"NotifyMsgs.SANAPP"];
                                                                  NSMutableArray* Msgs=[[NotifyMsgsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Flag==%@",@"0"]] mutableCopy];
                                                                  self.vwNotifyImg.hidden=YES;
                                                                  if([Msgs count]>0)
                                                                  {
                                                                      self.vwNotifyImg.hidden=NO;
                                                                  }
                                                                  NSLog(@"OK Fired");
                                                                  [self startNotifyTimer:120];
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [WBService SendServerRequest:@"GET/Notification" withParameter:nil withImages:nil DataSF:nil
                          completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                              NSMutableArray *receivedDta=[[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
                              for(int ij=0;ij<[receivedDta count];ij++){
                                  NSMutableArray *NotifyMsgs=[[NotifyMsgsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id==%@",[receivedDta[ij] valueForKey:@"id"]]] mutableCopy];
                                  if([NotifyMsgs count]>0){
                                      NSMutableDictionary* dist=[receivedDta[ij] mutableCopy];
                                      [dist setValue:@"1" forKey:@"Flag"];
                                      [receivedDta removeObjectAtIndex:ij];
                                      [receivedDta insertObject:[dist mutableCopy] atIndex:ij];
                                  }
                              }
                              NSMutableArray *Msgs=[[receivedDta filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Flag==%@",@"0"]] mutableCopy];
                              _vwNotifyImg.hidden=YES;
                              if([Msgs count]>0)
                              {
                                  _vwNotifyImg.hidden=NO;
                              }
                              [WBService saveData:[receivedDta mutableCopy] forKey:@"NotifyMsgs.SANAPP"];
                              [self startNotifyTimer:120];
                          }
                               error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                                   NSLog(@"%@",errorMsg);
                                   [self startNotifyTimer:120];
                               }
         ];
    }
    
}
-(void) startLatLngUpd{
    if([self.locationData.latitude isEqualToString:@""] ||[self.locationData.latitude isEqualToString:@"(null)"]){
        self.btnLocIndic.imageView.image=[UIImage imageNamed:@"locationW"];
    }
    else{
        self.btnLocIndic.imageView.image=[UIImage imageNamed:@"locationDB"];
    }
    self.lblLat.text= [NSString stringWithFormat:@"%@  : %@",NSLocalizedString(@"Lat", @"Lat"),self.locationData.latitude];
    self.lblLng.text= [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"Lng", @"Lng") ,self.locationData.longitude];
    [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startLatLngUpd) userInfo:nil repeats:NO] ;
}
-(void) startNotifyTimer:(NSTimeInterval) intrvl{
    [_tmr invalidate];
    _tmr = nil;
    intrvl=(intrvl*10000);
}
-(IBAction)logOutUser:(id)sender{
    _locationData.userSignedIn=NO;
    [AuthenticationManager.instance signOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)openSettings:(id)sender{
    
    [self performSegueWithIdentifier:@"SettingSegue" sender:self];
}
-(IBAction) RefreshData:(id)sender
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"CheckTPMsg",@"Master List Downloading...")];
    [self loadDatas];
}
-(void) loadDatas{

    self.dataLoaded=NO;
    self.numberLoaded=0;self.nSFMasLoaded=0;

    if(![self.UserDet.Desig isEqualToString:@"MR"]){
        SFsMaster=@[];
        /*SFsMaster=@[
                    [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",self.DataSF] andApiPath:@"GET/Territory" Parameters:nil],
                    [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.DataSF] andApiPath:@"GET/Doctors" Parameters:nil],
                    [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.DataSF] andApiPath:@"GET/Chemist" Parameters:nil],
                    [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"StockistDetails_%@.SANAPP",self.DataSF] andApiPath:@"GET/Stockist" Parameters:nil],
                    [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",self.DataSF] andApiPath:@"GET/UnlistedDR" Parameters:nil],
                    [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"JointWork_%@.SANAPP",self.DataSF] andApiPath:@"GET/JntWrk" Parameters:nil],
                    [[List alloc] initWithName:[[NSString alloc] initWithFormat:@"DRVstDetails_%@.SANAPP",self.DataSF] andApiPath:@"GET/VstDR" Parameters:nil]
                    ];*/
    }
    
    for(List* list in MasterList){
        [WBService SendServerRequest:list.apiPath withParameter:list.param withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
            NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            [WBService saveData:receivedDta forKey:list.name];
            //if([list.apiPath isEqual:@"GET/ProdSlides"]){[self loadSlides];}
            self.numberLoaded++;
            [self FinishDataLoading:MasterList.count andlc:SFsMaster.count];
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
            NSLog(@"%@",errorMsg);self.numberLoaded++;
        }];
    }
    
    
    if([self.UserDet.Desig isEqualToString:@"MR"]){
        for(List* list in SFsMaster){
            [WBService SendServerRequest:list.apiPath withParameter:list.param withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                [WBService saveData:receivedDta forKey:list.name];
                self.nSFMasLoaded++;
                [self FinishDataLoading:MasterList.count andlc:SFsMaster.count];
            }
            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                NSLog(@"%@",errorMsg);
            }];
        }
    }

}

-(void) loadSlides{
    self.nSlideLoaded=0;
    self.SlideList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"ProdSlides.SANAPP"] mutableCopy];
    self.UniqueSlides=[[NSMutableArray alloc] init];
    for(NSDictionary* slide in self.SlideList)
    {
        if([[self.UniqueSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", [slide valueForKey:@"Code"]]] count]<1){
            [self.UniqueSlides addObject:slide];
        }
    }
    [WBService saveData:[self.UniqueSlides mutableCopy] forKey:@"UniqueProdSlides.SANAPP"];
    if([self.SlideList count]>0) [self openDownloader];
}
-(void) FinishDataLoading:(NSUInteger)lc andlc:(NSUInteger)lc1{
    if(self.numberLoaded == lc && self.nSFMasLoaded==lc1){
        self.dataLoaded=YES;
        if(self.viewAppeared==YES && self.slidesDownloaded==YES) [self openTourPlan]; else [SVProgressHUD dismiss];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@YES forKey:@"flag"];
        if (self.slidesDownloaded==NO) [self loadSlides];
        [WBService saveData:dict forKey:@"dataLoaded"];
    }
}


-(void) openTourPlan
{
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"CheckDyTPMsg",@"Getting Today Tour Plan...")];
    [self showWTType ];
    NSDictionary *MyTP = [[NSDictionary alloc] init];
    MyTP = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
    
    BOOL TPFlag=YES;
    if(MyTP!=nil){
        NSString *sTPDt=@"";
        if([[MyTP valueForKey:@"TPDt"] isKindOfClass:[NSArray class]]){
            sTPDt=[[MyTP valueForKey:@"TPDt"][0] valueForKey:@"date"];
        }else{
            sTPDt=[MyTP valueForKey:@"TPDt"];
        }
        NSString *TPDt =[BaseViewController str2Format:sTPDt withFormat:@"yyyy-MM-dd"];
        NSString *sCDt =[BaseViewController date2str:[NSDate date] onlyDate:YES];
        NSLog(@"%@",TPDt);
        NSLog(@"%@",sCDt);
        
        if([TPDt isEqualToString:sCDt]){ TPFlag=NO;NSLog(@"New TP :False");}
        /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"IST"];
        NSDate *TPDt=[dateFormatter dateFromString:[MyTP valueForKey:@"TPDt"] ];
        
        NSDateComponents *datesDiff = [calendar components: NSCalendarUnitDay
                                                  fromDate: TPDt
                                                    toDate: [NSDate date]
                                                   options: 0];
        if(datesDiff.day==0 && TPDt!=nil){
            TPFlag=NO;
        }*/
        
        [SVProgressHUD dismiss];
    }
    if(TPFlag==YES)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyTodayplan.SANAPP"];
        [WBService saveData:@"NO" forKey:@"MyDAyPlanSubmitted"];
        [WBService SendServerRequest:@"GET/TodayTP" withParameter:nil withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            NSString *sTPFlw=@"";
            if ([receivedDta count]>0) sTPFlw=[receivedDta valueForKey:@"TpVwFlg"][0];
            if([sTPFlw isEqualToString:@"1"] || [receivedDta count]<1){
                if([receivedDta count]>0){
                    self.TdayPl=[TdayPlDetail sharedTdayPlDetail];
                    self.TdayPl.SFCode=[receivedDta valueForKey:@"SFCode"][0];
                    self.TdayPl.TPDt=[[receivedDta valueForKey:@"TPDt"][0] valueForKey:@"date"];
                    self.TdayPl.FWFlg=[receivedDta valueForKey:@"FWFlg"][0];
                    self.TdayPl.SFMem=[receivedDta valueForKey:@"SFMem"][0];
                    self.TdayPl.HQNm=[receivedDta valueForKey:@"HQNm"][0];
                    self.TdayPl.WT=[receivedDta valueForKey:@"WT"][0];
                    self.TdayPl.WTNm=[receivedDta valueForKey:@"WTNm"][0];
                    self.TdayPl.Pl=[receivedDta valueForKey:@"Pl"][0];
                    self.TdayPl.PlNm=[receivedDta valueForKey:@"PlNm"][0];
                    self.TdayPl.Rem=[receivedDta valueForKey:@"Rem"][0];
                }
                [self showTPWindow];
            }else{
                self.TdayPl=[TdayPlDetail sharedTdayPlDetail];
                self.TdayPl.SFCode=[receivedDta valueForKey:@"SFCode"][0];
                self.TdayPl.TPDt=[[receivedDta valueForKey:@"TPDt"][0] valueForKey:@"date"];
                self.TdayPl.FWFlg=[receivedDta valueForKey:@"FWFlg"][0];
                self.TdayPl.SFMem=[receivedDta valueForKey:@"SFMem"][0];
                self.TdayPl.HQNm=[receivedDta valueForKey:@"HQNm"][0];
                self.TdayPl.WT=[receivedDta valueForKey:@"WT"][0];
                self.TdayPl.WTNm=[receivedDta valueForKey:@"WTNm"][0];
                self.TdayPl.Pl=[receivedDta valueForKey:@"Pl"][0];
                self.TdayPl.PlNm=[receivedDta valueForKey:@"PlNm"][0];
                self.TdayPl.Rem=[receivedDta valueForKey:@"Rem"][0];
                [WBService saveData:[self.TdayPl toNSDictionary] forKey:@"MyTodayplan.SANAPP"];
                [WBService saveData:@"YES" forKey:@"MyDAyPlanSubmitted"];
            }
            [SVProgressHUD dismiss];
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
           NSLog(@"%@",errorMsg);
           [SVProgressHUD dismiss];
       }];
        
        
    }
}
-(void) showWTType{
    
    NSDictionary *MyTP = [[NSDictionary alloc] init];
    MyTP = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
    NSString *text = [[MyTP valueForKey:@"WTNm"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    self.lblWTType.text= NSLocalizedString(text, text);
    self.lblClust.text=NSLocalizedString([MyTP valueForKey:@"PlNm"], [MyTP valueForKey:@"PlNm"]);
    
}
-(void) showMissDtWindow{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditDateSelectionCtrl *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"MissDtEntry"];
    
    currentViewController.modalPresentationStyle=UIModalPresentationFormSheet;
    currentViewController.UserDet=self.UserDet;
//    currentViewController.NvMain=self;
    [self presentViewController:currentViewController animated:YES completion:nil];
    
}
-(void) showTPWindow{
    NSMutableArray* objWTList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy];
    if([objWTList count]>0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ToDyTPvwCtrl *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TPEntry"];
        
        currentViewController.modalPresentationStyle=UIModalPresentationFormSheet;
        currentViewController.UserDet=self.UserDet;
        
        [self presentViewController:currentViewController animated:YES completion:nil];
    }
    else{
        [BaseViewController Toast:NSLocalizedString(@"Master Data Not Loaded Properly. Kindly Sycn Again.", @"Master Data Not Loaded Properly. Kindly Sycn Again.")];
    }
    
    [SVProgressHUD dismiss];
}

-(BOOL)shouldAutorotate{
    return NO;
}
-(void) reloadSubCalls{
    @try{
        
    
    self.SubmittedCallsList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmittedCalls.SANAPP"] mutableCopy];
    self.PendingCallsList=[[self.SubmittedCallsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"vstTime < %@ and (Synced=%@ or Drft=1)", [BaseViewController date2str:[NSDate date]  onlyDate:YES],[NSNumber numberWithBool:NO]]] mutableCopy];
    
    
    self.TodayCallsList=[[self.SubmittedCallsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"vstTime >= %@ and (Synced=%@ or Drft=1)", [BaseViewController date2str:[NSDate date]  onlyDate:YES],[NSNumber numberWithBool:NO]]] mutableCopy];
    if(self.TodayCallsList==nil) self.TodayCallsList=[[NSMutableArray alloc]init];
    
    [WBService SendServerRequest:@"GET/toDyCalls" withParameter:nil withImages:nil DataSF:nil
        completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage)
        {
            NSMutableArray *recAryDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            self.TodayCallsList=[[self.TodayCallsList arrayByAddingObjectsFromArray:recAryDta] mutableCopy];
            [self reloadCalls];
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
            [self reloadCalls];
            NSLog(@"%@",errorMsg);
        }
     ];
        
    } @catch (NSException *exception) {
    } @finally {
    }
}
-(void) reloadCalls{
    
    self.SectionsHeders = [[NSMutableArray alloc] init];
    self.CallsSectionsList = [[NSMutableArray alloc] init];
    if ([self.PendingCallsList count]>0){
        [self.SectionsHeders addObject:@"Pending Calls"];
        [self.CallsSectionsList addObject:_PendingCallsList];
    }
    [self.SectionsHeders addObject:@"Today Calls"];
    [self.CallsSectionsList addObject:_TodayCallsList];
    
    [_clViewCalls reloadData];
}
-(void) openDownloader{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    downloaderView *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"Downloader"];
    
    currentViewController.modalPresentationStyle=UIModalPresentationFormSheet;
    
    [self presentViewController:currentViewController animated:YES completion:nil];

}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSArray* calls = self.CallsSectionsList[_cIndexPath.section];
        NSMutableDictionary* optLst=calls[_cIndexPath.row];
        NSString *ActSlNo=[optLst valueForKey:@"ADetSLNo"];
        if(ActSlNo==nil)
        {
            [self.CallsSectionsList[_cIndexPath.section] removeObjectAtIndex:_cIndexPath.row];
            [self saveSubmitCalls];
            [BaseViewController Toast:NSLocalizedString(@"Call Deleted Successfully", @"Call Deleted Successfully")];
            [self reloadCalls];
        }
        else
        {
            [WBService SendServerRequest:@"Delete/Call" withParameter:[optLst mutableCopy] withImages:nil DataSF:nil indexPath:_cIndexPath
                              completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage,NSIndexPath *indxPath)
                {
                    [self.CallsSectionsList[_cIndexPath.section] removeObjectAtIndex:_cIndexPath.row];
                    [self saveSubmitCalls];
                    [BaseViewController Toast:NSLocalizedString(@"Call Deleted Successfully", @"Call Deleted Successfully")];
                    [self reloadCalls];
                }
                error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage,NSIndexPath *indexPath){
                    NSLog(@"%@",errorMsg);
                }
             ];
        }
    }
}


-(IBAction)DeleteCall:(UIButton *)sender{
    
    _cIndexPath = [self.clViewCalls indexPathForCell:(mMenuCell *)[[[sender superview]superview]superview]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SAN Digital Detailing"
                                                        message:NSLocalizedString(@"Do you want delete the Call",@"Do you want delete the Call")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                              otherButtonTitles:NSLocalizedString(@"Ok",@"Ok"), nil];
    
    [alertView show];
}
-(void)AutoSyncCall{

    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    if(internetStatus == NotReachable)
    {
        return;
    }
    NSMutableArray *Arry=[[WBService getDataByKey:@"offMyTdypl.SANAPP"] mutableCopy];
    NSMutableArray* lMytp=[[Arry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"drfMode='1'"]] mutableCopy];
    if ([lMytp count]>0 && self.lsyncTp==NO){
        self.lsyncTp=YES;
        NSMutableDictionary *Mytp=[lMytp[0] mutableCopy];
        [WBService SendServerRequest:@"SAVE/MyTP" withParameter:Mytp withImages:nil DataSF:nil completion:^(BOOL success, id respData,NSMutableDictionary* uData) {
            NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            [SVProgressHUD dismiss];
            self.lsyncTp=NO;
            
            NSString* rMsg=[receivedDta valueForKey:@"Msg"];
            if([[receivedDta valueForKey:@"success"] boolValue]==YES){
                NSMutableArray* iArry=[[[NSUserDefaults standardUserDefaults] objectForKey:@"offMyTdypl.SANAPP"] mutableCopy];
                long indx= (int) [iArry indexOfObject:lMytp[0]];
                [iArry removeObjectAtIndex:indx];
                [WBService saveArrayData:[iArry mutableCopy] forKey:@"offMyTdypl.SANAPP"];
                if(![rMsg isEqualToString:@""]){
                    [BaseViewController Toast:rMsg];
                }else{
                    [BaseViewController Toast:NSLocalizedString(@"Today Work Plan Synced", @"Today Work Plan Synced")];
                }
            }
            else{
                if(![rMsg isEqualToString:@""]){
                    NSMutableArray* iArry=[[[NSUserDefaults standardUserDefaults] objectForKey:@"offMyTdypl.SANAPP"] mutableCopy];
                    long indx= (int) [iArry indexOfObject:lMytp[0]];
                    [iArry removeObjectAtIndex:indx];
                    [WBService saveArrayData:[iArry mutableCopy] forKey:@"offMyTdypl.SANAPP"];
                   // [BaseViewController Toast:rMsg];
                }else{
//                    [BaseViewController Toast:NSLocalizedString(@"Today Work Plan not Synced. Something went to wrong.\n Try Again!.", @"Today Work Plan not Synced. Something went to wrong.\n Try Again!.")];
                }
            }
        }
        error:^(NSString *errorMsg, NSMutableDictionary* uData){
            self.lsyncTp=NO;
            NSLog(@"%@",errorMsg);
        }];
    }
    NSArray* lCalls=[[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmittedCalls.SANAPP"] mutableCopy];
    NSArray* lPCalls=[[lCalls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Synced=%@ and Drft=%@",[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]]] mutableCopy];
    if ([lPCalls count]>0 && self.lsyncCall==NO){

        self.lsyncCall=YES;
        NSMutableDictionary *lpCall=[lPCalls[0] mutableCopy];
        
        NSMutableDictionary *imgData=[lpCall objectForKey:@"uImages"];
        [lpCall  removeObjectForKey:@"uImages"] ;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Scribbles"];
        NSMutableArray *Scrbs=[[lpCall objectForKey:@"Products"] mutableCopy];
        for (int il=0; il<[Scrbs count]; il++) {
            NSMutableArray* Slides=[Scrbs[il] objectForKey:@"Slides"];
            for (int jl=0; jl<[Slides count]; jl++) {
                NSMutableArray* Scribbles=[Slides[jl] objectForKey:@"Scribbles"];
                for (int kl=0; kl<[Scribbles count]; kl++) {
                    NSLog(@"%@",[Scribbles[kl] valueForKey:@"ScribbleName"]);
                    
                    NSString *fileName = [filePath stringByAppendingPathComponent:
                                          [NSString stringWithFormat:@"%@", [Scribbles[kl] valueForKey:@"ScribbleName"]]];
                    NSData *ScribData =[NSData dataWithContentsOfFile:fileName];
                    imgData=[[NSMutableDictionary alloc] init];
                    [imgData setObject:ScribData forKey:@"Image"];
                    [imgData setValue:@"ScribbleImg" forKey:@"Key"];
                    [imgData setValue:[Scribbles[kl] valueForKey:@"ScribbleName"] forKey:@"Filename"];
                    [WBService uplodeScribbleImages:[imgData mutableCopy]];
                }
            }
        }

        [WBService SendServerRequest:@"SAVE/Call" withParameter:[lpCall mutableCopy] withImages:[imgData mutableCopy] DataSF:nil indexPath:nil
                          completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage,NSIndexPath *indxPath)
            {
                NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                bool Success=[[receivedDta valueForKey:@"success"] boolValue];
            
                self.lsyncCall=NO;
                if(Success==YES){
                    NSMutableArray* ilCalls=[[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmittedCalls.SANAPP"] mutableCopy];
                    long indx= [ilCalls indexOfObject:lPCalls[0]];
                    [ilCalls removeObjectAtIndex:indx];
                    [WBService saveArrayData:[ilCalls mutableCopy] forKey:@"SubmittedCalls.SANAPP"];
                    [BaseViewController Toast:NSLocalizedString(@"Call Synced Successfully", @"Call Synced Successfully")];
                    [self reloadSubCalls];
                    NSString *CustCode=[lPCalls[0] valueForKey:@"CustCode"];
                    [WBService SendServerRequest:@"GET/CusLVst" withParameter:[@{@"CusCode":CustCode,@"typ":@"D"} mutableCopy] withImages:nil DataSF:nil
                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                            NSMutableArray *VstData=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                            [WBService saveData:VstData forKey:[NSString stringWithFormat:@"CLVst_Cus%@D.SANAPP",CustCode]];
                           
                          }
                          error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                              NSLog(@"%@",errorMsg);
                          }
                    ];
                    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(AutoSyncCall) userInfo:nil repeats:NO] ;
                }
            }
            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage,NSIndexPath *indexPath){
                self.lsyncCall=NO;
                NSLog(@"%@",errorMsg);
                [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(AutoSyncCall) userInfo:nil repeats:NO];
            }
         ];
    }else{
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(AutoSyncCall) userInfo:nil repeats:NO] ;
    }
}
-(IBAction)SyncCall:(UIButton *)sender{
    
    NSIndexPath *indexPath = [self.clViewCalls indexPathForCell:(mMenuCell *)[[[sender superview]superview]superview]];
    NSArray* calls = self.CallsSectionsList[indexPath.section];
    NSMutableDictionary* optLst=[calls[indexPath.row] mutableCopy];
    
    
    NSMutableDictionary *imgData=[optLst objectForKey:@"uImages"];
    [optLst  removeObjectForKey:@"uImages"] ;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Scribbles"];
    NSMutableArray *Scrbs=[[optLst objectForKey:@"Products"] mutableCopy];
    for (int il=0; il<[Scrbs count]; il++) {
        NSMutableArray* Slides=[Scrbs[il] objectForKey:@"Slides"];
        for (int jl=0; jl<[Slides count]; jl++) {
            NSMutableArray* Scribbles=[Slides[jl] objectForKey:@"Scribbles"];
            for (int kl=0; kl<[Scribbles count]; kl++) {
                NSLog(@"%@",[Scribbles[kl] valueForKey:@"ScribbleName"]);
                
                NSString *fileName = [filePath stringByAppendingPathComponent:
                                      [NSString stringWithFormat:@"%@", [Scribbles[kl] valueForKey:@"ScribbleName"]]];
                NSData *ScribData =[NSData dataWithContentsOfFile:fileName];
                imgData=[[NSMutableDictionary alloc] init];
                [imgData setObject:ScribData forKey:@"Image"];
                [imgData setValue:@"ScribbleImg" forKey:@"Key"];
                [imgData setValue:[Scribbles[kl] valueForKey:@"ScribbleName"] forKey:@"Filename"];
                [WBService uplodeScribbleImages:[imgData mutableCopy]];
            }
        }
    }
    
    
    
    [WBService SendServerRequest:@"SAVE/Call" withParameter:[optLst mutableCopy] withImages:[imgData mutableCopy] DataSF:nil indexPath:indexPath
        completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage,NSIndexPath *indxPath)
        {
            NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            bool Success=[[receivedDta valueForKey:@"success"] boolValue];
            if(Success==YES){
                NSMutableArray* ilCalls=[[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmittedCalls.SANAPP"] mutableCopy];
                
                NSArray* lPCalls=[[ilCalls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode=%@ and CusType=%@  and Synced=%@",[DatawithImage valueForKey:@"CustCode"],[DatawithImage valueForKey:@"CusType"],[NSNumber numberWithBool:NO]]] mutableCopy];
                
                if(lPCalls.count > 0)
                {
                    long indx= [ilCalls indexOfObject:lPCalls[0]];
                    [ilCalls removeObjectAtIndex:indx];
                    [WBService saveArrayData:[ilCalls mutableCopy] forKey:@"SubmittedCalls.SANAPP"];
                    NSString *CustCode=[lPCalls[0] valueForKey:@"CustCode"];
                    [WBService SendServerRequest:@"GET/CusLVst" withParameter:[@{@"CusCode":CustCode,@"typ":@"D"} mutableCopy] withImages:nil DataSF:nil
                                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                        NSMutableArray *VstData=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                        [WBService saveData:VstData forKey:[NSString stringWithFormat:@"CLVst_Cus%@D.SANAPP",CustCode]];
                        
                    }
                                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                        NSLog(@"%@",errorMsg);
                    }
                    ];
                    /* NSMutableDictionary* sCall=[self.CallsSectionsList[indxPath.section][indxPath.row] mutableCopy];
                     [sCall setObject:[NSNumber numberWithBool:YES] forKey:@"Synced"];
                     [self.CallsSectionsList[indxPath.section] removeObjectAtIndex:indxPath.row];
                     [self.CallsSectionsList[indxPath.section] insertObject:sCall atIndex:indxPath.row];
                     */
                    [BaseViewController Toast:NSLocalizedString(@"Call Synced Successfully", @"Call Synced Successfully")];
                    //[self saveSubmitCalls];
                    [self reloadSubCalls];
                }
            }
    }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage,NSIndexPath *indexPath){
        NSLog(@"%@",errorMsg);
    }
    ];
}

-(IBAction)EditCall:(UIButton *)sender{
    
    NSIndexPath *indexPath = [self.clViewCalls indexPathForCell:(mMenuCell *)[[[sender superview]superview]superview]];
    NSArray* calls = self.CallsSectionsList[indexPath.section];
    NSMutableDictionary* optLst=[calls[indexPath.row] mutableCopy];
    
    if([[optLst objectForKey:@"Synced"] intValue]==1)
    { //GET/CallDets
        NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
        [param setValue:[optLst valueForKey:@"ADetSLNo"] forKey:@"detno"];
        [param setValue:[optLst valueForKey:@"CustName"] forKey:@"cusname"];
        [param setValue:[optLst valueForKey:@"CustType"] forKey:@"custype"];
        [param setValue:@"0" forKey:@"pob"];
        [WBService SendServerRequest:@"editdata/call" withParameter:[param mutableCopy] withImages:nil DataSF:nil indexPath:indexPath
            completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage,NSIndexPath *indxPath)
            {
                NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                
                [self setEditCallData:receivedDta];
            }
            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage,NSIndexPath *indexPath){
                NSLog(@"%@",errorMsg);
            }
         ];
    }
    else{
        NSLog(@"%@", optLst);
        [self setEditCallData:optLst];
    }
    //CallMeetData
}
-(void)setEditCallData:(NSMutableDictionary*) optLst{

    self.meetData=[CallMeetData sharedDatas];
    
    self.meetData.amc=[optLst objectForKey:@"ADetSLNo"];
    self.meetData.DataSF=[optLst objectForKey:@"DataSF"];
    self.meetData.CustCode=[optLst objectForKey:@"CustCode"];
    self.meetData.CustName=[optLst objectForKey:@"CustName"];
    self.meetData.CusType=[optLst objectForKey:@"CusType"];
    //self.meetData.SpecCode=[optLst objectForKey:@"SpecCode"];
    //self.meetData.CateCode=[optLst objectForKey:@"CateCode"];
    self.meetData.vstTime=[optLst objectForKey:@"vstTime"];
    //self.meetData.ModTime=[optLst objectForKey:@"ModTime"];
    self.meetData.ModTime=[BaseViewController getDateTime];
    //self.meetData.mappedProds=[optLst objectForKey:@"mappedProds"];
    self.meetData.Products=[[optLst objectForKey:@"Products"] mutableDeepCopy];
    self.meetData.Inputs=[[optLst objectForKey:@"Inputs"] mutableDeepCopy];
    self.meetData.AdCuss=[[optLst objectForKey:@"AdCuss"] mutableDeepCopy];
    self.meetData.RCPAEntry=[[optLst objectForKey:@"RCPAEntry"] mutableDeepCopy];
    self.meetData.JWWrk=[[optLst objectForKey:@"JWWrk"] mutableDeepCopy];
    self.meetData.Remks=[optLst objectForKey:@"Remks"];
    
    NSMutableDictionary *imgData=[optLst objectForKey:@"uImages"];
    self.meetData.SignImg=[imgData objectForKey:@"Image"];
    
    [self performSegueWithIdentifier:@"EditFeedback" sender:self];
    
}
-(NSMutableArray *)ConvertMutable:(NSArray*)exArray
{
    NSMutableArray *NArray=[[NSMutableArray alloc] init];
    for(int il=0;il<[exArray count];il++){
        NSMutableDictionary *NDic = (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFDictionaryRef)exArray[il], kCFPropertyListMutableContainers));
        //NSMutableDictionary *NDic=[[NSMutableDictionary alloc] initWithDictionary:[exArray[il] mutableCopy]];
        
        [NArray addObject:NDic];
    }
    return NArray;
}
-(void) saveSubmitCalls{
    
    NSArray* scalls =[[NSArray alloc]initWithArray:self.CallsSectionsList[0]];
    if([self.CallsSectionsList count]>1)
        [scalls arrayByAddingObjectsFromArray:self.CallsSectionsList[1]];
    NSMutableDictionary *dsCalls=[scalls mutableCopy];
    [WBService saveArrayData:[dsCalls mutableCopy] forKey:@"SubmittedCalls.SANAPP"];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==self.clViewCalls){
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 52);
    }
    else{
        return CGSizeMake(((CGRectGetWidth(collectionView.bounds)-80)/3), 134);
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==self.clViewCalls)
    {
        return [self.CallsSectionsList[section] count];
    }else
    {
        return self.menulist.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(collectionView==self.clViewCalls)
    {
        return self.CallsSectionsList.count;
    }
    else
        return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mMenuCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    if(collectionView==_clViewCalls)
    {
        NSArray* calls = self.CallsSectionsList[indexPath.section];
        NSDictionary* optLst=calls[indexPath.row];
        cell.LblText.text = [optLst objectForKey:@"CustName"];
        cell.LblText.textColor = [UIColor blackColor];
        cell.btnEdit.hidden=YES;
        cell.btnDel.hidden=YES;
        cell.btnSync.hidden=[[optLst objectForKey:@"Synced"] boolValue];
        if([[optLst objectForKey:@"Drft"] intValue]==1){
            cell.LblText.textColor = [UIColor redColor];
            cell.btnEdit.hidden=NO;
            cell.btnDel.hidden=NO;
            cell.btnSync.hidden=YES;
        }else if([[optLst objectForKey:@"Synced"] boolValue]==YES){
            cell.btnEdit.hidden=NO;
            cell.btnDel.hidden=NO;
        }
        cell.LblHiLetText.text = [BaseViewController str2Format:[optLst objectForKey:@"vstTime"] withFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    }else{
        NSDictionary *menu=self.menulist[indexPath.row];
        UIColor *color = [[[CVColor alloc] init] getUIColorObjectFromHexString:[menu objectForKey:@"bgColor" ] alpha:.9];
        cell.layer.cornerRadius=5.0f;
        cell.bgView.layer.cornerRadius=5.0f;
        cell.backgroundColor=color;
        cell.titleLabel.text = NSLocalizedString([menu objectForKey:@"name"],[menu objectForKey:@"name"]);
        cell.bLogoImg.image = [UIImage imageNamed:[menu objectForKey:@"image"] ];
        cell.tagID=(int)[[menu objectForKey:@"tag"] intValue];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==_clViewCalls)
    {
    }else{
        self.meetData.MissedEntry=NO;
        [self.MissedEntry clearMissedEntry];
        int tagID = [[_menulist[indexPath.row] objectForKey:@"tag"] intValue];
        [self NavMenuItem:tagID];
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView* headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        UILabel* label = (UILabel*)[headerView viewWithTag:1];
        
        UILabel* labelc = (UILabel*)[headerView viewWithTag:2];
        NSString* title = self.SectionsHeders[indexPath.section];
        label.text =[NSString stringWithFormat:@"  %@",NSLocalizedString(title, title)];
        if([self.SectionsHeders count]>1){
            if (indexPath.section==0){
                labelc.text=[NSString stringWithFormat:@"%@ %lu %@",NSLocalizedString(@"Total",@"Total"),(unsigned long)[self.PendingCallsList count],NSLocalizedString(@"Calls",@"Calls")];
            }
            else{
                labelc.text=[NSString stringWithFormat:@"%@ %lu %@",NSLocalizedString(@"Total",@"Total"),(unsigned long)[self.TodayCallsList count],NSLocalizedString(@"Calls",@"Calls")];
            }
        }else{
            labelc.text=[NSString stringWithFormat:@"%@ %lu %@",NSLocalizedString(@"Total",@"Total"),(unsigned long)[self.TodayCallsList count],NSLocalizedString(@"Calls",@"Calls")];
        }
        //label.font = [UIFont fontWithName:@"Avenir-Black" size:18.0f];
        //label.textColor = [UIColor whiteColor];
        
        reusableview = headerView;
    }
    
    
    return reusableview;
}
-(IBAction) showMenu:(id)sender{
    [self showMenuView];
}
-(void) showMenuView{
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    
    [self.vwModal addGestureRecognizer:_tapGesture];
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options: 0
                         animations:^{
                             
                             self.Menuleft.constant=0;
                            
                             self.vwMenu.frame = CGRectMake(0.0, self.vwMenu.frame.origin.y, self.vwMenu.frame.size.width, self.vwMenu.frame.size.height);
                             
                             self.vwMenu.alpha=1;
                             self.vwModal.alpha=1;
                             self.vwModal.hidden=NO;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {   }];
    
}
-(void) closeMenuView{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.Menuleft.constant=-self.vwMenu.frame.size.width;
                         self.vwMenu.frame = CGRectMake(-self.vwMenu.frame.size.width, self.vwMenu.frame.origin.y, self.vwMenu.frame.size.width, self.vwMenu.frame.size.height);
                         self.vwMenu.alpha=0;
                         self.vwModal.alpha=0;
                         self.vwModal.hidden=YES;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeGestureRecognizer: _tapGesture];
                     }];
}
-(void) NavMenuItem:(int) menuId{
    if(menuId == 1 ){
        if(self.meetData.MissedEntry!=YES){
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"MyDAyPlanSubmitted"] isEqualToString:@"NO"])
            {
                [BaseViewController Toast:NSLocalizedString(@"My Day Plan is Needed", @"My Day Plan is Needed")];
                return;
            }
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedWKType"] isEqualToString:@"F"])
            {
                [BaseViewController Toast:NSLocalizedString(@"Cannot submit Calls in Non-Field worktype. Change My Day Plan", @"Cannot submit Calls in Non-Field worktype. Change My Day Plan")];
                return;
            }
        }
        if([self.locationData.latitude floatValue]>0)
        {
            self.meetData.Entry_location=[NSString stringWithFormat:@"%@:%@",self.locationData.latitude,self.locationData.longitude];
        }
        [self performSegueWithIdentifier:@"gotoCustomer" sender:self];
    }
    if(menuId==2){
        [self performSegueWithIdentifier:@"mGoPrepSlides" sender:self];
    }
    if(menuId==3){
        [self performSegueWithIdentifier:@"mGoReportsMenu" sender:self];
    }
    if(menuId==4){
        [self performSegueWithIdentifier:@"mGoTourPlan" sender:self];
    }
    if(menuId==5){
        [self performSegueWithIdentifier:@"GoToLeaveApp" sender:self];
    }
    if(menuId==8){
        [self performSegueWithIdentifier:@"SettingSegue" sender:self];
    }
    if(menuId==9){
        [self performSegueWithIdentifier:@"NavLvApproval" sender:self];
    }
    if(menuId==10){
        [self performSegueWithIdentifier:@"mGoDrProfiling" sender:self];
    }
    if(menuId==11){
        [self performSegueWithIdentifier:@"mGoChmProfiling" sender:self];
    }
    if(menuId==12){
        [self performSegueWithIdentifier:@"GoToActivity" sender:self];
    }
    if(menuId==13){
        [self performSegueWithIdentifier:@"GotoGEOTag" sender:self];
    }
    if(menuId==14){
        [self performSegueWithIdentifier:@"ActivityMain" sender:self];
    }
    if(menuId==15){
        [self closeMenuView];
        [self moveMeetingVC];
    }
    if(menuId==16){
        [_meetData clearCallMeet];
        [self performSegueWithIdentifier:@"gotoSurvey" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"mGoPresentation"]){
        PresentationSelCtrl *vc=[segue destinationViewController];
        //vc.ModeScr=@"Prepare";
    }
    if([[segue identifier] isEqualToString:@"EditFeedback"])
    {
        FeedbackCtrl *vc= [segue destinationViewController];
        vc.isForEdit =YES;
    }
}
-(IBAction) openMeeting:(id)sender{
    UIButton* btn=(UIButton*) sender;
    NSString* url=[[_MeetDatas[btn.tag] valueForKey:@"API_Meeting_Url"]  stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    NSString *mystr=[[NSString alloc] initWithFormat:@"msteams://%@",url];
    /*
    self.meetData.CustCode=self.CustCode;
    self.meetData.CustName=self.CustName;
    self.meetData.CusType=@"1";
    self.meetData.SpecCode=self.SpecCode;
    self.meetData.CateCode=self.CateCode;
    self.meetData.vstTime=[BaseViewController getDateTime];
    self.meetData.ModTime=[BaseViewController getDateTime];
    self.meetData.mappedProds=self.mappedProds;
    */
    NSLog(@"%@",mystr);
    NSArray* DrCds=[[_MeetDatas[btn.tag] valueForKey:@"DrDets"] componentsSeparatedByString:@","];
    if([DrCds count]>0){
        NSArray* DrDets=[DrCds[0] componentsSeparatedByString:@"^"];
        self.meetData.CustCode=DrDets[0];
        self.meetData.CustName=DrDets[1];
        self.meetData.CusType=@"1";
        self.meetData.SpecCode=DrDets[2];
        self.meetData.CateCode=DrDets[3];
        self.meetData.vstTime=[BaseViewController getDateTime];
        self.meetData.ModTime=[BaseViewController getDateTime];
        self.meetData.DataSF=DrDets[4];
        //self.mappedProds=
        
       
        NSMutableArray* sArr=[[NSMutableArray alloc] init];
        for(int il=1;il<[DrCds count]-1;il++){
            NSMutableDictionary* itm=[[NSMutableDictionary alloc] init];
            NSArray* DrDets=[DrCds[il]  componentsSeparatedByString:@"^"];
            [itm setValue:DrDets[0] forKey:@"Code"];
            [itm setValue:DrDets[1] forKey:@"Name"];
            [sArr addObject:itm];
        }
        self.meetData.AdCuss=sArr;
        //[self performSegueWithIdentifier:@"mGoPresentation" sender:self];
        //self.meetData.mappedProds=self.mappedProds;
        if (self.SetupData.RatingBasedSlide==1){
            _meetData.RatingSlideIds=@"";
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showWithStatus:NSLocalizedString(@"Getting Slides For Rating",@"Getting Slides For Rating")];
           
            [WBService SendServerRequest:@"GET/RatingSlides" withParameter:[@{@"CusCode":DrDets[0]} mutableCopy] withImages:nil DataSF:nil
                completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                     NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                    NSString *sSlNos=[[NSString alloc] init];
                    for(int il=0;il<[receivedDta count];il++){
                        sSlNos=[NSString stringWithFormat:@"%@%@,",sSlNos,[receivedDta[il] valueForKey:@"SI_NO"]];
                    }
                    _meetData.RatingSlideIds=[NSString stringWithFormat:@",%@",sSlNos];
                
                NSURL *myurl=[[NSURL alloc] initWithString:mystr];
                
                [[UIApplication sharedApplication] openURL:myurl];
                [self performSegueWithIdentifier:@"mGoPresentation" sender:self];
                [SVProgressHUD dismiss];
                }
                error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                      NSLog(@"%@",errorMsg);
                
                NSURL *myurl=[[NSURL alloc] initWithString:mystr];
                
                [[UIApplication sharedApplication] openURL:myurl];
                [self performSegueWithIdentifier:@"mGoPresentation" sender:self];
                [SVProgressHUD dismiss];
                }];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tbvwMeetings) return 64.0f;
    return 54.0f;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TBSelectionBxCell* cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (tableView==_tbvwMeetings)
    {
        if(cell.lblDynText==nil)
        {
            
            cell.lblDynText=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width,25)];
            [cell addSubview:cell.lblDynText];
            
            cell.lOptSImg=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-40, 5,15, 15)];
            [cell addSubview:cell.lOptSImg];
            
            cell.lblDynfrom=[[UILabel alloc] initWithFrame:CGRectMake(10, 25, cell.frame.size.width/2, 15)];
            [cell addSubview:cell.lblDynfrom];
        
            cell.lblDynTo=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width/2, 25, cell.frame.size.width/2, 15)];
            [cell addSubview:cell.lblDynTo];
            cell.lblDynGuest=[[UILabel alloc] initWithFrame:CGRectMake(10, 40, cell.frame.size.width/2, 20)];
            [cell addSubview:cell.lblDynGuest];
        
            cell.btnDynJoin=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-110, 40, 100, 20)];
            cell.btnDynJoin.layer.cornerRadius=5;
            [cell.btnDynJoin setTitle:NSLocalizedString(@"Start Meeting", @"Start Meeting") forState:UIControlStateNormal];
            cell.btnDynJoin.backgroundColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
            [cell.btnDynJoin.titleLabel setFont:[UIFont fontWithName:@"Poppins-Regular" size:11.0]];
            [cell addSubview:cell.btnDynJoin];
        }
        cell.lblDynText.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
        cell.lblDynText.text = [_MeetDatas[indexPath.row] objectForKey:@"Meeting_Sub"];
        
        cell.lblDynfrom.font=[UIFont fontWithName:@"Poppins-Regular" size:10.0];
        cell.lblDynfrom.text = [[_MeetDatas[indexPath.row] objectForKey:@"Sch_StartTime"] objectForKey:@"date"];
        cell.lblDynGuest.font=[UIFont fontWithName:@"Poppins-Regular" size:10.0];
        cell.lblDynGuest.text = [NSString stringWithFormat:@"%i Participants",[[_MeetDatas[indexPath.row] objectForKey:@"PartiCnt"] intValue]];
        
        UIColor* clr=nil;
        NSString *Stat=[_MeetDatas[indexPath.row] objectForKey:@"Stat"];
        if([Stat isEqual: @"NO"]){
            clr=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        } else if ([Stat isEqual: @"YES"]) {
            clr=[UIColor colorWithRed:48.0f/255 green:202.0f/255 blue:65.0f/255 alpha:1.0f];
        } else if ([Stat isEqual: @"MAYBE"]) {
            clr=[UIColor colorWithRed:243.0f/255 green:123.0f/255 blue:12.0f/255 alpha:1.0f];
        }
        //if(clr!=nil){    txtInField.layer.borderWidth=1.0f;
        cell.lOptSImg.image=nil;
        cell.lOptSImg.tintColor=clr;
        cell.lOptSImg.backgroundColor=clr;
        cell.lOptSImg.layer.cornerRadius=5;
        cell.lOptSImg.layer.borderWidth=1.0f;
        cell.lOptSImg.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
        
        cell.lblDynTo.font=[UIFont fontWithName:@"Poppins-Regular" size:10.0];
        cell.lblDynTo.text = [[_MeetDatas[indexPath.row] objectForKey:@"Sch_EndTime"] objectForKey:@"date"];
        NSString* Dtstr=[[_MeetDatas[indexPath.row] objectForKey:@"Sch_EndTime"] objectForKey:@"date"];
        NSDate* Dt=[BaseViewController str2date:Dtstr];
        NSDate* Dt1=[NSDate date];
        
        [cell.btnDynJoin setTitle:NSLocalizedString(@"Start Meeting", @"Start Meeting") forState:UIControlStateNormal];
        cell.btnDynJoin.enabled=YES;
        if(Dt.timeIntervalSince1970<Dt1.timeIntervalSince1970){
            [cell.btnDynJoin setTitle:NSLocalizedString(@"Meeting Ended", @"Meeting Ended") forState:UIControlStateNormal];
            cell.btnDynJoin.backgroundColor=[UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1.0f];
            cell.btnDynJoin.enabled=NO;
        }
        [cell.btnDynJoin addTarget:self action:@selector(openMeeting:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDynJoin.tag=indexPath.row;
    }else{
        NSDictionary *optLst = self.Sidemenulist[indexPath.row];
        cell.lOptImg.image=[UIImage imageNamed:[optLst objectForKey:@"image"] ];
        cell.lOptText.text = NSLocalizedString([optLst objectForKey:@"name"], [optLst objectForKey:@"name"]);
        cell.lOptText.tag=[[optLst objectForKey:@"tag"] intValue];
        
        CALayer *upperBorder = [CALayer layer];
        upperBorder.backgroundColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        if(indexPath.row){
            upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(cell.frame), 1.0f);
            [cell.layer addSublayer:upperBorder];
        }
        upperBorder.frame = CGRectMake(0,CGRectGetHeight(cell.frame)-1.0f,CGRectGetWidth(cell.frame), 1.0f);
        [cell.layer addSublayer:upperBorder];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_tbvwMeetings) return self.MeetDatas.count;
    return self.Sidemenulist.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"testing....");
    TBSelectionBxCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    self.meetData.MissedEntry=NO;
    [self.MissedEntry clearMissedEntry];
    int mID=(int)cell.lOptText.tag;
    if(mID==6){
        _locationData.userSignedIn=NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(mID==7){
        [self closeMenuView];
        [self showTPWindow];
    }
    else if(mID==12){
        [self closeMenuView];
       // [self showMissDtWindow];
        [self performSegueWithIdentifier:@"ShowMissesdDates" sender:self];
    }
    else
    {
        [self closeMenuView];
        [self NavMenuItem:(int)cell.lOptText.tag];
    }
    [self.tvSideMenu reloadData];
}
-(IBAction) showNotificationList:(id)sender {
    
     UIButton* btn=(UIButton *) sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NotificationListViewController *popVC = [storyboard instantiateViewControllerWithIdentifier:@"NotifyListCtrl"];
    [self presentViewController:popVC animated:YES completion:nil];    //popVC.NvMain=self;
    
    /*UIButton* btn=(UIButton *) sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NotifyListPopViewController *popVC = [storyboard instantiateViewControllerWithIdentifier:@"NotifyListCtrlOld"];
    popVC.NvMain=self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:popVC animated:YES completion:nil];
    }
    else {
        popVC.modalPresentationStyle = UIModalPresentationPopover;
        popVC.preferredContentSize = CGSizeMake(420,490);
        UIPopoverPresentationController *popController = [popVC popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        popController.delegate = self;
        popController.sourceView = btn;
        popController.sourceRect = btn.bounds;
        
        [self presentViewController:popVC animated:YES completion:nil];
    }*/
    
}
-(void) setSetupValues{
    NSMutableArray* AppSetups=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Settings.SANAPP"] mutableCopy];
    self.SetupData.DrPolicy=[[AppSetups[0] valueForKey:@"DrPolicy"] intValue];
    self.SetupData.inputMandate=[[AppSetups[0] valueForKey:@"DrInpMd"] intValue];
    self.SetupData.RCPAMandate=[[AppSetups[0] valueForKey:@"RcpaNd"] intValue];
    self.SetupData.GeoNeed=[[AppSetups[0] valueForKey:@"GeoNeed"] intValue];
    self.SetupData.GeoFencing=[[AppSetups[0] valueForKey:@"GEOTagNeed"] intValue];
    self.SetupData.DrNextVisit=[[AppSetups[0] valueForKey:@"DrNxtVst"] intValue];
    self.SetupData.DrNextVisitMandate=[[AppSetups[0] valueForKey:@"DrNxtVstMd"] intValue];
    self.SetupData.DrCallType=[[AppSetups[0] valueForKey:@"DrCallTyp"] intValue];
    self.SetupData.DrCallTypeMandate=[[AppSetups[0] valueForKey:@"DrCallTypMd"] intValue];
    self.SetupData.SkipSlideDemo=[[AppSetups[0] valueForKey:@"SkipSlideDemo"] intValue];
    self.SetupData.OnlyBRtFeed=[[AppSetups[0] valueForKey:@"OnlyBRtFeed"] intValue];
    self.SetupData.SampRating=[[AppSetups[0] valueForKey:@"SampRating"] intValue];
    self.SetupData.MaxStarRate=[[AppSetups[0] valueForKey:@"MaxStarRate"] intValue];
    self.SetupData.AddNewDrNeed=[[AppSetups[0] valueForKey:@"AddNewDrNeed"] intValue];
    self.SetupData.GPSSegNeed=[[AppSetups[0] valueForKey:@"GPSSegNeed"] intValue];
    self.SetupData.MissedEntry=[[AppSetups[0] valueForKey:@"MissedEntry"] intValue];
    self.SetupData.SmplQtyMnd=[[AppSetups[0] valueForKey:@"SmplQtyMnd"] intValue];
    self.SetupData.RatingBasedSlide=[[AppSetups[0] valueForKey:@"RatingBasedSlide"] intValue];
    self.SetupData.MeetEventNeed=[[AppSetups[0] valueForKey:@"MeetEventNeed"] intValue];
    self.SetupData.ActivityNeed=[[AppSetups[0] valueForKey:@"ActivityNeed"] intValue];
    self.SetupData.NActivityNeed=[[AppSetups[0] valueForKey:@"NActivityNeed"] intValue];
    self.SetupData.DrActivityNeed=[[AppSetups[0] valueForKey:@"DrActivityNeed"] intValue];
    self.SetupData.ChmActivityNeed=[[AppSetups[0] valueForKey:@"ChmActivityNeed"] intValue];
    self.SetupData.StkActivityNeed=[[AppSetups[0] valueForKey:@"StkActivityNeed"] intValue];
    self.SetupData.NdrActivityNeed=[[AppSetups[0] valueForKey:@"NdrActivityNeed"] intValue];
    
    self.SetupData.DrSurveyNeed=[[AppSetups[0] valueForKey:@"DrSurveyNeed"] intValue];
    self.SetupData.ChmSurveyNeed=[[AppSetups[0] valueForKey:@"ChmSurveyNeed"] intValue];
    self.SetupData.StkSurveyNeed=[[AppSetups[0] valueForKey:@"StkSurveyNeed"] intValue];
    self.SetupData.NdrSurveyNeed=[[AppSetups[0] valueForKey:@"NdrSurveyNeed"] intValue];
    self.SetupData.showSurvey=[[AppSetups[0] valueForKey:@"SurveyNd"] intValue];

    self.SetupData.HospBased=[[AppSetups[0] valueForKey:@"HospBased"] intValue];
    
    self.SetupData.CapSDP=[AppSetups[0] valueForKey:@"CapChm"];
    self.SetupData.CapDr=[AppSetups[0] valueForKey:@"DrCap"];
    self.SetupData.CapChm=[AppSetups[0] valueForKey:@"ChmCap"];
    self.SetupData.CapStk=[AppSetups[0] valueForKey:@"StkCap"];
    self.SetupData.CapUdr=[AppSetups[0] valueForKey:@"NLCap"];
    self.SetupData.CapHos=[AppSetups[0] valueForKey:@"HosCap"];
    
    self.SetupData.CapCate=[AppSetups[0] valueForKey:@"CateName"];
    self.SetupData.CapSpec=[AppSetups[0] valueForKey:@"SpecName"];
    self.SetupData.CapTerr=[AppSetups[0] valueForKey:@"TerrName"];
    self.SetupData.CapQua=[AppSetups[0] valueForKey:@"CapQua"];
    if([[AppSetups[0] valueForKey:@"ReloadData"] isEqualToString:@"1"]){
        self.dataLoaded=NO;
        [self loadDatas];
    }
    if([self.UserDet.Desig isEqualToString:@"MR"]){
        if([[AppSetups[0] valueForKey:@"ReloadTER"] isEqualToString:@"1"]){
            [self LoadData:@"GET/Territory" withParam:nil andDataFor:self.UserDet.SF andkey:[NSString  stringWithFormat:@"TerritoryDetails_%@.SANAPP",self.UserDet.SF]];
        }
        if([[AppSetups[0] valueForKey:@"ReloadDR"] isEqualToString:@"1"]){
            [self LoadData:@"GET/Doctors" withParam:nil andDataFor:self.UserDet.SF andkey:[NSString  stringWithFormat:@"DoctorDetails_%@.SANAPP",self.UserDet.SF]];
            
        }
        if([[AppSetups[0] valueForKey:@"ReloadCHM"] isEqualToString:@"1"]){
            [self LoadData:@"GET/Chemist" withParam:nil andDataFor:self.UserDet.SF andkey:[NSString  stringWithFormat:@"ChemistDetails_%@.SANAPP",self.UserDet.SF]];
        }
        if([[AppSetups[0] valueForKey:@"ReloadSTK"] isEqualToString:@"1"]){
            [self LoadData:@"GET/Stockist" withParam:nil andDataFor:self.UserDet.SF andkey:[NSString  stringWithFormat:@"StockistDetails_%@.SANAPP",self.UserDet.SF]];
        }
    }
}

-(void) loadSetups{
    [WBService SendServerRequest:@"GET/Setups" withParameter:nil withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        
         [WBService saveData:receivedDta forKey:@"Settings.SANAPP"];
        [self setSetupValues];
        [self loadMenus];
    }
    error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
        [self setSetupValues];
        [self loadMenus];
        
    }];
}
-(void) LoadData:(NSString *) apiPath withParam:(NSMutableDictionary *) param andDataFor:(NSString *)dataSF andkey:(NSString *) key{
           [WBService SendServerRequest:apiPath withParameter:param withImages:nil DataSF:dataSF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
               NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
               [WBService saveData:receivedDta forKey:key];
           }
           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
               NSLog(@"%@",errorMsg);
           }
     ];
}
@end
