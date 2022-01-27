//
//  FileDownloadInfo.h
//  BCTransferDemo
//
//  Created by SANeForce.com on 10/10/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloadInfo : NSObject

@property (nonatomic, strong) NSString *fileTitle;

@property (nonatomic, strong) NSString *downloadSource;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSData *taskResumeData;

@property (nonatomic) double downloadProgress;

@property (nonatomic) BOOL isDownloading;

@property (nonatomic) BOOL downloadComplete;

@property (nonatomic) unsigned long taskIdentifier;
@property (nonatomic, strong) NSString* dateEffect;
@property (nonatomic, strong) NSString* DwnDataSize;

-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source andEffDt:(NSString *)EffDt;

@end