//
//  IPhoneHomeCtrlr.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 25/10/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDyTPvwCtrl.h"
#import "BaseViewController.h"

@interface IPhoneHomeCtrlr : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

@end
