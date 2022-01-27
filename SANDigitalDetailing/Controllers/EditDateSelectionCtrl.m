//
//  EditDateSelectionCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 31/05/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "EditDateSelectionCtrl.h"

@interface EditDateSelectionCtrl ()

@property (nonatomic,strong) NSMutableArray *objMsDtList;
@end

@implementation EditDateSelectionCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.meetData=[CallMeetData sharedDatas];
    self.locationData=[LocationDetail sharedLocationData];
    self.tbDTSel.delegate = self;
    self.tbDTSel.dataSource = self;
    /**self.objMsDtList = [[NSMutableArray alloc] initWithObjects:
                        @{@"DDate" : @"15",@"DMon" : @"May",@"DYr" : @"2019",@"DDay" : @"Wed",@"EDate" : @"2019-05-15 00:00:00"},
                        @{@"DDate" : @"16",@"DMon" : @"May",@"DYr" : @"2019",@"DDay" : @"Thu",@"EDate" : @"2019-05-16 00:00:00"},nil
                         ];*/
    
    [self reloadDates];
}

-(void)viewDidAppear:(BOOL)animated{
    [self reloadDates];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 133;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objMsDtList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *objDT = self.objMsDtList[indexPath.row];
    
    cell.lOptVal.text =[NSString stringWithFormat:@"%@ %@",[objDT objectForKey:@"DMon"],[objDT objectForKey:@"DYr"]];
    cell.lOptFDate.text = [objDT objectForKey:@"DDate"];
    cell.lOptText.text = [objDT objectForKey:@"DDay"];
    cell.btnVal1.tag=indexPath.row;cell.btnVal2.tag=indexPath.row;
    [cell.btnVal1 addTarget:self action:@selector(GoToFieldWork:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnVal2 addTarget:self action:@selector(GoToNonFieldWork:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *objDT = self.objMsDtList[indexPath.row];
    
    self.meetData.EDate=[objDT objectForKey:@"EDate"];
    self.meetData.MissedEntry=YES;
    
    [self.NvMain NavMenuItem:1];
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

-(IBAction) GoToFieldWork:(id)sender{
    long indx=((UIButton *) sender).tag;
    NSDictionary *objDT = self.objMsDtList[indx];
    
    self.meetData.EDate=[objDT objectForKey:@"EDate"];
    self.meetData.MissedEntry=YES;
  
    [self performSegueWithIdentifier:@"MissedCalls" sender:self];
    //[self presentViewController:currentViewController animated:YES completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction) GoToNonFieldWork:(id)sender{
    long indx=((UIButton *) sender).tag;
    NSDictionary *objDT = self.objMsDtList[indx];
    
    self.meetData.EDate=[objDT objectForKey:@"EDate"];
    self.meetData.MissedEntry=YES;
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ToDyTPvwCtrl *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TPEntry"];
    
    currentViewController.modalPresentationStyle=UIModalPresentationFormSheet;
    currentViewController.UserDet=self.UserDet;
    
    [self performSegueWithIdentifier:@"MissedOthers" sender:self];
//    [self dismissViewControllerAnimated:NO completion:^{
//        [self presentViewController:currentViewController animated:YES completion:nil];
//
//    }];
    //[self presentViewController:currentViewController animated:YES completion:nil];
    
    //[self showViewController:currentViewController sender:nil];
    //[self dismissViewControllerAnimated:NO completion:^{}];
}

-(void) reloadDates{
    [WBService SendServerRequest:@"GET/MissDates" withParameter:nil withImages:nil DataSF:nil
                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage)
     {
         _objMsDtList=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         [self.tbDTSel reloadData];
     }
           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
               [self.tbDTSel reloadData];
               NSLog(@"%@",errorMsg);
           }
     ];
}
-(IBAction) CloseMissDtEntry:(id)sender{
    NSArray *viewControllers = [self.navigationController viewControllers];
    if([self.navigationController viewControllers]==nil){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
    }
    // [self dismissViewControllerAnimated:YES completion:nil];
}
@end
