//
//  downloaderView.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 11/10/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "downloaderView.h"

#import "AppDelegate.h"
#import "FileDownloadInfo.h"
#import "BaseViewController.h"
#import "Config.h"
#import "MainHomeController.h"
#define CellLabelTagValue               10
#define CellProgressBarTagValue         20
#define CellLabelRBytes                 30
#define CellLabelReadyTagValue          40
#define CellbtnPasueTagValue            50

@class downloaderView;
@protocol downloaderViewDelegate <NSObject>
-(void)dismissTargetVC:(downloaderView*)vc;
@end
@interface downloaderView ()

@property (nonatomic, strong) NSArray* SlideList;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) int downloadCompleted;
@property BOOL ErrorShown;

@property BOOL DownLoadErr;
-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier;
@property (nonatomic, weak) id<downloaderViewDelegate> delegate;
@end

@implementation downloaderView
AppDelegate *appDelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.docDirectoryURL = [URLs objectAtIndex:0];
    self.docDirectoryURL = [self.docDirectoryURL URLByAppendingPathComponent:@"Slides"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.docDirectoryURL path]]) {
        [BaseViewController deleteDirectory:[self.docDirectoryURL path]];
    }
    [BaseViewController createFolder: [self.docDirectoryURL path]];
    
    self.tblFiles.delegate = self;
    self.tblFiles.dataSource = self;
    self.downloadCompleted=0;
    _ErrorShown=NO;
    _DownLoadErr=NO;
    appDelegate = [UIApplication sharedApplication].delegate;
    Config *config=[Config sharedConfig];
    self.SlideList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"ProdSlides.SANAPP"] mutableCopy];
    self.arrFileDownloadData =[[NSMutableArray alloc] init];
    NSString* strSlidePageUrls=@"";
    for(NSDictionary* slide in self.SlideList)
    {
        NSDictionary *effDt=[slide objectForKey:@"Eff_from"];
        NSDate *dteff=[BaseViewController str2date:[effDt valueForKey:@"date"]];
        NSString *EffDT=[BaseViewController date2str:dteff onlyDate:YES];
        
        
        NSString* SlidePageUrl = [NSString stringWithFormat:@"%@%@", config.SlideUrl, [slide objectForKey:@"FilePath"]];
        if(![strSlidePageUrls containsString:[NSString stringWithFormat:@"%@;",SlidePageUrl]]){
            [self.arrFileDownloadData addObject:[[FileDownloadInfo alloc] initWithFileTitle:[slide objectForKey:@"FilePath"] andDownloadSource:SlidePageUrl andEffDt:EffDT]];
        }
        strSlidePageUrls=[NSString     stringWithFormat:@"%@%@;",strSlidePageUrls,SlidePageUrl];
    }
    
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"SlidesDownloader"];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
    [self invokeBackgroundSessionCompletionHandler];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrFileDownloadData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idCell"];
    }
    
    FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:indexPath.row];
    
    UILabel *displayedTitle = (UILabel *)[cell viewWithTag:10];
    UIProgressView *progressView = (UIProgressView *)[cell viewWithTag:CellProgressBarTagValue];
    UILabel *readyLabel = (UILabel *)[cell viewWithTag:CellLabelReadyTagValue];
    UIButton *btnPasue = (UIButton *)[cell viewWithTag:CellbtnPasueTagValue];
    UILabel *lblRBytes = (UILabel *)[cell viewWithTag:CellLabelRBytes];

    
    NSString *startPauseButtonImageName;
    
    displayedTitle.text = fdi.fileTitle;
    lblRBytes.text = fdi.DwnDataSize;
    
    if (!fdi.isDownloading) {
        progressView.hidden = YES;
        
        BOOL hideControls = (fdi.downloadComplete) ? YES : NO;
        readyLabel.hidden = !hideControls;
        startPauseButtonImageName = (fdi.downloadComplete) ? @"Checked" : @"Play";
    }
    else{
        progressView.hidden = NO;
        progressView.progress = fdi.downloadProgress;
        startPauseButtonImageName = @"Pause";
        
    }
    [btnPasue setImage:[UIImage imageNamed:startPauseButtonImageName] forState:UIControlStateNormal];
    
    return cell;
}
- (void) startAllDownloads{
}
- (void)invokeBackgroundSessionCompletionHandler {
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSUInteger count = [dataTasks count] + [uploadTasks count] + [downloadTasks count];
        
        NSLog(@"%lu",(unsigned long)count);
        if (count>0) {
            for(NSURLSessionTask *task in downloadTasks)
            {
                //if (task.currentRequest.URL.description)
                //{
                    [task cancel];
                    //[self.session invalidateAndCancel];
                //}
            }
           // [self.session invalidateAndCancel];
        }
            // Access all FileDownloadInfo objects using a loop.
        for (int i=0; i<[self.arrFileDownloadData count]; i++) {
                FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
                
                // Check if a file is already being downloaded or not.
                if (!fdi.isDownloading) {
                    // Check if should create a new download task using a URL, or using resume data.
                    if (fdi.taskIdentifier == -1) {
                        fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
                    }
                    else{
                        fdi.downloadTask = [self.session downloadTaskWithResumeData:fdi.taskResumeData];
                    }
                    
                    // Keep the new taskIdentifier.
                    fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                    
                    // Start the download.
                    [fdi.downloadTask resume];
                    
                    // Indicate for each file that is being downloaded.
                    fdi.isDownloading = YES;
                }
            }
            
            // Reload the table view.
            /////[self.tblFiles reloadData];
            
            ///[self dismissViewControllerAnimated:YES completion:nil];
            /*MTAppDelegate *applicationDelegate = (MTAppDelegate *)[[UIApplication sharedApplication] delegate];
            void (^backgroundSessionCompletionHandler)() = [applicationDelegate backgroundSessionCompletionHandler];
            
            if (backgroundSessionCompletionHandler) {
                [applicationDelegate setBackgroundSessionCompletionHandler:nil];
                backgroundSessionCompletionHandler();
            }*/
        
    }];
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
        // Locate the FileDownloadInfo object among all based on the taskIdentifier property of the task.
        int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Calculate the progress.
            fdi.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            UITableViewCell *cell = [self.tblFiles cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            UILabel *lblRBytes = (UILabel *)[cell viewWithTag:CellLabelRBytes];
            
            UIProgressView *progressView = (UIProgressView *)[cell viewWithTag:CellProgressBarTagValue];
            NSString* wByte=[NSByteCountFormatter stringFromByteCount:totalBytesWritten countStyle:NSByteCountFormatterCountStyleFile];
            NSString* TEByte=[NSByteCountFormatter stringFromByteCount:totalBytesExpectedToWrite countStyle:NSByteCountFormatterCountStyleFile];
            
            lblRBytes.text=[NSString stringWithFormat:@"%@ / %@", wByte, TEByte];
            fdi.DwnDataSize=[NSString stringWithFormat:@"%@ / %@", wByte, TEByte];
            progressView.progress = fdi.downloadProgress;
        }];
    }
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Change the flag values of the respective FileDownloadInfo object.
    int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
    FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:index];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    
    NSURL *destinationURL  = [self.docDirectoryURL URLByAppendingPathComponent:fdi.dateEffect];
    [BaseViewController createFolder: [destinationURL path]];
    
    NSURL *extractDIR  = destinationURL;
    
    destinationURL = [destinationURL URLByAppendingPathComponent:destinationFilename];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    
    if (success) {
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = YES;
        
        // Set the initial value to the taskIdentifier property of the fdi object,
        // so when the start button gets tapped again to start over the file download.
        fdi.taskIdentifier = -1;
        
        // In case there is any resume data stored in the fdi object, just make it nil.
        fdi.taskResumeData = nil;
        if([[destinationURL pathExtension] isEqual:@"zip"])
        {
            [SSZipArchive unzipFileAtPath:[destinationURL path] toDestination:[extractDIR path]];
            [fileManager removeItemAtURL:destinationURL error:nil];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Reload the respective table view row using the main thread.
            [self.tblFiles reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }
    else{
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error != nil) {
        
        int index = [self getDownloadInfoIndexByTaskIdentifier:task.taskIdentifier];
        
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
        if (index>-1){
            _DownLoadErr=YES;
            _ErrorShown=YES;
            self.downloadCompleted++;
        }
    }
    else{
        NSLog(@"Download finished successfully.");
        self.downloadCompleted++;
    }
    if(self.downloadCompleted>=self.arrFileDownloadData.count){
        if(_ErrorShown==YES){
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Downloading Error"
                                                  message:@"Download completed with error !. Try again later."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }];
            
            [alertController addAction:okAction];
            
        }
        [self.session invalidateAndCancel ];
        //if( [self.delegate respondsToSelector:@selector(dismissTargetVC:)])
        //{
           [self dismissTargetVC:self];
        //}
       // [self URLSessionDidFinishEventsForBackgroundURLSession:self.session];

    }
}
-(void)dismissTargetVC:(downloaderView*)vc
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Call the completion handler to tell the system that there are no other background transfers.
        NSLog(@"All files have been downloaded!");
        
        // Show a local notification when all downloads are over.
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = @"All files have been downloaded!";
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        [vc dismissViewControllerAnimated:YES completion:nil];
    }];


    // you can get relevant data from vc as you still hold reference to it in this block

    // your code ...
}
-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
    
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
}
- (void)initialize {
    // Access all FileDownloadInfo objects using a loop and give all properties their initial values.
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        
        if (fdi.isDownloading) {
            [fdi.downloadTask cancel];
        }
        
        fdi.isDownloading = NO;
        fdi.downloadComplete = NO;
        fdi.taskIdentifier = -1;
        fdi.downloadProgress = 0.0;
        fdi.downloadTask = nil;
    }
    
    // Reload the table view.
    [self.tblFiles reloadData];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Get all files in documents directory.
    NSArray *allFiles = [fileManager contentsOfDirectoryAtURL:self.docDirectoryURL
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (int i=0; i<[allFiles count]; i++) {
        [fileManager removeItemAtURL:[allFiles objectAtIndex:i] error:nil];
    }
}

-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier{
    int index = 0;
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}


-(int)getDownloadInfoIndexByTaskIdentifier:(unsigned long)taskIdentifier{
    int index = -1;
    for (int i=0; i<[self.arrFileDownloadData count]; i++) {
        FileDownloadInfo *fdi = [self.arrFileDownloadData objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}

@end
