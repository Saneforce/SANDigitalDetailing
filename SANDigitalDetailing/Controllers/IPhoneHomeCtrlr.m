//
//  IPhoneHomeCtrlr.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 25/10/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "IPhoneHomeCtrlr.h"
#import "mMenuCell.h"
#import "CVColor.h"
#import "LocationDetail.h"
@interface IPhoneHomeCtrlr ()

@property (nonatomic, strong) NSMutableArray * menulist;

@end

@implementation IPhoneHomeCtrlr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //self.layout.minimumInteritemSpacing = 1;
    //self.layout.minimumLineSpacing = 1;
    //self.layout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    self.menulist = @[@{@"name" : @"Doctor", @"bgColor":@"#fec543",@"image":@"doctor",@"tag":@1},
                      @{@"name" : @"Chemist",@"bgColor":@"#dcdcdc",@"image":@"chemist",@"tag":@2},
                      @{@"name" : @"Stockist",@"bgColor":@"#dcdcdc",@"image":@"stockist",@"tag":@3},
                      @{@"name" : @"Unlisted Dr",@"bgColor":@"#fec543",@"image":@"unlisted doctor",@"tag":@4},
                      
                      ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    mMenuCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    NSDictionary *menu=self.menulist[indexPath.row];
    UIColor* borderColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0f];
    
    UIColor *color = [[[CVColor alloc] init] getUIColorObjectFromHexString:[menu objectForKey:@"bgColor" ] alpha:.9];
    cell.bgView.backgroundColor=color;
    cell.bgView.layer.borderWidth = 5.0f;
    cell.bgView.layer.borderColor= borderColor.CGColor;
    cell.bgView.layer.cornerRadius=15.0f;
    cell.LblText.text = [menu objectForKey:@"name"];
    cell.bLogoImg.image = [UIImage imageNamed:[menu objectForKey:@"image"] ];
    cell.tagID=(int)[[menu objectForKey:@"tag"] intValue];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menulist.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    int tagID = [[_menulist[indexPath.row] objectForKey:@"tag"] intValue];
    [self NavMenuItem:tagID];
    
}
-(void) NavMenuItem:(int) menuId{
    
   /* if([self.locationData.latitude floatValue]>0)
    {
        self.meetData.Entry_location=[NSString stringWithFormat:@"%@:%@",self.locationData.latitude,self.locationData.longitude];
    }*/
    if(menuId == 1){
        [self performSegueWithIdentifier:@"DoctorEntry" sender:self];
    }
    if(menuId==2){
        [self performSegueWithIdentifier:@"ChemistEntry" sender:self];
    }
    if(menuId==3){
        [self performSegueWithIdentifier:@"StockistEntry" sender:self];
    }
    if(menuId==4){
        [self performSegueWithIdentifier:@"NLDrsEntry" sender:self];
    }
    if(menuId==5){
        [self performSegueWithIdentifier:@"GoToLeaveApp" sender:self];
    }
    if(menuId==8){
        [self performSegueWithIdentifier:@"SettingSegue" sender:self];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
