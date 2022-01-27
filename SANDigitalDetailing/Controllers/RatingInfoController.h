//
//  RatingInfoController.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 19/11/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RatingInfoController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvRatingInf;
@end

