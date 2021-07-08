//
//  ReplayQueriesView.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 30/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReplayQueriesView : UIViewController
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

@property (nonatomic, weak) IBOutlet UILabel* lDrName;

@end

NS_ASSUME_NONNULL_END
