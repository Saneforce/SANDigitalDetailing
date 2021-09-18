    //
//  MainHomeController.h
//  SANAPP
//
//  Created by SANeForce.com on 04/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDyTPvwCtrl.h"
#import "BaseViewController.h"
#import "PNChartDelegate.h"
#import "PNChart.h"
#import <Charts/Charts-umbrella.h>

@interface MainHomeController : UIViewController <UINavigationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,PNChartDelegate,UIScrollViewDelegate>{
    NSArray* MasterList;
    NSArray* SFsMaster;
}
@property (nonatomic,strong) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,strong) MissedEntryData *MissedEntry;
@property (nonatomic,strong) Config* config;
@property (nonatomic,strong) LocationDetail* locationData;
@property (nonatomic, strong) AppSetupData* SetupData;

@property (nonatomic,strong) TdayPlDetail* TdayPl;

@property (nonatomic) IBOutlet PNCircleChart * circleChart;
@property (nonatomic) IBOutlet PNBarChart * barChart;
@property (nonatomic) IBOutlet PNPieChart * pieChart;


@property (nonatomic, strong) IBOutlet UIViewController* currentViewController;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* Menuleft;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* nsScrollWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* vwTodyCallWidth;

@property (nonatomic, weak) IBOutlet UIImageView  *profileImg;
@property (nonatomic, weak) IBOutlet UIImageView  *vwNotifyImg;

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionView* clViewCalls;

@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layoutcalls;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;
@property (nonatomic, weak) IBOutlet UIView* vwTPView;
@property (nonatomic, weak) IBOutlet UIView* vwMenu;
@property (nonatomic, weak) IBOutlet UIView* vwModal;
@property (nonatomic, weak) IBOutlet UIView* vwCallsList;
@property (nonatomic, weak) IBOutlet UIView* vwChartCallAvg;
@property (nonatomic, weak) IBOutlet UIView* vwPieChart;
@property (nonatomic, weak) IBOutlet UITextView* tvRemk;

@property (nonatomic, weak) IBOutlet UILabel* lblhPieChart;
@property (nonatomic, weak) IBOutlet UILabel* lblhBarChart;
@property (nonatomic, weak) IBOutlet UILabel* lblDispSF;
@property (nonatomic, weak) IBOutlet UILabel* lblWTType;
@property (nonatomic, weak) IBOutlet UILabel* lblClust;

@property (nonatomic, weak) IBOutlet UILabel* lblCallCnt;
@property (nonatomic, weak) IBOutlet UILabel* lblLat;
@property (nonatomic, weak) IBOutlet UILabel* lblLng;
@property (nonatomic, weak) IBOutlet UIButton *btnLocIndic;

@property (nonatomic, weak) IBOutlet UIView *vwDashboard;
@property (nonatomic, weak) IBOutlet UIScrollView *scrlDashboard;
@property (nonatomic, weak) IBOutlet UIPageControl* PageIndicator;

@property (nonatomic, weak) IBOutlet UITableView* tvSideMenu;

@property (weak, nonatomic) IBOutlet UILabel *lblCLuster;



-(IBAction)logOutUser:(id)sender;
-(void) reloadSubCalls;
-(void) openTourPlan;
-(void) NavMenuItem:(int) menuId;
@end
