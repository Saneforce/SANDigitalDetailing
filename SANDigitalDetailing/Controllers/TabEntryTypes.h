//
//  TabEntryTypes.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 08/06/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarSubmit.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabEntryTypes : UITabBarController

@property (nonatomic, strong) AppSetupData* SetupData;
@property (nonatomic,weak) IBOutlet TabBarSubmit *tabETyp;
@end

NS_ASSUME_NONNULL_END
