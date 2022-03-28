//
//  PresentationSelCtrl.m
//  SANAPP
//
//  Created by SANeForce.com on 13/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "PresentationSelCtrl.h"
#import "mSlideCell.h"
#import "filterCell.h"
#import "TBSelectionBxCell.h"
#import "PresentationViewCtrl.h"
#import "ImageScale.h"
@interface PresentationSelCtrl ()
@property (nonatomic,strong) NSMutableArray* AllGroupSlides;
@property (nonatomic,strong) NSArray* currSlideList;
@property (nonatomic,strong) NSMutableArray* SelProductList;
@property (nonatomic,strong) NSMutableArray* filterTypes;
@property (nonatomic,strong) NSArray* OrgAllSlides;//ProductsList
@property (nonatomic,strong) NSArray* OrgUniqueSlides;
@property (nonatomic,strong) NSMutableArray* AllSlides;//ProductsList
@property (nonatomic,strong) NSMutableArray* UniqueSlides;
@property (nonatomic,assign) NSInteger filterType;
@property (nonatomic,strong) NSMutableDictionary* selProduct;
@property (nonatomic,weak) NSString* fileType;
@property (nonatomic,strong) NSArray* SpecList;
@property (nonatomic,weak) NSString* selectedSpec;



@end

@implementation PresentationSelCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.meetData=[CallMeetData sharedDatas];
    self.SetupData=[AppSetupData sharedDatas];
    
    self.slideCollectionView.delegate = self;
    self.slideCollectionView.dataSource = self;
    
    self.specCollectionView.delegate = self;
    self.specCollectionView.dataSource = self;
    
    self.tvFilterType.delegate = self;
    self.tvFilterType.dataSource = self;
    self.tvProdList.delegate = self;
    self.tvProdList.dataSource = self;
    //@{@"id":@3,@"Name":@"Therapeutics"},
    self.filterTypes=[@[@{@"id":@1,@"Name":@"Brand Matrix"}, @{@"id":@2,@"Name":@"Specialitywise"}, @{@"id":@4,@"Name":@"All Brands"},@{@"id":@5,@"Name":@"Customize"}] mutableCopy];
    
    self.vwSpecFilter.layer.borderWidth=2.0;
    self.vwSpecFilter.layer.cornerRadius= 3.0;
    self.vwSpecFilter.clipsToBounds = YES;
    self.vwSpecFilter.layer.borderColor=[UIColor redColor].CGColor;

    self.btnFilterType.layer.cornerRadius=5.0f;
    
    self.AllGroupSlides=[[[NSUserDefaults standardUserDefaults] objectForKey:@"GroupSlides.SANAPP"]     mutableCopy];
    if(self.AllGroupSlides==nil) self.AllGroupSlides=[[[NSMutableArray alloc] init] mutableCopy];

    for(int i=0;i<[self.AllGroupSlides count];i++){
        NSDictionary *dic=_AllGroupSlides[i];
        NSMutableDictionary *flTyp=[[NSMutableDictionary alloc] init];
        [flTyp setValue:[dic valueForKey:@"GroupId"] forKey:@"id"];
        [flTyp setValue:[dic valueForKey:@"GroupName"] forKey:@"Name"];
        [self.filterTypes addObject:flTyp];
    }
    self.SpecList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Specialitys.SANAPP"] mutableCopy];

    self.OrgAllSlides =[[[NSUserDefaults standardUserDefaults] objectForKey:@"ProdSlides.SANAPP"] mutableCopy];
    self.UniqueSlides =[[[NSUserDefaults standardUserDefaults] objectForKey:@"UniqueProdSlides.SANAPP"] mutableCopy];
    if (self.SetupData.RatingBasedSlide==1){
        self.OrgAllSlides = [self getRatingSlides:[self.OrgAllSlides mutableCopy]];
    }
    //self.UniqueSlides = [self getRatingSlides:[self.UniqueSlides mutableCopy]]; //filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains[c] .stringValue", [NSString stringWithFormat:@"%@", _meetData.RatingSlideIds]]] mutableCopy];
    
    self.filterType=1;
    self.fileType=@"I";
    [self.btnFilterType setTitle:NSLocalizedString([_filterTypes[0] objectForKey:@"Name"],[_filterTypes[0] objectForKey:@"Name"]) forState:UIControlStateNormal];
    self.SelProductList = [self getFilteredSlides];
    self.currSlideList=[[NSArray alloc]init];
    if (self.SelProductList.count>0) {
        self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", [self.SelProductList[0] valueForKey:@"Code"]]] mutableCopy];
        /*NSString* sRtSlides=@"";
        if (self.SetupData.RatingBasedSlide==1){
            NSArray* aRtSlides=[_meetData.RatingSlide filteredArrayUsingPredicate:[NSPredicate  predicateWithFormat:@"Code == %@",[self.SelProductList[0] valueForKey:@"Code"]]];
            sRtSlides=[aRtSlides[0] valueForKey:@"Prods"];
            if(!([sRtSlides isEqualToString:@""] || [sRtSlides isEqualToString:@"0"]))
            {    self.currSlideList = [[self.currSlideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains[c] SlideNm", sRtSlides]] mutableCopy];
            }
        }*/
        self.selProduct=self.SelProductList[0];
        
        NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"OrdNo" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
        self.currSlideList = [[self.currSlideList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
    self.lblCusName.text=self.meetData.CustName;
    _btnStartDemo.hidden=NO;
    _btnStartDemoImg.hidden=NO;
    _btnSkipDetailing.hidden=NO;
    _UserDet=[UserDetails sharedUserDetails];
    if([_UserDet.Desig isEqualToString:@"MR"]){
        _btnSkipDetailing.hidden=YES;
    }
    _btnSaveSlideGrp.hidden=YES;
    if ([_ModeScr isEqual:@"Prepare"]){
        _btnStartDemo.hidden=YES;
        _btnStartDemoImg.hidden=YES;
        
        _btnSaveSlideGrp.hidden=NO;
    }
    [_btnSaveSlideGrp layoutIfNeeded];
}

- (NSMutableArray *) getRatingSlides:(NSMutableArray *) nSlides {
    if([_meetData.RatingSlideIds isEqualToString:@""]) return nSlides;
    NSMutableArray *resultArr=[[NSMutableArray alloc] init];
    for(int il=0;il<[nSlides count];il++){
        NSRange range =[[NSString stringWithFormat:@",%@,",_meetData.RatingSlideIds] rangeOfString:[NSString stringWithFormat:@",%@,",[nSlides[il] valueForKey:@"SlideId"]]];
        
        if (range.length > 0 )
        {
                NSMutableDictionary *dic=[nSlides[il] mutableCopy];
                
                [resultArr addObject:dic];
            
        }
    }
    return [resultArr mutableCopy];
}
-(NSMutableArray *)FilterArray:(NSMutableArray *) Array{
    
    NSMutableArray *result=[[NSMutableArray alloc] init];
    for(int il=0;il<[self.UniqueSlides count];il++){
        if(_filterType==1){
            NSString *pCode=[NSString stringWithFormat:@",%@-",[self.UniqueSlides[il] valueForKey:@"Code"]];
            if([[NSString stringWithFormat:@",%@",self.meetData.mappedProds] rangeOfString:pCode].length>0)
            {
                [result addObject:self.UniqueSlides[il]];
            }
        }
        if(_filterType==2){
            NSString *pCode=[NSString stringWithFormat:@",%@",[self.UniqueSlides[il] valueForKey:@"Speciality_Code"]];
            if([pCode rangeOfString:[NSString stringWithFormat:@",%@,",self.meetData.SpecCode]].length>0)
            {
                [result addObject:self.UniqueSlides[il]];
            }
        }
        if(_filterType==3){
            NSString *pCode=[NSString stringWithFormat:@",%@",[self.UniqueSlides[il] valueForKey:@"Category_Code"]];
            if([pCode rangeOfString:[NSString stringWithFormat:@",%@,",self.meetData.CateCode]].length>0)
            {
                [result addObject:self.UniqueSlides[il]];
            }
        }
    }

    return result;
}
- (NSMutableArray *) getFilteredSlides{
    
    self.AllSlides=[self.OrgAllSlides mutableCopy];
    NSMutableArray *resultArr=nil;
//    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors ;//= [NSArray arrayWithObjects:NameField, nil];
    if(_filterType<=3) resultArr = [[self FilterArray:self.UniqueSlides] mutableCopy];
    if(_filterType==1){
        NSArray *mpProds =[self.meetData.mappedProds componentsSeparatedByString:@","];
        
        for(int il=0;il<[mpProds count];il++){
            if (![mpProds[il] isEqual:@""])
            {
                NSArray *slnos =[mpProds[il] componentsSeparatedByString:@"-"];
                
                NSMutableArray* Aryf = [[resultArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code==%@", slnos[0]]] mutableCopy];
                if([Aryf count]>0){
                    int intd=[resultArr indexOfObject:Aryf[0]];
                    NSMutableDictionary *dic=[Aryf[0] mutableCopy];
                    [dic setObject:slnos[1] forKey:@"PCatTyp"];
                    
                    [resultArr replaceObjectAtIndex:intd withObject:dic];
                }
            }
        }
        
        NSSortDescriptor *CampField = [NSSortDescriptor sortDescriptorWithKey:@"Camp" ascending:YES];
        NSSortDescriptor *PTypField = [NSSortDescriptor sortDescriptorWithKey:@"PCatTyp" ascending:YES];
        sortDescriptors = [NSArray arrayWithObjects:CampField, PTypField, nil];
    }else if(_filterType>=4 && _filterType<=9){
        resultArr = [self.UniqueSlides mutableCopy];
    }
    else if(_filterType==2 && self.selectedSpec!=nil)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i<resultArr.count; i++) {
            NSArray *arrSecond = [[[resultArr objectAtIndex:i] objectForKey:@"Speciality_Code"] componentsSeparatedByString:@","];
            if([arrSecond containsObject:_selectedSpec])
            {
                [arr addObject:resultArr[i]];
            }
        }
        resultArr = arr;
    }
    else{
        if(self.filterType>9)
        {
            NSLog(@"%d",(int)self.filterType);
            
            NSMutableArray* dic=[[self.AllGroupSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"GroupId == %d", self.filterType]]mutableCopy];
            self.AllSlides=[dic[0] objectForKey:@"GroupSlides"];
            resultArr=[[[NSMutableArray alloc] init] mutableCopy];
//            NSArray *Ids=[_AllSlides valueForKeyPath:@"@distinctUnionOfObjects.Code"];
            NSMutableArray *arrData = [[NSMutableArray alloc] init];
            for (int i = 0; i<self.AllSlides.count; i++) {
                if(![arrData containsObject:[[self.AllSlides objectAtIndex:i] objectForKey:@"Code"]])
                {
                    [arrData addObject:[[self.AllSlides objectAtIndex:i] objectForKey:@"Code"]];
                }
            }
            
            for(int i=0; i<[arrData count];i++){
                NSMutableArray* dic = [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", arrData[i]]]mutableCopy];
                [resultArr  addObject:dic[0]];
            }
            
        }
    }
//    resultArr = [[resultArr sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    return resultArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) openFilterType:(id)sender{
    BOOL upState=!self.vwFilter.hidden;
    [self closeTableViews];
    
    self.vwFilter.hidden=upState;
    CGRect optionsFrame = self.vwFilter.frame;
    optionsFrame.size.height = 0;
    self.vwFilter.frame = optionsFrame;
    self.vwFilter.alpha=0.0;
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^{
        [self.view layoutIfNeeded];
        CGRect optionsFrame = self.vwFilter.frame;
        optionsFrame.size.height= 252;
        self.vwFilter.frame = optionsFrame;
        
        optionsFrame.origin.x= 0;
        optionsFrame.origin.y= 0;
        self.tvFilterType.frame = optionsFrame;
        
        self.vwFilter.alpha=1.0;
    } completion:^(BOOL finished){
    
    }
 
 ];
}

-(void) closeTableViews{
    self.vwFilter.hidden=YES;
}



-(IBAction)CancelPresentation:(id)sender
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}

- (IBAction)btnCloseFilter:(id)sender {
    [self callORdismissFilter];
}

- (IBAction)btnFilterSpec:(id)sender {
    
    [self.specCollectionView reloadData];
    [self callORdismissFilter];
}
-(void)callORdismissFilter
{
    if(self.cnstrntSpecFilterViewOrigin.constant == -200)
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.cnstrntSpecFilterViewOrigin.constant = - self.view.frame.size.height;
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
    [UIView animateWithDuration:1.0 animations:^{
        self.cnstrntSpecFilterViewOrigin.constant = -200;
        [self.view layoutIfNeeded];
    }];
    }
}
-(IBAction)dismissModalStack:(id)sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}
-(IBAction)startDemo:(id)sender
{
    if([self.currSlideList count]<1){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Digital Detailing"
                                                            message:@"Can't start Demo."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil, nil];
        
        //TODO if user has not given permission to device
        /*if (![CLLocationManager locationServicesEnabled])
        {
            alertView.tag = 100;
        }
        //TODO if user has not given permission to particular app
        else
        {
            alertView.tag = 200;
        }*/
        
        [alertView show];
    }
    else{
    [self performSegueWithIdentifier:@"startDemo" sender:self];
    }
}
-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl{
    
    if(SControl.selectedSegmentIndex == 0)self.fileType=@"I";
    if(SControl.selectedSegmentIndex == 1) self.fileType=@"V";
    if(SControl.selectedSegmentIndex == 2) self.fileType=@"P";
    if(SControl.selectedSegmentIndex == 3) self.fileType=@"H";
    
    self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp=%@", [self.selProduct valueForKey:@"Code"],self.fileType ]] mutableCopy];
    [self.slideCollectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _slideCollectionView)
    {
    return self.currSlideList.count;
    }
    else if (collectionView == _specCollectionView)
        return self.SpecList.count;
    else
        return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (cv == _slideCollectionView) {
        mSlideCell * cell =[cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

        NSDictionary *optLst=self.currSlideList[indexPath.row];

        NSDictionary *effDt=[optLst objectForKey:@"Eff_from"];
        NSDate *dteff=[BaseViewController str2date:[effDt valueForKey:@"date"]];
        NSString *EffDT=[BaseViewController date2str:dteff onlyDate:YES];

        NSString *SlidesDirectory = [BaseViewController getSlidesDirectory];
        NSString *fileName=[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]];
        cell.ImgView.layer.cornerRadius=5.0f;
        if([[optLst objectForKey:@"FileTyp"] isEqual:@"H"]){
            cell.ImgView.image=[ImageScale imageWithImage:[BaseViewController loadSlideImage:[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]]] scaledToSize:CGSizeMake(cell.ImgView.frame.size.width, cell.ImgView.frame.size.height)];
            cell.ImgView.contentMode = UIViewContentModeScaleToFill;

        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"I"]){
            cell.ImgView.image= [ImageScale imageWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]] scaledToSize:CGSizeMake(cell.ImgView.frame.size.width, cell.ImgView.frame.size.height)];
        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"V"]){
            NSURL *urlVideoFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            cell.ImgView.image=[ImageScale imageWithImage:[BaseViewController getVideoThumbnail:urlVideoFile] scaledToSize:CGSizeMake(cell.ImgView.frame.size.width, cell.ImgView.frame.size.height)];
            cell.ImgView.contentMode = UIViewContentModeScaleToFill;
        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"P"])
        {
            NSURL *PDFFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            cell.ImgView.image=[ImageScale imageWithImage:[BaseViewController imageFromPDFWithDocumentRef:CGPDFDocumentCreateWithURL( (__bridge CFURLRef) PDFFile)] scaledToSize:CGSizeMake(cell.ImgView.frame.size.width, cell.ImgView.frame.size.height)];
            cell.ImgView.contentMode = UIViewContentModeScaleAspectFill;


        }
        cell.ImgView.clipsToBounds = YES;
        cell.ImgView.layer.borderColor=[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00].CGColor;
        cell.ImgView.layer.borderWidth=1;

        return cell;
    } else {
        filterCell* cell =[cv dequeueReusableCellWithReuseIdentifier:@"fCell" forIndexPath:indexPath];
        cell.lblFilterType.text = [[self.SpecList objectAtIndex:indexPath.row] objectForKey:@"Name"];
        
        cell.layer.borderColor = [UIColor redColor].CGColor;
        cell.layer.borderWidth = 2.0;
        cell.layer.cornerRadius = 3.0;
        cell.layer.masksToBounds = YES;
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.specCollectionView)
    {
    self.selectedSpec = [[[self.SpecList objectAtIndex:indexPath.row] objectForKey:@"Code"] stringValue];
    self.SelProductList = [self getFilteredSlides];
    self.currSlideList=[[NSMutableArray alloc] init];
    if (self.SelProductList.count>0) {

        self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp!=\"C\"", [self.SelProductList[0] valueForKey:@"Code"]]] mutableCopy];
        
        self.selProduct=self.SelProductList[0];
        
        NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"OrdNo" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];

        self.currSlideList = [[self.currSlideList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        
    }
    [self.tvProdList reloadData];
    [self.slideCollectionView reloadData];
    [self closeTableViews];
    [self callORdismissFilter];
    }
    
}


//user table view events

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tvProdList) return self.SelProductList.count;
    if(tableView==self.tvFilterType) return self.filterTypes.count;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    NSDictionary *optLst=[[NSDictionary alloc] init];
    
    cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(tableView==self.tvProdList){
        optLst = self.SelProductList[indexPath.row];
        NSDictionary *effDt=[optLst objectForKey:@"Eff_from"];
        NSDate *dteff=[BaseViewController str2date:[effDt valueForKey:@"date"]];
        NSString *EffDT=[BaseViewController date2str:dteff onlyDate:YES];
        
        NSString *SlidesDirectory = [BaseViewController getSlidesDirectory];
        NSString *fileName=[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]];
        
        if([[optLst objectForKey:@"FileTyp"] isEqual:@"H"]){
            cell.lOptImg.image=[BaseViewController loadSlideImage:[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]]];
            ///cell.lOptImg.contentMode = UIViewContentModeScaleToFill;
            
        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"I"]){
            //UIImage* image =[BaseViewController loadSlideImage:[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]]];
            cell.lOptImg.image= [ImageScale imageWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]] scaledToSize:CGSizeMake(cell.lOptImg.frame.size.width, cell.lOptImg.frame.size.height)];
            //UIImage* image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
          
            //cell.lOptImg.contentMode = UIViewContentModeScaleAspectFit;
            //cell.lOptImg.clipsToBounds = YES;
            //cell.lOptImg.image=image;
        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"V"]){
            //NSURL *urlVideoFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            
            //cell.lOptImg.image=[BaseViewController getVideoThumbnail:urlVideoFile];
            //cell.lOptImg.contentMode = UIViewContentModeScaleToFill;
        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"P"])
        {
            NSURL *PDFFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
           cell.lOptImg.image=[BaseViewController imageFromPDFWithDocumentRef:CGPDFDocumentCreateWithURL( (__bridge CFURLRef) PDFFile)];
           // cell.lOptImg.contentMode = UIViewContentModeScaleAspectFill;
           // cell.lOptImg.clipsToBounds = YES;
            
        }
        
        cell.lOptImg.layer.borderColor=[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00].CGColor;//[UIColor grayColor].CGColor;
        cell.lOptImg.layer.borderWidth=1;
        cell.lOptImg.layer.cornerRadius=5.0f;
        cell.lOptImg.clipsToBounds=YES;
        
        [cell.lOptText setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5.0];
        //cell.lOptText.
    }
    if(tableView==self.tvFilterType)
    {
        optLst = self.filterTypes[indexPath.row];
    }
    
    cell.lOptText.text = NSLocalizedString([optLst objectForKey:@"Name"],[optLst objectForKey:@"Name"]);
    return cell;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"startDemo"])
    {
        PresentationViewCtrl *pvc = [segue destinationViewController];
        pvc.filterType=self.filterType;
        [pvc setStartProductSlide:self.selProduct];
    }

}
-(void)setCurrentSlide:(NSDictionary *)selSlide{
 //   [self.currentSlide ]
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tvFilterType) {
        self.filterType=[[_filterTypes[indexPath.row] valueForKey:@"id"] integerValue];
        [self.btnFilterType setTitle:NSLocalizedString([_filterTypes[indexPath.row] objectForKey:@"Name"],[_filterTypes[indexPath.row] objectForKey:@"Name"])  forState:UIControlStateNormal];
        if(self.filterType == 2)
        {
            [self.btnFilterSpec setHidden:NO];
            [self.imgForward setHidden: NO];
        }
        else
        {
            if(self.cnstrntSpecFilterViewOrigin.constant == -200)
            {
            [UIView animateWithDuration:1.0 animations:^{
                self.cnstrntSpecFilterViewOrigin.constant = - self.view.frame.size.height;
                [self.view layoutIfNeeded];

            }];
            }
            [self.btnFilterSpec setHidden:YES];
            [self.imgForward setHidden: YES];
        }
        
        self.SelProductList = [self getFilteredSlides];
        self.currSlideList=[[NSMutableArray alloc] init];
        if (self.SelProductList.count>0) {

            self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp!=\"C\"", [self.SelProductList[0] valueForKey:@"Code"]]] mutableCopy]; //  and FileTyp=%@ ,self.fileType
            /*NSString* sRtSlides=@"";
            if (self.SetupData.RatingBasedSlide==1){
                NSArray* aRtSlides=[_meetData.RatingSlide filteredArrayUsingPredicate:[NSPredicate  predicateWithFormat:@"Code == %@",[self.SelProductList[0] valueForKey:@"Code"]]];
                sRtSlides=[aRtSlides[0] valueForKey:@"Prods"];
                if(!([sRtSlides isEqualToString:@""] || [sRtSlides isEqualToString:@"0"]))
                {    self.currSlideList = [[self.currSlideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains[c] SlideNm", sRtSlides]] mutableCopy];
                }
            }*/
            self.selProduct=self.SelProductList[0];
            
            NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"OrdNo" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];

            self.currSlideList = [[self.currSlideList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            
        }
        [self.tvProdList reloadData];
        [self.slideCollectionView reloadData];
        [self closeTableViews];
    }
    if(tableView==self.tvProdList) {
        self.selProduct=self.SelProductList[indexPath.row];
        self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp!=\"C\"", [self.SelProductList[indexPath.row] valueForKey:@"Code"]]] mutableCopy];
      /*  NSString* sRtSlides=@"";
        if (self.SetupData.RatingBasedSlide==1){
            NSArray* aRtSlides=[_meetData.RatingSlide filteredArrayUsingPredicate:[NSPredicate  predicateWithFormat:@"Code == %@",[self.SelProductList[indexPath.row] valueForKey:@"Code"]]];
            sRtSlides=[aRtSlides[0] valueForKey:@"Prods"];
            if(!([sRtSlides isEqualToString:@""] || [sRtSlides isEqualToString:@"0"]))
            {    self.currSlideList = [[self.currSlideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains[c] SlideNm", sRtSlides]] mutableCopy];
            }
        }*/
        if([_currSlideList count]>0)
        {
            NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"OrdNo" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
            self.currSlideList = [[self.currSlideList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        }
        [self.slideCollectionView reloadData];
    }
}
@end
