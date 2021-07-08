//
//  VwCReportMenu.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 07/05/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "VwCReportMenu.h"
#import "mMenuCell.h"
#import "ReportViewer.h"
@interface VwCReportMenu()

@property (nonatomic, strong) NSArray* menulist;
@property (nonatomic, strong) NSString* sUrl;
@end
@implementation VwCReportMenu

-(void) viewDidLoad{
    
    _BaseCtrlr=[[BaseViewController alloc] init];
    self.UserDet=[UserDetails sharedUserDetails];
    self.config=[Config sharedConfig];
    self.lblDispSF.text=self.UserDet.SFName;
    
    self.profileImg.image=[self.BaseCtrlr getProfileImage:@"/images/profile.jpg"];
    self.profileImg.clipsToBounds = YES;
    self.profileImg.layer.cornerRadius= 8.5f;
    self.profileImg.layer.borderWidth = 1.0f;
    self.profileImg.layer.borderColor= [UIColor whiteColor].CGColor;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    _menulist=[[[NSUserDefaults standardUserDefaults] objectForKey:@"rptMenuList.SANAPP"] mutableCopy];
    [_collectionView reloadData];
    [WBService SendServerRequest:@"GET/rptMenuList" withParameter:nil withImages:nil DataSF:nil completion:^(BOOL success, id respData,NSMutableDictionary *DatawithImage) {
        NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        [WBService saveData:receivedDta forKey:@"rptMenuList.SANAPP"];
        _menulist=[[[NSUserDefaults standardUserDefaults] objectForKey:@"rptMenuList.SANAPP"] mutableCopy];
        [_collectionView reloadData];
    }
    error:^(NSString *errorMsg,NSMutableDictionary *DatawithImage){
        NSLog(@"%@",errorMsg);
    }];
}

-(IBAction) gotoHome:(id)sender{
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menulist.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mMenuCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    NSDictionary *menu=self.menulist[indexPath.row];
    
    cell.titleLabel.text = [menu objectForKey:@"MenuText"];
    //cell.titleLabel.font=[UIFont fontWithName:@"Cochin Bold"  size:15.0];
   // cell.titleLabel.textColor=[UIColor blackColor];
    NSString *sMnuImg=@"";
    sMnuImg=[menu objectForKey:@"logoPath"];
    //if ([sMnuImg isEqualToString:@""]){sMnuImg=@"report-6"; }
    cell.bLogoImg.image = [UIImage imageNamed:sMnuImg];    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _sUrl= [_menulist[indexPath.row] objectForKey:@"MenuUrl"];
    [self performSegueWithIdentifier:@"goReportViewer" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"goReportViewer"]){
        ReportViewer *rptvwr=[segue destinationViewController];
        [rptvwr setWebUrl:[NSString stringWithFormat:@"%@%@",_config.ReportUrl,_sUrl]];
    }
}
@end
