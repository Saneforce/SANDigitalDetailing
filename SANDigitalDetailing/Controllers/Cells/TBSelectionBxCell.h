//
//  TBSelectionBxCell.h
//  SANAPP
//
//  Created by SANeForce.com on 17/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRatingView.h"
@class TBSelectionBxCell;

@protocol TBSelectionBxCellDelegate

    -(void)didSetRating: (StarRatingView *) starRating andIndexPath:(NSIndexPath *) indexPath andUserEvent:(BOOL)userEvent;

@optional

    -(void)didChecked: (TBSelectionBxCell *) Cell andIndexPath:(NSIndexPath *) indexPath;
@end

@interface TBSelectionBxCell : UITableViewCell<StarRatingViewDelegate>

@property (nonatomic, retain) UIButton* btnDynJoin;
@property (nonatomic, retain) UILabel* lblDynText;
@property (nonatomic, retain) UILabel* lblDynfrom;
@property (nonatomic, retain) UILabel* lblDynTo;
@property (nonatomic, retain) UILabel* lblDynGuest;;
@property (nonatomic, retain) UIImageView* lOptSImg;

@property (nonatomic, weak) IBOutlet UILabel* lOptText;
@property (nonatomic, weak) IBOutlet UILabel* lOptVal;
@property (nonatomic, weak) IBOutlet UILabel* lOptFDate;
@property (nonatomic, weak) IBOutlet UILabel* lOptTDate;
@property (nonatomic, weak) IBOutlet UILabel* lOptLDays;
@property (nonatomic, weak) IBOutlet UILabel* lOptDesc;
@property (nonatomic, weak) IBOutlet UILabel* lOptDrCnt;
@property (nonatomic, weak) IBOutlet UILabel* lOptParti;
@property (nonatomic, weak) IBOutlet UILabel* lOptLType;
@property (nonatomic, weak) IBOutlet UILabel* lOptLAva;

@property (nonatomic, weak) IBOutlet UIImageView* lOptImgStatus;
@property (nonatomic, weak) IBOutlet UIImageView* lOptImg;
@property (nonatomic, weak) IBOutlet UILabel* lOptTimeLine;
@property (nonatomic, weak) IBOutlet UITextView* lOptTextvw;
@property (nonatomic, weak) IBOutlet UITextView* lOptTVwAddOnLv;
@property (nonatomic, weak) IBOutlet StarRatingView* starRating;
@property (nonatomic, weak) id<TBSelectionBxCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton* btnVal1;
@property (nonatomic, weak) IBOutlet UIButton* btnVal2;
@property (nonatomic, weak) IBOutlet UIButton* btnVal3;
@property (nonatomic, weak) IBOutlet UIButton* btnCheked;
@property (nonatomic, assign) BOOL Checked;
@property (nonatomic, weak) IBOutlet UIButton* btnSync;
@property (nonatomic, weak) IBOutlet UIButton* btnDel;
@property (nonatomic, weak) IBOutlet UIButton* btnEdit;
@property (nonatomic, weak) IBOutlet UIButton* btnCnf;
@property (nonatomic, weak) IBOutlet UIButton* btnCmpt;
@property (nonatomic, weak) IBOutlet UIButton* btnCmptProd;
@property (nonatomic, assign) IBOutlet UITextField* txtSmpQty;
@property (nonatomic, assign) IBOutlet UITextField* txtRxQty;
@property (nonatomic, assign) IBOutlet UITextField* txtInpQty;

@property (nonatomic, assign) IBOutlet UITextField* txtCompName;
@property (nonatomic, assign) IBOutlet UITextField* txtCPName;
@property (nonatomic, assign) IBOutlet UITextField* txtCPQty;
@property (nonatomic, assign) IBOutlet UITextField* txtCPRate;
@property (nonatomic, assign) IBOutlet UITextField* txtCPValue;
@property (nonatomic, assign) IBOutlet UITextField* txtCName;
@property (nonatomic, assign) IBOutlet UITextField* txtDName;
@property (nonatomic, assign) IBOutlet UITextField* txtSTime;
@property (nonatomic, assign) IBOutlet UITextField* txtETime;
@property (nonatomic, assign) IBOutlet UITextField* txtInjected;


@property (nonatomic, weak) IBOutlet UIButton* btnInfo;


@property (nonatomic, weak) IBOutlet UILabel* lCPName;
@property (nonatomic, weak) IBOutlet UILabel* lCPQty;
@property (nonatomic, weak) IBOutlet UILabel* lCPRate;
@property (nonatomic, weak) IBOutlet UILabel* lCPValue;

@property UITapGestureRecognizer *TapRecognizer;

-(void) setRatingValue:(int)value;
@end
