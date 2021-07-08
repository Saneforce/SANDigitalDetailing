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

@interface SurveyActivityCtrl ()

@property (nonatomic, strong) NSArray* ObjCustomerList;
@property (nonatomic, strong) NSArray* CustomerList;

@property (nonatomic,strong) NSMutableArray *objSurveyList;

@property (nonatomic, retain) IBOutlet UIView* vwModeModal;
@property (nonatomic,retain) IBOutlet UITableView *selTypeMode;
@property (nonatomic, strong) NSArray* Types;

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
    
    UIImageView* btnImg=[[UIImageView alloc] initWithFrame:CGRectMake(_btnFilter.frame.size.width-18, (_btnFilter.frame.size.height-10)/2,10, 10)];
    btnImg.image=[[UIImage imageNamed:@"DwnArrw"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    btnImg.tintColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];
    [_btnFilter addSubview:btnImg];

    _SelType=@"";
    _Types=@[
        [self AddItem:@"1" andName:NSLocalizedString(self.SetupData.CapDr, self.SetupData.CapDr)],
        [self AddItem:@"2" andName:NSLocalizedString(self.SetupData.CapChm, self.SetupData.CapChm)],
        [self AddItem:@"3" andName:NSLocalizedString(self.SetupData.CapStk, self.SetupData.CapStk)],
        [self AddItem:@"4" andName:NSLocalizedString(self.SetupData.CapUdr, self.SetupData.CapUdr)],
        [self AddItem:@"5" andName:NSLocalizedString(self.SetupData.CapHos, self.SetupData.CapHos)]
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
                [self.collectionView reloadData];
            }
        }
        
    }
    [WBService SendServerRequest:@"GET/Survey" withParameter:pram withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
            _objSurveyList=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            [self.tbSurveyLst reloadData];
        } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==self.selTypeMode) return 42;
    if(tableView==self.tbSurveyLst) return 53;
    return 42;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.selTypeMode) return self.Types.count;
    if(tableView==self.tbSurveyLst) return [_objSurveyList count];
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
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tbSurveyLst){
        NSDictionary *objItem = self.objSurveyList[indexPath.row];
        _ObjCtrlList=[objItem objectForKey:@"survey_for"];
        _lblSrvyNm.text=[objItem objectForKey:@"name"];
        _selCat=[_ObjCtrlList[0] valueForKey:@"DrCat"];
        _selSpec=[_ObjCtrlList[0] valueForKey:@"DrSpl"];
        
        if(_meetData.CustCode!=nil){
            _arrControlsDets=[_ObjCtrlList mutableCopy];
            [self generateCtrls];
            
        }
    }
    if(tableView==self.selTypeMode) {
        NSDictionary *item = _Types[indexPath.row];
        [_btnFilter setTitle:NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"]) forState:UIControlStateNormal];
        _txtSelCus.placeholder=[NSString stringWithFormat:@"Search %@", NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"])];
        int TyCd=[[_Types[indexPath.row] objectForKey:@"Code"] intValue];
        _btnFilter.tag = [[_Types[indexPath.row] objectForKey:@"Code"] intValue];
        if(TyCd==1) _SelType=@"D";
        if(TyCd==2) _SelType=@"C";
        if(TyCd==3) _SelType=@"S";
        if(TyCd==4) _SelType=@"U";
        if(TyCd==5) _SelType=@"H";
        
        [self getDataList];
        [self.collectionView reloadData];
        [_vwModeModal removeFromSuperview];
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    self.txtSelCus.text=[SelItem objectForKey:@"Name"];
    self.CustCode=[SelItem objectForKey:@"Code"];
    self.SpecCode=[SelItem objectForKey:@"SpecialtyCode"];
    self.CateCode=[SelItem objectForKey:@"CategoryCode"];
    _arrControlsDets=[_ObjCtrlList mutableCopy];
   // _arrControlsDets=[[_ObjCtrlList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type==%@ and Cat_code == %ld",Typ,CatID]] mutableCopy];
    [self generateCtrls];
    _vwCusList.hidden=YES;
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
    _vwCusList.hidden=NO;
    
}
-(IBAction) hideCustList:(id)sender{
    _vwCusList.hidden=YES;
    
}
-(IBAction) showSelMode:(id)sender{
    _vwModeModal=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _vwModeModal.backgroundColor=[UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.6];
    UIView* vwMode=[[UIView alloc] initWithFrame:CGRectMake(_vwCusSel.superview.frame.origin.x+_btnFilter.frame.origin.x+10, _vwCusSel.frame.origin.y+_btnFilter.frame.size.height+80, _btnFilter.frame.size.width, 200)];
    vwMode.backgroundColor=[UIColor whiteColor];
    self.selTypeMode=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, _btnFilter.frame.size.width, 200)];
    [self.selTypeMode registerClass:[TBSelectionBxCell class] forCellReuseIdentifier:@"Cell"];
        
    _selTypeMode.rowHeight = 42;
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
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.DataSF];
    if ([_SelType isEqualToString:@"D"]){
        DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.DataSF];
    }
    if ([_SelType isEqualToString:@"C"]){
        DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.DataSF];
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
    self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.ObjCustomerList =[self FilterUnique:self.ObjCustomerList andKey:@"Code"];
    if ([_SelType isEqualToString:@"D"]){
        if(![_selCat isEqualToString:@""]){
            self.ObjCustomerList =[self FilterRevUnique:self.ObjCustomerList andKey:@"Code"];
        }
        if(![_selSpec isEqualToString:@""]){
            self.ObjCustomerList =[self FilterRevUnique:self.ObjCustomerList andKey:@"Code"];
        }
    }
    
    /*int flag=1;
    self.ObjCustomerList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"PlcyAcptFl.intValue == %d",flag]] mutableCopy];*/
    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    
    self.CustomerList = [[_ObjCustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
   
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
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    _cyAxis=0;_scrlHeight=0;
    if(self.vwCtrlsView!=nil){
        [self.vwCtrlsView removeFromSuperview];
    }
    self.vwCtrlsView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vwAdCtrl.frame.size.width, _scrlHeight)];
    _FormsCtrls=[[NSMutableArray alloc] init];
    long inc=0;long PrvScroll=0;
    
    for (int il=0; il<[_arrControlsDets count]; il++) {
        _selCat=[NSString stringWithFormat:@",%@,",[_arrControlsDets[il] valueForKey:@"DrCat"]];
        _selSpec=[NSString stringWithFormat:@",%@,",[_arrControlsDets[il] valueForKey:@"DrSpl"]];
        NSString* QSType=[NSString stringWithFormat:@",%@",[_arrControlsDets[il] valueForKey:@"Stype"]];
        Boolean Flg=NO;
        if ([_SelType isEqualToString:@"D"] && [QSType rangeOfString:@",D,"].length>0){
            if([_selCat rangeOfString:[NSString stringWithFormat:@",%@,",self.CateCode]].length>0 &&
               [_selSpec rangeOfString:[NSString stringWithFormat:@",%@,",self.SpecCode]].length>0
            )
            Flg=YES;
        }
        if ([_SelType isEqualToString:@"C"] && [QSType rangeOfString:@",C,"].length>0){
            if([_selCat rangeOfString:[NSString stringWithFormat:@",%@,",self.CateCode]].length>0 &&
               [_selSpec rangeOfString:[NSString stringWithFormat:@",%@,",self.SpecCode]].length>0
            )
            Flg=YES;
        }
        if ([_SelType isEqualToString:@"S"] && [QSType rangeOfString:@",S,"].length>0){
            if([_selCat rangeOfString:[NSString stringWithFormat:@",%@,",self.CateCode]].length>0 &&
               [_selSpec rangeOfString:[NSString stringWithFormat:@",%@,",self.SpecCode]].length>0
            )
            Flg=YES;
        }
        if ([_SelType isEqualToString:@"H"] && [QSType rangeOfString:@",H,"].length>0){
            if([_selCat rangeOfString:[NSString stringWithFormat:@",%@,",self.CateCode]].length>0 &&
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
            CardView.ID=[NSString stringWithFormat:@"Ctrl_%d_%d",CtrlID,il];
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

@end
