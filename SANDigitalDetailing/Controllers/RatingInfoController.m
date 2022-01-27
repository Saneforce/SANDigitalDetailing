//
//  RatingInfoController.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 19/11/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "RatingInfoController.h"

@interface RatingInfoController ()

@property (nonatomic, strong) NSArray* RatingInfList;
@end

@implementation RatingInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.RatingInfList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"RatingInfo.SANAPP"] mutableCopy];
    self.tvRatingInf.delegate=self;
    self.tvRatingInf.dataSource=self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.RatingInfList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBSelectionBxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *optLst = self.RatingInfList[indexPath.row];
    cell.lOptText.text = [optLst objectForKey:@"Name"];
    
    // Configure the cell...
    
    return cell;
}


@end
