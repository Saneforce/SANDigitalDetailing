//
//  ReplayQueriesView.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 30/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "ReplayQueriesView.h"
#import "ReplayQueryCell.h"
@interface ReplayQueriesView ()
@property (nonatomic, strong) NSMutableArray* DrQueryList;
@end

@implementation ReplayQueriesView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.meetData=[CallMeetData sharedDatas];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self loadDrQueries];
    
    self.lDrName.text=_meetData.CustName;
    // Do any additional setup after loading the view.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.DrQueryList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReplayQueryCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QryCell" forIndexPath:indexPath] ;
    
    cell.lMainQuery.text = [self.DrQueryList[indexPath.row] objectForKey:@"Msg"];
    cell.lQueryDt.text = [self.DrQueryList[indexPath.row] objectForKey:@"SentDt"];
    cell.tblOptList=[self.DrQueryList[indexPath.row] objectForKey:@"Replays"];
    [cell.tbQryReply reloadData];
    if ([cell.tblOptList count]>0){
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: [cell.tblOptList count]-1 inSection:0];
        [cell.tbQryReply scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: NO];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}
-(void) loadDrQueries{
    [WBService SendServerRequest:@"GET/DrQuery" withParameter:[@{@"CusCode":self.meetData.CustCode} mutableCopy] withImages:nil DataSF:nil
                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                          NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableContainers error:nil];
                          _DrQueryList=[[receivedDta filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"QryDet_ID=1"]] mutableCopy];
                          
                          for(int il=0;il<[_DrQueryList count];il++){
                              NSMutableArray *items=[[receivedDta filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Qry_ID=%@ and QryDet_ID>1",[_DrQueryList[il] valueForKey:@"Qry_ID"]]] mutableCopy];
                              [_DrQueryList[il] setObject:[items mutableCopy] forKey:@"Replays"];
                          }
                          [self.collectionView reloadData];
                      }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }
     ];
}

-(IBAction) SendQuery:(id)sender{
    ReplayQueryCell *Icell=(ReplayQueryCell *)[self getCollectionViewCell:sender];
    if ([Icell.tQueryMsg.text isEqualToString:@""]) return;
    UICollectionView *tbView=[self getCollectionView:sender];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    NSMutableDictionary* QryData=[[NSMutableDictionary alloc] init];
    [QryData setValue:[_DrQueryList[indexPath.row] valueForKey:@"Qry_ID"] forKey:@"QryID"];
    [QryData setValue:[BaseViewController date2str:[NSDate date] onlyDate:false] forKey:@"QryDt"];
    [QryData setValue:Icell.tQueryMsg.text forKey:@"QryMsg"];
    
    NSLog(@"%@",[QryData mutableCopy]);
    
    [WBService SendServerRequest:@"SAVE/DrQuery" withParameter:[QryData mutableCopy] withImages:nil
          DataSF:nil
        completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         if(Success==YES){
             //[BaseViewController Toast:@"Query Sent Successfully...."];
             Icell.tQueryMsg.text=@"";
            [self loadDrQueries];
         }
         else{
             [BaseViewController Toast:@"Query Sending  Failed."];
             
         }
         [SVProgressHUD dismiss];
     }
       error:^(NSString *errorMsg,NSMutableDictionary *uData){
           [BaseViewController Toast:[NSString stringWithFormat:@"Query Sending Failed.\n %@",errorMsg.description]];
           [SVProgressHUD dismiss];
       }];
}
-(IBAction) CloseWindow:(id)sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:NO];
}

-(UICollectionView *) getCollectionView:(UIView *)view{
    UICollectionView *ClView=(UICollectionView *) view;
    while(![ClView isKindOfClass: [UICollectionView class]])
    {
        ClView=(UICollectionView *) ClView.superview;
    }
    return ClView;
}

-(UICollectionViewCell *) getCollectionViewCell:(UIView *)view{
    UICollectionViewCell *clvCell=(UICollectionViewCell *) view;
    while(![clvCell isKindOfClass: [UICollectionViewCell class]])
    {
        clvCell=(UICollectionViewCell *) clvCell.superview;
    }
    return clvCell;
}
@end
