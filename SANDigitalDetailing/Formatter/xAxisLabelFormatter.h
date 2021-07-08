//
//  xAxisLabelFormatter.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 20/12/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Charts-Swift.h"
NS_ASSUME_NONNULL_BEGIN

@interface xAxisLabelFormatter : NSObject<IChartAxisValueFormatter>

@property (nonatomic, strong) NSMutableArray* LabelTextList;
- (id)initWithData:(NSArray*)data;
@end

NS_ASSUME_NONNULL_END
