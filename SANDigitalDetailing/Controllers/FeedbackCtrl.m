 //
//  FeedbackCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 04/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "FeedbackCtrl.h"
#import "MainHomeController.h"
#import "CVColor.h"
#import "RCPAEntryCtrlr.h"
#import "RatingInfoController.h"
@interface FeedbackCtrl ()
    @property (nonatomic, strong) NSArray* CustomerList;
    @property (nonatomic, strong) NSArray* ProductList;
    @property (nonatomic, strong) NSMutableArray* InputList;
    @property (nonatomic, strong) NSArray* JWList;
    @property (nonatomic, strong) NSArray* FeedBkList;


    @property (nonatomic, strong) NSArray* SelAdCustList;
    @property (nonatomic, strong) NSArray* SelProductList;
    @property (nonatomic, strong) NSMutableArray* DefProductList;
    @property (nonatomic, strong) NSMutableArray* AdSelProductList;
    @property (nonatomic, strong) NSArray* SelInputList;
    @property (nonatomic, strong) NSArray* AdSelInputList;
    @property (nonatomic, strong) NSArray* SelJWList;
    @property (nonatomic, strong) NSArray* SelDepartsList;

    @property (nonatomic, strong) NSArray* objOptList;

    @property (nonatomic, strong) NSMutableArray* SubmittedCallList;
    @property (nonatomic, strong) NSMutableArray* SelOptList;
    @property (nonatomic, strong) NSMutableArray* JWGrpOptList;
    @property (nonatomic, strong) NSArray* RatingFeedbks;
    @property (nonatomic, strong) NSArray* ProdSlides;

    @property(nonatomic,assign) CGSize keyboardSize;
    @property(nonatomic,strong) UITextView* CtxtFld;
    @property(nonatomic,assign) CGFloat animatedDistance;
@end

@implementation FeedbackCtrl

static const CGFloat ANIMATION_DURATION = 0.4;
static const CGFloat LITTLE_SPACE = 25;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
-(void) viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.MissedEntry=[MissedEntryData sharedDatas];
    self.meetData=[CallMeetData sharedDatas];
    self.UserDet=[UserDetails sharedUserDetails];
    self.SetupData=[AppSetupData sharedDatas];
    
    self.tvOptList.delegate = self;
    self.tvOptList.dataSource = self;
    self.tvAdCusList.delegate = self;
    self.tvAdCusList.dataSource = self;
    self.tvAdProdList.delegate = self;
    self.tvAdProdList.dataSource = self;
    self.tvAdInputList.delegate = self;
    self.tvAdInputList.dataSource = self;
    self.tvProdList.delegate = self;
    self.tvProdList.dataSource = self;
    self.tvInputList.delegate = self;
    self.tvInputList.dataSource = self;
    self.tvJWList.delegate = self;
    self.tvJWList.dataSource = self;
    self.tvDepts.delegate = self;
    self.tvDepts.dataSource = self;
    self.tvProdFeedBk.delegate=self;
    self.tvProdFeedBk.dataSource=self;
    self.tvFeedBk.delegate=self;
    self.tvFeedBk.dataSource=self;
    self.tvFeedBk1.delegate=self;
    self.tvFeedBk1.dataSource=self;
    //self.tvRatingInf.delegate=self;
    //self.tvRatingInf.dataSource=self;
    
    //self.tvRatingInf.layer.borderColor=[UIColor grayColor].CGColor;
    //self.tvRatingInf.layer.borderWidth=1.0f;
    //self.txtRem.delegate=self;
    NSString *LstType=@"DoctorDetails";
    self.btnSndQry.hidden=self.meetData.MissedEntry;
    self.btnAddAdCus.hidden=self.meetData.MissedEntry;
    self.btnFinal.hidden=self.meetData.MissedEntry;
    self.btnCancel.hidden=self.meetData.MissedEntry;
    self.btnSave.hidden=!self.meetData.MissedEntry;
    self.btnRCPA.hidden=YES;
    
    
    
    CGRect fram=CGRectMake(_btnActivity.frame.origin.x, _btnSurvey.frame.origin.y, _btnSurvey.frame.size.width, _btnSurvey.frame.size.height);
    _btnActivity.hidden=YES;
    if((_SetupData.DrActivityNeed==1 && [_meetData.CusType isEqualToString:@"1"]) ||
       (_SetupData.ChmActivityNeed==1 && [_meetData.CusType isEqualToString:@"2"]) ||
       (_SetupData.StkActivityNeed==1 && [_meetData.CusType isEqualToString:@"3"]) ||
       (_SetupData.NdrActivityNeed==1 && [_meetData.CusType isEqualToString:@"4"]))
    {
        _btnActivity.hidden=NO;
        fram=CGRectMake(_btnActivity.frame.origin.x-153, _btnSurvey.frame.origin.y, _btnSurvey.frame.size.width, _btnSurvey.frame.size.height);
        
    }
    
    _btnSurvey.hidden=YES;
    if((_SetupData.DrSurveyNeed==1 && [_meetData.CusType isEqualToString:@"1"]) ||
       (_SetupData.ChmSurveyNeed==1 && [_meetData.CusType isEqualToString:@"2"]) ||
       (_SetupData.StkSurveyNeed==1 && [_meetData.CusType isEqualToString:@"3"]) ||
       (_SetupData.NdrSurveyNeed==1 && [_meetData.CusType isEqualToString:@"4"]))
    {
        _btnSurvey.hidden=NO;
        _btnSurvey.frame=fram;
    }
    
    if([self.meetData.CusType isEqual:@"2"]) LstType=@"ChemistDetails";
    if([self.meetData.CusType isEqual:@"3"]) LstType=@"StockistDetails";
    if([self.meetData.CusType isEqual:@"4"]) LstType=@"UnlistedDR";
    if([self.meetData.CusType isEqual:@"1"]) self.btnRCPA.hidden=NO;
    NSString *DataKey=[[NSString alloc] initWithFormat:@"%@_%@.SANAPP",LstType,self.meetData.DataSF];
    
    self.CustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    
    //self.RatingInfList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"RatingInfo.SANAPP"] mutableCopy];
    self.ProductList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Products.SANAPP"] mutableCopy];
    self.InputList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Inputs.SANAPP"] mutableCopy];
    NSMutableDictionary *Item=[[NSMutableDictionary alloc] init];
    [Item setValue:@"" forKey:@"Code"];
    [Item setValue:@"No Gift" forKey:@"Name"];
    [self.InputList addObject:Item];
    self.JWList =[[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"JointWork_%@.SANAPP",self.meetData.DataSF]] mutableCopy];
    //self.FeedBkList=@[@"Not Accepted",@"Partially Accepted",@"Accepted"];
    
    _JWGrpOptList=[[NSMutableArray alloc] init];
    NSMutableDictionary* nitm=[[NSMutableDictionary alloc] init];
    [nitm setValue:@"HO Users" forKey:@"Name"];
    [nitm setValue:[[self.JWList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Typ.intValue==1"]] mutableCopy] forKey:@"Vals"];
    [nitm setValue:[NSNumber numberWithBool:YES] forKey:@"Expend"];
    [self.JWGrpOptList addObject:nitm];
    
    nitm=[[NSMutableDictionary alloc] init];
    [nitm setValue:@"Field Users" forKey:@"Name"];
    [nitm setValue:[[self.JWList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Typ.intValue!=1"]] mutableCopy] forKey:@"Vals"];
    [nitm setValue:[NSNumber numberWithBool:YES] forKey:@"Expend"];
    [self.JWGrpOptList addObject:nitm];
    _AdrDetsWin.tag=-1;
    self.RatingFeedbks =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Ratingfeedbk.SANAPP"] mutableCopy];
    if([_meetData.AdCuss count]){
        self.SelAdCustList =[_meetData.AdCuss mutableCopy];//[[NSArray alloc]init];
    }else{
        self.SelAdCustList =[[NSArray alloc]init];
    }
    
    if([_meetData.Products count]){
        self.SelProductList =[_meetData.Products mutableCopy];//[[NSArray alloc]init];
    }else{
        self.SelProductList =[[NSArray alloc]init];
    }
    
    if([_meetData.Inputs count]){
        self.SelInputList =[_meetData.Inputs mutableCopy];//[[NSArray alloc]init];
    }else{
        self.SelInputList =[[NSArray alloc]init];
    }
    
    self.DefProductList =[[NSMutableArray alloc]init];
    if([_meetData.Products count]){
        for(int il=0;il<[self.SelProductList count];il++){
            [self.DefProductList addObject:[self.SelProductList[il] mutableCopy]];
            [self.DefProductList setValue:[NSNumber numberWithInt:0] forKey:@"Rating"];
        }//[[NSArray alloc]init];
    }
    
    if([_meetData.Inputs count]){
        self.AdSelInputList =[_meetData.Inputs mutableCopy];//[[NSArray alloc]init];
    }else{
        self.AdSelInputList =[[NSArray alloc]init];
    }
    if([_meetData.JWWrk count]) self.SelJWList =[_meetData.JWWrk mutableCopy]; else self.SelJWList =[[NSArray alloc]init];
    if(_meetData.MissedEntry==YES){
        CallMeetData *itm=_MissedEntry.MissDatas[_MissedEntry.SelectedIndex];
        if([itm.JWWrk count]) self.SelJWList =[itm.JWWrk mutableCopy]; else self.SelJWList =[[NSArray alloc]init];
        if([itm.Products count]) self.SelProductList =[itm.Products mutableCopy]; else self.SelProductList =[[NSArray alloc]init];
        if([itm.Inputs count]) self.SelInputList =[itm.Inputs mutableCopy]; else self.SelInputList =[[NSArray alloc]init];
        self.txtRem.text=itm.Remks;
        
    }
    self.SelDepartsList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Departs.SANAPP"] mutableCopy];
    //self.objOptList =self.CustomerList;
    [self closeSelection];
    [self closeProdFeedback];
    [self winCloseQuery];
    [self.signatureView ClearSign];
    self.nsVfselTop.constant=self.vfSelWindow.frame.size.height;
    self.VfBottomLayout.constant=-self.vfSelWindow.frame.size.height;
    self.VfProdFeedTop.constant=self.vfProdFeed.frame.size.height;
    self.VfProdFeedBottom.constant=-self.vfProdFeed.frame.size.height;
    [self.view layoutIfNeeded];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    self.lblCusName.text=self.meetData.CustName;
    self.txtRem.text=self.meetData.Remks;
    NSData *imageData=_meetData.SignImg;
    UIImage *image=[UIImage imageWithData:imageData];
    _signatureView.mySignatureImage.image=image;
}
- (void)viewWillAppear:(BOOL)animated{
    self.vfProdFeed1.alpha=0;
    self.vfProdFeed1.hidden=YES;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==self.tvOptList && self.searchBox.tag==4)
        return _JWGrpOptList.count;
    else
        return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    float h=0;
    if(tableView==self.tvOptList && self.searchBox.tag==4) h=40;
    return h;
            
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tvOptList)
    {
        if(self.searchBox.tag==4)
            if ([[self.JWGrpOptList[section] objectForKey:@"Expend"] boolValue]==YES)
                return [[self.JWGrpOptList[section] objectForKey:@"Vals"] count];
            else
                return 0;
        else
            return self.objOptList.count;
    }
    if(tableView==self.tvAdCusList) return self.SelAdCustList.count;
    if(tableView==self.tvAdProdList) return self.AdSelProductList.count;
    if(tableView==self.tvAdInputList) return self.AdSelInputList.count;
    if(tableView==self.tvProdList) return self.SelProductList.count;
    if(tableView==self.tvInputList) return self.SelInputList.count;
    if(tableView==self.tvJWList) return self.SelJWList.count;
    if(tableView==self.tvDepts) return self.SelDepartsList.count;
    if(tableView==self.tvFeedBk||tableView==self.tvFeedBk1) return self.FeedBkList.count;
    if(tableView==self.tvProdFeedBk) return self.ProdSlides.count;
   // if(tableView==self.tvRatingInf) return self.RatingInfList.count;
    return 0;
}

-(IBAction) ExpendAndCloseItems:(id)sender{
   UIButton* btn=(UIButton*) sender;
    NSInteger section=btn.tag;
    NSArray *sectionData = [[self.JWGrpOptList[section] objectForKey:@"Vals"] mutableCopy];
    BOOL isExpend=[[self.JWGrpOptList[section] objectForKey:@"Expend"] boolValue];
    
    NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
    for (int i=0; i< sectionData.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
        [arrayOfIndexPaths addObject:index];
    }
    [self.tvOptList beginUpdates];
    if(isExpend==YES){
        /* [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
        }];*/
        [self.JWGrpOptList[section] setValue:[NSNumber numberWithBool:NO] forKey:@"Expend"];
        [self.tvOptList deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
    }
    else
    {
        [self.JWGrpOptList[section] setValue:[NSNumber numberWithBool:YES] forKey:@"Expend"];
        [self.tvOptList insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
    }
    [self.tvOptList endUpdates];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=40;
    if(tableView==self.tvOptList && self.searchBox.tag==4) h=40;
    else if(tableView==self.tvOptList && self.searchBox.tag!=4) h=60;
    else if(tableView==self.tvProdFeedBk ) h=122;
    return h;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView;
    if( self.searchBox.tag==4 && tableView==self.tvOptList){
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tvOptList.frame.size.width,40)]; //
        sectionView.tag=section;
        UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tvOptList.frame.size.width, 40)];
        viewLabel.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0f];
        viewLabel.textColor=[UIColor colorWithRed:26.0/255 green:26.0/255 blue:26.0/255 alpha:1];
        viewLabel.font=[UIFont fontWithName:@"Poppins-Bold"  size:14.0];
        viewLabel.text=[NSString stringWithFormat:@"  %@",[[_JWGrpOptList objectAtIndex:section] valueForKey:@"Name"]];
        [sectionView addSubview:viewLabel];
        UIButton *btnMim=[[UIButton alloc]initWithFrame:CGRectMake(_tvOptList.frame.size.width-40, 5, 30, 30)];
        [btnMim setImage:[UIImage imageNamed:@"Dropdown"]  forState:UIControlStateNormal];
        btnMim.tag=section;
        [btnMim addTarget:self action:@selector(ExpendAndCloseItems:) forControlEvents:UIControlEventTouchUpInside];
        //btnMim.backgroundColor=[UIColor redColor];
        [sectionView addSubview:btnMim];
    }
    else{
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        sectionView.hidden=YES;
     }
    return sectionView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;NSInteger tag = 0;
    NSDictionary *optLst=[[NSDictionary alloc] init];
    if(tableView==self.tvProdList) {optLst = [self.SelProductList[indexPath.row] mutableCopy];tag=1;}
    if(tableView==self.tvInputList){optLst = self.SelInputList[indexPath.row];tag=2;}
    if(tableView==self.tvAdCusList){optLst = self.SelAdCustList[indexPath.row];tag=3;}
    if(tableView==self.tvAdProdList) {optLst = [self.AdSelProductList[indexPath.row] mutableCopy];tag=11;}
    if(tableView==self.tvAdInputList){optLst = self.AdSelInputList[indexPath.row];tag=12;}
    if(tableView==self.tvJWList)   {optLst = self.SelJWList[indexPath.row];tag=4;}
    if(tableView==self.tvDepts)   {optLst = self.SelDepartsList[indexPath.row];tag=5;}
    
    

    if(tableView==self.tvOptList) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSDictionary *optLst;
        if([self.objOptList count]>0){
        if(self.searchBox.tag==4){
             optLst = [self.objOptList[indexPath.section] objectForKey:@"Vals"] [indexPath.row];
        }
        else{
            optLst = self.objOptList[indexPath.row];
        }
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        cell.lOptVal.text = [optLst objectForKey:@"Town_Name"];
        cell.btnCheked.tag = indexPath.row;
        }
        NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [optLst objectForKey:@"Code"]]] mutableCopy];
        if(Selitem.count>0){
            [cell.btnCheked setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            cell.Checked=YES;
        }else{
            [cell.btnCheked setImage:nil forState:UIControlStateNormal];
            cell.Checked=NO;
        }
        [cell.btnCheked addTarget:self action:@selector(setChecked:) forControlEvents:UIControlEventTouchUpInside];

    }
    /*else if(tableView==self.tvRatingInf) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *optLst = self.RatingInfList[indexPath.row];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        
    }*/
    else if(tableView==self.tvFeedBk || tableView==self.tvFeedBk1) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [self.FeedBkList[indexPath.row] valueForKey:@"Name"];
        [cell.lOptText sizeToFit];
        [cell.lOptText layoutIfNeeded];
        [cell layoutIfNeeded];
    }
    else if(tableView==self.tvDepts) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
    }
    else if(tableView==self.tvProdFeedBk) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSMutableDictionary *item=[self.ProdSlides[indexPath.row] mutableCopy];
        cell.lOptText.text = [item valueForKey:@"Slide"];
        
        NSString *EffDT=[item valueForKey:@"SlidePath"];
         
        NSString *SlidesDirectory = [BaseViewController getSlidesDirectory];
        NSString *fileName=[NSString stringWithFormat:@"%@/%@",EffDT,[item valueForKey:@"Slide"]];
        
        int likeFlg=[[item valueForKey:@"usrLike"] intValue];
        cell.lOptImgStatus.image=nil;
        if(likeFlg==1) cell.lOptImgStatus.image=[UIImage imageNamed:@"like_on"];
        if(likeFlg==2) cell.lOptImgStatus.image=[UIImage imageNamed:@"dislike_on"];
        if([[item valueForKey:@"SlideType"] isEqual:@"H"]){
         
        cell.lOptImg.image=[BaseViewController loadSlideImage:[NSString stringWithFormat:@"%@/%@",[item valueForKey:@"SlidePath"],[[item valueForKey:@"Slide"] stringByReplacingOccurrencesOfString:@".html" withString:@""]]];
        cell.lOptImg.contentMode = UIViewContentModeScaleToFill;
         
        }
        else if([[item valueForKey:@"SlideType"] isEqual:@"I"]){
            UIImage* image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            cell.lOptImg.contentMode = UIViewContentModeScaleAspectFit;
            cell.lOptImg.clipsToBounds = YES;
            cell.lOptImg.image=image;
        }
        else if([[item valueForKey:@"SlideType"] isEqual:@"V"]){
            NSURL *urlVideoFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            
            cell.lOptImg.image=[BaseViewController getVideoThumbnail:urlVideoFile];
            cell.lOptImg.contentMode = UIViewContentModeScaleToFill;
        }
        else if([[item valueForKey:@"SlideType"] isEqual:@"P"])
        {
            NSURL *PDFFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            cell.lOptImg.image=[BaseViewController imageFromPDFWithDocumentRef:CGPDFDocumentCreateWithURL( (__bridge CFURLRef) PDFFile)];
            cell.lOptImg.contentMode = UIViewContentModeScaleAspectFill;
            cell.lOptImg.clipsToBounds = YES;
         
        }
        cell.lOptImg.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.lOptImg.layer.borderWidth=1;
         
        
        int val=[[item objectForKey:@"SlideRating"] intValue];
        
        [cell.starRating setRatingValue:val];
        cell.delegate=self;
        cell.lOptTextvw.text = [item valueForKey:@"SlideRem"];
        NSArray *times=[[item valueForKey:@"Times"] mutableCopy];
        NSTimeInterval diff=0;
        for(int il=0;il<[times count];il++){
            
            NSDate *date1 = [BaseViewController str2date:[times[il] valueForKey:@"sTm"]];
            NSDate *date2 = [BaseViewController str2date:[times[il] valueForKey:@"eTm"]];
            
            diff += [date2 timeIntervalSinceDate:date1];
        }
        cell.lOptTimeLine.text = [NSString stringWithFormat:@"%@ - %@  %d Sec",[BaseViewController str2Format:[times[0] valueForKey:@"sTm"] withFormat:@"HH:mm:ss"],[BaseViewController str2Format:[times[[times count]-1] valueForKey:@"eTm"] withFormat:@"HH:mm:ss"],(int)diff];
        
        cell.lOptTextvw.tag=indexPath.row;
        cell.lOptTextvw.delegate=self;
        
        
    }
    else
    {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [optLst objectForKey:@"Name"];
        cell.btnDel.tag = indexPath.row;
        cell.btnDel.titleLabel.tag=tag;
        
        cell.btnDel.enabled=YES;
        [cell.btnDel addTarget:self action:@selector(DeleteRow:) forControlEvents:UIControlEventTouchUpInside];
        if(tableView==self.tvProdList || tableView==self.tvAdProdList )
        {
            NSString* sGroup=[optLst objectForKey:@"Type"];
            cell.lOptTimeLine.hidden=YES;
            cell.starRating.hidden=(_SetupData.SampRating==0)?YES:NO;
            cell.btnInfo.hidden=YES;
            int val=[[optLst objectForKey:@"Rating"] intValue];
            [cell.starRating setRatingValue:val];
            
            NSMutableDictionary *TimeLine=[[NSMutableDictionary alloc] init];
            TimeLine=[optLst objectForKey:@"Timesline"];
            
            cell.lOptTimeLine.text=[NSString stringWithFormat:@"%@ %@",[BaseViewController  str2Format:[TimeLine objectForKey:@"sTm"] withFormat:@"HH:mm:ss"],[BaseViewController  str2Format:[TimeLine objectForKey:@"eTm"] withFormat:@"HH:mm:ss"]];
            cell.txtRxQty.text=[optLst objectForKey:@"RxQty"];
            cell.txtSmpQty.text=[optLst objectForKey:@"SmpQty"];
            [cell.txtRxQty addTarget:self action:@selector(txtRxDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.txtSmpQty addTarget:self action:@selector(txtSampDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.btnInfo addTarget:self action:@selector(ViewProdFeedback:) forControlEvents:UIControlEventTouchUpInside];
            
            if([sGroup isEqualToString:@"D"]){
                cell.lOptTimeLine.hidden=NO;
                cell.starRating.hidden=NO;
                cell.btnInfo.hidden=NO;
                cell.btnDel.enabled=NO;
            }
            cell.delegate=self;
        }
        if(tableView==self.tvInputList || tableView==self.tvAdInputList){[cell.txtInpQty addTarget:self action:@selector(txtIQtyDidChange:) forControlEvents:UIControlEventEditingChanged];}
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TBSelectionBxCell* cell;
    
    if(tableView==self.tvOptList) {
        cell =[tableView cellForRowAtIndexPath:indexPath];
        
        NSMutableDictionary *item ;
        if(self.searchBox.tag==4){
            item= [[[self.objOptList[indexPath.section] valueForKey:@"Vals"] objectAtIndex:indexPath.row] mutableCopy];
            
        }else {
            item= [[self.objOptList objectAtIndex:indexPath.row] mutableCopy];
        }
        NSMutableArray *Selitem = [[self.SelOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [item objectForKey:@"Code"]]] mutableCopy];
        
        if (Selitem.count<=0){
            NSMutableDictionary *selItem =[[NSMutableDictionary alloc] init];
            [selItem setValue:[item objectForKey:@"Code"] forKey:@"Code"];
            [selItem setValue:[item objectForKey:@"Name"] forKey:@"Name"];
            if(self.searchBox.tag==1 || self.searchBox.tag==11)
            {
                [selItem setValue:[item objectForKey:@"NoofSamples"] forKey:@"NoofSamples"];
                [selItem setValue:[item objectForKey:@"cateid"] forKey:@"cateid"];
                
            }
            if(self.searchBox.tag==2 || self.searchBox.tag==12)
            {
                int IQty=[[item objectForKey:@"IQty"] intValue];
                if(IQty==0) IQty=1;
                [selItem setValue:[NSNumber numberWithInt:IQty] forKey:@"IQty"];
            }
            if(self.searchBox.tag==3)
            {
                [selItem setValue:[item objectForKey:@"Town_Code"] forKey:@"TCode"];
                [selItem setValue:[item objectForKey:@"Town_Name"] forKey:@"TName"];
            }
            [self.SelOptList addObject:selItem];
            
            [cell.btnCheked setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            cell.Checked=YES;
       }
        else{
            [self.SelOptList removeObject:Selitem[0]];
            [cell.btnCheked setImage:nil forState:UIControlStateNormal];
            cell.Checked=NO;

        }
    }
    else if(tableView==self.tvDepts) {
        
        [self.btnDept setTitle:[NSString stringWithFormat:@"  %@",[self.SelDepartsList[indexPath.row] valueForKey:@"Name"]] forState:UIControlStateNormal];
        self.DeptCode=[NSString stringWithFormat:@"%@",[self.SelDepartsList[indexPath.row] valueForKey:@"Code"] ];
        self.DeptName=[self.SelDepartsList[indexPath.row] valueForKey:@"Name"];
        
        [self CloseDeptSel];
    }
    else if(tableView==self.tvFeedBk||tableView==self.tvFeedBk1) {
        _txtRatingFeed.text=[self.FeedBkList[indexPath.row] valueForKey:@"Name"];
        _txtRatingFeed1.text=[self.FeedBkList[indexPath.row] valueForKey:@"Name"];
        if(_AdrDetsWin.tag>-1){
            [self.AdSelProductList[self.tvFeedBk.tag] setValue:_txtRatingFeed.text forKey:@"ProdFeedbk"];
        }else{
            [self.SelProductList[self.tvFeedBk.tag] setValue:_txtRatingFeed.text forKey:@"ProdFeedbk"];
            
        }
       /* [self.btnfeedbk setTitle:self.FeedBkList[indexPath.row] forState:UIControlStateNormal];
        NSString *clrStr=(indexPath.row==0)?@"#D62932":(indexPath.row==1)?@"#C8AB00":@"#077018";
        UIColor *color = [[[CVColor alloc] init] getUIColorObjectFromHexString:clrStr alpha:1];
        [self.btnfeedbk setTitleColor:color forState:UIControlStateNormal];*/
        self.wFeedOpt.hidden=YES;
        self.wFeedOpt1.hidden=YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
 //   [super textViewDidEndEditing:textView];
    [textView resignFirstResponder];
    if(textView.tag>2000){
        if(_AdrDetsWin.tag>-1){
            [self.AdSelProductList[self.tvFeedBk.tag] setValue:textView.text forKey:@"ProdFeedbk"];
        }else{
            [self.SelProductList[self.tvFeedBk.tag] setValue:textView.text forKey:@"ProdFeedbk"];
        }
    }else{
        [self.ProdSlides[textView.tag] setValue:textView.text forKey:@"SlideRem"];
    }
}

-(void)txtRxDidChange :(UITextField *)txtRxField{
    
    UITableViewCell *Icell=[self getTableViewCell:txtRxField];
    UITableView *tbView=[self getTableView:txtRxField];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    [self.SelProductList[indexPath.row] setValue:txtRxField.text forKey:@"RxQty"];
}

-(void)txtSampDidChange :(UITextField *)txtSampField{
    UITableViewCell *Icell=[self getTableViewCell:txtSampField];
    UITableView *tbView=[self getTableView:txtSampField];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    NSInteger MaxSamp=0;

    BOOL stringIsValid = [self validateNumber:txtSampField.text];
    if(!stringIsValid)
        txtSampField.text = [txtSampField.text substringToIndex:[txtSampField.text length] - 1];
    
    if(_AdrDetsWin.tag>-1){
        MaxSamp=[[_AdSelProductList[indexPath.row] valueForKey:@"NoofSamples"] integerValue];
    }else{
        MaxSamp=[[_SelProductList[indexPath.row] valueForKey:@"NoofSamples"] integerValue];
    }
    NSInteger SampQty=[txtSampField.text integerValue];
    if([_meetData.CallType isEqualToString:@"2"]){
        [BaseViewController Toast:[NSString stringWithFormat:NSLocalizedString(@"Can't Enter Samples", @"Can't Enter Samples")]];
        txtSampField.text=@"";
        // return;
    }
    if(SampQty>MaxSamp && MaxSamp>0){
        [BaseViewController Toast:[NSString stringWithFormat:@"%@ %li",NSLocalizedString(@"Sample Qty Exceed. Can Enter Maximum", @"Sample Qty Exceed. Can Enter Maximum"),(long)MaxSamp] ];
        txtSampField.text=@"";
       // return;
    }
    if(_AdrDetsWin.tag>-1){
        [_AdSelProductList[indexPath.row] setValue:txtSampField.text forKey:@"SmpQty"];
    }else{
        [self.SelProductList[indexPath.row] setValue:txtSampField.text forKey:@"SmpQty"];
    }
}

-(void)txtIQtyDidChange :(UITextField *)txtIQtyField{
    
    BOOL stringIsValid = [self validateNumber:txtIQtyField.text];
    if(!stringIsValid)
        txtIQtyField.text = [txtIQtyField.text substringToIndex:[txtIQtyField.text length] - 1];
    
    UITableViewCell *Icell=[self getTableViewCell:txtIQtyField];
    UITableView *tbView=[self getTableView:txtIQtyField];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    [self.SelInputList[indexPath.row] setValue:txtIQtyField.text forKey:@"IQty"];
}

-(BOOL)validateNumber:(NSString *)text
{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:text];
    return [numbersOnly isSupersetOfSet:characterSetFromTextField];
}


-(void) didSetRating:(StarRatingView *)starRating andIndexPath:(NSIndexPath *)indexPath andUserEvent:(BOOL) userEvent{
    UITableView *tableView=[self getTableView:starRating];
    if(tableView==self.tvProdFeedBk){
        [self.ProdSlides[indexPath.row] setValue:[NSNumber numberWithInt:starRating.Value] forKey:@"SlideRating"];
    }else if(tableView==self.tvProdList || tableView==self.tvAdProdList){
        int pSRVal=-1;
        if(_AdrDetsWin.tag>-1){
            pSRVal=[[self.AdSelProductList[indexPath.row]  objectForKey:@"Rating"] intValue];
        }else{
            pSRVal=[[self.SelProductList[indexPath.row]  objectForKey:@"Rating"] intValue];
        }
        int srVal=starRating.Value;
        if(srVal>_SetupData.MaxStarRate) srVal=_SetupData.MaxStarRate;
        
        if(_AdrDetsWin.tag>-1){
            [self.AdSelProductList[indexPath.row] setValue:[NSNumber numberWithInt:srVal] forKey:@"Rating"];
        }else{
            [self.SelProductList[indexPath.row] setValue:[NSNumber numberWithInt:srVal] forKey:@"Rating"];
        }
        if(_SetupData.OnlyBRtFeed ==1 && starRating.Value>0){
            if(pSRVal!=srVal) {
                _txtRatingFeed1.text=@"";
                if(_AdrDetsWin.tag>-1){
                    [self.AdSelProductList[indexPath.row] setValue:@"" forKey:@"ProdFeedbk"];
                }else{
                    [self.SelProductList[indexPath.row] setValue:@"" forKey:@"ProdFeedbk"];
                }
            }
            NSMutableDictionary *item=nil;
            if(_AdrDetsWin.tag>-1){
                item=self.AdSelProductList[indexPath.row];
            }else{
                item=self.SelProductList[indexPath.row];
            }
            self.FeedBkList= [[self.RatingFeedbks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"BCode==%@ and RCode==%@", [item objectForKey:@"Code"],[item objectForKey:@"Rating"]]] mutableCopy];
            if([self.FeedBkList count]<=0){
                self.FeedBkList= [[self.RatingFeedbks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"BCode==%@ and RCode==%@", [item objectForKey:@"cateid"],[item objectForKey:@"Rating"]]] mutableCopy];
            }
                
            [self.tvFeedBk1 reloadData];
            self.lblProduct1.text= [item valueForKey:@"Name"];
            _txtRatingFeed.text= [item valueForKey:@"ProdFeedbk"];
            _txtRatingFeed1.text= [item valueForKey:@"ProdFeedbk"];
            [self.SRProdFeedbk setRatingValue:starRating.Value];
            if(userEvent==true)
            {
                self.vfProdFeed1.alpha=1;
                self.vfProdFeed1.hidden=NO;
                self.txtRatingFeed.tag=2001;
                self.txtRatingFeed1.tag=2001;
                self.tvFeedBk.tag=indexPath.row;
                self.txtRatingFeed.delegate=self;
                self.txtRatingFeed1.delegate=self;
            }
            
            
        }
    }
}

-(IBAction) ShowFeedOpt:(id)sender{
    self.wFeedOpt.hidden=NO;
    self.wFeedOpt1.hidden=NO;
}
-(IBAction) ViewProdFeedback:(id)sender{
    
    UITableViewCell *Icell=[self getTableViewCell:sender];
    UITableView *tbView=[self getTableView:Icell];
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    
    NSMutableDictionary *item=self.SelProductList[indexPath.row];
    self.lblProduct.text= [item valueForKey:@"Name"];
    self.lblGroup.text= [NSString stringWithFormat:@"Group %@",[item valueForKey:@"Group"]];
    _txtRatingFeed.text= [item valueForKey:@"ProdFeedbk"];
    _txtRatingFeed1.text= [item valueForKey:@"ProdFeedbk"];
    self.ProdSlides= [[[self.meetData.Products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [item objectForKey:@"Code"]]][0] valueForKey:@"Slides" ] mutableCopy];
    
    self.FeedBkList= [[self.RatingFeedbks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"BCode==%@ and RCode==%@", [item objectForKey:@"Code"],[item objectForKey:@"Rating"]]] mutableCopy];
    
    [self.tvProdFeedBk reloadData];
    self.txtRatingFeed.tag=2001;
    self.txtRatingFeed1.tag=2001;
    self.tvFeedBk.tag=indexPath.row;
    self.txtRatingFeed.delegate=self;
    self.txtRatingFeed1.delegate=self;
    [self.tvFeedBk reloadData];
    [self ShowProdFeedback];
}

-(void) setSRatingValue:(StarRatingView *)sender{
    NSLog(@"Start Rate:%d",sender.Value);
}
-(IBAction)DeleteRow:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSMutableArray* tmpArr=[[NSMutableArray alloc]init];
    UITableView *TBView;
    
    NSInteger tbvId=btn.titleLabel.tag;
    if(tbvId==1){ tmpArr=[self.SelProductList mutableCopy];TBView=self.tvProdList; }
    if(tbvId==2){ tmpArr=[self.SelInputList mutableCopy];TBView=self.tvInputList; }
    if(tbvId==3){ tmpArr=[self.SelAdCustList mutableCopy];TBView=self.tvAdCusList; }
    if(tbvId==4){ tmpArr=[self.SelJWList mutableCopy];TBView=self.tvJWList; }
    if(tbvId==5){ tmpArr=[self.SelDepartsList mutableCopy];TBView=self.tvDepts; }
    [tmpArr removeObjectAtIndex:btn.tag];
    if(tbvId==1) self.SelProductList=tmpArr;
    if(tbvId==2) self.SelInputList=tmpArr;
    if(tbvId==3) self.SelAdCustList=tmpArr;
    if(tbvId==4) self.SelJWList=tmpArr;
    if(tbvId==5) self.SelDepartsList=tmpArr;
    [TBView reloadData];
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


-(IBAction) setSelOptsValues:(id)sender{
    if(self.searchBox.tag==1)
    {
        self.SelProductList=[self.SelOptList mutableCopy];
        [_tvProdList reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==2)
    {
        self.SelInputList=[self.SelOptList mutableCopy];
        [_tvInputList reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==3)
    {
        self.SelAdCustList=[self.SelOptList mutableCopy];
        [_tvAdCusList reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==4)
    {
        self.SelJWList=[self.SelOptList mutableCopy];
        [_tvJWList reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==5)
    {
        self.SelDepartsList=[self.SelOptList mutableCopy];
        [_tvDepts reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==11)
    {
        
        self.AdSelProductList=[self.SelOptList mutableCopy];
        [_tvAdProdList reloadData];
        [self closeSelection];
    }
    if(self.searchBox.tag==12)
    {
        self.AdSelInputList=[self.SelOptList mutableCopy];
        [_tvAdInputList reloadData];
        [self closeSelection];
    }
}
-(IBAction) saveCallMeet:(id)sender{
    if([self.meetData.CusType isEqual:@"1"] && [self.UserDet.Desig isEqualToString:@"MR"]){
        if([_SelProductList count]<1){
            [BaseViewController Toast:NSLocalizedString(@"Select the Product", @"Select the Product")];
            return;
        }
        for (int il=0; il<[_SelProductList count]; il++) {
            NSInteger MaxSamp=[[_SelProductList[il] valueForKey:@"NoofSamples"] integerValue];
            NSInteger SampQty=[[_SelProductList[il] valueForKey:@"SmpQty"] integerValue];
            NSInteger Rating=[[_SelProductList[il] valueForKey:@"Rating"] integerValue];

            if([_SelProductList[il] valueForKey:@"SmpQty"]== nil   && _SetupData.SmplQtyMnd==1){
                [BaseViewController Toast:[NSString stringWithFormat:@"%@ ",NSLocalizedString(@"Enter the Sample Qty", @"Enter the Sample Qty")] ];
                return;
            }
            if(SampQty>MaxSamp && MaxSamp>0){
                [BaseViewController Toast:[NSString stringWithFormat:@"%@ %li",NSLocalizedString(@"Sample Qty Exceed. Can Enter Maximum", @"Sample Qty Exceed. Can Enter Maximum"),(long)MaxSamp] ];
                return;
            }
            if(_SetupData.OnlyBRtFeed==1 && Rating<=0){
                [BaseViewController Toast:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Rating Must be given", @"Rating Must be given")] ];
                return;
                
            }
        }
        if([_SelInputList count]<1 && _SetupData.inputMandate ==1){
            [BaseViewController Toast:NSLocalizedString(@"Select the Input", @"Select the Input")];
            return;
        }
        if([_meetData.RCPAEntry count]<1 && _SetupData.RCPAMandate ==1){
            [BaseViewController Toast:NSLocalizedString(@"RCPA Details Missing", @"RCPA Details Missing")];
            [self openRCPAEntry:self];
            return;
        }
    }
    [self SaveCallMeetDet:0];
}
-(void) SaveCallMeetDet:(int) Mode{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Submitting Status", @"Submitting Please Wait...")];
    NSMutableDictionary *imgData=nil;
    NSData *imageData = UIImagePNGRepresentation(self.signatureView.mySignatureImage.image);
    
    if(self.signatureView.mySignatureImage.image!=nil){
        _meetData.signName=[NSString stringWithFormat:@"sign%@%@",[_meetData.CustCode stringByReplacingOccurrencesOfString:@"/" withString:@""],[[BaseViewController date2str:[NSDate date] onlyDate:true] stringByReplacingOccurrencesOfString:@"-" withString:@""]] ;
        [self.signatureView saveSignature:_meetData.signName];
        _meetData.signName=[NSString stringWithFormat:@"%@.png",_meetData.signName];
        imgData=[[NSMutableDictionary alloc] init];
        [imgData setObject:imageData forKey:@"Image"];
        [imgData setValue:@"SignImg" forKey:@"Key"];
        [imgData setValue:_meetData.signName forKey:@"Filename"];
        //[WBService uplodeImages:imageData];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Scribbles"];
    
    for (int il=0; il<[_meetData.Products count]; il++) {
        NSMutableArray* Slides=[_meetData.Products[il] objectForKey:@"Slides"];
        for (int jl=0; jl<[Slides count]; jl++) {
            NSMutableArray* Scribbles=[Slides[jl] objectForKey:@"Scribbles"];
            for (int kl=0; kl<[Scribbles count]; kl++) {
                NSLog(@"%@",[Scribbles[kl] valueForKey:@"ScribbleName"]);
                
                NSString *fileName = [filePath stringByAppendingPathComponent:
                                      [NSString stringWithFormat:@"%@", [Scribbles[kl] valueForKey:@"ScribbleName"]]];
                NSData *ScribData =[NSData dataWithContentsOfFile:fileName];
                imgData=[[NSMutableDictionary alloc] init];
                [imgData setObject:ScribData forKey:@"Image"];
                [imgData setValue:@"ScribbleImg" forKey:@"Key"];
                [imgData setValue:[Scribbles[kl] valueForKey:@"ScribbleName"] forKey:@"Filename"];
                [WBService uplodeScribbleImages:[imgData mutableCopy]];
            }
        }
    }
    self.SubmittedCallList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmittedCalls.SANAPP"] mutableCopy];
    if (_SubmittedCallList== nil) self.SubmittedCallList=[[NSMutableArray alloc]init];
    NSString* WrkNm=@"F";
    NSDictionary* wrk =[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FWFlg ='F'", WrkNm]] mutableCopy];
    _meetData.Pl=@"DDet";
    _meetData.WT=[[wrk valueForKey:@"Code"][0] mutableCopy];
    _meetData.WTNm=[[wrk valueForKey:@"Name"][0] mutableCopy];;
    _meetData.SF=_UserDet.SF;
    _meetData.SFName=_UserDet.SFName;
    _meetData.DivCode=_UserDet.DivCode;
    _meetData.Products=[self.SelProductList mutableCopy];
    _meetData.Inputs=[self.SelInputList mutableCopy];
    _meetData.AdCuss=[self.SelAdCustList mutableCopy];
    _meetData.JWWrk=[self.SelJWList mutableCopy];
    _meetData.Remks=self.txtRem.text;
    _meetData.mode=[NSString stringWithFormat:@"%i", Mode];
    LocationDetail *locationData=[LocationDetail sharedLocationData];
    _meetData.Entry_location=[NSString stringWithFormat:@"%@:%@",locationData.latitude,locationData.longitude];
    NSArray* lPCalls=[[_SubmittedCallList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode=%@ and vstTime=%@ and CusType=%@",_meetData.CustCode,_meetData.vstTime,_meetData.CusType]] mutableCopy];
    
    if([lPCalls count]>0){
        [_SubmittedCallList removeObjectAtIndex:[_SubmittedCallList indexOfObject:lPCalls[0]]];
        [WBService saveArrayData:self.SubmittedCallList forKey:@"SubmittedCalls.SANAPP"];
    }
    [WBService SendServerRequest:@"SAVE/Call" withParameter:[[_meetData toNSDictionary] mutableCopy] withImages:[imgData mutableCopy]
    DataSF:nil
    completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         NSString *sMsg=[NSString stringWithFormat:@"%@",[receivedDta valueForKey:@"Msg"]];
         // bool Success=[[receivedDta valueForKey:@"vualt"] boolValue];
         if(Success==YES){
             NSString *CustCode=self.meetData.CustCode;
             [WBService SendServerRequest:@"GET/CusLVst" withParameter:[@{@"CusCode":CustCode,@"typ":@"D"} mutableCopy] withImages:nil DataSF:nil
               completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                     NSMutableArray *VstData=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
                     [WBService saveData:VstData forKey:[NSString stringWithFormat:@"CLVst_Cus%@D.SANAPP",CustCode]];
                    
                   }
                   error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
                       NSLog(@"%@",errorMsg);
                   }
             ];
             [BaseViewController Toast:NSLocalizedString(@"Call Submitted Successfully", @"Call Submitted Successfully")];
             [self ClearandCloseView];
         }
         else{
             [BaseViewController Toast:[NSString stringWithFormat:@"%@. %@",NSLocalizedString(@"Offline Calls are saved Locally", @"Offline Calls are saved Locally"),sMsg]];
             if([sMsg isEqualToString:@""] || receivedDta==nil){
                 [uData setValue:[NSNumber numberWithBool:NO] forKey:@"Drft"];
                 [uData setValue:[NSNumber numberWithBool:NO] forKey:@"Synced"];
                 [self.SubmittedCallList addObject:[uData mutableCopy]];
                 [WBService saveArrayData:self.SubmittedCallList forKey:@"SubmittedCalls.SANAPP"];
                 [self ClearandCloseView];
             }
         }
         [SVProgressHUD dismiss];
     }
                           error:^(NSString *errorMsg,NSMutableDictionary *uData){
                               [uData setValue:[NSNumber numberWithBool:NO] forKey:@"Drft"];
                               [self.SubmittedCallList addObject:[uData mutableCopy]];
                               [WBService saveArrayData:self.SubmittedCallList forKey:@"SubmittedCalls.SANAPP"];
                               
                               [BaseViewController Toast:[NSString stringWithFormat:@"%@.\n %@",NSLocalizedString(@"Offline Calls are saved Locally", @"Offline Calls are saved Locally"),errorMsg.description]];
                               [SVProgressHUD dismiss];
                               [self ClearandCloseView];
                           }];
}
-(void) ClearandCloseView{
    [self.meetData clearCallMeet];
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}
-(IBAction) showRatingInfo:(id)sender {
    UIButton* btn=(UIButton *) sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RatingInfoController *popVC = [storyboard instantiateViewControllerWithIdentifier:@"RatingInfCtrl"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:popVC animated:YES completion:nil];
    }
    else {
        popVC.modalPresentationStyle = UIModalPresentationPopover;
        //popVC.preferredContentSize = CGSizeMake(120,90);
        UIPopoverPresentationController *popController = [popVC popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        popController.delegate = self;
        popController.sourceView = btn;
        popController.sourceRect = btn.bounds;
        
        [self presentViewController:popVC animated:YES completion:nil];
    }
    
    
}
-(IBAction)hideSelection:(id)sender{
    [self closeSelection];
}

-(IBAction)hideProdFeedback:(id)sender{
    [self closeProdFeedback];
}
-(void)ShowProdFeedback{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         
                         self.VfProdFeedTop.constant=0;
                         self.VfProdFeedBottom.constant=0;
                         self.vfProdFeed.alpha=1;
                         self.vfProdFeed.hidden=NO;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}
-(IBAction) closePFeedbkMndt:(id)sender{
    if([_txtRatingFeed1.text isEqualToString:@""]){
        [BaseViewController Toast:NSLocalizedString(@"Select / Enter the Feedback", @"Select / Enter the Feedback")];
        return;
    }
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.vfProdFeed1.alpha=0;
                         self.vfProdFeed1.hidden=YES;
                     }
                     completion:^(BOOL finished) {   }];
}
-(void) closeProdFeedback{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.VfProdFeedTop.constant=self.vfProdFeed.frame.size.height;
                         [self.view layoutIfNeeded];
                         
                         self.VfProdFeedBottom.constant=-self.vfProdFeed.frame.size.height;
                         [self.view layoutIfNeeded];
                         self.vfProdFeed.alpha=0;
                         self.vfProdFeed.hidden=YES;
                     }
                     completion:^(BOOL finished) {   }];
}
-(void)ShowSelection:(NSString*)sTitle{
    
    //[_tvOptList setEditing:YES animated:YES];
    
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
    if(self.searchBox.tag==2) self.objOptList=[self.InputList mutableCopy];
    if(self.searchBox.tag==3) self.objOptList=[self.CustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Not Code == %@", self.meetData.CustCode]];//[self.CustomerList mutableCopy];
    if(self.searchBox.tag==4) self.objOptList=[self.JWGrpOptList mutableCopy];
    
    if([self.searchBox.text isEqualToString:@""]==NO){
        if(self.searchBox.tag==4){
            [self.objOptList[0] setObject:[[self.objOptList[0] objectForKey:@"Vals"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]] forKey:@"Vals"];
            [self.objOptList[1] setObject:[[self.objOptList[1] objectForKey:@"Vals"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]] forKey:@"Vals"];
        }else{
            self.objOptList = [self.objOptList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.searchBox.text]];
        }
    }
    [self.tvOptList reloadData];
}
-(IBAction)OpenProduct:(id)sender{
    UIButton* btn=(UIButton*) sender;
    
    self.objOptList=[self.ProductList mutableCopy];
    if(btn.tag==1){
        self.searchBox.tag=11;
        self.SelOptList=[self.AdSelProductList mutableCopy];
    }
    else{
        self.searchBox.tag=1;
        self.SelOptList=[self.SelProductList mutableCopy];
    }
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Products Selection",@"Products Selection")];
}
-(IBAction)OpenInput:(id)sender{
    UIButton* btn=(UIButton*) sender;
    
    self.objOptList=[self.InputList mutableCopy];
    if(btn.tag==1){
        self.searchBox.tag=12;
        self.SelOptList=[self.AdSelInputList mutableCopy];
    }
    else{
        self.searchBox.tag=2;
        self.SelOptList=[self.SelInputList mutableCopy];
    }
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Inputs Selection",@"Inputs Selection")];
}
-(IBAction)CloseProdFeed:(id)sender{
    self.wFeedOpt.hidden=YES;
    self.wFeedOpt1.hidden=YES;
}
-(IBAction)OpenAdDoctor:(id)sender{
    self.searchBox.tag=3;
    
    self.objOptList = [self.CustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Not Code == %@", self.meetData.CustCode]];
    self.SelOptList=[self.SelAdCustList mutableCopy];
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Additional Doctor Selection",@"Additional Doctor Selection")];
}
-(IBAction)OpenJointWork:(id)sender{
    self.searchBox.tag=4;
    
    self.objOptList=[self.JWGrpOptList mutableCopy];
    self.SelOptList=[self.SelJWList mutableCopy];
    [self.tvOptList reloadData];
    [self ShowSelection:NSLocalizedString(@"Joint Work Selection",@"Joint Work Selection")];
}
-(IBAction)showAdrDetails:(id)sender{
    UITableViewCell *Icell=[self getTableViewCell:sender];
    UITableView *tbView=[self getTableView:sender];
    
    NSIndexPath *indexPath = [tbView indexPathForCell:Icell];
    self.AdrDetsWin.tag=indexPath.row;
    
    self.AdSelProductList= [[self.SelAdCustList[self.AdrDetsWin.tag] objectForKey:@"AdProds"] mutableCopy];
    if(self.AdSelProductList ==nil){
        self.AdSelProductList =[[NSMutableArray alloc]init];
        for(int il=0;il<[self.DefProductList count];il++){
            [self.AdSelProductList addObject:[self.DefProductList[il] mutableCopy]];
        }
    }
    
    self.AdSelInputList= [[self.SelAdCustList[self.AdrDetsWin.tag] objectForKey:@"AdInput"] mutableCopy];
    if(self.AdSelInputList==nil){
        self.AdSelInputList =[[NSArray alloc]init];
    }
    [self.tvAdProdList reloadData];
    [self.tvAdInputList reloadData];
    self.AdrDetsWin.hidden=NO;
}

-(IBAction)closeAdrDetails:(id)sender{
    [self closeAdrDetsWin];
}
-(void)closeAdrDetsWin{
    self.AdrDetsWin.tag=-1;
    self.AdrDetsWin.hidden=YES;
}
-(IBAction)svAdDrPDet:(id)sender{
    
    [self.SelAdCustList[self.AdrDetsWin.tag] setObject:[self.AdSelProductList mutableCopy] forKey:@"AdProds"];
    [self.SelAdCustList[self.AdrDetsWin.tag] setObject:[self.AdSelInputList mutableCopy] forKey:@"AdInput"];
    [self closeAdrDetsWin];
}
-(IBAction)OpenQueryWin:(id)sender{
    self.vwQuryWin.alpha=0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         
                         self.vwQuryWin.hidden=NO;
                         self.vwQuryWin.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}
-(IBAction) SendQuery:(id)sender{
    NSMutableDictionary* QryData=[[NSMutableDictionary alloc] init];
    [QryData setValue:self.meetData.CustCode forKey:@"DrCode"];
    [QryData setValue:self.meetData.CustName forKey:@"DrName"];
    [QryData setValue:self.DeptCode forKey:@"DeptCode"];
    [QryData setValue:self.DeptName forKey:@"DeptName"];
    [QryData setValue:self.txtQuery.text forKey:@"QryMsg"];
    [QryData setValue:[BaseViewController date2str:[NSDate date] onlyDate:false] forKey:@"QryDt"];
    [WBService SendServerRequest:@"SAVE/DrQuery" withParameter:[QryData mutableCopy] withImages:nil
                          DataSF:nil
                      completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
         bool Success=[[receivedDta valueForKey:@"success"] boolValue];
         if(Success==YES){
             [BaseViewController Toast:NSLocalizedString(@"Query Sent Successfully", @"Query Sent Successfully")];
         }
         else{
             [BaseViewController Toast:NSLocalizedString(@"Query Sending Failed", @"Query Sending Failed")];
             [uData setValue:[NSNumber numberWithBool:NO] forKey:@"Synced"];
             
         }
         [SVProgressHUD dismiss];
     }
       error:^(NSString *errorMsg,NSMutableDictionary *uData){
           [BaseViewController Toast:[NSString stringWithFormat:@"%@.\n %@",NSLocalizedString(@"Query Sending Failed", @"Query Sending Failed"),errorMsg.description]];
           [SVProgressHUD dismiss];
       }];
}
-(IBAction) CloseQueryWin:(id)sender{
    [self winCloseQuery];
}
-(void) winCloseQuery
{
    self.vwQuryWin.alpha=1;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         
                         self.vwQuryWin.hidden=YES;                         self.vwQuryWin.alpha=0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}
-(IBAction)OpenDeptSel:(id)sender{
    if(self.tvDepts.hidden==YES){
        self.tvDepts.alpha=0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         
                         self.tvDepts.hidden=NO;
                         self.tvDepts.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
    }else{
        [self CloseDeptSel];
    }
}
-(void)CloseDeptSel{
    self.tvDepts.alpha=1;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                         self.tvDepts.hidden=YES;
                         self.tvDepts.alpha=0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}

-(IBAction)CancelCallMeet:(id)sender{
    NSLog(@"%@", [_meetData toNSDictionary]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SAN Digital Detailing"
                                                        message:NSLocalizedString(@"Do you want Cancel this call without Submit Call",@"Do you want Cancel this call without Submit Call")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                              otherButtonTitles:NSLocalizedString(@"Save Draft",@"Save Draft"),NSLocalizedString(@"Ok",@"Ok"), nil];
    
    [alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2)
    {
        [self ClearandCloseView];
    }

    if(buttonIndex == 1)
    {
        NSMutableDictionary *imgData=nil;
        NSData *imageData = UIImagePNGRepresentation(self.signatureView.mySignatureImage.image);
        
        if(self.signatureView.mySignatureImage.image!=nil){
            _meetData.signName=[NSString stringWithFormat:@"sign%@%@",[_meetData.CustCode stringByReplacingOccurrencesOfString:@"/" withString:@""],[[BaseViewController date2str:[NSDate date] onlyDate:true] stringByReplacingOccurrencesOfString:@"-" withString:@""]] ;
            [self.signatureView saveSignature:_meetData.signName];
            _meetData.signName=[NSString stringWithFormat:@"%@.png",_meetData.signName];
            imgData=[[NSMutableDictionary alloc] init];
            [imgData setObject:imageData forKey:@"Image"];
            [imgData setValue:@"SignImg" forKey:@"Key"];
            [imgData setValue:_meetData.signName forKey:@"Filename"];
            //[WBService uplodeImages:imageData];
        }
        self.SubmittedCallList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmittedCalls.SANAPP"] mutableCopy];
        if (_SubmittedCallList== nil) self.SubmittedCallList=[[NSMutableArray alloc]init];
        NSString* WrkNm=@"F";
        NSDictionary* wrk =[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FWFlg ='F'", WrkNm]] mutableCopy];
        _meetData.Pl=@"DDet";
        _meetData.WT=[[wrk valueForKey:@"Code"][0] mutableCopy];
        _meetData.WTNm=[[wrk valueForKey:@"Name"][0] mutableCopy];;
        _meetData.SF=_UserDet.SF;
        _meetData.SFName=_UserDet.SFName;
        _meetData.DivCode=_UserDet.DivCode;
        _meetData.Products=[self.SelProductList mutableCopy];
        _meetData.Inputs=[self.SelInputList mutableCopy];
        _meetData.AdCuss=[self.SelAdCustList mutableCopy];
        _meetData.JWWrk=[self.SelJWList mutableCopy];
        _meetData.Remks=self.txtRem.text;
        LocationDetail *locationData=[LocationDetail sharedLocationData];
        _meetData.Entry_location=[NSString stringWithFormat:@"%@:%@",locationData.latitude,locationData.longitude];
        NSMutableDictionary *uData=[[_meetData toNSDictionary] mutableCopy];
        NSArray* lPCalls=[[_SubmittedCallList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CustCode=%@ and vstTime=%@ and CusType=%@",[uData objectForKey:@"CustCode"],[uData objectForKey:@"vstTime"],[uData objectForKey:@"CusType"]]] mutableCopy];
        
        if([lPCalls count]>0){
            [_SubmittedCallList removeObjectAtIndex:[_SubmittedCallList indexOfObject:lPCalls[0]]];
        }
        [uData setValue:[NSNumber numberWithBool:YES] forKey:@"Drft"];
        [uData setValue:[NSNumber numberWithBool:NO] forKey:@"Synced"];
        if (imgData!=nil){
            [uData setObject:imgData forKey:@"uImages"];
        }
        [self.SubmittedCallList addObject:[uData mutableCopy]];
        [WBService saveArrayData:self.SubmittedCallList forKey:@"SubmittedCalls.SANAPP"];
        //[self SaveCallMeetDet:1];
        [self ClearandCloseView];
    }
}
-(IBAction)backToCusSelection:(id)sender{
    CallMeetData *meetData=_MissedEntry.MissDatas[_MissedEntry.SelectedIndex];
    NSString* WrkNm=@"F";
    NSDictionary* wrk =[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"WorktypeDetails.SANAPP"] mutableCopy] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FWFlg ='F'", WrkNm]] mutableCopy];
    meetData.Pl=@"DDet";
    meetData.WT=[[wrk valueForKey:@"Code"][0] mutableCopy];
    meetData.WTNm=[[wrk valueForKey:@"Name"][0] mutableCopy];;
    meetData.SF=_UserDet.SF;
    meetData.SFName=_UserDet.SFName;
    meetData.DivCode=_UserDet.DivCode;
    meetData.Products=[self.SelProductList mutableCopy];
    meetData.Inputs=[self.SelInputList mutableCopy];
    meetData.AdCuss=[self.SelAdCustList mutableCopy];
    meetData.JWWrk=[self.SelJWList mutableCopy];
    meetData.Remks=self.txtRem.text;

    [_MissedEntry.MissDatas replaceObjectAtIndex:_MissedEntry.SelectedIndex withObject:meetData];
    [self performSegueWithIdentifier:@"CusSelection" sender:self];
}
-(IBAction)ShowActivityEntry:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DynamicActivityCtrl *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ActivityCtrlr"];

    [currentViewController setEMode:[NSString stringWithFormat:@"%@,", _meetData.CusType]];
    currentViewController.modalPresentationStyle=UIModalPresentationFullScreen;
    
    [self presentViewController:currentViewController animated:YES completion:nil];
    
    //[self performSegueWithIdentifier:@"ActivityDetails" sender:self];
}
-(IBAction)openSurveyEntry:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RCPAEntryCtrlr *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SurveyEntry"];
    currentViewController.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:currentViewController animated:YES completion:nil];
}
-(IBAction)openRCPAEntry:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RCPAEntryCtrlr *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"RCPAEntry"];
    
    currentViewController.modalPresentationStyle=UIModalPresentationFullScreen;
    
    [self presentViewController:currentViewController animated:YES completion:nil];
    
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
-(void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _CtxtFld=NULL;
    if(self.txtRem.isFirstResponder) _CtxtFld=self.txtRem;
    if(self.txtQuery.isFirstResponder) _CtxtFld=self.txtQuery;
    if(self.txtRatingFeed.isFirstResponder) _CtxtFld=self.txtRatingFeed;
    if(self.txtRatingFeed1.isFirstResponder) _CtxtFld=self.txtRatingFeed1;
    
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ActivityDetails"]){
        DynamicActivityCtrl *ActivityCTRL=[segue destinationViewController];
        [ActivityCTRL setEMode:[NSString stringWithFormat:@"%@,", _meetData.CusType]];
    }
}

@end
