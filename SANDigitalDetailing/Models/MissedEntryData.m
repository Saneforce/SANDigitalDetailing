//
//  MissedEntryData.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/06/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "MissedEntryData.h"

@implementation MissedEntryData
static MissedEntryData *MissEntry= NULL;
@synthesize MissDatas,SelectedIndex;

+(MissedEntryData *)sharedDatas{
    @synchronized (MissEntry) {
        if (!MissEntry || MissEntry==NULL) {
            MissEntry=[[MissedEntryData alloc] init];
            MissEntry.MissDatas=[[NSMutableArray alloc] init];
            MissEntry.SelectedIndex=-1;
        }
        return MissEntry;
    }
}
-(void)clearMissedEntry{
    @synchronized(MissEntry) {
        if (MissEntry != nil) {
            MissEntry = nil;
        }
    }
}
@end
