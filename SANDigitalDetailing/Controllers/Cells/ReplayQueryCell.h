//
//  ReplayQueryCell.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 01/11/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBSelectionBxCell.h"
@interface ReplayQueryCell : UICollectionViewCell <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LClblLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LClblRight;

@property (nonatomic, weak) IBOutlet UILabel* lMainQuery;
@property (nonatomic, weak) IBOutlet UILabel* lQueryDt;
@property (nonatomic, weak) IBOutlet UITableView* tbQryReply;
@property (nonatomic, weak) IBOutlet UITextView* tQueryMsg;
@property (nonatomic, strong) NSMutableArray* tblOptList;
@end

