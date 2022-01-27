//
//  xAxisLabelFormatter.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 20/12/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "xAxisLabelFormatter.h"

@implementation xAxisLabelFormatter
/*static xAxisLabelFormatter *AxisFormtr = NULL;

+(xAxisLabelFormatter *)SetDatas{
    @synchronized (AxisFormtr) {
        if (!AxisFormtr || AxisFormtr==NULL) {
            AxisFormtr=[[xAxisLabelFormatter alloc] init];
        }
        return AxisFormtr;
    }
 }*/
- (id)initWithData:(NSMutableArray*)data
{
    self = [super init];
    if (self)
    {
        self.LabelTextList = [[NSMutableArray alloc] initWithArray:data];
    }
    return self;
}
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    NSMutableArray *lblText=[[self.LabelTextList  filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id=='%i'", (int)value]]] mutableCopy];
    return ([lblText count]>0)?[lblText[0] valueForKey:@"label"]:@"";
}
@end
