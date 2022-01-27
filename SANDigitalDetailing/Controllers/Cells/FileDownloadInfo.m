//
//  FileDownloadInfo.m
//  BCTransferDemo
//
//  Created by SANeForce.com on 10/10/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "FileDownloadInfo.h"

@implementation FileDownloadInfo
-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source andEffDt:(NSString *)EffDt{
    if (self == [super init]) {
        self.fileTitle = title;
        self.downloadSource = source;
        self.downloadProgress = 0.0;
        self.isDownloading = NO;
        self.downloadComplete = NO;
        self.taskIdentifier = -1;
        self.dateEffect = EffDt;
    }
    
    return self;
}
@end
