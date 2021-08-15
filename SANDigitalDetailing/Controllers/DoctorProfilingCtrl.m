//
//  DoctorProfilingCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "DoctorProfilingCtrl.h"
#import "mCustomerCell.h"
#define kCtrlStart 16

#define mHeight 185

@interface DoctorProfilingCtrl ()
    @property (nonatomic, strong) NSArray* ObjCustomerList;
    @property (nonatomic, strong) NSArray* CustomerList;
    @property (nonatomic,strong) NSArray* HospitalList;
    @property (nonatomic, strong) NSDictionary* TP;
    @property (nonatomic, strong) NSMutableArray* ProductList;

    @property (nonatomic, strong) NSMutableArray* SelObj;
    @property (nonatomic, strong) NSMutableArray* AllSelObj;
    @property (nonatomic, strong) NSString* fldName;
    @property (nonatomic, strong) NSString* CodeName;
    @property (nonatomic, strong) NSMutableArray* ObjCtrlList;
    @property (nonatomic, strong) NSMutableArray* arrControlsDets;
    @property (nonatomic, strong) NSMutableArray* moreDets;

    @property (nonatomic, strong) NSArray* QualList;
    @property (nonatomic, strong) NSArray* SpecList;
    @property (nonatomic, strong) NSArray* CatList;
    @property (nonatomic, strong) NSArray* TypList;
    @property (nonatomic, strong) NSArray* TarNwPatList;
    @property (nonatomic, strong) NSArray* AvgPatList;
    @property (nonatomic, strong) NSArray* SessList;
    @property (nonatomic, strong) NSArray* EconoList;
    @property (nonatomic, strong) NSArray* objOptList;
    @property (nonatomic, strong) NSArray* objAllOptList;
    @property (nonatomic, strong) NSArray* ClassList;


    @property (nonatomic, strong) NSMutableArray* FormsCtrls;
    @property (nonatomic, strong) NSArray* Hours;
    @property (nonatomic, strong) NSArray* Mins;
    @property (nonatomic, strong) NSArray* Types;

    @property(nonatomic,assign) CGSize keyboardSize;
    @property(nonatomic,strong) UITextView* CtxtFld;
    @property(nonatomic,assign) CGFloat animatedDistance;

    @property(nonatomic,assign) float cyAxis,scrlHeight,defHeight;
    @property(nonatomic,assign) NSString* selectedHour;
    @property(nonatomic,assign) NSString* selectedMinute;
    @property(nonatomic,strong) NSString* selectedText;
    @property(nonatomic,strong) NSString* selectedValue;
    @property(nonatomic,assign) NSDate* selectedDate;
    @property(nonatomic,assign) SANControlsBox* eCtrl;
    @property(nonatomic,retain) UIButton* btnFilter;
    @property(nonatomic,retain) UILabel* lblCPerson;
    @property(nonatomic,retain) UITextField* txtCPerson;

    @property(nonatomic,strong) NSString* SelType;
    @property(nonatomic,assign) int SelLstType;
    @property(nonatomic,retain) UIView* vwHospProf;

@end

@implementation DoctorProfilingCtrl
static const CGFloat ANIMATION_DURATION = 0.4;
static const CGFloat LITTLE_SPACE = 25;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.meetData=[CallMeetData sharedDatas];
    self.UserDet=[UserDetails sharedUserDetails];
    self.DrProfData=[DrProfileData sharedDatas];
    self.SetupData=[AppSetupData sharedDatas];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.pikFT.delegate=self;
    self.pikFT.dataSource=self;
    self.pikTT.delegate=self;
    self.pikTT.dataSource=self;
    
    self.tbPoten.delegate = self;
    self.tbPoten.dataSource = self;
    self.tbSegm.delegate = self;
    self.tbSegm.dataSource = self;
    self.tbSelectBx.delegate = self;
    self.tbSelectBx.dataSource = self;
    self.selOptTableView.delegate = self;
    self.selOptTableView.dataSource = self;
    
    self.layout.minimumInteritemSpacing = 8;
    self.layout.minimumLineSpacing = 25;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.TP =[[[NSUserDefaults standardUserDefaults] objectForKey:@"MyTodayplan.SANAPP"] mutableCopy];
    self.meetData.DataSF=[self.TP valueForKey:@"SFMem"];
    self.meetData.DataSFHQ=[self.TP valueForKey:@"HQNm"];
    if([self.UserDet.Desig isEqualToString:@"MR"]) self.meetData.DataSF=self.UserDet.SF;

    self.DrProfData.VisitDays=[[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    self.DrProfData.VstSess=[[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    self.DrProfData.vstAvgPDy=[[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    self.DrProfData.vstEcoPats=[[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    
    self.Hours=[[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    self.Mins=[[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59", nil];
    self.ProductList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Brands.SANAPP"] mutableCopy];
    [self getDataList];
    self.objHQList= [[[NSUserDefaults standardUserDefaults] objectForKey:@"HQDetails.SANAPP"] mutableCopy];
   
    
    _btnSelHQ.hidden=YES;
    if(![_UserDet.Desig isEqualToString:@"MR"]) _btnSelHQ.hidden=NO;
    _SelType=@"D";
    
    NSString* DataKey=[[NSString alloc] initWithFormat:@"Hospital_%@.SANAPP",self.meetData.DataSF];
    self.HospitalList=[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.QualList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Qualifics.SANAPP"] mutableCopy];
    self.SpecList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Specialitys.SANAPP"] mutableCopy];
    self.CatList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Category.SANAPP"] mutableCopy];
    self.TypList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DocTypes.SANAPP"] mutableCopy];
    
    self.ClassList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"DocClass.SANAPP"] mutableCopy];
    
    _Types=@[
        [self AddItem:@"1" andName:NSLocalizedString(self.SetupData.CapDr, self.SetupData.CapDr)],/*
        [self AddItem:@"2" andName:NSLocalizedString(self.SetupData.CapChm, self.SetupData.CapChm)],
        [self AddItem:@"3" andName:NSLocalizedString(self.SetupData.CapStk, self.SetupData.CapStk)],
        [self AddItem:@"4" andName:NSLocalizedString(self.SetupData.CapUdr, self.SetupData.CapUdr)],*/
        [self AddItem:@"5" andName:NSLocalizedString(self.SetupData.CapHos, self.SetupData.CapHos)]
    ];
    _SessList=@[
        [self AddItem:@"M" andName:NSLocalizedString(@"Morning", @"Morning")],
        [self AddItem:@"A" andName:NSLocalizedString(@"Afternoon", @"Afternoon")],
        [self AddItem:@"E" andName:NSLocalizedString(@"Evening", @"Evening")],
        [self AddItem:@"D" andName:NSLocalizedString(@"Day", @"Day")]
    ];
    _AvgPatList=@[
         [self AddItem:@"20" andName:@">20"],
         [self AddItem:@"15" andName:@"15"],
         [self AddItem:@"10" andName:@"10"],
         [self AddItem:@"5" andName:@"5"]
    ];
    _TarNwPatList=@[
        [self AddItem:@">12" andName:@">12"],
        [self AddItem:@"7 to 11" andName:@"7 to 11"],
        [self AddItem:@"1 to 6" andName:@"1 to 6"]
    ];
    _EconoList=@[
        [self AddItem:@"H" andName:NSLocalizedString(@"High", @"High")],
        [self AddItem:@"A" andName:NSLocalizedString(@"Medium High", @"Medium High")],
        [self AddItem:@"E" andName:NSLocalizedString(@"Medium Low", @"Medium Low")],
        [self AddItem:@"D" andName:NSLocalizedString(@"Low", @"Low")]
    ];
    [WBService SendServerRequest:@"get/custctrl" withParameter:nil withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage)
        {
            NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            _ObjCtrlList=[receivedDta mutableCopy];
        
        }
       error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
           NSLog(@"%@",errorMsg);
       }
     ];
    
    self.lblAdd2.hidden=YES;
    self.lblAdd3.hidden=YES;
    self.lblAdd4.hidden=YES;
    self.lblAdd5.hidden=YES;
    self.lblCapPincode.hidden=YES;
    self.lblCapBrick.hidden=YES;
    self.txtAdd2.hidden=YES;
    self.txtAdd3.hidden=YES;
    self.txtAdd4.hidden=YES;
    self.txtAdd5.hidden=YES;
    self.lblPincode.hidden=YES;
    self.lblBrick.hidden=YES;
    
    [_lblMob setFrame:CGRectMake(_lblMob.frame.origin.x, _lblMob.frame.origin.y - mHeight , _lblMob.frame.size.width, _lblMob.frame.size.height)];
    [_txtMob setFrame:CGRectMake(_txtMob.frame.origin.x, _txtMob.frame.origin.y-mHeight, _txtMob.frame.size.width, _txtMob.frame.size.height)];
    [_lblPhone setFrame:CGRectMake(_lblPhone.frame.origin.x, _lblPhone.frame.origin.y-mHeight, _lblPhone.frame.size.width, _lblPhone.frame.size.height)];
    [_txtPhone setFrame:CGRectMake(_txtPhone.frame.origin.x, _txtPhone.frame.origin.y-mHeight, _txtPhone.frame.size.width, _txtPhone.frame.size.height)];
    [_lblEmail setFrame:CGRectMake(_lblMob.frame.origin.x, _lblEmail.frame.origin.y-mHeight, _lblEmail.frame.size.width, _lblEmail.frame.size.height)];
    [_txtEmail setFrame:CGRectMake(_txtMob.frame.origin.x, _txtEmail.frame.origin.y-mHeight, _txtMob.frame.size.width, _txtEmail.frame.size.height)];
    
    [_vwAddrDets setFrame:CGRectMake(_vwAddrDets.frame.origin.x, _vwAddrDets.frame.origin.y, _vwAddrDets.frame.size.width, _vwAddrDets.frame.size.height-mHeight)];
    double eW=(self.view.frame.size.width-36)/4;
    double eH=self.txtSearch.frame.size.height;
    [_txtSearch setFrame:CGRectMake(18, self.txtSearch.frame.origin.y,eW*3, self.txtSearch.frame.size.height)];
    CAShapeLayer *maskTLayer = [CAShapeLayer layer];
    maskTLayer.borderWidth=0.5;
    maskTLayer.borderColor=[UIColor grayColor].CGColor;
    maskTLayer.path = [UIBezierPath bezierPathWithRoundedRect:_txtSearch.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:(CGSize){5.0, 5.0}].CGPath;
    
    _txtSearch.layer.mask = maskTLayer;
    _btnFilter=[[UIButton alloc] initWithFrame:CGRectMake(eW*3, self.txtSearch.frame.origin.y,eW+18, self.txtSearch.frame.size.height)];
    [_btnFilter setTitle:NSLocalizedString(self.SetupData.CapDr, self.SetupData.CapDr) forState:UIControlStateNormal];
    _btnFilter.titleLabel.font=[UIFont fontWithName:@"Poppins-SemiBold" size:14.0];
    _btnFilter.backgroundColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];//[UIColor colorWithRed:89.0f/255 green:89.0f/255 blue:89.0f/255 alpha:1.0f];
    _btnFilter.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _btnFilter.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_btnFilter.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:(CGSize){5.0, 5.0}].CGPath;
    _btnFilter.layer.mask = maskLayer;
    
    UIImageView* btnImg=[[UIImageView alloc] initWithFrame:CGRectMake(_btnFilter.frame.size.width-18, (eH-10)/2,10, 10)];
    btnImg.image=[[UIImage imageNamed:@"DwnArrw"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    btnImg.tintColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];
    [_btnFilter addSubview:btnImg];
    [_btnFilter addTarget:self action:@selector(showSelMode:) forControlEvents:UIControlEventTouchUpInside];
    [_selDrView addSubview:_btnFilter];
    //self.txtDrDistrict.text=[item valueForKey:@"District"];
    //self.txtDrCity.text=[self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
    
 /*   [_btnSelHQ setTitle:self.meetData.DataSFHQ forState:UIControlStateNormal];
    if([self.meetData.DataSFHQ  isEqual:@""]) [_btnSelHQ setTitle:@"Select the Headquaters" forState:UIControlStateNormal];
 */
}
-(void) getDataList{
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
    if ([_SelType isEqualToString:@"D"]){
        DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
    }
    if ([_SelType isEqualToString:@"C"]){
        DataKey=[[NSString alloc] initWithFormat:@"ChemistDetails_%@.SANAPP",self.meetData.DataSF];
    }
    if ([_SelType isEqualToString:@"S"]){
        DataKey=[[NSString alloc] initWithFormat:@"StockistDetails_%@.SANAPP",self.meetData.DataSF];
    }
    if ([_SelType isEqualToString:@"U"]){
        DataKey=[[NSString alloc] initWithFormat:@"UnlistedDR_%@.SANAPP",self.meetData.DataSF];
    }
    if ([_SelType isEqualToString:@"H"]){
        DataKey=[[NSString alloc] initWithFormat:@"Hospital_%@.SANAPP",self.meetData.DataSF];
    }
    self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.ObjCustomerList =[self FilterUnique:self.ObjCustomerList andKey:@"Code"];
    
    /*int flag=1;
    self.ObjCustomerList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"PlcyAcptFl.intValue == %d",flag]] mutableCopy];*/
    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    
    self.CustomerList = [[_ObjCustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
   
}
-(IBAction) showSelMode:(id)sender{
    _vwModeModal=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _vwModeModal.backgroundColor=[UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:0.6];
    UIView* vwMode=[[UIView alloc] initWithFrame:CGRectMake(_btnFilter.frame.origin.x, _btnFilter.frame.origin.y+_btnFilter.frame.size.height+70, _btnFilter.frame.size.width, 200)];
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
-(NSMutableDictionary *) AddItem:(NSString *) Code andName:(NSString *) Name{
    NSMutableDictionary * newItem=[[NSMutableDictionary alloc] init];
    [newItem setValue:Code forKey:@"Code"];
    [newItem setValue:Name forKey:@"Name"];
    return newItem;
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
    self.lblDrName.text=[SelItem objectForKey:@"Name"];
    self.CustCode=[SelItem objectForKey:@"Code"];
    
    [WBService SendServerRequest:@"GET/DrDets" withParameter:[@{@"CusCode":self.CustCode,@"typ":_SelType} mutableCopy] withImages:nil DataSF:nil
                      completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                          
        NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *item =receivedDta[0];
        NSMutableArray *lItem;
        NSString *sText;
        _vwProfArea.hidden=NO;
        
        if(_vwHospProf!=nil){
            [_vwHospProf removeFromSuperview];
            
            [_vwAddrDets setFrame:CGRectMake(_vwAddrDets.frame.origin.x, _vwProfArea.frame.size.height+18, _vwAddrDets.frame.size.width, _vwAddrDets.frame.size.height)];
           
            [_vwAdCtrl setFrame:CGRectMake(_vwAdCtrl.frame.origin.x, _vwAddrDets.frame.origin.y+_vwAddrDets.frame.size.height+18, _vwAdCtrl.frame.size.width, _vwAdCtrl.frame.size.height)];
        }
        if([_SelType isEqualToString:@"D"]){
            UIView* lblCont=[[UIView alloc] initWithFrame:CGRectMake(_lblCity.frame.origin.x, _btnType.frame.origin.y, 350, 30)];
 
            UILabel* lblHosp=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
            lblHosp.text=_SetupData.CapHos;
            lblHosp.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
            UIButton* cmbHosp=[[UIButton alloc] initWithFrame:CGRectMake(130, 0, 260, 30)];
            cmbHosp.layer.borderWidth=1.0f;
            cmbHosp.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
            cmbHosp.layer.cornerRadius=5;
            cmbHosp.backgroundColor=[UIColor colorWithRed:249.0f/255 green:249.0f/255 blue:249.0f/255 alpha:1.0f] ;
            [cmbHosp setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
            cmbHosp.titleLabel.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
            [cmbHosp.titleLabel setTextAlignment:NSTextAlignmentLeft];
            NSString* btnImg=@"DwnArrw";
            UIEdgeInsets imgEdg=UIEdgeInsetsMake(10, 246,  10,  8);
            [cmbHosp setClipsToBounds:YES];
            cmbHosp.tag=11;
            [cmbHosp setTitle:[item valueForKey:@"HospNames"] forState:UIControlStateNormal];
            self.DrProfData.DrHosp=[item valueForKey:@"HospCodes"];
            self.DrProfData.DrHospNm=[item valueForKey:@"HospNames"];
            
            [cmbHosp setImage:[UIImage imageNamed:btnImg] forState:UIControlStateNormal];
            [cmbHosp setImageEdgeInsets: imgEdg];
            [cmbHosp addTarget:self action:@selector(showCmbList:) forControlEvents: UIControlEventTouchUpInside];
            
            [lblCont addSubview:cmbHosp];
            [lblCont addSubview:lblHosp];
            
            [_vwProfArea addSubview:lblCont];
            
        }
        else if([_SelType isEqualToString:@"H"])
        {
            _vwProfArea.hidden=YES;
            _vwHospProf=[[UIView alloc] initWithFrame:CGRectMake(_vwProfArea.frame.origin.x, _vwProfArea.frame.origin.y, _vwProfArea.frame.size.width, 60)];
            UIView* lblCont=[[UIView alloc] initWithFrame:CGRectMake(18, 18, 350, 30)];
            _vwHospProf.backgroundColor=[UIColor whiteColor];
            UILabel* lblClass=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
            lblClass.text=@"Class / Category";
            lblClass.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
            UIButton* cmbClass=[[UIButton alloc] initWithFrame:CGRectMake(130, 0, 260, 30)];
            cmbClass.layer.borderWidth=1.0f;
            cmbClass.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
            cmbClass.layer.cornerRadius=5;
            cmbClass.backgroundColor=[UIColor colorWithRed:249.0f/255 green:249.0f/255 blue:249.0f/255 alpha:1.0f] ;
            [cmbClass setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
            cmbClass.titleLabel.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
            [cmbClass.titleLabel setTextAlignment:NSTextAlignmentLeft];
            NSString* btnImg=@"DwnArrw";
            UIEdgeInsets imgEdg=UIEdgeInsetsMake(10, 246,  10,  8);
            [cmbClass setClipsToBounds:YES];
            cmbClass.tag=10;
            [cmbClass setTitle:[item valueForKey:@"ClsName"] forState:UIControlStateNormal];
            [cmbClass setImage:[UIImage imageNamed:btnImg] forState:UIControlStateNormal];
            
            [cmbClass setImageEdgeInsets: imgEdg];
            [cmbClass addTarget:self action:@selector(showCmbList:) forControlEvents: UIControlEventTouchUpInside];
             [lblCont addSubview:cmbClass];
             [lblCont addSubview:lblClass];
             //lblCont.backgroundColor=[UIColor grayColor];
             [_vwHospProf addSubview:lblCont];
             
             
             [_vwProfArea.superview addSubview:_vwHospProf];
            
            //[_vwAddrDets setFrame:CGRectMake(_vwAddrDets.frame.origin.x, 0, _vwAddrDets.frame.size.width, _vwAddrDets.frame.size.height)];
            float x2=_txtEmail.frame.origin.x+_txtEmail.frame.size.width+30;
            float y2=_txtEmail.frame.origin.y;
            _lblCPerson=[[UILabel alloc] initWithFrame:CGRectMake(x2, y2, 130, 30)];
            _lblCPerson.text=@"Contact Person";
            _lblCPerson.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
            _txtCPerson=[[UITextField alloc] initWithFrame:CGRectMake(_txtPhone.frame.origin.x, y2, 350, 30)];
            _txtCPerson.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
            _txtCPerson.borderStyle=UITextBorderStyleRoundedRect;
            _txtCPerson.layer.borderWidth=1.0f;
            _txtCPerson.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
            _txtCPerson.text=[item valueForKey:@"ContactPer"];
            _txtCPerson.layer.cornerRadius=5;
            [_txtCPerson setClipsToBounds:YES];
            [_vwAddrDets addSubview:_lblCPerson];
            [_vwAddrDets addSubview:_txtCPerson];
            [_vwAddrDets setFrame:CGRectMake(_vwAddrDets.frame.origin.x, _vwHospProf.frame.size.height+18, _vwAddrDets.frame.size.width, _vwAddrDets.frame.size.height)];
        
            
        }
        self.txtDOBD.text=[NSString stringWithFormat:@"%d",[[item valueForKey:@"DOBD"] intValue]];
        self.txtDOBM.text=[NSString stringWithFormat:@"%d",[[item valueForKey:@"DOBM"] intValue]];
        self.txtDOWD.text=[NSString stringWithFormat:@"%d",[[item valueForKey:@"DOWD"] intValue]];
        self.txtDOWM.text=[NSString stringWithFormat:@"%d",[[item valueForKey:@"DOWM"] intValue]];
        self.txtDOBY.text=[NSString stringWithFormat:@"%d",[[item valueForKey:@"DOBY"] intValue]];
        self.txtDOWY.text=[NSString stringWithFormat:@"%d",[[item valueForKey:@"DOWY"] intValue]];
        self.txtAdd1.text=[item valueForKey:@"Addr1"];
        self.txtAdd2.text=[item valueForKey:@"Addr2"];
        self.txtAdd3.text=[item valueForKey:@"Addr3"];
        self.txtAdd4.text=[item valueForKey:@"Addr4"];
        self.txtAdd5.text=[item valueForKey:@"Addr5"];
        self.lblPincode.text=[item valueForKey:@"PinCode"];
        self.lblBrick.text=[item valueForKey:@"Brick"];
        self.txtDrDistrict.text=[item valueForKey:@"District"];
        self.txtDrCity.text=[self.CustomerList[indexPath.row] objectForKey:@"Town_Name"];
        self.txtPhone.text=[item valueForKey:@"Phone"];
        self.txtMob.text=[item valueForKey:@"Mobile"];
        self.txtEmail.text=[item valueForKey:@"Email"];

        NSString* Gender=[item valueForKey:@"Gender"];
        if([Gender isEqualToString:@"M"]){
          [self selGender:_btnMale];
        }
        if([Gender isEqualToString:@"F"]){
          [self selGender:_btnFemale];
        }

        _defHeight=642.0f-mHeight;
        self.vwSeg.hidden=YES;
        self.vwPotan.hidden=YES;
        self.vwVstDets.hidden=YES;
        if([[SelItem valueForKey:@"PlcyAcptFl"] integerValue]==1){
            _defHeight=1582.0f-mHeight;
            self.vwSeg.hidden=NO;
            self.vwPotan.hidden=NO;
            self.vwVstDets.hidden=NO;
        }
        _defHeight=_vwAddrDets.frame.origin.y+_vwAddrDets.frame.size.height+18;
        _nsScrollHeight.constant=_defHeight;
        [self.view layoutIfNeeded];

        self.DrProfData.DrQual=[item valueForKey:@"QualCode"];
        lItem=[[self.QualList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"Code==%@", [item valueForKey:@"QualCode"]]]] mutableCopy];
        sText=@"";if([lItem count]>0) sText=[lItem[0] objectForKey:@"Name"];
        [_btnQual setTitle:NSLocalizedString(sText,sText) forState:UIControlStateNormal];
        //[_btnQual setTitle:NSLocalizedString([item objectForKey:@"QualName"], [item objectForKey:@"QualName"]) forState:UIControlStateNormal];
        self.DrProfData.DrSpec=[item valueForKey:@"SpecCode"];
        [_btnSpec setTitle:NSLocalizedString([item objectForKey:@"SpecName"], [item objectForKey:@"SpecName"]) forState:UIControlStateNormal];
        self.DrProfData.DrCat=[item valueForKey:@"CatCode"];
        self.moreDets=[item valueForKey:@"AdDets"];
        if([_SelType isEqualToString:@"D"]){
            [self generateCtrls:[self.DrProfData.DrCat longLongValue]];
        }
          [_btnDCate setTitle:NSLocalizedString([item objectForKey:@"CatName"], [item objectForKey:@"CatName"]) forState:UIControlStateNormal];
          self.DrProfData.DrType=[item valueForKey:@"Type"];
          lItem=[[self.TypList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code==%@", [item valueForKey:@"Type"]]] mutableCopy];
          sText=@"";if([lItem count]>0) sText=[lItem[0] objectForKey:@"Name"];
          [_btnType setTitle:NSLocalizedString(sText,sText) forState:UIControlStateNormal];
          
          self.DrProfData.DrTar=[item valueForKey:@"Target"];
          [_btnTar setTitle:NSLocalizedString([item objectForKey:@"Target"], [item objectForKey:@"Target"]) forState:UIControlStateNormal];
              NSString* sCate=@"-";
          if([self.DrProfData.DrTar isEqualToString:@">12"]) sCate=@"A";
          if([self.DrProfData.DrTar isEqualToString:@"7 to 11"]) sCate=@"B";
          if([self.DrProfData.DrTar isEqualToString:@"1 to 6"]) sCate=@"C";
          [self.btnCate setTitle:sCate forState:UIControlStateNormal];

          self.DrProfData.DrClass=sCate;
        if([_SelType isEqualToString:@"H"]){
            sCate=[item valueForKey:@"ClsCode"];
            self.DrProfData.DrClass=sCate;
            [self generateCtrls:[sCate longLongValue]];
        }
          for (int il=0; il<[self.ProductList count]; il++) {
              NSMutableDictionary* newItem=[self.ProductList[il] mutableCopy];
              [newItem removeObjectForKey:@"SetPoten"];
              [newItem removeObjectForKey:@"SetSegm"];
              [self.ProductList replaceObjectAtIndex:il withObject:newItem];
          }
          
          NSArray* sProducts = [[item valueForKey:@"Product_Range"] componentsSeparatedByString:@"#"];
          for (int il=0; il<[sProducts count]; il++) {
              NSArray* ProdDet = [sProducts[il] componentsSeparatedByString:@"/"];
              if(![ProdDet[0] isEqualToString:@""]){
                  NSMutableArray *nItem=[[self.ProductList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"Code==%@", ProdDet[0]]]] mutableCopy];
                  if([nItem count]>0)
                  {
                      int indx=[self.ProductList indexOfObject:nItem[0]];
                      NSMutableDictionary* newItem=[nItem[0] mutableCopy];
                      [newItem setValue:[NSString stringWithFormat:@"%ld",(long)[ProdDet[1] integerValue]] forKey:@"SetPoten"];
                      [newItem setValue:[NSString stringWithFormat:@"%ld",(long)[ProdDet[2] integerValue]] forKey:@"SetSegm"];
                      [self.ProductList replaceObjectAtIndex:indx withObject:newItem];
                  }
              }
          }
          
          [_tbPoten reloadData];
          [_tbSegm reloadData];
          
          NSArray* sVDts=[[item valueForKey:@"ListedDr_Visit_Days"] componentsSeparatedByString:@"/"];
          NSArray* sVSes=[[item valueForKey:@"Visit_Session_Multiple"] componentsSeparatedByString:@"/"];
          NSArray* sVAvgP=[[item valueForKey:@"ListedDr_Avg_Patients"] componentsSeparatedByString:@"/"];
          NSArray* sVClsP=[[item valueForKey:@"ListedDr_Class_Patients"] componentsSeparatedByString:@"/"];
          for (int il=0; il<[sVDts count]-1; il++) {
              UIButton* btnWkDy=(UIButton*)_btnVstDys[il];
              btnWkDy.titleLabel.tag=([sVDts[il] isEqualToString:@""])?1:0;
              [self selWeekDays:btnWkDy];
              
              self.DrProfData.VstSess[il]=sVSes[il];
              UIButton* btnSes=(UIButton*)_btnVstSes[il];
              lItem=[[self.SessList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code==%@", sVSes[il]]] mutableCopy];
              sText=@"";if([lItem count]>0) sText=[lItem[0] objectForKey:@"Name"];
              [btnSes setTitle:NSLocalizedString(sText, sText) forState:UIControlStateNormal];
              
              self.DrProfData.vstAvgPDy[il]=sVAvgP[il];
              UIButton* btnAvP=(UIButton*)_btnVstAvP[il];
              lItem=[[self.AvgPatList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code==%@", sVAvgP[il]]] mutableCopy];
              sText=@"";if([lItem count]>0) sText=[lItem[0] objectForKey:@"Name"];
              [btnAvP setTitle:NSLocalizedString(sText, sText) forState:UIControlStateNormal];
              
              self.DrProfData.vstEcoPats[il]=sVClsP[il];
              UIButton* btnClsP=(UIButton*)_btnVstClP[il];
              lItem=[[self.EconoList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code==%@", sVClsP[il]]] mutableCopy];
              sText=@"";if([lItem count]>0) sText=[lItem[0] objectForKey:@"Name"];
              [btnClsP setTitle:NSLocalizedString(sText, sText) forState:UIControlStateNormal];
              
          }
    }
    error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
       NSLog(@"%@",errorMsg);
    }];
    self.selDrView.hidden=YES;
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=42;
    return h;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tbSelectBx) return self.objOptList.count;
    if(tableView==self.tbHQ) return self.objHQList.count;
    if(tableView==self.tbPoten || tableView==self.tbSegm) return self.ProductList.count;
    if(tableView==self.selOptTableView) return self.SelObj.count;
    if(tableView==self.selTypeMode) return self.Types.count;
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
        cell.lOptImg.hidden=YES;
        if(self.tbSelectBx.tag==11){
            cell.lOptImg.hidden=NO;
            
            [cell.lOptText setFrame:CGRectMake(40, 5, cell.frame.size.width-35, cell.frame.size.height-10)];
            [cell layoutIfNeeded];
            [cell.lOptImg setFrame:CGRectMake(5, 10, 20, 20)];
            cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if([self.DrProfData.DrHosp rangeOfString:[item objectForKey:@"Code"]].length>0){
                cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        }
    }
    if(tableView==self.tbPoten || tableView==self.tbSegm)  {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *item = self.ProductList[indexPath.row];
        cell.lOptText.text = [item valueForKey:@"Name"];
        
        cell.btnVal1.tag=1;
        cell.btnVal2.tag=2;
        cell.btnVal3.tag=3;
        
        cell.btnVal1.titleLabel.tag=indexPath.row;
        cell.btnVal2.titleLabel.tag=indexPath.row;
        cell.btnVal3.titleLabel.tag=indexPath.row;
        
        NSInteger selVal=0;
        if(tableView==self.tbPoten) selVal=[[item valueForKey:@"SetPoten"] integerValue];
        if(tableView==self.tbSegm)  selVal=[[item valueForKey:@"SetSegm"] integerValue];
        
        [cell.btnVal1 setImage:[UIImage imageNamed:@"unchkOptB"] forState:UIControlStateNormal];
        [cell.btnVal2 setImage:[UIImage imageNamed:@"unchkOptB"] forState:UIControlStateNormal];
        [cell.btnVal3 setImage:[UIImage imageNamed:@"unchkOptB"] forState:UIControlStateNormal];
        
        if(selVal==1) [cell.btnVal1 setImage:[UIImage imageNamed:@"chkoptRed"] forState:UIControlStateNormal];
        if(selVal==2) [cell.btnVal2 setImage:[UIImage imageNamed:@"chkoptRed"] forState:UIControlStateNormal];
        
        if(tableView==self.tbPoten) {
            if(selVal==3) [cell.btnVal3 setImage:[UIImage imageNamed:@"chkoptRed"] forState:UIControlStateNormal];
            
            [cell.btnVal1 addTarget:self action:@selector(setPotanChecked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnVal2 addTarget:self action:@selector(setPotanChecked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnVal3 addTarget:self action:@selector(setPotanChecked:) forControlEvents:UIControlEventTouchUpInside];
        }
        if(tableView==self.tbSegm) {
            [cell.btnVal1 addTarget:self action:@selector(setSegmChecked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnVal2 addTarget:self action:@selector(setSegmChecked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if(tableView==self.selTypeMode) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height)];
        lbl.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
        //[cell.lOptText setFrame:CGRectMake(18, 9, cell.frame.size.width-18, cell.frame.size.height)];
        lbl.text = [_Types[indexPath.row] objectForKey:@"Name"];
        [cell addSubview:lbl];
    }
    if(tableView==self.selOptTableView) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [_SelObj[indexPath.row] objectForKey:_fldName];
        cell.lOptImg.hidden=YES;
        if(_eCtrl.ControlType==ComboboxMultiple||_eCtrl.ControlType==CustomMultiple){
            cell.lOptImg.hidden=NO;
            cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if([_selectedValue rangeOfString:[_SelObj[indexPath.row] objectForKey:_CodeName]].length>0){
                cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        }
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tbHQ) {
        NSDictionary *HQ = self.objHQList[indexPath.row];
        [self.btnSelHQ setTitle:[HQ objectForKey:@"name"] forState:UIControlStateNormal];
        self.meetData.DataSF=[HQ objectForKey:@"id"];
        NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
        self.searchBox.text=@"";
        
        [BaseViewController loadMasterData:self.meetData.DataSF completion:^(){
            self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
            self.ObjCustomerList =[self FilterUnique:self.ObjCustomerList andKey:@"Code"];
            NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
            
            self.CustomerList = [[_ObjCustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
            [self.collectionView reloadData];
        } error:^(NSString* errMsg){
        }];
    }
    if(tableView==self.selTypeMode) {
        NSDictionary *item = _Types[indexPath.row];
        [_btnFilter setTitle:NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"]) forState:UIControlStateNormal];
        _txtSearch.placeholder=[NSString stringWithFormat:@"Search %@", NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"])];
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
    if(tableView==_tbSelectBx){
        NSDictionary *item = self.objOptList[indexPath.row];
        if(_tbSelectBx.tag!=11)
            [_btnSelectbx setTitle:NSLocalizedString([item objectForKey:@"Name"], [item objectForKey:@"Name"]) forState:UIControlStateNormal];
        NSString* sCode=[item valueForKey:@"Code"];
        if(_tbSelectBx.tag==1)self.DrProfData.DrQual=sCode;
        if(_tbSelectBx.tag==2)self.DrProfData.DrSpec=sCode;
        if(_tbSelectBx.tag==3){self.DrProfData.DrCat=sCode; [self generateCtrls:[sCode longLongValue]];}
        if(_tbSelectBx.tag==4)self.DrProfData.DrType=sCode;
        if(_tbSelectBx.tag==5){
            NSString* sCate=@"-";
            if([sCode isEqualToString:@">12"]) sCate=@"A";
            if([sCode isEqualToString:@"7 to 11"]) sCate=@"B";
            if([sCode isEqualToString:@"1 to 6"]) sCate=@"C";
            self.DrProfData.DrTar=sCode;
            [self.btnCate setTitle:sCate forState:UIControlStateNormal];
            self.DrProfData.DrClass=sCate;
        }
        if(_tbSelectBx.tag==7) self.DrProfData.VstSess[_btnSelectbx.tag -1]=sCode;
        if(_tbSelectBx.tag==8) self.DrProfData.vstAvgPDy[_btnSelectbx.tag -1]=sCode;
        if(_tbSelectBx.tag==9) self.DrProfData.vstEcoPats[_btnSelectbx.tag -1]=sCode;
        if(_tbSelectBx.tag==10) {self.DrProfData.DrClass=sCode;[self generateCtrls:[sCode longLongValue]];}
        if(_tbSelectBx.tag==11){
            TBSelectionBxCell* cell =[tableView cellForRowAtIndexPath:indexPath];
            if([self.DrProfData.DrHosp rangeOfString:sCode].length<=0){
                self.DrProfData.DrHospNm=[NSString stringWithFormat:@"%@%@,",self.DrProfData.DrHospNm,[item objectForKey:@"Name"]];
                self.DrProfData.DrHosp =[NSString stringWithFormat:@"%@%@,",self.DrProfData.DrHosp,sCode];
                cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            else{
                self.DrProfData.DrHospNm=[self.DrProfData.DrHospNm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",[item objectForKey:@"Name"]] withString:@""];
                self.DrProfData.DrHosp=[self.DrProfData.DrHosp stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",sCode] withString:@""];
                cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            [_btnSelectbx setTitle:self.DrProfData.DrHospNm forState:UIControlStateNormal];
            cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        }
        return;
        
    }
    if(tableView==self.selOptTableView) {
        TBSelectionBxCell* cell =[tableView cellForRowAtIndexPath:indexPath];
        if(_eCtrl.ControlType==Combobox||_eCtrl.ControlType==CustomSingle)
        {
            [_eCtrl setSelectedText:[NSString stringWithFormat:@"%@",[_SelObj[indexPath.row] objectForKey:_fldName]]];
            [_eCtrl setSelectedValue:[NSString stringWithFormat:@"%@",[_SelObj[indexPath.row] objectForKey:_CodeName]]];
            
            _vwModalView.hidden=YES;
            _vwCmbView.hidden=YES;
            _vwClndrView.hidden=YES;
            //cell.lOptText.text = [_SelObj[indexPath.row] objectForKey:_fldName];
        }
        if(_eCtrl.ControlType==ComboboxMultiple || _eCtrl.ControlType==CustomMultiple){
            if([_selectedValue rangeOfString:[_SelObj[indexPath.row] objectForKey:_CodeName]].length<=0){
                _selectedText=[NSString stringWithFormat:@"%@%@, ",_selectedText,[_SelObj[indexPath.row] objectForKey:_fldName]];
                _selectedValue=[NSString stringWithFormat:@"%@%@, ",_selectedValue,[_SelObj[indexPath.row] objectForKey:_CodeName]];
                cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                
            }
            else{
                _selectedText=[_selectedText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@, ",[_SelObj[indexPath.row] objectForKey:_fldName]] withString:@""];
                _selectedValue=[_selectedValue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@, ",[_SelObj[indexPath.row] objectForKey:_CodeName]] withString:@""];
                cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        }
    }
    [self closeTableViews];
}

-(IBAction)showCmbList:(id)sender{
    UIButton* btn=(UIButton*) sender;
    _btnSelectbx=btn;
    [self AssignObjs:(int) btn.tag];
}
-(IBAction)setPotanChecked:(id)sender{
    UIButton *btn=(UIButton *)sender;
    TBSelectionBxCell* cell;
    NSInteger indx=(int)btn.titleLabel.tag;
    NSMutableDictionary *item=[self.ProductList[indx] mutableCopy];
    cell =[self.tbPoten cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indx inSection:0] ];
    [cell.btnVal1 setImage:[UIImage imageNamed:@"unchkOptB"] forState:UIControlStateNormal];
    [cell.btnVal2 setImage:[UIImage imageNamed:@"unchkOptB"] forState:UIControlStateNormal];
    [cell.btnVal3 setImage:[UIImage imageNamed:@"unchkOptB"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"chkoptRed"] forState:UIControlStateNormal];
    [item setValue:[NSNumber numberWithInt:(int)btn.tag] forKey:@"SetPoten"];
    [self.ProductList replaceObjectAtIndex:indx withObject:item];
}
-(IBAction)setSegmChecked:(id)sender{
    UIButton *btn=(UIButton *)sender;
    TBSelectionBxCell* cell;
    NSInteger indx=(int)btn.titleLabel.tag;
    NSMutableDictionary *item=[self.ProductList[indx] mutableCopy];
    cell =[self.tbSegm cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indx inSection:0] ];
    [cell.btnVal1 setImage:[UIImage imageNamed:@"unchkOptB"] forState:UIControlStateNormal];
    [cell.btnVal2 setImage:[UIImage imageNamed:@"unchkOptB"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"chkoptRed"] forState:UIControlStateNormal];
    [item setValue:[NSNumber numberWithInt:(int)btn.tag] forKey:@"SetSegm"];
    [self.ProductList replaceObjectAtIndex:indx withObject:item];
    
}
-(IBAction)searchDoctor:(id)sender
{
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.meetData.DataSF];
    self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    self.ObjCustomerList =[self FilterUnique:self.ObjCustomerList andKey:@"Code"];
    /*int flag=1;
    self.ObjCustomerList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"PlcyAcptFl.intValue == %d",flag]] mutableCopy];*/
    if([self.searchBox.text isEqualToString:@""]==NO){
        NSMutableArray *MkList = [[self.ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]] mutableCopy];
        self.ObjCustomerList = [[MkList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
    
    self.CustomerList = [[_ObjCustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    [self.collectionView reloadData];
}
-(IBAction)selGender:(id)sender{
    UIButton *btnGen=(UIButton *) sender;
    [_btnMale setImage:[UIImage imageNamed:@"unchk"] forState:UIControlStateNormal];
    [_btnFemale setImage:[UIImage imageNamed:@"unchk"] forState:UIControlStateNormal];
    [btnGen setImage:[UIImage imageNamed:@"chkGreen"] forState:UIControlStateNormal];
    self.DrProfData.DrGender=btnGen.titleLabel.text;
}
-(IBAction)selWeekDays:(id)sender{
    UIButton *btnWkDy=(UIButton *) sender;
    if(btnWkDy.titleLabel.tag!=0){
        [btnWkDy setImage:[UIImage imageNamed:@"unchk"] forState:UIControlStateNormal];
        btnWkDy.titleLabel.tag=0;
        self.DrProfData.VisitDays[btnWkDy.tag -1]=@"";
    }
    else{
        [btnWkDy setImage:[UIImage imageNamed:@"chkGreen"] forState:UIControlStateNormal];
        btnWkDy.titleLabel.tag=btnWkDy.tag;
        self.DrProfData.VisitDays[btnWkDy.tag -1]=btnWkDy.titleLabel.text;
        
    }
}
-(void) closeTableViews{
    self.tbHQ.hidden=YES;
    self.vwSelBxModal.hidden=YES;
}
-(void)showCutomerList:(id)sender{
    self.selDrView.hidden=NO;
}
-(void) ShowSelection:(NSString *) title{
    
    self.lblTittle.text=title;
    self.vwSelBxModal.hidden=NO;
}

-(void) AssignObjs:(int)mod{
    
    NSString *title=@"";
    
    if(mod==1){self.objOptList=[self.QualList mutableCopy];title=NSLocalizedString(@"Qualification List",@"Qualification List");}
    if(mod==2) {self.objOptList=[self.SpecList mutableCopy];title=NSLocalizedString(@"Speciality List",@"Speciality List");}
    if(mod==3) {self.objOptList=[self.CatList mutableCopy];title=NSLocalizedString(@"Category List",@"Category List");}
    if(mod==4) {self.objOptList=[self.TypList mutableCopy];title=NSLocalizedString(@"Type List",@"Type List");}
    
    if(mod==5) {self.objOptList=[self.TarNwPatList mutableCopy];title=NSLocalizedString(@"Targeting (New Patients / Month)",@"Targeting (New Patients / Month)");}
    if(mod==7) {self.objOptList=[self.SessList mutableCopy];title=NSLocalizedString(@"Sessions List",@"Sessions List");}
    if(mod==8) {self.objOptList=[self.AvgPatList mutableCopy];title=NSLocalizedString(@"Average number of patients per day (approximately)",@"Average number of patients per day (approximately)");}
    if(mod==9) {self.objOptList=[self.EconoList mutableCopy];title=NSLocalizedString(@"Economic class of patients",@"Economic class of patients");}
    if(mod==10) {
        self.objOptList=[[self.ClassList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type contains[c] %@",[NSString stringWithFormat:@"%@,",_SelType]]] mutableCopy];
    title=NSLocalizedString(@"Select the Class",@"Select the Class");}
    
    if(mod==11) {
        NSString* msgStr=[NSString stringWithFormat:@"%@",_SetupData.CapHos];
        self.objOptList=[self.HospitalList mutableCopy];
        title=NSLocalizedString(msgStr,msgStr);
    }
    _objAllOptList=[self.objOptList mutableCopy];
    _tbSelectBx.tag=mod;
    [self.tbSelectBx reloadData];
    [self ShowSelection:title];
}

-(IBAction)showModalList:(id)sender{
    UIButton* btn=(UIButton *) sender;
    _btnSelectbx=btn;
    [self AssignObjs:(int)btn.tag];
    
}
-(IBAction)showVstSessModalList:(id)sender{
    UIButton* btn=(UIButton *) sender;
    _btnSelectbx=btn;
    [self AssignObjs:7];
}
-(IBAction)showAvgPDyModalList:(id)sender{
    UIButton* btn=(UIButton *) sender;
    _btnSelectbx=btn;
    [self AssignObjs:8];
}
-(IBAction)showEcoPatModalList:(id)sender{
    UIButton* btn=(UIButton *) sender;
    _btnSelectbx=btn;
    [self AssignObjs:9];
}
-(IBAction)hideModalList:(id)sender{
    self.vwSelBxModal.hidden=YES;
}

-(IBAction) openSelHQ:(id)sender{
    BOOL upState=!self.tbHQ.hidden;
    [self closeTableViews];
    self.tbHQ.hidden=upState;
}
-(void) generateCtrls:(long)CatID{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"LoadinStatus", @"Loading..")];
    NSString* Typ=@"CU";
    if([_SelType isEqualToString:@"H"]) Typ=@"HO";
    _arrControlsDets=[[_ObjCtrlList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Type==%@ and Cat_code == %ld",Typ,CatID]] mutableCopy];
    
    _cyAxis=0;_scrlHeight=0;
    if(self.vwCtrlsView!=nil){
        [self.vwCtrlsView removeFromSuperview];
    }
    self.vwCtrlsView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vwAdCtrl.frame.size.width, _scrlHeight)];
    UILabel *lblHeader=[[UILabel alloc]initWithFrame:CGRectMake(kCtrlStart+2, 10, self.vwAdCtrl.frame.size.width, 30)];
    lblHeader.font=[UIFont fontWithName:@"Poppins-SemiBold" size:17.0];
    lblHeader.text=@"Additional Detail";
    [self.vwCtrlsView addSubview:lblHeader];
    UIView *HeaderBorder=[[UIView alloc]initWithFrame:CGRectMake(kCtrlStart+2, 40, self.vwAdCtrl.frame.size.width-36, 1)];
    HeaderBorder.backgroundColor=[UIColor colorWithRed:221.0f/255 green:221.0f/255 blue:221.0f/255 alpha:1.0f];
    [self.vwCtrlsView addSubview:HeaderBorder];
    _cyAxis=50;_scrlHeight=50;
    _FormsCtrls=[[NSMutableArray alloc] init];
    long inc=0;long PrvScroll=0;
    for (int il=0; il<[_arrControlsDets count]; il++) {
        NSLog(@"%@",[_arrControlsDets[il] valueForKey:@"Field_Name"]);
        NSString* Caption=[[[_arrControlsDets[il] valueForKey:@"Field_Name"] stringByReplacingOccurrencesOfString:@"From / To " withString:@""] stringByReplacingOccurrencesOfString:@"Start / End " withString:@""];
        int CtrlID=[[_arrControlsDets[il] valueForKey:@"Control_Id"] intValue];
        int CrID=[[_arrControlsDets[il] valueForKey:@"Sl_no"] intValue];
        
        float height=65.0f;
        if (CtrlID==3 || CtrlID==Files) height=110.0f;
        if (CtrlID==0) height=30.0f;
        BOOL isRange=NO;
        if (CtrlID==5 || CtrlID==7) isRange=YES;
        long mWidth=_vwAdCtrl.frame.size.width/2;
        
        SANControlsBox *CardView=[[SANControlsBox alloc] initWithFrame:CGRectMake(kCtrlStart+inc, _cyAxis, mWidth-((kCtrlStart*2)+4) , height) title:Caption ControlType:CtrlID isRange:isRange];
        
        CardView.Caption=Caption;
        CardView.ID=[NSString stringWithFormat:@"Ctrl_%d_%d",CtrlID,il];
        CardView.index=il;
        CardView.isMandate=[[_arrControlsDets[il] valueForKey:@"Mandatory"] boolValue];
        if(CtrlID==Currency){
            CardView.ICurrency=[_arrControlsDets[il] valueForKey:@"Control_Para"] ;
        }else if(CtrlID==TextField||CtrlID==NumberField||CtrlID==TextArea) {
            CardView.MaxLength=[[_arrControlsDets[il] valueForKey:@"Control_Para"] integerValue];
        }
        CardView.delegate=self;
        
        NSMutableArray* adVals=[[self.moreDets filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Cat_Code == %ld and Control_Id.intValue ==%ld and Created_Sl_No.intValue==%ld",CatID,CtrlID,CrID]] mutableCopy];
        if([adVals count]>0){
            NSMutableDictionary* adItm=adVals[0];
            CardView.selectedValue=[adItm valueForKey:@"Creation_Code"];
            CardView.selectedText=[adItm valueForKey:@"Creation_Name"];
        }
        [self.vwCtrlsView addSubview:CardView];
        if(il<(([_arrControlsDets count]-1)/2)){
            _cyAxis+=CardView.frame.size.height+5;
            _scrlHeight+=CardView.frame.size.height+5;
        }else{
            if(inc==0) {
                inc=mWidth;
                _cyAxis=50;
                PrvScroll=_scrlHeight+CardView.frame.size.height+5;
                _scrlHeight=50;
            }else{
                _cyAxis+=CardView.frame.size.height+5;
                _scrlHeight+=CardView.frame.size.height+5;
            }
        }
        /*
        if(inc==0) {inc=mWidth;
        }else{inc=0;
            _cyAxis+=CardView.frame.size.height+5;
            _scrlHeight+=CardView.frame.size.height+5;
        }*/
        [_FormsCtrls addObject:CardView];
    }
    if (PrvScroll>_scrlHeight) _scrlHeight=PrvScroll;
    [self.vwCtrlsView setFrame:CGRectMake(0, 0, self.vwAdCtrl.frame.size.width-0, _scrlHeight)];
    [self.vwAdCtrl setFrame:CGRectMake(self.vwAdCtrl.frame.origin.x, _defHeight, self.vwAdCtrl.frame.size.width-0, _scrlHeight)];

    _nsScrollHeight.constant=_defHeight+_scrlHeight+10;
    [self.view layoutIfNeeded];
    [self.vwAdCtrl addSubview:self.vwCtrlsView];

    //[self.vwScrlContView setContentSize: CGSizeMake(self.vwCtrlsView.frame.size.width, self.vwCtrlsView.frame.size.height+16)];
    [SVProgressHUD dismiss];
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView==self.pikFT) return [self.Hours count];
    if(pickerView==self.pikTT) return [self.Mins count];
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [pickerLabel setFont:[UIFont fontWithName:@"Poppins-Regular" size:11.0]];
        //pickerLabel.textColor = primaryTextColor;
        pickerLabel.textAlignment = NSTextAlignmentCenter;


    }
    // Fill the label text here
    if(pickerView==self.pikFT)
    pickerLabel.text = self.Hours[row];
    if(pickerView==self.pikTT)
    pickerLabel.text = self.Mins[row];

    return pickerLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView==self.pikFT)
    _selectedHour = self.Hours[row];
    if(pickerView==self.pikTT)
    _selectedMinute = self.Mins[row];
}
-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _lblSelDt.text=[dateFormatter stringFromDate:date];
    _selectedDate=date;
    if(_eCtrl.ControlType==DatePicker || _eCtrl.ControlType==DatePickerRange){
        if(_eCtrl.isToCtrl==YES){
            _eCtrl.selectedToValue=[dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
            _eCtrl.selectedToText=[dateFormatter stringFromDate:date];
        }else{
            _eCtrl.selectedValue=[dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
            _eCtrl.selectedText=[dateFormatter stringFromDate:date];
        }
        [self CloseOptWindow:self];
    }
}

-(IBAction) CloseOptWindow:(id)sender{
        _vwModalView.hidden=YES;
        _vwCmbView.hidden=YES;
        _vwClndrView.hidden=YES;
}
-(void)deleteFile:(NSString *)FileUrl{
    
}
- (void)didClick:(id)Control{
    _CtxtFld=[UIResponder currentFirstResponder];
    if(_CtxtFld!=nil)
    [_CtxtFld endEditing:YES];
    
    _eCtrl=(SANControlsBox*) Control;
    //SANContolType ControlType=eCtrl.ControlType;
    _lblSelHead.text=[NSString stringWithFormat:@"Select the %@",_eCtrl.Caption];
    _lblSelHead1.text=[NSString stringWithFormat:@"Select the %@",_eCtrl.Caption];
    _selectedText=@"";
    _selectedValue=@"";
    
    if(!([_eCtrl.selectedValue isEqualToString:@""] || _eCtrl.selectedValue==nil)){
        _selectedValue=_eCtrl.selectedValue;
        _selectedText=_eCtrl.selectedText;
    }
    int ControlIndex=_eCtrl.index;
    int CType=[[_arrControlsDets[ControlIndex] objectForKey:@"Control_Id"] intValue];
    if(CType==Files){
        UIDocumentPickerViewController* documentPicker =
          [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.image", @"public.audio", @"public.movie", @"public.text", @"public.item", @"public.content", @"public.source-code"]
                                                                 inMode:UIDocumentPickerModeImport];
        documentPicker.delegate = self;
        documentPicker.modalPresentationStyle=UIModalPresentationFullScreen;
        [self presentViewController:documentPicker animated:YES completion:nil];
   
    }
    if(CType==Combobox || CType==ComboboxMultiple|| CType==CustomSingle || CType==CustomMultiple){
        _vwModalView.hidden=NO;
        _vwCmbView.hidden=NO;
        _vwClndrView.hidden=YES;
        _SelObj= [[_arrControlsDets[ControlIndex] objectForKey:@"input"] mutableCopy];
        _AllSelObj= [[_arrControlsDets[ControlIndex] objectForKey:@"input"] mutableCopy];
        _fldName=[_arrControlsDets[ControlIndex] objectForKey:@"Table_name"];
        _CodeName=[_arrControlsDets[ControlIndex] objectForKey:@"Table_code"];
        [_selOptTableView reloadData];
    }
    if(CType==DatePicker || CType==DatePickerRange || CType==TimePicker || CType==TimePickerRange)
    {
        _vwModalView.hidden=NO;
        _vwCmbView.hidden=YES;
        _vwClndrView.hidden=NO;
    }
}
-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    NSString* sFilePath=[[NSString stringWithFormat:@"%@",[urls[0] absoluteURL]] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSArray *arrayOfComponents = [sFilePath componentsSeparatedByString:@"/"];
    
    NSData *ScribData =[NSData dataWithContentsOfFile:[NSURL URLWithString:sFilePath]];
    if(ScribData==nil){
        [BaseViewController Toast:NSLocalizedString(@"Invalid File or Filename", @"Invalid File or Filename")];
    }else{
        NSMutableDictionary *fileData=[[NSMutableDictionary alloc] init];
        [fileData setObject:ScribData forKey:@"File"];
        [fileData setValue:@"AFile" forKey:@"Key"];
        [fileData setValue:arrayOfComponents[[arrayOfComponents count]-1] forKey:@"Filename"];
        [WBService uploadFileToServer:[fileData mutableCopy]];
        
        //[WBService uploadFileToServer:sFilePath FileName:arrayOfComponents[[arrayOfComponents count]-1]];
        _eCtrl.selectedValue=sFilePath;
        _eCtrl.selectedText=arrayOfComponents[[arrayOfComponents count]-1];
    }
}
- (IBAction)searchInDidChange:(id)sender{
    UITextField* txtSearch=(UITextField*) sender;
    if([txtSearch.text isEqualToString:@""])
        _objOptList=_objAllOptList;
    else
        _objOptList=[[_objAllOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@",txtSearch.text]] mutableCopy];
    
    [_tbSelectBx reloadData];
}
- (IBAction)searchTextDidChange:(id)sender{
    UITextField* txtSearch=(UITextField*) sender;
    if([txtSearch.text isEqualToString:@""])
        _SelObj=_AllSelObj;
    else
        _SelObj=[[_AllSelObj filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K contains[c] %@",self.fldName,txtSearch.text]] mutableCopy];
    
    [_selOptTableView reloadData];
}
-(IBAction) setControlValue:(id)sender{
    if(_eCtrl.ControlType==TimePicker || _eCtrl.ControlType==TimePickerRange){
        if(_selectedDate==nil)
        {
            [BaseViewController Toast:NSLocalizedString(@"Date Not Seleted...", @"Date Not Seleted...")];
            return;
        }
        if (_selectedHour==nil) _selectedHour=@"00";
        if (_selectedMinute==nil) _selectedMinute =@"00";
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        _selectedValue=[NSString stringWithFormat:@"%@ %@:%@",[dateFormatter stringFromDate:_selectedDate],_selectedHour,_selectedMinute];
        
        dateFormatter.dateFormat = @"dd-MM-yyyy";
        _selectedText=[NSString stringWithFormat:@"%@ %@:%@",[dateFormatter stringFromDate:_selectedDate],_selectedHour,_selectedMinute];
        
    }
    if(_eCtrl.isToCtrl==YES){
        [_eCtrl setSelectedToText:_selectedText];
        [_eCtrl setSelectedToValue:_selectedValue];
    }else{
        [_eCtrl setSelectedText:_selectedText];
        [_eCtrl setSelectedValue:_selectedValue];
    }
    if(_eCtrl.ControlType==TimePicker || _eCtrl.ControlType==TimePickerRange){
        [self.pikFT selectRow:0 inComponent:0 animated:YES];
        [self.pikTT selectRow:0 inComponent:0 animated:YES];
        _selectedHour=@"00";
        _selectedMinute =@"00";
    }
    [self CloseOptWindow:sender];
}


-(IBAction) gotoHome:(id)sender{
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}
-(NSMutableArray*) getDynProfData{
    
    NSMutableArray *datas=[[NSMutableArray alloc]init];
    for(int il=0;il<[_FormsCtrls count];il++)
    {
        
        SANControlsBox* cCtrl = (SANControlsBox*) _FormsCtrls[il];
        int CType=[[_arrControlsDets[cCtrl.index] objectForKey:@"Control_Id"] intValue];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormat setLocale:[NSLocale currentLocale]];
        
        
        NSMutableDictionary *dataItem=[[NSMutableDictionary alloc]init];
        [dataItem setValue:self.UserDet.SF forKey:@"SF"];
        [dataItem setValue:[self.UserDet.DivCode stringByReplacingOccurrencesOfString:@"," withString:@""] forKey:@"div"];
        [dataItem setValue:[dateFormat stringFromDate:date] forKey:@"act_date"];
        [dataItem setValue:[dateFormat stringFromDate:date] forKey:@"update_time"];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd 00:00:00"];
        [dataItem setValue:[dateFormat stringFromDate:date] forKey:@"dcr_date"];
        [dataItem setValue:[NSString stringWithFormat:@"%i",CType] forKey:@"ctrl_id"];
        [dataItem setValue:[_arrControlsDets[cCtrl.index] objectForKey:@"Sl_no"] forKey:@"creat_id"];
        [dataItem setValue:[_arrControlsDets[cCtrl.index] objectForKey:@"Group_Creation_Id"] forKey:@"group_creat_id"];
        [dataItem setValue:_locationData.latitude forKey:@"lat"];
        [dataItem setValue:_locationData.longitude forKey:@"lng"];
        
        if(cCtrl.ControlType<3){
            cCtrl.selectedValue=cCtrl.txtField.text;
            cCtrl.selectedText=cCtrl.txtField.text;
        }else if(cCtrl.ControlType<4){
            cCtrl.selectedValue=cCtrl.txtView.text;
            cCtrl.selectedText=cCtrl.txtView.text;
        }
        if(cCtrl.isMandate==YES){
            if([cCtrl.selectedValue isEqualToString:@""] || cCtrl.selectedValue==nil){
                [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Kindly Fill the ValidationErrMSG", @"Kindly Fill the"),cCtrl.Caption]];
                return nil;
            }
            if(cCtrl.ControlType==DatePickerRange || cCtrl.ControlType==TimePickerRange){
                if([cCtrl.selectedToValue isEqualToString:@""] || cCtrl.selectedToValue==nil){
                    [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Kindly Fill the to Range of ValidationErrMSG", @"Kindly Fill the to Range of "),cCtrl.Caption]];
                    return nil;
                }
            }
        }
        if(cCtrl.ControlType==DatePickerRange || cCtrl.ControlType==TimePickerRange){
            if(!([cCtrl.selectedValue isEqualToString:@""] || cCtrl.selectedValue==nil || [cCtrl.selectedToValue isEqualToString:@""] || cCtrl.selectedToValue==nil)){
                NSDate  *startDate;
                NSDate  *endDate;
                if(cCtrl.ControlType==TimePickerRange){
                    startDate=[BaseViewController str2date:[NSString stringWithFormat:@"%@:00",cCtrl.selectedValue]];
                    endDate=[BaseViewController str2date:[NSString stringWithFormat:@"%@:00",cCtrl.selectedToValue]];
                }else{
                    startDate=[BaseViewController str2date:cCtrl.selectedValue];
                    endDate=[BaseViewController str2date:cCtrl.selectedToValue];
                }
                if([endDate compare:startDate]==NSOrderedAscending){
                    [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"To Range Must be greater then From Seletion of", @"To Range Must be greater then From Seletion of"),cCtrl.Caption]];
                    return nil;
                }
            }
        }
        
        [dataItem setValue:cCtrl.selectedText forKey:@"values"];
        [dataItem setValue:cCtrl.selectedValue forKey:@"codes"];
        [datas addObject:dataItem];
    }
    return datas;
}
-(IBAction) svDoctorProfile:(id)sender{
    NSMutableArray* DynData=[self getDynProfData];
    if(DynData==nil){
        return;
    }
    self.DrProfData.CustCode=self.CustCode;
    self.DrProfData.CustName=self.lblDrName.text;
    self.DrProfData.ProfType=self.SelType;
    self.DrProfData.DrDOBD=self.txtDOBD.text;
    self.DrProfData.DrDOBM=self.txtDOBM.text;
    self.DrProfData.DrDOWD=self.txtDOWD.text;
    self.DrProfData.DrDOWM=self.txtDOWM.text;
    self.DrProfData.DrDOBY=self.txtDOBY.text;
    self.DrProfData.DrDOWY=self.txtDOWY.text;
    self.DrProfData.DrAdd1=[NSString stringWithFormat:@"%@",self.txtAdd1.text];
    self.DrProfData.DrAdd2=[NSString stringWithFormat:@"%@",self.txtAdd2.text];
    self.DrProfData.DrAdd3=[NSString stringWithFormat:@"%@",self.txtAdd3.text];
    self.DrProfData.DrAdd4=[NSString stringWithFormat:@"%@",self.txtAdd4.text];
    self.DrProfData.DrAdd5=[NSString stringWithFormat:@"%@",self.txtAdd5.text];
    self.DrProfData.DrPhone=[NSString stringWithFormat:@"%@",self.txtPhone.text];
    self.DrProfData.DrMob=[NSString stringWithFormat:@"%@",self.txtMob.text];
    self.DrProfData.DrEmail=[NSString stringWithFormat:@"%@",self.txtEmail.text];
    self.DrProfData.ContactPerson=[NSString stringWithFormat:@"%@",self.txtCPerson.text];
    self.DrProfData.Products=[self.ProductList mutableCopy];
    self.DrProfData.AdditionalCtrls=[DynData mutableCopy];
    NSLog(@"%@",[self.DrProfData toNSDictionary]);
    NSString* Type=NSLocalizedString(self.SetupData.CapDr, self.SetupData.CapDr);
    if([_SelType isEqualToString:@"H"]) Type=NSLocalizedString(self.SetupData.CapHos, self.SetupData.CapHos);
    
    [WBService SendServerRequest:@"SAVE/DrProfile" withParameter:[_DrProfData toNSDictionary] withImages:nil
                          DataSF:self.meetData.DataSF
                      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         if(Success==YES){
             [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",Type,NSLocalizedString(@"Profile Saved Successfully", @"Profile Saved Successfully")]];
         }
         else{
             [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",Type,NSLocalizedString(@"Profiling Failed.", @"Profiling Failed.")]];
         }
         [SVProgressHUD dismiss];
     }
       error:^(NSString *errorMsg,NSMutableDictionary *uData){
           [BaseViewController Toast:[NSString stringWithFormat:@"%@ .\n %@",Type,errorMsg.description,NSLocalizedString(@"Profiling FailedERR", @"Profiling Failed")]];
           [SVProgressHUD dismiss];
       }];
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
-(void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _CtxtFld=[UIResponder currentFirstResponder];

    if (_CtxtFld!=NULL){
        CGRect viewFrame = self.view.window.frame;
        CGRect textFieldRect = [self.view.window convertRect:_CtxtFld.bounds fromView:_CtxtFld];
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
        //viewFrame.origin.y += _animatedDistance;

        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        
        //[self.view.window layoutIfNeeded];
        
        [self.view.window setFrame:viewFrame];
        [UIView commitAnimations];
}
@end
