//
//  SurveyActivityCtrl.m
//  SANDigitalDetailing
//
//  Created by Mac on 25/04/21.
//  Copyright © 2021 SANeForce.com. All rights reserved.
//

#import "SurveyActivityCtrl.h"
#import "mCustomerCell.h"
#define kCtrlStart 16

#define mHeight 185

@interface SurveyActivityCtrl ()<UISearchBarDelegate>

//@property (nonatomic, strong) NSArray* ObjCustomerList;
@property (nonatomic, strong) NSArray* CustomerList;
@property (nonatomic, strong) NSArray* arrChemistList;

@property (nonatomic,strong) TdayPlDetail* TdayPl;

@property (nonatomic,strong) NSMutableArray *objSurveyList;

@property (nonatomic, retain) IBOutlet UIView* vwModeModal;
@property (nonatomic, retain) IBOutlet UIView* vwHQListModel;

@property (nonatomic,retain) IBOutlet UITableView *selTypeMode;
@property (nonatomic,retain) IBOutlet UITableView *tblHQList;

@property (nonatomic, strong) NSArray* Types;
@property (nonatomic,strong) NSArray *objHQList;

@property (weak, nonatomic) NSString* CustCode;
@property (weak, nonatomic) NSString* SpecCode;
@property (weak, nonatomic) NSString* CateCode;

@property(nonatomic,strong) NSString* SelType;
@property(nonatomic,strong) NSString* DataSF;

@property (nonatomic, strong) NSMutableArray* arrControlsDets;
@property (nonatomic, strong) NSMutableArray* ObjCtrlList;
@property (nonatomic, strong) NSMutableArray* FormsCtrls;
@property(nonatomic,assign) SANControlsBox* eCtrl;
@property(nonatomic,assign) float cyAxis,scrlHeight,defHeight;
@property(nonatomic,strong) NSString* selCat;
@property(nonatomic,strong) NSString* selSpec;
@property(nonatomic,strong) NSString* selChemist;
@property(nonatomic,strong) NSString* selSurvery;
@property(nonatomic,strong) NSString* selMode;
@property(nonatomic,strong) NSString* selSurveryID;
@property(nonatomic,strong) NSString* selHQName;
@property(nonatomic,strong) NSString* fromDate;
@property(nonatomic,strong) NSString* toDate;


@end

@implementation SurveyActivityCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //http://crm.sanclm.info/Server/db_native.php?divisionCode=28%2C&rSF=MR0840&axn=getsurvey&orderBy=&sfCode=MR0840
    self.UserDet=[UserDetails sharedUserDetails];
    self.SetupData=[AppSetupData sharedDatas];
    self.meetData=[CallMeetData sharedDatas];
    
    _DataSF=self.UserDet.SF;
    self.tbSurveyLst.delegate=self;
    self.tbSurveyLst.dataSource=self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.txtfldSearchBar.showsCancelButton = YES;
    
    //    [self.vwAdCtrl setBackgroundColor:[UIColor yellowColor]];
    UIImageView* btnImg=[[UIImageView alloc] initWithFrame:CGRectMake(_btnFilter.frame.size.width-18, (_btnFilter.frame.size.height-10)/2,10, 10)];
    btnImg.image=[[UIImage imageNamed:@"DwnArrw"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    btnImg.tintColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];
    [_btnFilter addSubview:btnImg];
    
    _SelType=@"";
    _Types=@[
        [self AddItem:@"1" andName:NSLocalizedString(self.SetupData.CapDr, self.SetupData.CapDr)],
        [self AddItem:@"2" andName:NSLocalizedString(self.SetupData.CapChm, self.SetupData.CapChm)],
        /* [self AddItem:@"3" andName:NSLocalizedString(self.SetupData.CapStk, self.SetupData.CapStk)],
         [self AddItem:@"4" andName:NSLocalizedString(self.SetupData.CapUdr, self.SetupData.CapUdr)],
         [self AddItem:@"5" andName:NSLocalizedString(self.SetupData.CapHos, self.SetupData.CapHos)]*/
    ];
    NSMutableDictionary *pram=nil;
    if(_meetData.CustCode!=nil)
    {
        pram=[[NSMutableDictionary alloc] init];
        [pram setValue:_meetData.CustCode forKey:@"CustCode"];
        [pram setValue:_meetData.CusType forKey:@"CustType"];
        
        int SCCd=[ _meetData.CusType intValue];
        for (int ik=0; ik<[_Types count]; ik++) {
            if(SCCd==[[_Types[ik] objectForKey:@"Code"] intValue])
            {
                NSDictionary *item = _Types[ik];
                [_btnFilter setTitle:NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"]) forState:UIControlStateNormal];
                _txtSelCus.placeholder=[NSString stringWithFormat:@"Search %@", NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"])];
                int TyCd=[[_Types[ik] objectForKey:@"Code"] intValue];
                _btnFilter.tag = [[_Types[ik] objectForKey:@"Code"] intValue];
                
                if(TyCd==1) _SelType=@"D";
                if(TyCd==2) _SelType=@"C";
                if(TyCd==3) _SelType=@"S";
                if(TyCd==4) _SelType=@"U";
                if(TyCd==5) _SelType=@"H";
                
                self.txtSelCus.text=_meetData.CustName;
                self.CustCode=_meetData.CustCode;
                
                [self getDataList];
                //[self.collectionView reloadData];
            }
        }
        
    }
    
    self.TdayPl=[TdayPlDetail sharedTdayPlDetail];
    
    if([_UserDet.Desig isEqualToString:@"MR"]){
        _btnSelectHeadQtr.enabled=NO;
        self.DataSF = self.UserDet.SF;
        [_btnSelectHeadQtr setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(self.UserDet.SFName, self.UserDet.SFName) ] forState:UIControlStateNormal];
        //[_btnSelectHeadQtr setHidden:YES];
    }
    else
    {
        [_btnSelectHeadQtr setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(self.TdayPl.HQNm, self.TdayPl.HQNm) ] forState:UIControlStateNormal];
        self.DataSF = self.TdayPl.SFMem;
        _btnSelectHeadQtr.enabled=YES;
        [_btnSelectHeadQtr setHidden:NO];
    }
    
    [self getDataList];
    [WBService SendServerRequest:@"GET/Survey" withParameter:pram withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        _objSurveyList=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        _objSurveyList = [[self filterSurvay:_objSurveyList] mutableCopy];
        [self.tbSurveyLst reloadData];
    } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.tblHQList) return  50;
    if(tableView==self.selTypeMode) return 50;
    if(tableView==self.tbSurveyLst) return 53;
    return 42;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.selTypeMode) return self.Types.count;
    if(tableView==self.tbSurveyLst) return [_objSurveyList count];
    if(tableView==self.tblHQList) return [self.objHQList count];
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell ;
    if(tableView==self.tbSurveyLst){
        cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *objItem = self.objSurveyList[indexPath.row];
        
        cell.lOptText.text = [objItem objectForKey:@"name"];
        cell.lOptFDate.text = [objItem objectForKey:@"from_date"];
        cell.lOptTDate.text = [objItem objectForKey:@"to_date"];
    }
    if(tableView==self.selTypeMode) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height)];
        lbl.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
        //[cell.lOptText setFrame:CGRectMake(18, 9, cell.frame.size.width-18, cell.frame.size.height)];
        lbl.text = [_Types[indexPath.row] objectForKey:@"Name"];
        [cell addSubview:lbl];
    }
    if(tableView==self.tblHQList){
        cell=[tableView dequeueReusableCellWithIdentifier:@"HQCell" forIndexPath:indexPath];
        //        UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height)];
        //        lbl.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
        //        lbl.text = [self.objHQList[indexPath.row] objectForKey:@"name"];
        //        [cell addSubview:lbl];
        cell.textLabel.text = [self.objHQList[indexPath.row] objectForKey:@"name"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==self.tbSurveyLst){
        
        NSDictionary *objItem = self.objSurveyList[indexPath.row];
        if(_selSurvery != nil && ![self.vwAdCtrl isHidden] && ![_selSurvery isEqualToString:[NSString stringWithFormat:@"%@",[objItem objectForKey:@"name"]]])
        {
            [self.vwAdCtrl setHidden:YES];

        }
        self.txtSelCus.text = @"";
        self.CustomerList = [NSMutableArray new];
        [_btnFilter setTitle:NSLocalizedString( @"-- Select --",@"SelectDropdown") forState:UIControlStateNormal];
        _txtSelCus.placeholder=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Select the doctor", @"Select the doctor")];
        _selMode = @"";
        [_btnSubmitSurvey setUserInteractionEnabled:NO];

        [self.collectionView reloadData];
        _ObjCtrlList=[objItem objectForKey:@"survey_for"];
        _lblSrvyNm.text=[objItem objectForKey:@"name"];
        _selCat=[_ObjCtrlList[0] valueForKey:@"DrCat"];
        _selSpec=[_ObjCtrlList[0] valueForKey:@"DrSpl"];
        _selChemist=[_ObjCtrlList[0] valueForKey:@"ChmCat"];
        _selSurvery = [objItem valueForKey:@"name"];
        _selSurveryID = [objItem valueForKey:@"id"];
        
        
        //        if(_meetData.CustCode!=nil){
        //            self.vwAdCtrl.hidden = NO;
        //            _arrControlsDets=[_ObjCtrlList mutableCopy];
        //            [self generateCtrls];
        //        }
        //        else
        //            self.vwAdCtrl.hidden = YES;
        
        [self getDataList];
//
//        if([self.SelType isEqualToString:@"D"])
//        {
//            [self filterDoctorList];
//        }
//        else if ([self.SelType isEqualToString:@"C"])
//        {
//            [self filterChemistList];
//        }
//
//        [self addForm];
    }
    if(tableView==self.selTypeMode) {
        //[self clearForms];
        NSDictionary *item = _Types[indexPath.row];
        
        if(_selMode != nil && ![self.vwAdCtrl isHidden] && ![_selMode isEqualToString:[NSString stringWithFormat:@"%@",[item objectForKey:@"Name"]]] && _ObjCtrlList.count > 0)
        {

            self.txtSelCus.text=@"";
            [self.vwAdCtrl setHidden:YES];
        }
        _selCat=[_ObjCtrlList[0] valueForKey:@"DrCat"];
        _selSpec=[_ObjCtrlList[0] valueForKey:@"DrSpl"];
        _selChemist=[_ObjCtrlList[0] valueForKey:@"ChmCat"];
        
        [_btnFilter setTitle:NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"]) forState:UIControlStateNormal];
        _txtSelCus.placeholder=[NSString stringWithFormat:@"Search %@", NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"])];
        int TyCd=[[_Types[indexPath.row] objectForKey:@"Code"] intValue];
        _btnFilter.tag = [[_Types[indexPath.row] objectForKey:@"Code"] intValue];
        
        _selMode = [item objectForKey:@"Name"];
        
        if(TyCd==1) _SelType=@"D";
        if(TyCd==2) _SelType=@"C";
        if(TyCd==3) _SelType=@"S";
        if(TyCd==4) _SelType=@"U";
        if(TyCd==5) _SelType=@"H";
        
        [self getDataList];
        
        
        if([self.SelType isEqualToString:@"D"])
        {
            [self filterDoctorList];
            
        }
        else if ([self.SelType isEqualToString:@"C"])
        {
            [self filterChemistList];
        }
        //[self.collectionView reloadData];
        [_vwModeModal removeFromSuperview];
        [self addForm];
        
        
    }
    if(tableView == self.tblHQList){
        //[self clearForms];
        NSDictionary *objItem = self.objHQList[indexPath.row];
        
        if(_selMode != nil && ![_selHQName isEqualToString:[NSString stringWithFormat:@"%@",[objItem objectForKey:@"name"]]] && _objSurveyList.count > 0)
        {
            _selCat=[_ObjCtrlList[0] valueForKey:@"DrCat"];
            _selSpec=[_ObjCtrlList[0] valueForKey:@"DrSpl"];
            _selChemist=[_ObjCtrlList[0] valueForKey:@"ChmCat"];
        }
        
        [self.btnSelectHeadQtr setTitle:[objItem objectForKey:@"name"]  forState:UIControlStateNormal];
        [_vwHQListModel removeFromSuperview];
        self.DataSF = [objItem objectForKey:@"id"];
        _selHQName = [objItem objectForKey:@"name"];
        self.meetData.DataSF=[objItem objectForKey:@"id"];
        [self getDataList];
        if([self.SelType isEqualToString:@"D"])
        {
            [self filterDoctorList];
        }
        else if ([self.SelType isEqualToString:@"C"])
        {
            [self filterChemistList];
        }
        
        
        self.txtSelCus.text=@"";
        //[self.collectionView reloadData];
        [self addForm];
        
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.CustomerList.count == 1)
        return CGSizeMake((CGRectGetWidth(collectionView.bounds))-7, 125);
    else
        return CGSizeMake((CGRectGetWidth(collectionView.bounds)/3)-7, 125);

        
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.CustomerList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mCustomerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    cell.layer.cornerRadius=4.0f;
    if(self.CustomerList.count > 0)
    {
        cell.lCustName.text = [self.CustomerList[indexPath.row] objectForKey:@"Name"];
        cell.lTownName.text = [self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
        cell.lCategory.text = [self.CustomerList[indexPath.row] objectForKey:@"Category"];
        cell.lSpeciality.text = [self.CustomerList[indexPath.row] objectForKey:@"Specialty"];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.CustomerList.count >0)
    {
        NSMutableDictionary* SelItem= self.CustomerList[indexPath.row];
        self.txtSelCus.text=[SelItem objectForKey:@"Name"];
        self.CustCode=[SelItem objectForKey:@"Code"];
        self.SpecCode=[SelItem objectForKey:@"SpecialtyCode"];
        _arrControlsDets=[_ObjCtrlList mutableCopy];
        
        if([_SelType isEqualToString:@"D"])
            self.CateCode=[SelItem objectForKey:@"CategoryCode"];
        else if ([_SelType isEqualToString:@"C"])
            self.CateCode=[SelItem objectForKey:@"Chm_cat"];
        
        // _arrControlsDets=[[_ObjCtrlList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type==%@ and Cat_code == %ld",Typ,CatID]] mutableCopy];
       // [self generateCtrls];
        [self addForm];
        _vwCusList.hidden=YES;
    }
}

-(IBAction) gotoHome:(id)sender{
    if(_meetData.CustCode!=nil){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
    }
    //NSArray *viewControllers = [self.navigationController viewControllers];
    //[self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}
-(IBAction) showCustList:(id)sender{
    
    _txtfldSearchBar.text = @"";
    [self getDataList];
    if ([_SelType isEqualToString:@"D"]) {
        [self filterDoctorList];
    }
    else
        [self filterChemistList];
    
    
    if (_selSurvery.length == 0)
        [BaseViewController Toast:NSLocalizedString(@"Please Select Survey", @"Please Select Survey")];
    else if(_selMode.length == 0)
        [BaseViewController Toast:NSLocalizedString(@"Please Select DCR type", @"Please Select DCR type")];
    else
        _vwCusList.hidden=NO;
    
}
-(IBAction) hideCustList:(id)sender{
    _vwCusList.hidden=YES;
    
}
-(IBAction) showSelMode:(id)sender{
    _vwModeModal=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _vwModeModal.backgroundColor=[UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.6];
    UIView* vwMode=[[UIView alloc] initWithFrame:CGRectMake(_vwCusSel.superview.frame.origin.x+_btnFilter.frame.origin.x+10, _vwCusSel.frame.origin.y+_btnFilter.frame.size.height+80, _btnFilter.frame.size.width, /*200*/ _Types.count * 60)];
    vwMode.backgroundColor=[UIColor whiteColor];
    self.selTypeMode=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, _btnFilter.frame.size.width, /*200*/ _Types.count * 50)];
    [self.selTypeMode registerClass:[TBSelectionBxCell class] forCellReuseIdentifier:@"Cell"];
    
    // _selTypeMode.rowHeight = 42;
    _selTypeMode.scrollEnabled = YES;
    _selTypeMode.showsVerticalScrollIndicator = YES;
    _selTypeMode.userInteractionEnabled = YES;
    _selTypeMode.bounces = YES;
    
    _selTypeMode.delegate = self;
    _selTypeMode.dataSource = self;
    [vwMode addSubview:self.selTypeMode];
    [_vwModeModal addSubview:vwMode];
    
    [self.view addSubview:_vwModeModal];   //vwMode
    // [vwMode.centerXAnchor constraintEqualToAnchor:vwModeModal.centerXAnchor].active=YES;
    //[vwMode.centerYAnchor constraintEqualToAnchor:vwModeModal.centerYAnchor].active=YES;
}
- (void)didChecked:(id)Control{
    NSLog(@"Chkbox Clicked...");
}
-(NSMutableDictionary *) AddItem:(NSString *) Code andName:(NSString *) Name{
    NSMutableDictionary * newItem=[[NSMutableDictionary alloc] init];
    [newItem setValue:Code forKey:@"Code"];
    [newItem setValue:Name forKey:@"Name"];
    return newItem;
}

-(void) getDataList{
    
    if(_selSurvery.length == 0)
    {
        [_btnSubmitSurvey setUserInteractionEnabled:FALSE];
        _vwCusList.hidden=YES;
        return;
    }
    else
    {
        [_btnFilter setUserInteractionEnabled:TRUE];
    }
    NSString *apiKey =[[NSString alloc] init];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.DataSF];
    self.CustomerList = [[NSArray alloc] init];
    if ([_SelType isEqualToString:@"D"]){
        DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.DataSF];
        apiKey= NSLocalizedString(@"Doctor", @"Doctor");
    }
    if ([_SelType isEqualToString:@"C"]){
        DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.DataSF];
        apiKey= NSLocalizedString(@"Chemist", @"Chemist");

//        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
        
    }
    if ([_SelType isEqualToString:@"S"]){
        DataKey=[[NSString alloc] initWithFormat:@"StockistDetails_%@.SANAPP",self.DataSF];

    }
    if ([_SelType isEqualToString:@"U"]){
        DataKey=[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",self.DataSF];

    }
    if ([_SelType isEqualToString:@"H"]){
        DataKey=[[NSString alloc] initWithFormat:@"Hospital_%@.SANAPP",self.DataSF];

    }
    self.CustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
     
    if(self.CustomerList.count == 0 || self.CustomerList == nil)
    {
        [self LoadData:[NSString  stringWithFormat:@"GET/%@",apiKey] withParam:nil andDataFor:self.DataSF andkey:[NSString  stringWithFormat:@"%@",DataKey]];

    }
    
    self.CustomerList =[self FilterUnique:self.CustomerList andKey:@"Code"];
    if ([_SelType isEqualToString:@"D"]){
        if(![_selCat isEqualToString:@""]){
            self.CustomerList =[self FilterRevUnique:self.CustomerList andKey:@"Code"];
            
            //            self.meetData.DataSF=[HQ objectForKey:@"id"];
            //            NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
            //
            //            self.CustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
        }
        if(![_selSpec isEqualToString:@""]){
            self.CustomerList =[self FilterRevUnique:self.CustomerList andKey:@"Code"];
        }
    }
    
    /*int flag=1;
     self.ObjCustomerList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"PlcyAcptFl.intValue == %d",flag]] mutableCopy];*/
    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    
    self.CustomerList = [[self.CustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
}
-(NSArray *) FilterUnique:(NSArray*) srcArray andKey:(NSString*) key {
    NSMutableArray* decArray=[[NSMutableArray alloc] init];
    for(int il=0;il<[srcArray count];il++){
        NSArray* itms=[decArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K==%@",key, [srcArray[il] valueForKey:key]]];
        if([itms count]<1){
            [decArray addObject:[srcArray[il] mutableCopy]];
        }
    }
    return decArray;
}
-(NSArray *) FilterRevUnique:(NSArray*) srcArray andKey:(NSString*) key {
    NSMutableArray* decArray=[[NSMutableArray alloc] init];
    for(int il=0;il<[srcArray count];il++){
        NSArray* itms=[decArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains[c] %K",key, [srcArray[il] valueForKey:key]]];
        if([itms count]<1){
            [decArray addObject:[srcArray[il] mutableCopy]];
        }
    }
    return decArray;
}



-(void) generateCtrls{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"LoadinStatus", @"Loading..")];

    _cyAxis=0;_scrlHeight=0;
    if(self.vwCtrlsView!=nil){
        [self.vwCtrlsView removeFromSuperview];
    }
    self.vwCtrlsView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vwAdCtrl.frame.size.width, _scrlHeight)];
    _FormsCtrls=[[NSMutableArray alloc] init];
    long inc=0;long PrvScroll=0;
    
    for (int il=0; il<[_arrControlsDets count]; il++) {
        [_btnSubmitSurvey setUserInteractionEnabled:YES];

        NSString* QSType = [[_arrControlsDets[il] valueForKey:@"Stype"] stringByReplacingOccurrencesOfString:@"," withString:@""];

        //NSString* QSType=[NSString stringWithFormat:@",%@",[_arrControlsDets[il] valueForKey:@"Stype"]];
        Boolean Flg=NO;
        if ([_SelType isEqualToString:@"D"] && [QSType rangeOfString:@"D"].length>0){
            _selCat=[NSString stringWithFormat:@",%@,",[_arrControlsDets[il] valueForKey:@"DrCat"]];
            _selSpec=[NSString stringWithFormat:@",%@,",[_arrControlsDets[il] valueForKey:@"DrSpl"]];
            if([_selCat rangeOfString:[NSString stringWithFormat:@",%@,",self.CateCode]].length>0 ||
               [_selSpec rangeOfString:[NSString stringWithFormat:@",%@,",self.SpecCode]].length>0
               )
                Flg=YES;
        }
        if ([_SelType isEqualToString:@"C"] && [QSType rangeOfString:@"C"].length>0){
            _selCat=[NSString stringWithFormat:@",%@,",[_arrControlsDets[il] valueForKey:@"ChmCat"]];
            // _selSpec=[NSString stringWithFormat:@",%@,",[_arrControlsDets[il] valueForKey:@"DrSpl"]];
            
            if([_selCat rangeOfString:[NSString stringWithFormat:@",%@,",self.CateCode]].length>0)
                Flg=YES;
        }
        if ([_SelType isEqualToString:@"S"] && [QSType rangeOfString:@"S"].length>0){
            if([_selCat rangeOfString:[NSString stringWithFormat:@",%@,",self.CateCode]].length>0 ||
               [_selSpec rangeOfString:[NSString stringWithFormat:@",%@,",self.SpecCode]].length>0
               )
                Flg=YES;
        }
        if ([_SelType isEqualToString:@"H"] && [QSType rangeOfString:@"H"].length>0){
            if([_selCat rangeOfString:[NSString stringWithFormat:@",%@,",self.CateCode]].length>0 ||
               [_selSpec rangeOfString:[NSString stringWithFormat:@",%@,",self.SpecCode]].length>0
               )
                Flg=YES;
        }
        if(Flg==YES){
            NSLog(@"%@",[_arrControlsDets[il] valueForKey:@"Qname"]);
            NSString* Caption=[_arrControlsDets[il] valueForKey:@"Qname"];
            NSString* lType=[_arrControlsDets[il] valueForKey:@"Qtype"];
            NSString* QAns=[_arrControlsDets[il] valueForKey:@"Qanswer"];
            
            NSArray* aryVals=[QAns componentsSeparatedByString:@","];
            //yet to Change
            int CtrlID=0;
            if([lType isEqualToString:@"Enterable - Text"]) CtrlID=1;
            if([lType isEqualToString:@"Enterable - Numeric"]) CtrlID=2;
            if([lType isEqualToString:@"Selectable - Single"]) CtrlID=31;
            if([lType isEqualToString:@"Selectable- Multiple"]) CtrlID=32;
            
            //int CtrlID=[[_arrControlsDets[il] valueForKey:@"Control_Id"] intValue];
            int CrID=[[_arrControlsDets[il] valueForKey:@"Qc_id"] intValue];
            
            float height=65.0f;
            if (CtrlID==3 || CtrlID==Files) height=110.0f;
            if (CtrlID==0) height=30.0f;
            
            if(CtrlID>=31){
                int itmCnt = (int)([aryVals count])-1;
                int rwNo=(int) itmCnt/3;
                if((itmCnt-(rwNo*3))>0){
                    rwNo++;
                }
                height=(rwNo*40)+30;
            }
            BOOL isRange=NO;
            if (CtrlID==5 || CtrlID==7) isRange=YES;
            long mWidth=_vwAdCtrl.frame.size.width;///2;
            
            SANControlsBox *CardView=[[SANControlsBox alloc] initWithFrame:CGRectMake(kCtrlStart+inc, _cyAxis, mWidth-((kCtrlStart*2)+4) , height)  title:Caption ControlType:CtrlID ListValues:QAns isRange:isRange];
            CardView.Caption=Caption;
            CardView.ID=[NSString stringWithFormat:@"%@ %d_%d",NSLocalizedString(@"Ctrl_", @"Ctrl_") ,CtrlID,il];
            CardView.index=il;
            CardView.isMandate=YES;
            CardView.HeadColor=[UIColor colorWithRed:255.0f/255.0f green:29.0f/255.0f blue:37.0f/255.0f alpha:1.0f];
            CardView.BgColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            if(CtrlID==TextField||CtrlID==NumberField||CtrlID==TextArea) {
                CardView.MaxLength=500;//[[_arrControlsDets[il] valueForKey:@"Control_Para"] integerValue];
            }
            CardView.delegate=self;
            
            [self.vwCtrlsView addSubview:CardView];
            _cyAxis+=CardView.frame.size.height+5;
            _scrlHeight+=CardView.frame.size.height+5;
            /*
             if(inc==0) {inc=mWidth;
             }else{inc=0;
             _cyAxis+=CardView.frame.size.height+5;
             _scrlHeight+=CardView.frame.size.height+5;
             }*/
            [_FormsCtrls addObject:CardView];
        }
    }
    [self.vwCtrlsView setFrame:CGRectMake(0, 0, self.vwCtrlArea.frame.size.width-0, _scrlHeight)];
    [self.vwAdCtrl setFrame:CGRectMake(0, 0, self.vwCtrlArea.frame.size.width-0, _scrlHeight)];
    [self.vwAdCtrl addSubview:self.vwCtrlsView];
    [self.vwCtrlArea setContentSize: CGSizeMake(self.vwCtrlsView.frame.size.width, self.vwCtrlsView.frame.size.height+16)];
    //[self.vwScrlContView setContentSize: CGSizeMake(self.vwCtrlsView.frame.size.width, self.vwCtrlsView.frame.size.height+16)];
    [SVProgressHUD dismiss];
    
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnSelectHdQtr:(id)sender{
    
    [self updateHQData];
}
-(NSArray* )filterSurvay:(NSArray* )surveryList
{
    NSMutableArray *arrFilteredDate = [[NSMutableArray alloc] init];
    
    for (int i =0; i<surveryList.count; i++) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *fromDate = [dateFormatter dateFromString:[surveryList[i] objectForKey:@"from_date"]];
        NSDate *toDate =  [dateFormatter dateFromString:[surveryList[i] objectForKey:@"to_date"]];
        
        if (([fromDate compare:[NSDate date]] == NSOrderedAscending) && ([toDate compare:[NSDate date]] == NSOrderedDescending)) {
            [arrFilteredDate addObject:surveryList[i]];
        }
    }
    return arrFilteredDate;
    
}
-(void)filterChemistList
{
    if(self.CustomerList.count > 0 && _selChemist!= nil )
    {
        NSMutableArray *arrChemist = [[_selChemist componentsSeparatedByString:@","] mutableCopy];
        NSMutableArray *filteredCustomerList = [[NSMutableArray alloc] init];
        
        for (id dID in arrChemist) {
            if(![dID isEqualToString:@""] )
            {
                NSArray *data = [self.CustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Chm_cat contains[c] %@",dID]];
                
                [filteredCustomerList addObjectsFromArray:data];
            }
        }
        self.CustomerList = filteredCustomerList;
    }
    else
        self.CustomerList = [NSMutableArray new];
    
    [_collectionView reloadData];

}
-(void)filterDoctorList
{
    NSMutableArray *filteredCustomerList = [[NSMutableArray alloc] init];
    
    if((_selSpec.length >0 || _selCat.length >0) && self.CustomerList.count > 0 )
    {
        //hq code(done in didselect), dr code = CategoryCode, speciality = SpecialtyCode, survey = name
        NSMutableArray *arrCust = [[_selCat componentsSeparatedByString:@","] mutableCopy];
        
        for (id dID in arrCust) {
            if(![dID isEqualToString:@""] )
            {
                NSArray *data = [self.CustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CategoryCode contains[c] %@",dID]];
                [filteredCustomerList addObjectsFromArray:data];
            }
        }
        if(filteredCustomerList.count == 0)
            filteredCustomerList = [self.CustomerList mutableCopy];
        NSMutableArray *arrSpl = [[_selSpec componentsSeparatedByString:@","] mutableCopy];
        NSMutableArray *arrfilterDr =[NSMutableArray new];
        for (id dID in arrSpl) {
            if(![dID isEqualToString:@""] )
            {
                NSArray *data = [[filteredCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SpecialtyCode contains[c] %@",dID]] mutableCopy];
                [arrfilterDr addObjectsFromArray:data];
            }
        }
        NSLog(@"HERE %@",arrfilterDr);
        self.CustomerList = arrfilterDr;
    }
    else
        self.CustomerList = [NSMutableArray new];
    [_collectionView reloadData];

}

-(void)updateHQData
{
    if (self.vwAdCtrl != nil) {
        NSLog(@"test");
    }
    
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
    _vwHQListModel=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _vwHQListModel.backgroundColor=[UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.6];
    
    UIView* vwHdQtrList=[[UIView alloc] initWithFrame:CGRectMake(_btnSelectHeadQtr.frame.origin.x, _btnSelectHeadQtr.frame.origin.y+_btnSelectHeadQtr.frame.size.height, _btnSelectHeadQtr.frame.size.width, /*200*/ _objHQList.count * 60)];
    vwHdQtrList.backgroundColor=[UIColor whiteColor];
    self.tblHQList=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, _btnSelectHeadQtr.frame.size.width, /*200*/ _objHQList.count * 50)];
    [self.tblHQList registerClass:[TBSelectionBxCell class] forCellReuseIdentifier:@"HQCell"];
    
    
    // _tblHQList.rowHeight = 42;
    _tblHQList.scrollEnabled = YES;
    _tblHQList.showsVerticalScrollIndicator = YES;
    _tblHQList.userInteractionEnabled = YES;
    _tblHQList.bounces = YES;
    
    _tblHQList.delegate = self;
    _tblHQList.dataSource = self;
    [vwHdQtrList addSubview:self.tblHQList];
    [_vwHQListModel addSubview:vwHdQtrList];
    
    [self.view addSubview:_vwHQListModel];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length > 0)
    {
        [self getDataList];
        if ([_SelType isEqualToString:@"D"]) {
            [self filterDoctorList];
        }
        else
            [self filterChemistList];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name contains[c] %@",searchText];
        NSArray *results = [self.CustomerList filteredArrayUsingPredicate:predicate];
        self.CustomerList = results;
        [self.collectionView reloadData];
        NSLog(@"%@",self.CustomerList);
    }
    else
    {
        [self getDataList];
        if ([_SelType isEqualToString:@"D"]) {
            [self filterDoctorList];
        }
        else
            [self filterChemistList];
    }
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self getDataList];
    if ([_SelType isEqualToString:@"D"]) {
        [self filterDoctorList];
    }
    else
        [self filterChemistList];
}
-(void)addForm
{
    if(_selSurvery.length >0 && _txtSelCus.text.length >0 && self.DataSF.length >0)
    {
        [self.vwAdCtrl setHidden:NO];
        [self generateCtrls];
        
    }
    else
        [self.vwAdCtrl setHidden:YES];
}

- (IBAction)btnSubmitSurvey:(id)Control {
    
    
    NSMutableArray *datas=[[NSMutableArray alloc]init];
    for(int il=0;il<[_FormsCtrls count];il++)
    {
        
        SANControlsBox* cCtrl = (SANControlsBox*) _FormsCtrls[il];
        NSMutableDictionary *dictSurveyData = [[NSMutableDictionary alloc] init];
        
        if(cCtrl.ControlType<3){
            cCtrl.selectedValue=cCtrl.txtField.text;
            cCtrl.selectedText=cCtrl.txtField.text;
        }else if(cCtrl.ControlType<4){
            cCtrl.selectedValue=cCtrl.txtView.text;
            cCtrl.selectedText=cCtrl.txtView.text;
        }
        if(cCtrl.isMandate==YES){
            if([cCtrl.selectedValue isEqualToString:@""] || cCtrl.selectedValue==nil){
                [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Kindly Fill the ", @"Kindly Fill the " ),cCtrl.Caption]];
                return;
            }
        }
        if(cCtrl.ControlType == 31 || cCtrl.ControlType == 32)
        {
            cCtrl.selectedText = cCtrl.selectedValue;
        }
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        
        NSArray *data = [self.ObjCtrlList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Qname contains[c] %@",cCtrl.Caption]];
        NSString *QC_ID;
        if(data.count == 1)
        {
            QC_ID =[NSString stringWithFormat:@"%@", [data[0] objectForKey:@"Qc_id"]];
        }
        
        [dictSurveyData setValue:_SelType forKey:@"CustType"];
        [dictSurveyData setValue:_CustCode forKey:@"CustCode"];
        [dictSurveyData setValue:_selSurveryID forKey:@"Survey_Id"];
        [dictSurveyData setValue:QC_ID forKey:@"Question_Id"];
        [dictSurveyData setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"SurveyDate"];
        [dictSurveyData setValue:cCtrl.selectedText forKey:@"Answer"];
        
        [datas addObject:dictSurveyData];
        
    }
    
    if(datas.count > 0)
    {
        
        NSMutableDictionary *Param=[[NSMutableDictionary alloc]init];
        [Param setObject:datas forKey:@"val"];
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"SendingStatus", @"Sending..")];
        [WBService SendServerRequest:@"SAVE/survey" withParameter:Param withImages:nil
                              DataSF:nil
                          completion:^(BOOL success, id respData,NSMutableDictionary *uData)
         {
            NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            bool Success=[[receivedDta valueForKey:@"success"] boolValue];
            if(Success==YES){
                [BaseViewController Toast:NSLocalizedString(@"Survey Submitting Successfully", @"Survey Submitting Successfully") ];
                for(int il=0;il<[_FormsCtrls count];il++)
                {
                    SANControlsBox* cCtrl = (SANControlsBox*) _FormsCtrls[il];
                    cCtrl.selectedText = @"";
                    cCtrl.selectedValue = @"";
                }
                [self generateCtrls];
            }
            else{
                [BaseViewController Toast:NSLocalizedString(@"Survey Submitting Failed.", @"Survey Submitting Failed.")];
            }
            [SVProgressHUD dismiss];
        }
                               error:^(NSString *errorMsg,NSMutableDictionary *uData){
            [BaseViewController Toast:[NSString stringWithFormat:@"%@\n %@.",NSLocalizedString(@"Survey Submitting", @"Survey Submitting"),errorMsg.description]];
            [SVProgressHUD dismiss];
        }];
    }
}

-(void) LoadData:(NSString *) apiPath withParam:(NSMutableDictionary *) param andDataFor:(NSString *)dataSF andkey:(NSString *) key{
           [WBService SendServerRequest:apiPath withParameter:param withImages:nil DataSF:dataSF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
               NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
               [WBService saveData:receivedDta forKey:key];
               if(receivedDta.count > 0)
               {
                   [self getDataList];
                   if([self.SelType isEqualToString:@"D"])
                   {
                       [self filterDoctorList];
                   }
                   else if ([self.SelType isEqualToString:@"C"])
                   {
                       [self filterChemistList];
                   }
               }
           }
           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
               NSLog(@"%@",errorMsg);
           }
     ];
}
@end
