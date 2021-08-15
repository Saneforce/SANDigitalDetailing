//
//  ChemistProfilingCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 20/01/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "ChemistProfilingCtrl.h"
#import "mCustomerCell.h"

@interface ChemistProfilingCtrl ()
@property (nonatomic, strong) NSArray* ObjCustomerList;
@property (nonatomic, strong) NSArray* CustomerList;
@property (nonatomic, strong) NSArray* TP;


@property (nonatomic, strong) NSArray* CatList;
@property (nonatomic, strong) NSArray* TerrList;
@property (nonatomic, strong) NSArray* objOptList;

@end

@implementation ChemistProfilingCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.meetData=[CallMeetData sharedDatas];
    self.UserDet=[UserDetails sharedUserDetails];
    self.ChmProfData=[ChmProfileData sharedDatas];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.tbSelectBx.delegate = self;
    self.tbSelectBx.dataSource = self;
    
    self.layout.minimumInteritemSpacing = 8;
    self.layout.minimumLineSpacing = 25;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.TP =[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
    self.meetData.DataSF=[self.TP valueForKey:@"SFMem"];
    self.meetData.DataSFHQ=[self.TP valueForKey:@"HQNm"];
    if([self.UserDet.Desig isEqualToString:@"MR"]) self.meetData.DataSF=self.UserDet.SF;
    
    NSString *DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.meetData.DataSF];
    self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    /*int flag=1;
     self.ObjCustomerList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"PlcyAcptFl.intValue == %d",flag]] mutableCopy];*/
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    
    self.CustomerList = [[_ObjCustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    
    
    _btnSelHQ.hidden=YES;
    if(![_UserDet.Desig isEqualToString:@"MR"]) _btnSelHQ.hidden=NO;
    
    DataKey=[[NSString alloc] initWithFormat:@"TerritoryDetails_%@.SANAPP",self.meetData.DataSF];
    self.TerrList=[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.CatList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Category.SANAPP"] mutableCopy];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.CustomerList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mCustomerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    cell.layer.cornerRadius=4.0f;
    cell.lCustName.text = [self.CustomerList[indexPath.row] objectForKey:@"Name"];
    cell.lCustName.textColor=[UIColor whiteColor];
    cell.lTownName.text = [self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
    cell.lCategory.text = [self.CustomerList[indexPath.row] objectForKey:@"Category"];
    cell.lSpeciality.text = [self.CustomerList[indexPath.row] objectForKey:@"Specialty"];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* SelItem= self.CustomerList[indexPath.row];
    self.lblChmName.text=[SelItem objectForKey:@"Name"];
    self.CustCode=[SelItem objectForKey:@"Code"];
    [WBService SendServerRequest:@"GET/ChmDets" withParameter:[@{@"CusCode":self.CustCode,@"typ":@"C"} mutableCopy] withImages:nil DataSF:nil
                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                          
                          NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                          NSDictionary *item =receivedDta[0];
                          self.txtCnctPNm.text=[self.CustomerList[indexPath.row] objectForKey:@"ContactName"];
                          self.txtAdd1.text=[item valueForKey:@"Addr1"];
                          //self.lblPincode.text=[item valueForKey:@"PinCode"];
                          self.txtCity.text=[self.CustomerList[indexPath.row] objectForKey:@"CityName"];
                          self.txtPhone.text=[item valueForKey:@"Phone"];
                          self.txtMob.text=[item valueForKey:@"Mobile"];
                          self.txtEmail.text=[item valueForKey:@"Email"];
                                                  [self.view layoutIfNeeded];
                          
                          self.ChmProfData.ChmCat=[item valueForKey:@"CatCode"];
                          [_btnCate setTitle:NSLocalizedString([item objectForKey:@"CatName"], [item objectForKey:@"CatName"]) forState:UIControlStateNormal];
                          self.ChmProfData.ChmTerr=[item valueForKey:@"TerrCode"];
                          [_btnTerr setTitle:NSLocalizedString([item objectForKey:@"TerrName"], [item objectForKey:@"TerrName"]) forState:UIControlStateNormal];
                          
                          
                      }
                           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                               NSLog(@"%@",errorMsg);
                           }
     ];
    self.selChmView.hidden=YES;
    [self.view endEditing:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tbSelectBx) return self.objOptList.count;
    if(tableView==self.tbHQ) return self.objHQList.count;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    
    if(tableView==self.tbHQ) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"CellHQ" forIndexPath:indexPath];
        NSDictionary *HQ = self.objHQList[indexPath.row];
        cell.lOptText.text = [HQ objectForKey:@"name"];
    }
    
    if(tableView==self.tbSelectBx) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *item = self.objOptList[indexPath.row];
        cell.lOptText.text = NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"]);
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tbHQ) {
        NSDictionary *HQ = self.objHQList[indexPath.row];
        [self.btnSelHQ setTitle:[HQ objectForKey:@"name"] forState:UIControlStateNormal];
        self.meetData.DataSF=[HQ objectForKey:@"id"];
        NSString *DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.meetData.DataSF];
        self.searchBox.text=@"";
        
        [BaseViewController loadMasterData:self.meetData.DataSF completion:^(){
            self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            
            NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
            
            self.CustomerList = [[_ObjCustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            [self.collectionView reloadData];
        } error:^(NSString* errMsg){
        }];
    }
    if(tableView==_tbSelectBx){
        NSDictionary *item = self.objOptList[indexPath.row];
        [_btnSelectbx setTitle:NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"]) forState:UIControlStateNormal];
        NSString* sCode=[item valueForKey:@"Code"];
        if(_tbSelectBx.tag==1)self.ChmProfData.ChmCat=sCode;
        if(_tbSelectBx.tag==2)self.ChmProfData.ChmTerr=sCode;
    }
    [self closeTableViews];
}

-(IBAction)searchDoctor:(id)sender
{
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.meetData.DataSF];
    self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    /*int flag=1;
     self.ObjCustomerList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"PlcyAcptFl.intValue == %d",flag]] mutableCopy];*/
    if([self.searchBox.text isEqualToString:@""]==NO){
        NSMutableArray *MkList = [[self.ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]] mutableCopy];
        self.ObjCustomerList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
    
    self.CustomerList = [[_ObjCustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    [self.collectionView reloadData];
}
-(void) closeTableViews{
    self.tbHQ.hidden=YES;
    self.vwSelBxModal.hidden=YES;
}
-(void)showCutomerList:(id)sender{
    self.selChmView.hidden=NO;
}
-(void) ShowSelection:(NSString *) title{
    
    self.lblTittle.text=title;
    self.vwSelBxModal.hidden=NO;
}
-(void) AssignObjs:(int)mod{
    
    NSString *title=@"";
    
    if(mod==1) {self.objOptList=[self.CatList mutableCopy];title=NSLocalizedString(@"Category List",@"Category List");}
    if(mod==2) {self.objOptList=[self.TerrList mutableCopy];title=NSLocalizedString(@"Territory List",@"Territory List");}
    
    _tbSelectBx.tag=mod;
    [self.tbSelectBx reloadData];
    [self ShowSelection:title];
}

-(IBAction)showModalList:(id)sender{
    UIButton* btn=(UIButton *) sender;
    _btnSelectbx=btn;
    [self AssignObjs:(int)btn.tag];
    
}
-(IBAction)hideModalList:(id)sender{
    self.vwSelBxModal.hidden=YES;
}

-(IBAction) openSelHQ:(id)sender{
    BOOL upState=!self.tbHQ.hidden;
    [self closeTableViews];
    self.tbHQ.hidden=upState;
}
-(IBAction) gotoHome:(id)sender{
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}
-(IBAction) svChemistProfile:(id)sender{
    self.ChmProfData.CustCode=self.CustCode;
    self.ChmProfData.CustName=self.lblChmName.text;
    self.ChmProfData.CnctPNm=[NSString stringWithFormat:@"%@",self.txtCnctPNm.text];
    self.ChmProfData.ChmAdd1=[NSString stringWithFormat:@"%@",self.txtAdd1.text];
    self.ChmProfData.ChmCity=[NSString stringWithFormat:@"%@",self.txtCity.text];
    self.ChmProfData.ChmPhone=[NSString stringWithFormat:@"%@",self.txtPhone.text];
    self.ChmProfData.ChmMob=[NSString stringWithFormat:@"%@",self.txtMob.text];
    self.ChmProfData.ChmEmail=[NSString stringWithFormat:@"%@",self.txtEmail.text];
    
    NSLog(@"%@",[self.ChmProfData toNSDictionary]);
    
    [WBService SendServerRequest:@"SAVE/ChmProfile" withParameter:[_ChmProfData toNSDictionary] withImages:nil
                          DataSF:nil
                      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         if(Success==YES){
             [BaseViewController Toast:NSLocalizedString(@"Chemist Profile Saved Successfully", @"Chemist Profile Saved Successfully")];
         }
         else{
             [BaseViewController Toast:NSLocalizedString(@"Chemist Profiling Failed.", @"Chemist Profiling Failed.")];
         }
         [SVProgressHUD dismiss];
     }
                           error:^(NSString *errorMsg,NSMutableDictionary *uData){
                               [BaseViewController Toast:[NSString stringWithFormat:@"%@.\n %@",NSLocalizedString( @"Chemist Profiling FailedERR", @"Chemist Profiling Failed"),errorMsg.description]];
                               [SVProgressHUD dismiss];
                           }];
}
@end
