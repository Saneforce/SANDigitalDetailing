//
//  downloaderView.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 11/10/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface downloaderView : UIViewController <UITableViewDelegate, UITableViewDataSource,NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblFiles;

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;

@property (nonatomic, strong) NSURL *docDirectoryURL;
- (void) startAllDownloads;
- (void)initialize;
@end
