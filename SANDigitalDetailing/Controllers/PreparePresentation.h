//
//  PreparePresentation.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 16/03/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "BaseViewController.h"

@interface PreparePresentation : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView* slideCollectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* slideLayout;

@property (nonatomic, weak) IBOutlet UICollectionView* prodCollectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* prodLayout;

//@property (nonatomic, weak) IBOutlet UITableView* tvProdList;
@property (nonatomic, weak) IBOutlet UITableView* tvPrsntGrpList;

@property (nonatomic, retain) IBOutlet UIImageView* movingCell;

@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnSaveSlideGrp;
@property (nonatomic, weak) IBOutlet UIButton* btnCancelEdit;

@property (nonatomic, retain) IBOutlet UIView* ddrPrsntModal;
@property (nonatomic, retain) IBOutlet UIView* ddrPrsntGrp;

@property (nonatomic, retain) IBOutlet UITextField* txtGroupName;
-(IBAction)CancelPresentation:(id)sender;
@end
