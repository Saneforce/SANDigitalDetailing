//
//  VwCReportMenu.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 07/05/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface VwCReportMenu : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) BaseViewController *BaseCtrlr;
@property (nonatomic,strong) Config* config;
@property (nonatomic,strong) UserDetails* UserDet;

@property (nonatomic, weak) IBOutlet UIImageView  *profileImg;
@property (nonatomic, weak) IBOutlet UILabel* lblDispSF;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

-(IBAction) gotoHome:(id)sender;
@end
