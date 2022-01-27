//
//  MissedEntryData.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/06/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissedEntryData : NSObject

@property (nonatomic,strong) NSMutableArray *MissDatas;
@property (nonatomic,assign) long SelectedIndex;

+(MissedEntryData *)sharedDatas;
-(void)clearMissedEntry;
@end

NS_ASSUME_NONNULL_END
