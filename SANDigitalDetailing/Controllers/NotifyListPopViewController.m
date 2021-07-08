//
//  NotifyListPopViewController.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 20/10/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "NotifyListPopViewController.h"

@interface NotifyListPopViewController ()
@property (nonatomic, strong) NSMutableArray* NotificationList;
@end

@implementation NotifyListPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NotificationList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"NotifyMsgs.SANAPP"] mutableCopy];
    self.tvNotify.delegate=self;
    self.tvNotify.dataSource=self;    // Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.NotificationList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBSelectionBxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *optLst = self.NotificationList[indexPath.row];
    cell.lOptText.text = [optLst objectForKey:@"msg"];
    [cell.lOptText sizeToFit];
    cell.lOptVal.text = [optLst objectForKey:@"Dt"];
    
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *NotifyMsg=[self.NotificationList[indexPath.row] valueForKey:@"msg"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NotifyHead",@"Notification Message")
                                                                   message:NotifyMsg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSMutableDictionary* dist=[self.NotificationList[indexPath.row] mutableCopy];
                                                              [dist setValue:@"1" forKey:@"Flag"];
                                                              [self.NotificationList replaceObjectAtIndex:indexPath.row withObject:dist];
                                                              [WBService saveData:[self.NotificationList mutableCopy] forKey:@"NotifyMsgs.SANAPP"];
                                                              NSMutableArray* NotifyMsgs=[[self.NotificationList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Flag==%@",@"0"]] mutableCopy];
                                                              self.NvMain.vwNotifyImg.hidden=YES;
                                                              if([NotifyMsgs count]>0)
                                                              {
                                                                  self.NvMain.vwNotifyImg.hidden=NO;
                                                              }
                                                              NSLog(@"OK Fired");
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
