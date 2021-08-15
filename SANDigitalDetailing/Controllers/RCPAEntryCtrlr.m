//
//  RCPAEntryCtrlr.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 14/11/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "RCPAEntryCtrlr.h"

@interface RCPAEntryCtrlr ()

@property (nonatomic, strong) NSDictionary* TP;
@property (nonatomic, strong) NSMutableDictionary* EmptyCompetDet;
@property (nonatomic, strong) NSArray* ObjChemistList;

@property (nonatomic, strong) NSArray* objOptList;
@property (nonatomic, strong) NSArray* CustomerList;
@property (nonatomic, strong) NSArray* ChemistList;
@property (nonatomic, strong) NSArray* ProductList;
@property (nonatomic, strong) NSArray* mCompetitorList;
@property (nonatomic, strong) NSMutableArray* mCompProdList;

@property (nonatomic, strong) NSMutableArray* SelOptList;
@property (nonatomic, strong) NSArray* SelChemistList;
@property (nonatomic, strong) NSArray* SelCustomerList;
@property (nonatomic, strong) NSMutableArray* CompetitorList;

@property (nonatomic, weak) NSString* SelPCode;
@property (nonatomic, weak) NSString* SelPName;
@property (nonatomic, strong) NSMutableArray* RCPADetails;

@property(nonatomic,strong) BaseViewController *BaseCtrlr;
@property(nonatomic,assign) CGSize keyboardSize;
@property(nonatomic,assign) CGFloat animatedDistance;
@property(nonatomic,assign) CGFloat frameHeight;

@end

@implementation RCPAEntryCtrlr

static const CGFloat ANIMATION_DURATION = 0.4;
static const CGFloat LITTLE_SPACE = 25;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.btnBack.layer.cornerRadius=20.0f;
    
    self.meetData=[CallMeetData sharedDatas];
    self.UserDet=[UserDetails sharedUserDetails];
    self.TdayPl=[TdayPlDetail sharedTdayPlDetail];
    
    self.tvOptList.dataSource=self;
    self.tvOptList.delegate=self;
    self.tvChemistList.dataSource=self;
    self.tvChemistList.delegate=self;
    self.txtOPRate.userInteractionEnabled=_UserDet.RateEditable;
    self.txtOPValue.userInteractionEnabled=_UserDet.RateEditable;
    
    self.tvComptList.dataSource=self;
    self.tvComptList.delegate=self;
    self.tvRCPAList.dataSource=self;
    self.tvRCPAList.delegate=self;
    self.DCREntryMode=@"1";
    
    [self.btnSubmit setTitle:NSLocalizedString(@"SaveBTN",@"Save") forState:UIControlStateNormal];
    if (self.meetData.CustCode==nil) {
        self.DCREntryMode=@"0";
        [self.btnSubmit setTitle:NSLocalizedString(@"FinalSubmitBTN", @"Final Submit") forState:UIControlStateNormal];
    }
    
    self.tvOptList.sectionHeaderHeight=0.0f;
    self.tvChemistList.sectionHeaderHeight=0.0f;
    self.tvComptList.sectionHeaderHeight=0.0f;
    
    self.EmptyCompetDet=[[NSMutableDictionary alloc] init];
    [self.EmptyCompetDet setValue:@"" forKey:@"CompName"];
    [self.EmptyCompetDet setValue:@"" forKey:@"CompPName"];
    [self.EmptyCompetDet setValue:@"" forKey:@"CPQty"];
    [self.EmptyCompetDet setValue:@"" forKey:@"CPRate"];
    [self.EmptyCompetDet setValue:@"" forKey:@"CPValue"];
    _CompetitorList=[@[[_EmptyCompetDet mutableCopy],[_EmptyCompetDet mutableCopy],[_EmptyCompetDet mutableCopy],[_EmptyCompetDet mutableCopy],[_EmptyCompetDet mutableCopy]] mutableCopy];
    self.TP =[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
    self.meetData.DataSF=[self.TP valueForKey:@"SFMem"];
    self.meetData.DataSFHQ=[self.TP valueForKey:@"HQNm"];
    if([self.UserDet.Desig isEqualToString:@"MR"]) self.meetData.DataSF=self.UserDet.SF;
    
    self.CustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF]] mutableCopy];
    
    self.mCompetitorList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"CompetitorDetails.SANAPP"] mutableCopy];
    
    self.ObjChemistList =[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ChemistDetails_%@.SANAPP",self.meetData.DataSF]] mutableCopy];    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    
    NSMutableArray *MkList=[[_ObjChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code contains[c] %@", self.TdayPl.Pl]] mutableCopy];
    self.ChemistList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    MkList=[[_ObjChemistList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Town_Code!= %@", self.TdayPl.Pl]] mutableCopy];
    self.ChemistList = [[self.ChemistList arrayByAddingObjectsFromArray:[MkList sortedArrayUsingDescriptors:sortDescriptors]] mutableCopy];
    
    self.ProductList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Products.SANAPP"] mutableCopy];
    self.lblDoctorName.text=[NSString stringWithFormat:@" %@", self.meetData.CustName];
    self.nsVfselTop.constant=self.vfSelWindow.frame.size.height;
    self.VfBottomLayout.constant=-self.vfSelWindow.frame.size.height;
    [self closeSelection];
    self.SelChemistList =[[NSArray alloc]init];
    self.RCPADetails =[_meetData.RCPAEntry mutableCopy];
    if(self.RCPADetails ==nil)
        self.RCPADetails =[[NSMutableArray alloc]init];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==self.tvRCPAList && [_RCPADetails count]>0)
        return _RCPADetails.count;
    else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tvOptList) return self.objOptList.count;
    if(tableView==self.tvChemistList) return self.SelChemistList.count;
    if(tableView==self.tvComptList) return self.CompetitorList.count;
    if(tableView==self.tvRCPAList && _RCPADetails.count>0){
        return [[self.RCPADetails[section] objectForKey:@"Competitors"] count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=44;
    if(tableView==self.tvRCPAList) h=93;
    if(tableView==self.tvOptList) h=60;
    
    return h;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tvRCPAList.frame.size.width,40)];
    if( [_RCPADetails count]>0 && tableView==self.tvRCPAList){
        sectionView.tag=section;
        UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, _tvRCPAList.frame.size.width-40, 40)];
        viewLabel.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0f];
        viewLabel.textColor=[UIColor colorWithRed:26.0/255 green:26.0/255 blue:26.0/255 alpha:1];
        viewLabel.font=[UIFont fontWithName:@"Poppins-Bold"  size:14.0];
        
        viewLabel.text=[NSString stringWithFormat:@"  %@",[[_RCPADetails objectAtIndex:section] valueForKey:@"OPName"]];
        [sectionView addSubview:viewLabel];
    }
    else
        sectionView.hidden=YES;
    return sectionView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;NSInteger tag = 0;
    NSDictionary *optLst=[[NSDictionary alloc] init];
    if(tableView==self.tvChemistList) {optLst = self.SelChemistList[indexPath.row];tag=2;}
    
    if(tableView==self.tvOptList) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst = self.objOptList[indexPath.row];
        if (self.searchBox.tag==4)
            cell.lOptText.text = [optLst objectForKey:@"Comp_Name"];
        else
            cell.lOptText.text = [optLst objectForKey:@"Name"];
        cell.lOptVal.text = [optLst objectForKey:@"Town_Name"];
        cell.btnCheked.tag = indexPath.row;
        cell.btnCheked.hidden=YES;
        cell.lOptText.textColor=[UIColor blackColor];
        
        
        if( self.searchBox.tag==2){
            NSString* Code=[self.ChemistList[indexPath.row] objectForKey:@"Town_Code"];
            if([Code isEqualToString:[NSString stringWithFormat:@"%@",_TdayPl.Pl]])
                cell.lOptText.textColor=[UIColor colorWithRed:225.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
            NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [optLst objectForKey:@"Code"]]] mutableCopy];
            if(Selitem.count>0){
                [cell.btnCheked setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
                cell.Checked=YES;
            }else{
                [cell.btnCheked setImage:nil forState:UIControlStateNormal];
                cell.Checked=NO;
            }
            [cell.btnCheked addTarget:self action:@selector(setChecked:) forControlEvents:UIControlEventTouchUpInside];
        }else if( self.searchBox.tag==2){
            
        }
    }
    else if(tableView==self.tvChemistList) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst = self.SelChemistList[indexPath.row];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        cell.btnDel.tag = indexPath.row;
        cell.btnDel.titleLabel.tag=tag;
        [cell.btnDel addTarget:self action:@selector(DeleteRow:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(tableView==self.tvComptList) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst = self.CompetitorList[indexPath.row];
        cell.txtCompName.text = [optLst objectForKey:@"CompName"];
        cell.txtCPName.text = [optLst objectForKey:@"CompPName"];
        cell.txtCPQty.text = [optLst objectForKey:@"CPQty"];
        cell.txtCPRate.text = [optLst objectForKey:@"CPRate"];
        cell.txtCPValue.text = [optLst objectForKey:@"CPValue"];
        cell.txtCPRate.userInteractionEnabled=_UserDet.CPRateEditable;
        cell.txtCPValue.userInteractionEnabled=_UserDet.CPRateEditable;
        [cell.btnCmpt addTarget:self action:@selector(OpenCompetitor:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCmptProd addTarget:self action:@selector(OpenCompProd:) forControlEvents:UIControlEventTouchUpInside];
        [cell.txtCompName addTarget:self action:@selector(txtCmptNameChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.txtCPName addTarget:self action:@selector(txtCPNameChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.txtCPQty addTarget:self action:@selector(txtCPQtyChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.txtCPRate addTarget:self action:@selector(txtCPRateChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.txtCPValue addTarget:self action:@selector(txtCPValueChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    else if(tableView==self.tvRCPAList) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst =[self.RCPADetails[indexPath.section] objectForKey:@"Competitors"] [indexPath.row];
        cell.lOptText.text = [optLst objectForKey:@"CompName"];
        cell.lCPName.text = [optLst objectForKey:@"CompPName"];
        cell.lCPQty.text =[NSString stringWithFormat:@"Qty : %@", [optLst objectForKey:@"CPQty"]];
        cell.lCPRate.text = [NSString stringWithFormat:@"Rate : %@", [optLst objectForKey:@"CPRate"]];
        cell.lCPValue.text = [NSString stringWithFormat:@"Value : %@", [optLst objectForKey:@"CPValue"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TBSelectionBxCell* cell;
    
    if(tableView==self.tvOptList) {
        cell =[tableView cellForRowAtIndexPath:indexPath];
        
        NSMutableDictionary *item = [[self.objOptList objectAtIndex:indexPath.row] mutableCopy];
        if( self.searchBox.tag==2){
            self.SelOptList=[[NSMutableArray alloc] init];
            NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [item objectForKey:@"Code"]]] mutableCopy];
            if (Selitem.count<=0){
                NSMutableDictionary *selItem =[[NSMutableDictionary alloc] init];
                [selItem setValue:[item objectForKey:@"Code"] forKey:@"Code"];
                [selItem setValue:[item objectForKey:@"Name"] forKey:@"Name"];
                
                [self.SelOptList addObject:selItem];
                
                [cell.btnCheked setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
                cell.Checked=YES;
            }
            else{
                [self.SelOptList removeObject:Selitem[0]];
                [cell.btnCheked setImage:nil forState:UIControlStateNormal];
                cell.Checked=NO;
            }
            [self setSelOptsValues:self];
        }
        else if(self.searchBox.tag==4){
            [_CompetitorList[self.vfSelWindow.tag] setValue:[item objectForKey:@"Comp_Name"] forKey:@"CompName" ];
            [_CompetitorList[self.vfSelWindow.tag] setValue:[item objectForKey:@"Comp_Sl_No"] forKey:@"CompCode" ];
            
            _mCompProdList=[[NSMutableArray alloc] init];
            NSArray *PlCds=[[NSString stringWithFormat:@"%@/",[item valueForKey:@"Comp_Prd_Sl_No"]] componentsSeparatedByString:@"/"];
            NSArray *PlNms=[[NSString stringWithFormat:@"%@/",[item valueForKey:@"Comp_Prd_name"]] componentsSeparatedByString:@"/"];
            for (int ik=0; ik<[PlCds count]; ik++) {
                if(![PlCds[ik] isEqualToString:@""]){
                    NSMutableDictionary *nProd=[[NSMutableDictionary alloc] init];
                    [nProd setValue:PlCds[ik] forKey:@"Code"];
                    [nProd setValue:PlNms[ik] forKey:@"Name"];
                    [_mCompProdList addObject:nProd];
                }
            }
            
            [_tvComptList reloadData];
            [self closeSelection];
        }else if(self.searchBox.tag==5){
            [_CompetitorList[self.vfSelWindow.tag] setValue:[item objectForKey:@"Name"] forKey:@"CompPName" ];
            [_CompetitorList[self.vfSelWindow.tag] setValue:[item objectForKey:@"Code"] forKey:@"CompPCode" ];
            
            [_tvComptList reloadData];
            [self closeSelection];
        }
        else if(self.searchBox.tag==1){
            self.SelPCode=[item objectForKey:@"Code"];
            self.SelPName=[item objectForKey:@"Name"];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.firstLineHeadIndent = 8;
            self.lblOurPName.attributedText=[[NSAttributedString alloc] initWithString:self.SelPName attributes:@{NSParagraphStyleAttributeName: style}];
            self.txtOPRate.text=[NSString stringWithFormat:@"%@",[item valueForKey:@"DRate"]];
            [self closeSelection];
        }
    }
}
-(IBAction) CalcOPValue:(id)sender{
    float Q=[_txtOPQty.text floatValue];
    float R=[_txtOPRate.text floatValue];
    _txtOPValue.text=[NSString stringWithFormat:@"%.02f",Q*R];
}
-(void) addRCPADetails{
    NSMutableDictionary *RCPAItem=[[NSMutableDictionary alloc] init];
    [RCPAItem setObject:self.SelChemistList forKey:@"Chemists"];
    [RCPAItem setValue:self.SelPCode forKey:@"OPCode"];
    [RCPAItem setValue:self.SelPName forKey:@"OPName"];
    [RCPAItem setValue:self.txtOPQty.text forKey:@"OPQty"];
    [RCPAItem setValue:self.txtOPRate.text forKey:@"OPRate"];
    [RCPAItem setValue:self.txtOPValue.text forKey:@"OPValue"];
    NSMutableArray *iCompt=[[NSMutableArray alloc] init];
    for(int il=0;il<[_CompetitorList count];il++)
    {
        if(!([[_CompetitorList[il] valueForKey:@"CompName"] isEqualToString:@""] && [[_CompetitorList[il] valueForKey:@"CompPName"] isEqualToString:@""]))
        {
            [iCompt  addObject:[_CompetitorList objectAtIndex:il]];
        }
    }
    [RCPAItem setObject:iCompt forKey:@"Competitors"];
    [_RCPADetails addObject:RCPAItem];
    
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
-(IBAction)searchOpts:(id)sender
{
    if(self.searchBox.tag==1) self.objOptList=[self.ProductList mutableCopy];
    if(self.searchBox.tag==2) self.objOptList=[self.ChemistList mutableCopy];
    if(self.searchBox.tag==3) self.objOptList=[self.CustomerList mutableCopy];//[self.CustomerList mutableCopy];
    if([self.searchBox.text isEqualToString:@""]==NO){
        self.objOptList = [self.objOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]];
    }
    [self.tvOptList reloadData];
}
-(IBAction)addMorePCompetitor:(id)sender
{
    if([self validateForm]){
        [self addRCPADetails];
        [self ClearFields];
        [_tvRCPAList reloadData];
        [_tvComptList reloadData];
    }
}

-(IBAction)SetCmptAndFltrProduct:(id)sender{
    
}
-(IBAction)OpenProduct:(id)sender{
    self.objOptList=[self.ProductList mutableCopy];
  //  self.SelOptList=[self.SelProductList mutableCopy];
    self.searchBox.tag=1;
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Products Selection",@"Products Selection")];
}
-(IBAction)OpenChemist:(id)sender{
    self.searchBox.tag=2;
    
    self.objOptList = [self.ChemistList mutableCopy];
    self.SelOptList=[self.SelChemistList mutableCopy];
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Chemist Selection",@"Chemist Selection")];
}
-(IBAction)OpenAdDoctor:(id)sender{
    self.searchBox.tag=3;
    
    self.objOptList = [self.CustomerList mutableCopy];
    self.SelOptList=[self.SelCustomerList mutableCopy];
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Additional Doctor Selection",@"Additional Doctor Selection")];
}
-(IBAction)OpenCompetitor:(id)sender{
    UITableViewCell *Icell=[self getTableViewCell:sender];
    UITableView *tbView=[self getTableView:Icell];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    self.objOptList=[self.mCompetitorList mutableCopy];
    //  self.SelOptList=[self.SelProductList mutableCopy];

    self.searchBox.tag=4;
    self.vfSelWindow.tag=indexPath.row;
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Competitor Selection",@"Competitor Selection")];
}
-(IBAction)OpenCompProd:(id)sender{
    UITableViewCell *Icell=[self getTableViewCell:sender];
    UITableView *tbView=[self getTableView:Icell];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    self.objOptList=[self.mCompProdList mutableCopy];
    //  self.SelOptList=[self.SelProductList mutableCopy];
    
    self.searchBox.tag=5;
    self.vfSelWindow.tag=indexPath.row;
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Competitor Brand Selection",@"Competitor Brand Selection")];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) setSelOptsValues:(id)sender{
    if(self.searchBox.tag==1)
    {
        self.SelPCode=[self.SelOptList valueForKey:@"Code"];
        self.SelPName=[self.SelOptList valueForKey:@"Name"];
        [self closeSelection];
    }
    if(self.searchBox.tag==2)
    {
        self.SelChemistList=[self.SelOptList mutableCopy];
        [_tvChemistList reloadData];
        [self closeSelection];
    }
    /*if(self.searchBox.tag==3)
    {
        self.SelAdCustList=[self.SelOptList mutableCopy];
        [_tvAdCusList reloadData];
        [self closeSelection];
    }*/
}
-(IBAction)hideSelection:(id)sender{
    [self closeSelection];
}
-(IBAction)setChecked:(id)sender{
    UIButton *btn=(UIButton *)sender;
    TBSelectionBxCell* cell;
    cell =[self.tvOptList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0] ];
    if(cell.Checked==YES){
        [cell.btnCheked setImage:nil forState:UIControlStateNormal];
        cell.Checked=NO;
    }else{
        [cell.btnCheked setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
        cell.Checked=YES;
        // [self.SelProductList set]
    }
}
-(void)txtCmptNameChange :(UITextField *)txtCmptNameField{
    UITableViewCell *Icell=[self getTableViewCell:txtCmptNameField];
    UITableView *tbView=[self getTableView:Icell];
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    
    [self.CompetitorList[indexPath.row] setValue:txtCmptNameField.text forKey:@"CompName"];
    
}
-(void)txtCPNameChange :(UITextField *)txtCPNameField{
    TBSelectionBxCell *Icell=(TBSelectionBxCell*)[self getTableViewCell:txtCPNameField];
    UITableView *tbView=[self getTableView:Icell];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    [self.CompetitorList[indexPath.row] setValue:txtCPNameField.text forKey:@"CompPName"];
}
-(void)txtCPQtyChange :(UITextField *)txtCPQtyField{
    TBSelectionBxCell *Icell=(TBSelectionBxCell*)[self getTableViewCell:txtCPQtyField];
    UITableView *tbView=[self getTableView:Icell];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    if([Icell.txtCPRate.text isEqualToString:@""]){
        [self.CompetitorList[indexPath.row] setValue:_txtOPRate.text forKey:@"CPRate"];
        Icell.txtCPRate.text=_txtOPRate.text;
        
    }
    float Q=[Icell.txtCPQty.text floatValue];
    float R=[Icell.txtCPRate.text floatValue];
    Icell.txtCPValue.text=[NSString stringWithFormat:@"%.02f",Q*R];
    [self.CompetitorList[indexPath.row] setValue:Icell.txtCPValue.text forKey:@"CPValue"];
    [self.CompetitorList[indexPath.row] setValue:txtCPQtyField.text forKey:@"CPQty"];
}
-(void)txtCPRateChange :(UITextField *)txtCPRateField{
    TBSelectionBxCell *Icell=(TBSelectionBxCell*)[self getTableViewCell:txtCPRateField];
    UITableView *tbView=[self getTableView:Icell];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    float Q=[Icell.txtCPQty.text floatValue];
    float R=[Icell.txtCPRate.text floatValue];
    Icell.txtCPValue.text=[NSString stringWithFormat:@"%.02f",Q*R];
    [self.CompetitorList[indexPath.row] setValue:Icell.txtCPValue.text forKey:@"CPValue"];
    
    [self.CompetitorList[indexPath.row] setValue:txtCPRateField.text forKey:@"CPRate"];
}
-(void)txtCPValueChange :(UITextField *)txtCPValueField{
    UITableViewCell *Icell=[self getTableViewCell:txtCPValueField];
    UITableView *tbView=[self getTableView:Icell];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    [self.CompetitorList[indexPath.row] setValue:txtCPValueField.text forKey:@"CPValue"];
}
-(IBAction)AddCmptList:(id)sender{
    [self.CompetitorList addObject:[_EmptyCompetDet mutableCopy]];
    [self.tvComptList reloadData];
}
-(IBAction)DeleteRow:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSMutableArray* tmpArr=[[NSMutableArray alloc]init];
    UITableView *TBView;
    
    NSInteger tbvId=btn.titleLabel.tag;
    if(tbvId==2){ tmpArr=[self.SelChemistList mutableCopy];TBView=self.tvChemistList; }
    [tmpArr removeObjectAtIndex:btn.tag];
    if(tbvId==2) self.SelChemistList=tmpArr;
    [TBView reloadData];
}
-(void) ClearFields{
    self.SelPCode=@"";
    self.SelPName=@"";
    self.lblOurPName.text=@"";
    self.txtOPQty.text=@"";
    self.txtOPRate.text=@"";
    self.txtOPValue.text=@"";
    _CompetitorList=[@[[_EmptyCompetDet mutableCopy],[_EmptyCompetDet mutableCopy],[_EmptyCompetDet mutableCopy],[_EmptyCompetDet mutableCopy],[_EmptyCompetDet mutableCopy]] mutableCopy];
}
-(BOOL) validateForm{
    if([self.meetData.CustCode isEqualToString:@""] || self.meetData.CustCode==nil ){
        [BaseViewController Toast:NSLocalizedString(@"Select the Doctor Name", @"Select the Doctor Name")];
        return NO;
    }
    if([self.SelChemistList count]<1){
        [BaseViewController Toast:NSLocalizedString(@"Select the Chemist Name", @"Select the Chemist Name")];
        return NO;
    }
    if([self.SelPCode isEqualToString:@""] || self.SelPCode==nil ){
        [BaseViewController Toast:NSLocalizedString(@"Select the Our Product Brand", @"Select the Our Product Brand")];
        return NO;
    }
    NSString *Qty=self.txtOPQty.text;
    if([Qty isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the Our Product Brand Qty", @"Enter the Our Product Brand Qty")];
        return NO;
    }
    if(![self isNumeric:Qty] || [Qty length]>3){
        [BaseViewController Toast:NSLocalizedString(@"Enter Numbers only and lessthen 1000", @"Enter Numbers only and lessthen 1000")];
        return NO;
    }
    
    NSString *Rate=self.txtOPRate.text;
    if([Rate isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the Our Product Brand Rate", @"Enter the Our Product Brand Rate")];
        return NO;
    }
    if(![self isFloat:Rate]){
        [BaseViewController Toast:NSLocalizedString(@"Enter Numbers with Amount format.", @"Enter Numbers with Amount format.")];
        return NO;
    }
    NSString *Value=self.txtOPValue.text;
    if([Value isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Enter the Our Product Brand Value", @"Enter the Our Product Brand Value")];
        return NO;
    }
    if(![self isFloat:Value]){
        [BaseViewController Toast:NSLocalizedString(@"Enter Numbers with Amount format.", @"Enter Numbers with Amount format.")];
        return NO;
    }
    for(int il=0;il<[_CompetitorList count];il++)
    {
        NSDictionary* iCmpt=[[NSDictionary alloc] initWithDictionary:_CompetitorList[il]];
        if((![[iCmpt valueForKey:@"CompName"] isEqualToString:@""] || ![[iCmpt valueForKey:@"CompPName"] isEqualToString:@""]))
        {
            if([[iCmpt valueForKey:@"CompName"] isEqualToString:@""] || [iCmpt valueForKey:@"CompName"]==nil){
                [BaseViewController Toast:NSLocalizedString(@"Enter the Competitor Name", @"Enter the Competitor Name")];
                return NO;
            }
            if([[iCmpt valueForKey:@"CompPName"] isEqualToString:@""] || [iCmpt valueForKey:@"CompPName"]==nil){
                [BaseViewController Toast:NSLocalizedString(@"Enter the Competitor Product Brand", @"Enter the Competitor Product Brand")];
                return NO;
            }
            
            NSString *Qty=[iCmpt valueForKey:@"CPQty"];
            if([Qty isEqualToString:@""] ||[Qty isEqualToString:@"0"] || [iCmpt valueForKey:@"CPQty"]==nil){
                [BaseViewController Toast:NSLocalizedString(@"Enter the Competitor Qty", @"Enter the Competitor Qty")];
                return NO;
            }
            if(![self isNumeric:Qty] || [Qty length]>3){
                [BaseViewController Toast:NSLocalizedString(@"Enter Numbers only and lessthen 1000", @"Enter Numbers only and lessthen 1000")];
                return NO;
            }
            NSString *Rate=[iCmpt valueForKey:@"CPRate"];
            if([Rate isEqualToString:@""] || [iCmpt valueForKey:@"CPRate"]==nil){
                [BaseViewController Toast:NSLocalizedString(@"Enter the Competitor Rate", @"Enter the Competitor Rate")];
                return NO;
            }
            if(![self isFloat:Rate]){
                [BaseViewController Toast:NSLocalizedString(@"Enter Numbers with Amount format.", @"Enter Numbers with Amount format.")];
                return NO;
            }
            NSString *Value=[iCmpt valueForKey:@"CPValue"];
            if([Value isEqualToString:@""] || [iCmpt valueForKey:@"CPValue"]==nil){
                [BaseViewController Toast:NSLocalizedString(@"Enter the Competitor Value", @"Enter the Competitor Value")];
                return NO;
            }
            if(![self isFloat:Value]){
                [BaseViewController Toast:NSLocalizedString(@"Enter Numbers with Amount format.", @"Enter Numbers with Amount format.")];
                return NO;
            }
        }
    }
    return YES;
}
-(IBAction) CloseWindow:(id)sender {
    if([self.DCREntryMode isEqualToString:@"1"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
    }
}
-(IBAction)SaveRCPAEntry:(id)sender{
    if(![self.SelPCode isEqualToString:@""] && self.SelPCode!=nil ){
        if(![self validateForm]){
            return;
        }
        [self addRCPADetails];
    }
    if([self.DCREntryMode isEqualToString:@"1"]){
        _meetData.RCPAEntry=[self.RCPADetails mutableCopy];
        NSLog(@"RCPAData : %@",[self.meetData toNSDictionary]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
    }
}
-(void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIView* CtxtFld=[self getFocusedCtrl];
    if (CtxtFld!=nil){
        CGRect viewFrame = self.view.window.frame;
        CGRect textFieldRect = [self.view.window convertRect:CtxtFld.bounds fromView:CtxtFld];
        CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
        CGFloat textFieldBottomLine = textFieldRect.origin.y + textFieldRect.size.height + LITTLE_SPACE;
        
        CGFloat keyboardHeight = _keyboardSize.height;
        
        BOOL isTextFieldHidden = textFieldBottomLine > (viewRect.size.height - keyboardHeight)? TRUE :FALSE;
        if (isTextFieldHidden) {
            viewFrame.origin.y=0;
            _animatedDistance = textFieldBottomLine - (viewRect.size.height - keyboardHeight) ;
            viewFrame.origin.y -= _animatedDistance;
            if(viewFrame.origin.y>0) viewFrame.origin.y=0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:ANIMATION_DURATION];
            //[self.view.window layoutIfNeeded];
            [self.view.window setFrame:viewFrame];
            [UIView commitAnimations];
        }
    }
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect viewFrame = self.view.window.frame;
    viewFrame.origin.y=0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    //[self.view.window layoutIfNeeded];
    
    [self.view.window setFrame:viewFrame];
    [UIView commitAnimations];
}
-(UIView *) getFocusedCtrl{
    NSArray *allSubviewsOfWindow = [self allSubviewsOfView:self.view];
    for(UIView *subview in allSubviewsOfWindow)
    {
        if([subview isKindOfClass: [UITextView class]])
        {
            if(((UITextView*)subview).isFocused) return subview;
        }
        
        if([subview isKindOfClass: [UITextField class]])
        {
            if(((UITextField*)subview).isEditing) return subview;
        }
    }
    return nil;
}
- (NSArray *)allSubviewsOfView:(UIView *)view
{
    NSMutableArray *subviews = [[view subviews] mutableCopy];
    for (UIView *subview in [view subviews])
        [subviews addObjectsFromArray:[self allSubviewsOfView:subview]]; //recursive
    return subviews;
}

-(UITableView *) getTableView:(UIView *)view{
    UITableView *tbView=(UITableView *) view;
    while(![tbView isKindOfClass: [UITableView class]])
    {
        tbView=(UITableView *) tbView.superview;
    }
    return tbView;
}
-(UITableViewCell *) getTableViewCell:(UIView *)view{
    UITableViewCell *tbCell=(UITableViewCell *) view;
    while(![tbCell isKindOfClass: [UITableViewCell class]])
    {
        tbCell=(UITableViewCell *) tbCell.superview;
    }
    return tbCell;
}
-(BOOL) isNumeric:(NSString*) string{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    return [scanner scanInteger:NULL] && [scanner isAtEnd];
}
-(BOOL) isFloat:(NSString*) string{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    return [scanner scanFloat:NULL] && [scanner isAtEnd];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}7010666212
*/

@end
