//
//  PresentationSelCtrl.h
//  SANAPP
//
//  Created by SANeForce.com on 13/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIView+RoudedCorners.h"

@interface PresentationSelCtrl : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic, strong) AppSetupData* SetupData;
@property (nonatomic, strong) Slide* currentSlide;

@property (nonatomic, weak) IBOutlet UICollectionView* slideCollectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* slideLayout;

@property (nonatomic, weak) IBOutlet UICollectionView* specCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *lblCusName;
@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnStartDemo;
@property (nonatomic, weak) IBOutlet UIImageView* btnStartDemoImg;
@property (nonatomic, weak) IBOutlet UIButton* btnSaveSlideGrp;
@property (nonatomic, weak) IBOutlet UIButton* btnSkipDetailing;
@property (nonatomic, weak) IBOutlet UIButton* btnFilterType;
@property (nonatomic, weak) IBOutlet UITableView* tvFilterType;
@property (nonatomic, weak) IBOutlet UITableView* tvProdList;
@property (nonatomic, weak) IBOutlet UIView* vwFilter;

@property (nonatomic,weak) NSString *ModeScr;

@property (strong, nonatomic) IBOutlet UISegmentedControl * segmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *imgForward;
@property (weak, nonatomic) IBOutlet UIButton *btnFilterSpec;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrntSpecFilterViewOrigin;
@property (weak, nonatomic) IBOutlet UIView *vwSpecFilter;

- (IBAction)btnFilterSpec:(id)sender;
- (IBAction)btnCloseFilter:(id)sender;

-(IBAction)CancelPresentation:(id)sender;

@end
