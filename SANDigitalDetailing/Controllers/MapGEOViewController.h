//
//  MapGEOViewController.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 03/01/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBSelectionBxCell.h"
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Pin.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapGEOViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UserDetails* UserDet;

@property (nonatomic,strong) NSArray *objHQList;
@property (nonatomic,weak) NSString* DataSF;

@property (nonatomic,weak) IBOutlet MKMapView* MapView;
@property (nonatomic,weak) IBOutlet UITableView* tvSHPlace;
@property (nonatomic,weak) IBOutlet UITableView* tvEMode;
@property (nonatomic,weak) IBOutlet UITableView* tbHQ;
@property (nonatomic,retain) IBOutlet UILabel* lblCurrAddress;
@property (nonatomic,retain) IBOutlet UILabel* lblDrName;
@property (nonatomic,retain) IBOutlet UILabel* lblLatLong;
@property (nonatomic,retain) IBOutlet UILabel* lblHQ;

@property (nonatomic,retain) IBOutlet UITextField* tSearchAddress;
@property (nonatomic,retain) IBOutlet UITextField* searchBox;
@property (nonatomic,retain) IBOutlet UITextField* txtHQ;
@property (nonatomic,retain) IBOutlet UITextView* tAddress;
@property (nonatomic,retain) IBOutlet UIButton* btnSearch;
@property (nonatomic,retain) IBOutlet UIButton* btnCloseSearch;
@property (nonatomic,retain) IBOutlet UIButton* btnNewTag;
@property (nonatomic,retain) IBOutlet UIButton* btnLocPin;
@property (nonatomic,retain) IBOutlet UIButton* btnMode;
@property (nonatomic,retain) IBOutlet UISegmentedControl* segTypeMode;
@property (nonatomic,retain) IBOutlet UIView* vwCustSelect;
@property (nonatomic,retain) IBOutlet UIView* vwCustDet;
@property (nonatomic,retain) IBOutlet UIView* vwNewCustDet;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

@end

NS_ASSUME_NONNULL_END
