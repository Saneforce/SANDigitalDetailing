//
//  MasterDownloader.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/12/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "MasterDownloader.h"
#import "TBSelectionBxCell.h"
#import "downloaderView.h"
#import "UIImage+animatedGIF.h"

@interface MasterDownloader ()

@property (nonatomic, strong) UserDetails* UserDet;

@property (nonatomic,strong) NSMutableArray *MasterList;
@property (nonatomic, strong) NSArray* objOptList;
@property (nonatomic,strong) NSArray *objHQList;

@property (nonatomic,strong) NSMutableArray *SelHQList;
@property (nonatomic, strong) NSMutableArray* SelOptList;
@property (nonatomic, assign) NSString* DataSF;
@property (nonatomic, assign) int iActivity;

@end

@implementation MasterDownloader

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self closeSelection];
    self.UserDet=[UserDetails sharedUserDetails];

    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    [self resetData];
    
    self.btnBack.layer.cornerRadius=20.0f;
    self.lblHQName.layer.cornerRadius=10.0f;
    
    self.tvMasterList.delegate=self;
    self.tvMasterList.dataSource=self;
    self.tvOptList.delegate=self;
    self.tvOptList.dataSource=self;
    
    [self.lblHQName setText:[NSString stringWithFormat:@"%@",self.UserDet.HQName]];

}
-(void) resetData
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_UserDet.SF,@"SF",_UserDet.SF,@"APPUserSF",_UserDet.DivCode,@"div", nil];
    self.MasterList =[[NSMutableArray alloc] init];
    [_MasterList addObject:[[List alloc] initWithName:@"WorktypeDetails.SANAPP" andLabel:@"Work Types" andApiPath:@"GET/WorkType" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"HQDetails.SANAPP" andLabel:@"Headquters" andApiPath:@"GET/HQ" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"CompetitorDetails.SANAPP" andLabel:@"Competitors" andApiPath:@"GET/CompDet" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"Inputs.SANAPP" andLabel:@"Inputs" andApiPath:@"GET/Inputs" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"SlideBrand.SANAPP" andLabel:@"Slide Brand" andApiPath:@"GET/slidebrand" Parameters:reqData]];
    [_MasterList addObject:[[List alloc] initWithName:@"Products.SANAPP" andLabel:@"Products" andApiPath:@"GET/Products" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"ProdSlides.SANAPP" andLabel:@"Slides" andApiPath:@"GET/ProdSlides" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"Brands.SANAPP" andLabel:@"Brands" andApiPath:@"GET/Brands" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"Departs.SANAPP" andLabel:@"Departments" andApiPath:@"GET/Departs" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"Specialitys.SANAPP" andLabel:@"Speciality" andApiPath:@"GET/Speciality" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"Category.SANAPP" andLabel:@"Category" andApiPath:@"GET/Categorys" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"Qualifics.SANAPP" andLabel:@"Qualifications" andApiPath:@"GET/Quali" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"DocClass.SANAPP" andLabel:@"Class" andApiPath:@"GET/Class" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"DocTypes.SANAPP" andLabel:@"Types" andApiPath:@"GET/Types" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"VisitTypes.SANAPP" andLabel:@"Types" andApiPath:@"GET/VisitTypes" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"RatingInfo.SANAPP" andLabel:@"Rating Details" andApiPath:@"GET/RatingInf" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:@"Ratingfeedbk.SANAPP" andLabel:@"Rating Feedbacks" andApiPath:@"GET/RatingFeedbk" Parameters:nil]];
    //if(_iActivity==(int) 1){
        
        [_MasterList addObject:[[List alloc] initWithName:@"SpeakersList.SANAPP" andLabel:@"Speaker List" andApiPath:@"GET/Speaker" Parameters:nil]];
        [_MasterList addObject:[[List alloc] initWithName:@"ParticipantList.SANAPP" andLabel:@"Participant List" andApiPath:@"GET/Participant" Parameters:nil]];
        [_MasterList addObject:[[List alloc] initWithName:@"IndicationList.SANAPP" andLabel:@"Indication List" andApiPath:@"GET/Indication" Parameters:nil]];
    //}
}
-(void) refreshData:(NSString *) DataSF{
    [self resetData];
    [_MasterList addObject:[[List alloc] initWithName:[NSString  stringWithFormat:@"TerritoryDetails_%@.SANAPP",DataSF] andLabel:@"Clusters" andApiPath:@"GET/Territory" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:[NSString  stringWithFormat:@"DoctorDetails_%@.SANAPP",DataSF] andLabel:@"Doctors" andApiPath:@"GET/Doctors" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:[NSString  stringWithFormat:@"ChemistDetails_%@.SANAPP",DataSF] andLabel:@"Chemists" andApiPath:@"GET/Chemist" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:[NSString  stringWithFormat:@"StockistDetails_%@.SANAPP",DataSF] andLabel:@"Stockists" andApiPath:@"GET/Stockist" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:[NSString  stringWithFormat:@"UnlistedDR_%@.SANAPP",DataSF] andLabel:@"Unlisted Doctors" andApiPath:@"GET/UnlistedDR" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:[NSString  stringWithFormat:@"Hospital_%@.SANAPP",DataSF] andLabel:@"Institutions" andApiPath:@"GET/Hospitals" Parameters:nil]];
    [_MasterList addObject:[[List alloc] initWithName:[NSString  stringWithFormat:@"JointWork_%@.SANAPP",DataSF] andLabel:@"Jointworks" andApiPath:@"GET/JntWrk" Parameters:nil]];
    
    [_tvMasterList reloadData];
    [self closeSelection];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TBSelectionBxCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.tvOptList==tableView)
        cell.lOptText.text=[_objOptList[indexPath.row] valueForKey:@"name"];
    else{
        List* list=_MasterList[indexPath.row];
        cell.lOptText.text= NSLocalizedString(list.label, list.label);
        
        cell.lOptVal.text= [NSString stringWithFormat:@"( %ld )", [[[NSUserDefaults standardUserDefaults] objectForKey:list.name] count]];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tvOptList==tableView) return [_objOptList count];
    if (self.tvMasterList==tableView) return [_MasterList count];
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TBSelectionBxCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (self.tvOptList==tableView)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.firstLineHeadIndent = 8;
        self.lblHQName.attributedText=[[NSAttributedString alloc] initWithString:[_objOptList[indexPath.row] valueForKey:@"name"] attributes:@{NSParagraphStyleAttributeName: style}];
        self.DataSF=[_objOptList[indexPath.row] valueForKey:@"id"];
        [self refreshData:_DataSF];
    }
    else if(tableView==self.tvMasterList){
        NSString *datSF=_DataSF;
        if(indexPath.row<5) datSF=nil;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
        cell.lOptImg.image= [UIImage animatedImageWithAnimatedGIFURL:url];
        [self LoadData:_MasterList[indexPath.row] andDataFor:datSF  andIndexPath:indexPath];
    }
}
-(void) LoadData:(List *) list andDataFor:(NSString *)dataSF andIndexPath:(NSIndexPath *)indexPath{
    [WBService SendServerRequest:list.apiPath withParameter:list.param withImages:nil DataSF:dataSF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            id jsonData=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            id  receivedDta = [WBService removeNullValues:jsonData];
            [WBService saveData:receivedDta forKey:list.name];
        
            NSLog(@"%@ Reloaded Successfully...",list.name);
            TBSelectionBxCell *cell=[self.tvMasterList cellForRowAtIndexPath:indexPath];
            cell.lOptImg.image= nil;
            //List* list=_MasterList[indexPath.row];
            //cell.lOptText.text=list.label;
            if([list.label isEqualToString:@"Slides"]){
                
                NSMutableArray* UniqueSlides=[[NSMutableArray alloc] init];
                for(NSDictionary* slide in receivedDta)
                {
                    if([[UniqueSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", [slide valueForKey:@"Code"]]] count]<1){
                        [UniqueSlides addObject:slide];
                    }
                }
                [WBService saveData:[UniqueSlides mutableCopy] forKey:@"UniqueProdSlides.SANAPP"];
                
                [self openDownloader];
            }
            [_tvMasterList reloadData];
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
           NSLog(@"%@",errorMsg);
        }
     ];
}
-(void) openDownloader{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    downloaderView *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"Downloader"];
    
    currentViewController.modalPresentationStyle=UIModalPresentationFormSheet;
    
    [self presentViewController:currentViewController animated:YES completion:nil];
    
}
-(IBAction)CloseSelWin:(id)sender{
    [self closeSelection];
}
-(IBAction)OpenHeadquaters:(id)sender{
    self.objOptList=[self.objHQList mutableCopy];
    self.SelOptList=[self.SelHQList mutableCopy];
    self.searchBox.tag=2;
    [self.tvOptList reloadData];
    [self ShowSelection:@"Headquater Selection"];
}
-(IBAction)searchOpts:(id)sender
{
    self.objOptList=[self.objHQList mutableCopy];
    
    
    if([self.searchBox.text isEqualToString:@""]==NO){
        self.objOptList = [self.objOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]];
    }
    [self.tvOptList reloadData];
}
-(void)ShowSelection:(NSString*)sTitle{
    
    [self.lblTitle setText:sTitle];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.nsVfselTop.constant=0;
                         self.VfBottomLayout.constant=0;
                         self.vfSelWindow.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}
-(void) closeSelection{
    
    self.searchBox.tag=0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.nsVfselTop.constant=self.vfSelWindow.frame.size.height;
                         [self.view layoutIfNeeded];
                         
                         self.VfBottomLayout.constant=-self.vfSelWindow.frame.size.height;
                         [self.view layoutIfNeeded];
                         self.vfSelWindow.alpha=0;
                         
                     }
                     completion:^(BOOL finished) {   }];
}


-(IBAction) CloseWindow:(id)sender {
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}

@end
