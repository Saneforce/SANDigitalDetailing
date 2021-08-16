//
//  PresentationViewCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 04/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "PresentationViewCtrl.h"
#import "mSlideCell.h"
#import "TBSelectionBxCell.h"
#import "ShapesUI.h"
#import "LineView.h"

@interface PresentationViewCtrl ()

@property (nonatomic,strong) NSMutableArray* AllGroupSlides;
@property (nonatomic,strong) NSMutableArray* currSlideList; //collection Slides of selected product
@property (nonatomic,strong) NSMutableArray* filterTypes;   // List Of Filter Types eg: Images | Vedio
@property (nonatomic,strong) NSArray* OrgAllSlides;//ProductsList
@property (nonatomic,strong) NSArray* OrgUniqueSlides;
@property (nonatomic,strong) NSMutableArray* UniqueSlides; //List of Unique products

@property (nonatomic,strong) NSMutableArray* SelProductList; //filtered List of products from UniqueSlides
@property (nonatomic,strong) NSMutableArray* ScribbleList;

@property (nonatomic,strong) NSMutableArray* AllSlides;    //Products all slides List
@property (nonatomic,strong) NSMutableDictionary* selProduct; //selected Product
@property (nonatomic,weak) NSString* fileType;
@property (nonatomic,assign) BOOL menuShowed;
@property (nonatomic,assign) BOOL userMoved;
@property (nonatomic,assign) NSInteger Slideindex;
@property (nonatomic,assign) long BrandIndex;
@property (nonatomic,assign) int moveFlag;
@property (nonatomic,assign) int SwipID;

@property (nonatomic,assign) UIColor* penColor;
@property (nonatomic,assign) UIButton* penColorBtn;


@property (nonatomic,strong) NSMutableArray* Products;
@property (nonatomic,strong) NSMutableArray* SubSlides;
@property (nonatomic,strong) NSMutableDictionary* ProductsDets;
@property (nonatomic,strong) NSMutableDictionary* SubSlideDets;

@property (nonatomic,strong) NSString* pSlide;
@property (nonatomic,strong) NSString* pSlidePath;
@property (nonatomic,strong) NSString* pSlideType;
@property (nonatomic,strong) NSString* STime;
@property (nonatomic,strong) NSString* ProdSTime;
@property (nonatomic,assign) int likeSlide;

@property(nonatomic,assign) float lastScale;
@property UIPinchGestureRecognizer *twoFingerPinch;

@property UITapGestureRecognizer *PauseTapRecognizer;

@end
@implementation PresentationViewCtrl
AVPlayer *player;
UIImageView *pdfimgView;
UILabel *lblPdfFNm;
NSURL *PDFFile;
CGFloat lastScale = 1.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.meetData=[CallMeetData sharedDatas];
    self.SetupData=[AppSetupData sharedDatas];
    self.meetData.Products=[[NSMutableArray alloc] init];
    self.ProductsDets=[[NSMutableDictionary alloc] init];
    self.ScribbleList=[[NSMutableArray alloc] init];
    
    self.slideCollectionView.delegate = self;
    self.slideCollectionView.dataSource = self;
    
    self.vwWinBgMenu.hidden=YES;
    self.vwAboutSlide.hidden=YES;
    self.vwWinScribble.hidden=YES;
    
    self.tvFilterType.delegate = self;
    self.tvFilterType.dataSource = self;
    self.tvProdList.delegate = self;
    self.tvProdList.dataSource = self;
    self.filterTypes=[@[@{@"id":@1,@"Name":@"Brand Matrix"}, @{@"id":@2,@"Name":@"Specialitywise"}, @{@"id":@4,@"Name":@"All Brands"}] mutableCopy];
    _userMoved=YES;
    self.btnFilterType.layer.cornerRadius=5.0f;
    self.vwWinMenu.layer.cornerRadius=10.0f;
    
    self.OrgAllSlides =[[[NSUserDefaults standardUserDefaults] objectForKey:@"ProdSlides.SANAPP"] mutableCopy];
    self.UniqueSlides =[[[NSUserDefaults standardUserDefaults] objectForKey:@"UniqueProdSlides.SANAPP"] mutableCopy];
    if (self.SetupData.RatingBasedSlide==1){
    self.OrgAllSlides = [self getRatingSlides:[self.OrgAllSlides mutableCopy]];
    //self.UniqueSlides = [self getRatingSlides:[self.UniqueSlides mutableCopy]];
    }
    self.AllGroupSlides=[[[NSUserDefaults standardUserDefaults] objectForKey:@"GroupSlides.SANAPP"]     mutableCopy];
    if(self.AllGroupSlides==nil) self.AllGroupSlides=[[[NSMutableArray alloc] init] mutableCopy];
    for(int i=0;i<[self.AllGroupSlides count];i++){
        NSDictionary *dic=_AllGroupSlides[i];
        NSMutableDictionary *flTyp=[[NSMutableDictionary alloc] init];
        [flTyp setValue:[dic valueForKey:@"GroupId"] forKey:@"id"];
        [flTyp setValue:[dic valueForKey:@"GroupName"] forKey:@"Name"];
        [self.filterTypes addObject:flTyp];
    }
    _SubSlides=[[NSMutableArray alloc] init];
    NSMutableArray* Aryf = [[_filterTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id==%i", _filterType]] mutableCopy];
    [self.btnFilterType setTitle:NSLocalizedString([Aryf[0] objectForKey:@"Name"],[Aryf[0] objectForKey:@"Name"]) forState:UIControlStateNormal];
    
    //get Products with first slide
    self.SelProductList = [self getFilteredSlides];
    
    self.currSlideList=[[NSMutableArray alloc]init];
    //if (self.SelProductList.count>0) self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp=%@", [self.selProduct valueForKey:@"Code"],self.fileType]] mutableCopy];
    if (self.SelProductList.count>0){
        _BrandIndex=[_SelProductList indexOfObject:_selProduct];
        self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp!=\"C\"", [self.selProduct valueForKey:@"Code"]]] mutableCopy];
       /* NSString* sRtSlides=@"";
        if (self.SetupData.RatingBasedSlide==1){
            NSArray* aRtSlides=[_meetData.RatingSlide filteredArrayUsingPredicate:[NSPredicate  predicateWithFormat:@"Code == %@",[self.selProduct valueForKey:@"Code"]]];
            sRtSlides=[aRtSlides[0] valueForKey:@"Prods"];
            if(!([sRtSlides isEqualToString:@""] || [sRtSlides isEqualToString:@"0"]))
            {    self.currSlideList = [[self.currSlideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains[c] SlideNm", sRtSlides]] mutableCopy];
            }
        }*/
        NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"OrdNo" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
        self.currSlideList = [[self.currSlideList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
    
    [self.slideCollectionView reloadData];
    [self setSlides];
    _SwipID=1;
    self.ProdSTime= [self getDateTime];
    
    _PauseTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowSelection:)];
    _PauseTapRecognizer.delegate = self;
    [_PauseTapRecognizer setNumberOfTouchesRequired:2];
    [self.scrollView addGestureRecognizer:_PauseTapRecognizer];
    
}
- (NSMutableArray *) getRatingSlides:(NSMutableArray *) nSlides {
    
    NSMutableArray *resultArr=[[NSMutableArray alloc] init];
        
        for(int il=0;il<[self.OrgAllSlides count];il++){
            
            NSRange range =[[NSString stringWithFormat:@",%@,",_meetData.RatingSlideIds] rangeOfString:[NSString stringWithFormat:@",%@,",[nSlides[il] valueForKey:@"SlideId"]]];
           // NSRange range =[[NSString stringWithFormat:@"%@",_meetData.RatingSlideIds] rangeOfString:[nSlides[il] valueForKey:@"SlideId"]];
            if([[nSlides[il] valueForKey:@"SlideId"] isEqual:@"84"]||[[nSlides[il] valueForKey:@"SlideId"] isEqual:@"85"]){
                NSLog(@"LOG");
            }
            if (range.length > 0 )
            {
                    NSMutableDictionary *dic=[nSlides[il] mutableCopy];
                    
                    [resultArr addObject:dic];
                
            }
        }
    return [resultArr mutableCopy];
}
-(void)viewDidAppear:(BOOL)animated
{
    
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
    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    if(_filterType<=3) resultArr = [[self FilterArray:self.UniqueSlides] mutableCopy];
    if(_filterType==1){
        NSArray *mpProds =[self.meetData.mappedProds componentsSeparatedByString:@","];
        
        for(int il=0;il<[mpProds count];il++){
            if (![mpProds[il] isEqual:@""])
            {
                NSArray *slnos =[mpProds[il] componentsSeparatedByString:@"-"];
                
                NSMutableArray* Aryf = [[resultArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code==%@", slnos[0]]] mutableCopy];
                if([Aryf count]>0){
                    NSInteger intd=[resultArr indexOfObject:Aryf[0]];
                    NSMutableDictionary *dic=[Aryf[0] mutableCopy];
                    [dic setObject:slnos[1] forKey:@"PCatTyp"];
                    
                    [resultArr replaceObjectAtIndex:intd withObject:dic];
                }
            }
        }
        
        NSSortDescriptor *CampField = [NSSortDescriptor sortDescriptorWithKey:@"Camp" ascending:YES];
        NSSortDescriptor *PTypField = [NSSortDescriptor sortDescriptorWithKey:@"PCatTyp" ascending:YES];
        sortDescriptors = [NSArray arrayWithObjects:CampField, PTypField, NameField, nil];
    }else if(_filterType>=4 && _filterType<=9){
        resultArr = [self.UniqueSlides mutableCopy];
    }
    else{
        if(self.filterType>9)
        {
            NSLog(@"%d",(int)self.filterType);
            
            NSMutableArray* dic=[[self.AllGroupSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"GroupId == %d", self.filterType]]mutableCopy];
            self.AllSlides=[dic[0] objectForKey:@"GroupSlides"];
            resultArr=[[[NSMutableArray alloc] init] mutableCopy];
            NSArray *Ids=[_AllSlides valueForKeyPath:@"@distinctUnionOfObjects.Code"];
            for(int i=0; i<[Ids count];i++){
                NSMutableArray* dic = [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", Ids[i]]]mutableCopy];
                [resultArr addObject:dic[0]];
            }
            
        }
    }
    resultArr = [[resultArr sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
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
        
    }];
}

-(void) closeTableViews{
    self.vwFilter.hidden=YES;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // set delegate method of UISrollView
   /* webView.scrollView.maximumZoomScale = 20; // set as you want.
    webView.scrollView.minimumZoomScale = 1; // set as you want.*/
    [self doSlideAnimation:@"H"];
    
    self.STime= [self getDateTime];
    NSUInteger sSlideCnt=[_SubSlides count];
    if(sSlideCnt>0){
        NSString* EndTime=[_SubSlides[sSlideCnt-1] valueForKey:@"ETM"];
        if(EndTime==nil || [EndTime isEqualToString:@""]){
            [_SubSlides[sSlideCnt-1] setValue:[self getDateTime] forKey:@"ETM"];
        }
    }
    if(_userMoved==NO){
        
        NSString* sUrlstr=webView.request.URL.absoluteString;
        NSMutableArray *items = [[sUrlstr componentsSeparatedByString:@"/"] mutableCopy];
        NSString* fileNm=[NSString stringWithFormat:@"%@.zip",items[[items count]-2]];
        
        NSMutableArray* currentSlide= [[self.currSlideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"FilePath == %@ and FileTyp==\"H\"", fileNm]] mutableCopy];
        if([currentSlide count]>0){
            NSInteger slideIndex=[self.currSlideList indexOfObject:currentSlide[0]];
            [self setProductsData];
            _Slideindex=slideIndex;
        }
        else{
            NSLog(@"%@,\n%@",[self.selProduct valueForKey:@"SlideId"],fileNm);
            _SubSlideDets=[[NSMutableDictionary alloc] init];
            [_SubSlideDets setValue:[self.selProduct valueForKey:@"SlideId"] forKey:@"SlideId"];
            [_SubSlideDets setValue:fileNm forKey:@"SubSlideNm"];
            [_SubSlideDets setValue:self.STime forKey:@"STM"];
            [_SubSlides addObject:_SubSlideDets];
        }
    }
    _userMoved=NO;
}
- (UIView *) getSlideViewByType:(NSString *) Type{
    
    int Indx=0;
    if ([Type isEqual:@"I"]) Indx=1;
    if ([Type isEqual:@"V"]) Indx=2;
    if ([Type isEqual:@"P"]) Indx=3;
    return [[self.scrollView subviews] objectAtIndex:Indx];
}
- (void) doSlideAnimation:(NSString *)Type{
    UIView* sldView=[self getSlideViewByType:Type];
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    if (self.moveFlag==1)
    {
        [animation setSubtype:kCATransitionFromRight];
    }else{
        [animation setSubtype:kCATransitionFromLeft];
    }
    [animation setDuration:0.30];
    [animation setTimingFunction:
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sldView.layer addAnimation:animation forKey:kCATransition];
}

-(NSString*) getDateTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setLocale:[NSLocale currentLocale]];
    return [dateFormat stringFromDate:date];
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    UIWebView* sldView=[[self.scrollView subviews] objectAtIndex:0];
    sldView.scrollView.scrollEnabled=(sldView.scrollView.zoomScale>1.0f)?true:false;
    
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        recognizer.scale=sldView.scrollView.zoomScale;
    }
    [sldView.scrollView setZoomScale:recognizer.scale animated:NO];
}
- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint
{
    CGRect vf = view.frame;
    CGPoint co = self.scrollView.contentOffset;
    
    CGFloat x = centerPoint.x - vf.size.width / 2.0;
    CGFloat y = centerPoint.y - vf.size.height / 2.0;
    
    if(x < 0)
    {
        co.x = -x;
        vf.origin.x = 0.0;
    }
    else
    {
        vf.origin.x = x;
    }
    if(y < 0)
    {
        co.y = -y;
        vf.origin.y = 0.0;
    }
    else
    {
        vf.origin.y = y;
    }
    
    view.frame = vf;
    [self.scrollView setContentOffset:CGPointMake(co.x, co.y) animated:YES];
    //self.scrollView.contentOffset = co;
    NSLog(@"%@",[NSString stringWithFormat:@"x: %f y: %f", self.scrollView.contentOffset.x,self.scrollView.contentOffset.y]);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIImageView *sldView=[[self.scrollView subviews] objectAtIndex:1];
    UIImageView *wbView=[[self.scrollView subviews] objectAtIndex:0];
    if (sldView.hidden==NO)
        return sldView;
    else if (wbView.hidden==NO)
        return wbView;
    else
        return nil;
}
-(void)HandlePinch:(UIPinchGestureRecognizer*)recognizer{
    UIImageView *sldView=[[self.scrollView subviews] objectAtIndex:1];
    CGFloat scale = recognizer.scale;
    CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
    
    sldView.transform = CGAffineTransformScale(sldView.transform, scale, scale);
    if(currentScale<1.0f) {
        scale=1.0f;
        sldView.transform = CGAffineTransformScale(sldView.transform, scale, scale);
    }
    
    
    /*self.scrollView.scrollEnabled=(self.scrollView.zoomScale>1.0f)?true:false;
    [self.scrollView setZoomScale:recognizer.scale animated:NO];
    */
    recognizer.scale = 1.0;
    NSLog(@"Scale:%f",currentScale);
    self.scrollView.scrollEnabled=(currentScale>1.0f)?YES:NO;
    
}
-(void) setSlides{
    
    int x=0;
    int y=0;
    while ([self.scrollView.subviews count] > 0) {
        [[[self.scrollView subviews] objectAtIndex:0] removeFromSuperview];
    }

    /*for (int i=0; i<[self.currSlideList count]; i++)
    {*/
    UIWebView *wbView=[[UIWebView alloc]initWithFrame:CGRectMake(x, 0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    wbView.delegate=self;
    wbView.mediaPlaybackRequiresUserAction = NO;
    

    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    imgView.userInteractionEnabled=YES;
    UIView *VideoView=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    VideoView.userInteractionEnabled=YES;
    
    UIView *pdfView=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    pdfView.userInteractionEnabled=YES;
    int scH=[[UIScreen mainScreen] bounds].size.height-50;
    int xx=([[UIScreen mainScreen] bounds].size.width/2)/2;
    y=15;
    
    pdfimgView=[[UIImageView alloc]initWithFrame:CGRectMake(xx, y,[[UIScreen mainScreen] bounds].size.width/2, scH)];
    pdfimgView.userInteractionEnabled=YES;
    pdfimgView.layer.borderWidth=2;
    pdfimgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    lblPdfFNm=[[UILabel alloc]initWithFrame:CGRectMake(xx, (y+scH)+5,[[UIScreen mainScreen] bounds].size.width/2,20)];
    [lblPdfFNm setTextAlignment:NSTextAlignmentCenter];
    [pdfView addSubview:pdfimgView];
    [pdfView addSubview:lblPdfFNm];
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://s3-eu-west-1.amazonaws.com/alf-proeysen/Bakvendtland-MASTER.mp4"];
    
    player = [AVPlayer playerWithURL:url];
    _playerViewController = [[AVPlayerViewController alloc] init];
    [self addChildViewController:_playerViewController];
    
    _playerViewController.view.frame = CGRectMake(0,50,VideoView.bounds.size.width, VideoView.bounds.size.height-100);
    _playerViewController.player = player;
    _playerViewController.showsPlaybackControls = YES;
    player.closedCaptionDisplayEnabled = NO;
    self.view.autoresizesSubviews = YES;
    
    imgView.hidden=YES;
    wbView.hidden=YES;
    VideoView.hidden=YES;
    pdfView.hidden=YES;
    
    wbView.scalesPageToFit=true;
    //wbView.autoresizingMask=YES;
    wbView.scrollView.scrollEnabled=false;
    
    [self.scrollView addSubview:wbView];
    [self.scrollView addSubview:imgView];
    [self.scrollView addSubview:VideoView];
    [self.scrollView addSubview:pdfView];
    
    [VideoView addSubview:_playerViewController.view];
    
    /*NSMutableDictionary *di=[[NSMutableDictionary alloc] init];
    [di setValue:@"P" forKey:@"FileTyp"];
//    //[di setValue:@"" forKey:<#(nonnull NSString *)#>
    [self.currSlideList addObject:di ];*/
    
    [self loadUrl:1];

    _Slideindex=0;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenus:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(CloseWinMenu:)];
    UISwipeGestureRecognizer *VidSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenus:)];
    UISwipeGestureRecognizer *wbSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenus:)];
    UISwipeGestureRecognizer *imgSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenus:)];
    UISwipeGestureRecognizer *pdfSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenus:)];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    UISwipeGestureRecognizer *VideoswipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *VideoswipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    UISwipeGestureRecognizer *ImgswipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *ImgswipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    UISwipeGestureRecognizer *PdfswipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *PdfswipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]
                      initWithTarget:self
                      action:@selector(twoFingerPinch:)];
    
    UIPinchGestureRecognizer *twoFingerPinch1 = [[UIPinchGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(HandlePinch:)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPDFFileViewer)];
    singleTap.numberOfTapsRequired = 1;
    
    
    
    //[wbView addGestureRecognizer:twoFingerPinch];
   // [imgView addGestureRecognizer:twoFingerPinch1];

    
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [VidSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [imgSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [wbSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [pdfSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [VideoswipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [VideoswipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [ImgswipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [PdfswipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [PdfswipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [wbView addGestureRecognizer:wbSwipeUp];
    [VideoView addGestureRecognizer:VidSwipeUp];
    [imgView addGestureRecognizer:swipeUp];
    [pdfView addGestureRecognizer:pdfSwipeUp];
    //[pdfimgView addGestureRecognizer:swipeUp];
    
    [self.vwWinBgMenu addGestureRecognizer:swipeDown];
    
    // Adding the swipe gesture
    [wbView addGestureRecognizer:swipeLeft];
    [wbView addGestureRecognizer:swipeRight];
    [VideoView addGestureRecognizer:VideoswipeLeft];
    [VideoView addGestureRecognizer:VideoswipeRight];
    [imgView addGestureRecognizer:ImgswipeLeft];
    [imgView addGestureRecognizer:ImgswipeRight];
    [pdfView addGestureRecognizer:PdfswipeLeft];
    [pdfView addGestureRecognizer:PdfswipeRight];
    [pdfimgView addGestureRecognizer:singleTap];
    
    x=x+[[UIScreen mainScreen] bounds].size.width;
    //}
    self.scrollView.contentSize=CGSizeMake(x, [[UIScreen mainScreen] bounds].size.height-20);
    self.scrollView.contentOffset=CGPointMake(0, 0);
    
    
    self.scrollView.maximumZoomScale = 20; // set as you want.
    self.scrollView.minimumZoomScale = 1; // set as you want.
}
-(void) loadUrl:(int) moveFlag{
    
    NSDictionary *optLst=self.currSlideList[_Slideindex];//i];
    
    UIWebView* wbView=[[self.scrollView subviews] objectAtIndex:0];
    UIImageView* imgView=[[self.scrollView subviews] objectAtIndex:1];
    UIView* VideoView=[[self.scrollView subviews] objectAtIndex:2];
    UIView* pdfView=[[self.scrollView subviews] objectAtIndex:3];
    
    wbView.hidden=YES;
    imgView.hidden=YES;
    VideoView.hidden=YES;
    pdfView.hidden=YES;
    
    [player seekToTime:CMTimeMake(0, 1)];
    [player pause];
    
    NSDictionary *effDt=[optLst objectForKey:@"Eff_from"];
    NSDate *dteff=[BaseViewController str2date:[effDt valueForKey:@"date"]];
    NSString *EffDT=[BaseViewController date2str:dteff onlyDate:YES];
    
    NSString *SlidesDirectory = [BaseViewController getSlidesDirectory];
    NSString *fileName=[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]];
    self.moveFlag=moveFlag;
    
    self.pSlide=[fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",EffDT] withString:@""];
    self.pSlidePath=EffDT;
    self.pSlideType=[optLst objectForKey:@"FileTyp"];
    wbView.scrollView.delegate = nil;
    self.scrollView.delegate=self;
    if([[optLst objectForKey:@"FileTyp"] isEqual:@"H"])
    {
        wbView.hidden=NO;
        //wbView.scrollView.delegate = self;
        NSString *path = [NSString stringWithFormat:@"%@",[SlidesDirectory stringByAppendingPathComponent:[fileName stringByReplacingOccurrencesOfString:@".zip" withString:@""]]];
    
        NSArray *AllFiles = [[NSFileManager defaultManager]
                               contentsOfDirectoryAtPath:path error:nil];
        NSLog(@"%@",AllFiles);
        NSArray *htmlFiles = [[[NSFileManager defaultManager]
                           contentsOfDirectoryAtPath:path error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension='html'"]];
        self.pSlide=htmlFiles[0];
        self.pSlidePath=EffDT;
        NSString *htmlfile=[NSString stringWithFormat:@"%@/%@",path,htmlFiles[0]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlfile]];
        [wbView loadRequest:urlRequest  ];
    }
    else if([[optLst objectForKey:@"FileTyp"] isEqual:@"I"])
    {
        imgView.hidden=NO;
        UIImage* image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
        //imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;

       //  UIImage* image= [ImageScale imageWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]] scaledToSize:CGSizeMake(imgView.frame.size.width, imgView.frame.size.height)];
        imgView.image=image;

        [self doSlideAnimation:@"I"];
        self.STime= [self getDateTime];
    }
    else if([[optLst objectForKey:@"FileTyp"] isEqual:@"V"])
    {
        VideoView.hidden=NO;
        NSURL *urlVideoFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
        NSLog(@"File Name: %@/%@",SlidesDirectory,fileName);
        AVPlayerItem *newPlayerItem_ = [AVPlayerItem playerItemWithURL:urlVideoFile];
        [player replaceCurrentItemWithPlayerItem:newPlayerItem_];
        
        [self doSlideAnimation:@"V"];
        self.STime= [self getDateTime];
    }
    else if([[optLst objectForKey:@"FileTyp"] isEqual:@"P"])
    {
        pdfView.hidden=NO;
        PDFFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
        self.pdf = CGPDFDocumentCreateWithURL( (__bridge CFURLRef) PDFFile );
        pdfimgView.image=[BaseViewController imageFromPDFWithDocumentRef:self.pdf];
        
        //CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
        
        lblPdfFNm.text=[optLst objectForKey:@"FilePath"];
        [self doSlideAnimation:@"P"];
        self.STime= [self getDateTime];
    }
    
    self.likeSlide=0;
    self.SlideRemarks.text=@"";
    self.ScribbleList=[[NSMutableArray alloc] init];
    [self.btnLikeButton setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
    [self.btnDislikeButton setImage:[UIImage imageNamed:@"dislike_off"] forState:UIControlStateNormal];
    
    self.Products = [[self.meetData.Products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", [self.selProduct valueForKey:@"Code"]]] mutableCopy];
    NSMutableArray *slideList=[[NSMutableArray alloc] init];
    if([self.Products count]>0)
    {
        self.ProductsDets=self.Products[0];
        slideList=[self.ProductsDets objectForKey:@"Slides"];
        NSMutableArray *fslides = [[slideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Slide == %@", self.pSlide]] mutableCopy];
        if ([fslides count]>0){
            self.likeSlide=[[fslides[0] valueForKey:@"usrLike"] intValue];
            if(self.likeSlide==1) [self.btnLikeButton setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
            if(self.likeSlide==2) [self.btnDislikeButton setImage:[UIImage imageNamed:@"dislike_on"] forState:UIControlStateNormal];
            self.SlideRemarks.text=[fslides[0] valueForKey:@"SlideRem"];
            self.ScribbleList=[[fslides[0] valueForKey:@"Scribbles"] mutableCopy];
        }
    }
    
    
}
-(void) setProdTimeline{
    
    self.Products = [[self.meetData.Products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", [self.selProduct valueForKey:@"Code"]]] mutableCopy];
    
    NSInteger indexValue = -1;
    if([self.Products count]>0)
    {
        indexValue = [self.meetData.Products indexOfObject:self.Products[0]];
        self.ProductsDets=self.Products[0];
        NSMutableDictionary *PTimeline=[[NSMutableDictionary alloc] init];
    
        [PTimeline setValue:self.ProdSTime forKey:@"sTm"];
        [PTimeline setValue:[self getDateTime] forKey:@"eTm"];
        [self.ProductsDets setValue:PTimeline forKey:@"Timesline"];
    
        if (indexValue>-1)
        {
            [self.meetData.Products replaceObjectAtIndex:indexValue withObject:self.ProductsDets];
        }
        else
        {
            [self.meetData.Products addObject:[self.ProductsDets mutableCopy]];
        }
    }
}
-(void) setProductsData{
    
    self.Products = [[self.meetData.Products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", [self.selProduct valueForKey:@"Code"]]] mutableCopy];
    
    NSMutableArray *slideList=[[NSMutableArray alloc] init];
    NSMutableArray *slidesTime=[[NSMutableArray alloc] init];
    NSInteger indexValue = -1;
    if([self.Products count]>0)
    {
        indexValue = [self.meetData.Products indexOfObject:self.Products[0]];
        self.ProductsDets=self.Products[0];
        slideList=[self.ProductsDets objectForKey:@"Slides"];
    }
    else
    {
        self.ProductsDets =[[NSMutableDictionary alloc] init];
        [self.ProductsDets setValue:[self.selProduct valueForKey:@"Code"] forKey:@"Code"];
        [self.ProductsDets setValue:[self.selProduct valueForKey:@"Name"] forKey:@"Name"];
        [self.ProductsDets setValue:[self.selProduct valueForKey:@"NoofSamples"] forKey:@"NoofSamples"];
        [self.ProductsDets setValue:[self.selProduct valueForKey:@"Group"] forKey:@"Group"];
        [self.ProductsDets setValue:@"D" forKey:@"Type"];
    }
    
    NSMutableDictionary *slideDet=[[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *timeDet=[[NSMutableDictionary alloc] init];
    NSMutableArray *fslides = [[slideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Slide == %@", self.pSlide]] mutableCopy];
    if ([fslides count]>0){
        slideDet=fslides[0];
        slidesTime=[slideDet objectForKey:@"Times"];
    }
    else{
        
        [slideDet setValue:self.pSlide forKey:@"Slide"];
        [slideDet setValue:self.pSlidePath forKey:@"SlidePath"];
        [slideDet setValue:self.pSlideType forKey:@"SlideType"];
    }
    
    [slideDet setValue:[NSString stringWithFormat:@"%i",self.likeSlide] forKey:@"usrLike"];
    [slideDet setValue:self.SlideRemarks.text forKey:@"SlideRem"];
    [slideDet setValue:self.ScribbleList forKey:@"Scribbles"];
    
    [timeDet setValue:self.STime forKey:@"sTm"];
    [timeDet setValue:[self getDateTime] forKey:@"eTm"];
    [slidesTime addObject:timeDet];
    
    [slideDet setValue:slidesTime forKey:@"Times"];
    
    if ([fslides count]<1) [slideList addObject:slideDet];
    
    [self.ProductsDets setValue:slideList forKey:@"Slides"];
    
    if (indexValue>-1)
    {
        [self.meetData.Products replaceObjectAtIndex:indexValue withObject:self.ProductsDets];
    }
    else
    {
        [self.meetData.Products addObject:[self.ProductsDets mutableCopy]];
    }

}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    NSLog(@"Swipe Fired...");
    _userMoved=YES;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        _SwipID=1;
        if (_Slideindex<[_currSlideList count]-1)
        {
            [self setProductsData];
            _Slideindex++;
            [self loadUrl:_SwipID];
        }
        else{
            if (_BrandIndex<[_SelProductList count]-1){
                _BrandIndex++;
                [self MoveBrand:_BrandIndex];
            }
        }
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        
        _SwipID=2;
        if (_Slideindex>0) {
            _Slideindex--;
            [self setProductsData];
            [self loadUrl:_SwipID];
        }
        else{
            if(_BrandIndex<1) return;
            _BrandIndex--;
            [self MoveBrand:_BrandIndex];
        }
    }
    
}
-(void)ShowSelection:(NSString*)sTitle{
    
    //[_tvOptList setEditing:YES animated:YES];
    if(self.menuShowed==YES){
        self.menuShowed=NO;
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options: 0
                         animations:^{
                             
                             self.headerTop.constant=-131;
                             self.footerBottom.constant=-75;
                             self.headerLeft.constant=- 260;
                             self.footerLeft.constant=-260;
                             self.lBarLeft.constant=-260;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {   }];
    }else{
        self.menuShowed=YES;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: 0
                     animations:^{
                         
                         self.headerTop.constant=0;
                         self.headerLeft.constant=260;
                         self.footerLeft.constant=0;//260;
                         //self.headerLeft.constant=0;
                         //self.footerLeft.constant=0;
                         self.footerBottom.constant=0;
                         self.lBarLeft.constant=0;
                         self.lBarTop.constant=-131;
                         self.lBarBottom.constant=0;//-75;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
    }
}

-(IBAction)CancelPresentation:(id)sender
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}
-(IBAction)dismissModalStack:(id)sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
}
-(IBAction)startDemo:(id)sender
{
    [self performSegueWithIdentifier:@"startDemo" sender:self];
}
-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl{
    
    if(SControl.selectedSegmentIndex == 0)self.fileType=@"I";
    if(SControl.selectedSegmentIndex == 1) self.fileType=@"V";
    if(SControl.selectedSegmentIndex == 2) self.fileType=@"P";
    
    self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp=%@", [self.selProduct valueForKey:@"Code"],self.fileType ]] mutableCopy];
    [self.slideCollectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.currSlideList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    mSlideCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    long row=0;
    if ([self.currSlideList count]>indexPath.row){
        row=indexPath.row;
    }
    NSDictionary *optLst=self.currSlideList[row];
    
    NSDictionary *effDt=[optLst objectForKey:@"Eff_from"];
    NSDate *dteff=[BaseViewController str2date:[effDt valueForKey:@"date"]];
    NSString *EffDT=[BaseViewController date2str:dteff onlyDate:YES];
    
    NSString *SlidesDirectory = [BaseViewController getSlidesDirectory];
    NSString *fileName=[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]];
    
    if([[optLst objectForKey:@"FileTyp"] isEqual:@"H"]){
        cell.ImgView.image=[BaseViewController loadSlideImage:[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]]];
        cell.ImgView.contentMode = UIViewContentModeScaleToFill;
        
    }
    else if([[optLst objectForKey:@"FileTyp"] isEqual:@"I"]){
        cell.ImgView.image=[BaseViewController loadSlideImage:[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]]];
        UIImage* image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
        cell.ImgView.contentMode = UIViewContentModeScaleAspectFit;
        cell.ImgView.clipsToBounds = YES;
        cell.ImgView.image=image;
    }
    else if([[optLst objectForKey:@"FileTyp"] isEqual:@"V"]){
        NSURL *urlVideoFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
        
        cell.ImgView.image=[BaseViewController getVideoThumbnail:urlVideoFile];
        cell.ImgView.contentMode = UIViewContentModeScaleToFill;
    }
    else if([[optLst objectForKey:@"FileTyp"] isEqual:@"P"])
    {
        NSURL *PDFFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
        cell.ImgView.image=[BaseViewController imageFromPDFWithDocumentRef:CGPDFDocumentCreateWithURL( (__bridge CFURLRef) PDFFile)];
        cell.ImgView.contentMode = UIViewContentModeScaleAspectFill;
        cell.ImgView.clipsToBounds = YES;
        
    }
    cell.ImgView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.ImgView.layer.borderWidth=1;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int _mfl=2;
    if(_Slideindex<indexPath.row) _mfl=1;
    [self ShowSelection:@""];
    [self setProductsData];
    _Slideindex=indexPath.row;
    [self loadUrl:_mfl];
}

//4725+150
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
        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"I"]){
            //cell.lOptImg.image=[BaseViewController loadSlideImage:[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]]];
            cell.lOptImg.image= [ImageScale imageWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]] scaledToSize:CGSizeMake(cell.lOptImg.frame.size.width, cell.lOptImg.frame.size.height)];
            
            /*UIImage* image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            cell.lOptImg.contentMode = UIViewContentModeScaleAspectFit;
            cell.lOptImg.clipsToBounds = YES;
            cell.lOptImg.image=image;*/
        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"V"]){
            NSURL *urlVideoFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            
            cell.lOptImg.image=[BaseViewController getVideoThumbnail:urlVideoFile];
            //cell.lOptImg.contentMode = UIViewContentModeScaleToFill;
        }
        else if([[optLst objectForKey:@"FileTyp"] isEqual:@"P"])
        {
            NSURL *PDFFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",SlidesDirectory,fileName]];
            cell.lOptImg.image=[BaseViewController imageFromPDFWithDocumentRef:CGPDFDocumentCreateWithURL( (__bridge CFURLRef) PDFFile)];
            
        }
    }
    if(tableView==self.tvFilterType)
    {
        optLst = self.filterTypes[indexPath.row];
    }
    
    cell.lOptText.text = NSLocalizedString([optLst objectForKey:@"Name"],[optLst objectForKey:@"Name"]);
    return cell;
    
}
-(void)setStartProductSlide:(NSMutableDictionary *)selSlide{
    self.selProduct=selSlide;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.tvFilterType) {
        self.filterType=[[_filterTypes[indexPath.row] valueForKey:@"id"] integerValue];
        
        [self.btnFilterType setTitle:NSLocalizedString([_filterTypes[indexPath.row] objectForKey:@"Name"],[_filterTypes[indexPath.row] objectForKey:@"Name"]) forState:UIControlStateNormal];
        self.SelProductList = [self getFilteredSlides];
        [self.tvProdList reloadData];
        [self closeTableViews];
    }
    if(tableView==self.tvProdList) {
        _BrandIndex=indexPath.row;
        [self MoveBrand:_BrandIndex];
        [self ShowSelection:@""];
    }
}
-(void) MoveBrand:(long) indx{
    [self setProductsData];
    [self setProdTimeline];
    
    self.selProduct=self.SelProductList[indx];
    self.ProdSTime= [self getDateTime];
    //[self setCurrentSlide:self.SelProductList[indexPath.row]];
    self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp!=\"C\"", [self.SelProductList[indx] valueForKey:@"Code"]]] mutableCopy];

    /*NSString* sRtSlides=@"";
    if (self.SetupData.RatingBasedSlide==1){
        NSArray* aRtSlides=[_meetData.RatingSlide filteredArrayUsingPredicate:[NSPredicate  predicateWithFormat:@"Code == %@",[self.SelProductList[indx] valueForKey:@"Code"]]];
        sRtSlides=[aRtSlides[0] valueForKey:@"Prods"];
        if(!([sRtSlides isEqualToString:@""] || [sRtSlides isEqualToString:@"0"]))
        {    self.currSlideList = [[self.currSlideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains[c] SlideNm", sRtSlides]] mutableCopy];
        }
    }
    */
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"OrdNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    self.currSlideList = [[self.currSlideList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    _Slideindex=0;
    [self loadUrl:_SwipID];
    //[self setSlides];
    [self.slideCollectionView reloadData];
    
}
-(IBAction)FinishDemo:(id)sender{
    _meetData.RMeetEndTime=[self getDateTime];
    _meetData.SubSlides=_SubSlides;
    [self setProductsData];
    [self setProdTimeline];
    [self performSegueWithIdentifier:@"gotoFeedBk" sender:self];
}


-(void) openPDFFileViewer{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PDFViewerController *currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"PDFViewerController"];
    [currentViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    currentViewController.modalPresentationStyle=UIModalPresentationFullScreen;
    currentViewController.pdf=self.pdf;
    
    [self presentViewController:currentViewController animated:YES completion:nil];
    //[currentViewController initialize];
    // [currentViewController startAllDownloads];
    
    
}
-(IBAction)setLikeValue:(id)sender{
    
    if(self.likeSlide!=1){
        self.likeSlide=1;
        [self.btnLikeButton setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
        [self.btnDislikeButton setImage:[UIImage imageNamed:@"dislike_off"] forState:UIControlStateNormal];
    }else{
        self.likeSlide=0;
        [self.btnLikeButton setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
        [self.btnDislikeButton setImage:[UIImage imageNamed:@"dislike_off"] forState:UIControlStateNormal];
    }
}

-(IBAction)setDislikeValue:(id)sender{
    
    if(self.likeSlide!=2){
        self.likeSlide=2;
        [self.btnLikeButton setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
        [self.btnDislikeButton setImage:[UIImage imageNamed:@"dislike_on"] forState:UIControlStateNormal];
    }else{
        self.likeSlide=0;
        [self.btnLikeButton setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
        [self.btnDislikeButton setImage:[UIImage imageNamed:@"dislike_off"] forState:UIControlStateNormal];
    }
    
}
-(IBAction) closeAboutSlide:(id)sender{
    self.vwAboutSlide.hidden=YES;
}
-(IBAction) openAboutSlide:(id)sender{
    [self ShowAboutSlide:@""];
}
-(void) ShowAboutSlide:(NSString*)sTitle{
    self.vwFilter.alpha=0.0;
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^{
        [self.view layoutIfNeeded];
        /*CGRect optionsFrame = self.vwFilter.frame;
        optionsFrame.size.height= 252;
        self.vwFilter.frame = optionsFrame;
        
        optionsFrame.origin.x= 0;
        optionsFrame.origin.y= 0;
        self.tvFilterType.frame = optionsFrame;
        */
        self.vwAboutSlide.hidden=NO;
        self.vwAboutSlide.alpha=1.0;
    } completion:^(BOOL finished){
        
    }];
}
- (IBAction)share:(id)sender {
    NSDictionary *optLst=self.currSlideList[_Slideindex];//i];
    NSDictionary *effDt=[optLst objectForKey:@"Eff_from"];
    NSDate *dteff=[BaseViewController str2date:[effDt valueForKey:@"date"]];
    NSString *EffDT=[BaseViewController date2str:dteff onlyDate:YES];
    
    NSString *SlidesDirectory = [BaseViewController getSlidesDirectory];
    NSString *filePath=[NSString stringWithFormat:@"%@/%@/%@",SlidesDirectory,EffDT,[optLst objectForKey:@"FilePath"]];
    
    
    
    
    
    
   // NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Heading1.PDF"];
    //NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
    NSArray *activityItems = [NSArray arrayWithObjects: pdfData, nil];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    }
    //if iPad
    else {

        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [activityController popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popController.delegate = self;
        
        // in case we don't have a bar button as reference
        popController.sourceView = self.view;
        popController.sourceRect = CGRectMake(self.vwWinMenu.frame.origin.x+305, self.vwWinMenu.frame.origin.y, 0, 0);
        
        popController.delegate = self; //18
        [self presentViewController:activityController animated:YES completion:nil]; // 19

        // Change Rect to position Popover
        /*UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [popup presentPopoverFromRect:CGRectMake(self.vwWinMenu.frame.origin.x+150, self.vwWinMenu.frame.origin.y, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];*/
    }
}

- (UIImage *)imageByRenderingView:(UIView*) srcView
{
    UIGraphicsBeginImageContext(srcView.bounds.size);
    [srcView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
-(IBAction)ShowScribbleWin:(id)sender{
    self.vwScribble.ScribbleBgImage.image=[self imageByRenderingView:self.scrollView];
    self.vwScribble.myScribbleImage.image=nil;
    self.vwDrawWin=[[UIView alloc] initWithFrame:self.vwScribble.myScribbleImage.frame];
    self.vwDrawWin.clipsToBounds=YES;
    [self.vwScribble addSubview:self.vwDrawWin];
    self.vwWinScribble.alpha=0.0;
    _penColorBtn=self.btnBlack;
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^{
        [self.view layoutIfNeeded];
        /*CGRect optionsFrame = self.vwFilter.frame;
         optionsFrame.size.height= 252;
         self.vwFilter.frame = optionsFrame;
         
         optionsFrame.origin.x= 0;
         optionsFrame.origin.y= 0;
         self.tvFilterType.frame = optionsFrame;
         */
        self.vwWinScribble.hidden=NO;
        self.vwWinScribble.alpha=1.0;
    } completion:^(BOOL finished){
        
    }];
}
-(IBAction)CloseScribbleWin:(id)sender{
    [self CloseScribble];
}
-(void) CloseScribble{
    [self selColorAnim:_penColorBtn SelButton:self.btnBlack];
    [self setPencilColorRed:0.0f Green:0.0f Blue:0.0f Alpha:1.0f];
    [self.vwDrawWin removeFromSuperview];
    self.vwWinScribble.hidden=YES;
}
- (void)showMenus:(UISwipeGestureRecognizer *)swipe{
    self.vwWinBgMenu.alpha=0.0;
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^{
        [self.view layoutIfNeeded];
        self.vwWinBgMenu.alpha=1.0;
        self.vwWinBgMenu.hidden=NO;
    } completion:^(BOOL finished){
        
    }];
}
- (void)CloseWinMenu:(UISwipeGestureRecognizer *)swipe
{
    self.vwWinBgMenu.hidden=YES;
}
-(IBAction) svScribblingImage:(id)sender
{
    NSMutableDictionary *scribbleDet=[[NSMutableDictionary alloc] init];
    NSDictionary *optLst=self.currSlideList[_Slideindex];//i];
    NSString *filName =[optLst objectForKey:@"FilePath"];
    NSMutableArray *items = [[filName componentsSeparatedByString:@"."] mutableCopy];
    [items removeLastObject];
    filName = [[items componentsJoinedByString:@"_"] mutableCopy];
    
    NSString* dtId=[[NSString stringWithFormat:@"%08f",[NSDate timeIntervalSinceReferenceDate]] stringByReplacingOccurrencesOfString:@"." withString:@""];
    [self.vwScribble saveScribbleImage:[NSString stringWithFormat:@"Scribble_%@_%i_%@",filName,(int)_Slideindex,dtId]];
    
    [scribbleDet setValue:[NSString stringWithFormat:@"%@_%i",[optLst objectForKey:@"FilePath"], (int)_Slideindex] forKey:@"ScribbleId"];
    [scribbleDet setValue:[optLst objectForKey:@"FilePath"] forKey:@"SlidePath"];
    [scribbleDet setValue:[NSString stringWithFormat:@"Scribble_%@_%i_%@.jpg",filName,(int)_Slideindex,dtId] forKey:@"ScribbleName"];
    
    [_ScribbleList addObject:scribbleDet];
    [BaseViewController Toast:NSLocalizedString(@"Scribble Added Successfully.", @"Scribble Added Successfully...")];
    [self CloseScribble];
}
-(IBAction)drawSqure:(id)sender{
    UIColor *lClr=[UIColor colorWithRed:self.vwScribble.red  green:self.vwScribble.green blue:self.vwScribble.blue alpha:self.vwScribble.alpha];
    
    ShapesUI *ShpSqure=[[ShapesUI alloc] initWithSqure:CGRectMake(0, 0, 150, 150) andLineColor:lClr];
    [self.vwDrawWin addSubview:ShpSqure];
}

-(IBAction)drawCircle:(id)sender{
    UIColor *lClr=[UIColor colorWithRed:self.vwScribble.red  green:self.vwScribble.green blue:self.vwScribble.blue alpha:self.vwScribble.alpha];
    
    ShapesUI *ShpCircle=[[ShapesUI alloc] initWithCircle:CGRectMake(0, 0, 150, 150) andLineColor:lClr];
    [self.vwDrawWin addSubview:ShpCircle];
}
-(IBAction)drawLine:(id)sender{
    UIColor *lClr=[UIColor colorWithRed:self.vwScribble.red  green:self.vwScribble.green blue:self.vwScribble.blue alpha:self.vwScribble.alpha];
    
    LineView *lineView = [[LineView alloc] initWithFrame:self.vwDrawWin.bounds andLineColor:lClr];
    [self.vwDrawWin addSubview:lineView];
}
-(IBAction)selPenTool:(id)sender{
    self.vwScribble.wTool=@"P";
}
-(IBAction)selEraseTool:(id)sender{
    self.vwScribble.wTool=@"E";
    [self selColorAnim:_penColorBtn SelButton:nil];
}
-(void) setPencilColorRed:(CGFloat) r Green:(CGFloat) g Blue:(CGFloat) b Alpha:(CGFloat) a{
    self.vwScribble.red=r;
    self.vwScribble.green=g;
    self.vwScribble.blue=b;
    self.vwScribble.alpha=a;
    self.vwScribble.scribbleColor=[UIColor colorWithRed:r green:g blue:b alpha:a];
}
-(IBAction) setPencilColor:(id)sender{
    CGFloat r, g, b, a;
    UIButton* BtnColor=(UIButton*)sender;
    /*UIColor* bgColor=(UIColor *) BtnColor.backgroundColor;
    _penColor=bgColor;
    [bgColor getRed:&r green:&g blue:&b alpha:&a];*/
    self.vwScribble.wTool=@"P";
    a=1.0f;
    switch (BtnColor.tag) {
        case 2:
            r=79.0f/225;g=134.0f/225;b=31.0f/255;
            break;
        case 3:
            r=48.0f/225;g=163.0f/225;b=13.0f/255;
            break;
        case 4:
            r=9.0f/225;g=91.0f/225;b=49.0f/255;
            break;
        case 5:
            r=83.0f/225;g=197.0f/225;b=178.0f/255;
            break;
        case 6:
            r=71.0f/225;g=177.0f/225;b=236.0f/255;
            break;
        case 7:
            r=90.0f/225;g=133.0f/225;b=203.0f/255;
            break;
        case 8:
            r=44.0f/225;g=36.0f/225;b=100.0f/255;
            break;
        case 9:
            r=237.0f/225;g=205.0f/225;b=0.0f/255;
            break;
        case 10:
            r=248.0f/225;g=102.0f/225;b=4.0f/255;
            break;
        case 11:
            r=187.0f/225;g=35.0f/225;b=30.0f/255;
            break;
        case 12:
            r=254.0f/225;g=181.0f/225;b=73.0f/255;
            break;
        case 13:
            r=137.0f/225;g=27.0f/225;b=21.0f/255;
            break;
        case 14:
            r=255.0f/225;g=162.0f/225;b=162.0f/255;
            break;
        case 15:
            r=211.0f/225;g=68.0f/225;b=120.0f/255;
            break;
        case 16:
            r=74.0f/225;g=31.0f/225;b=78.0f/255;
            break;
        case 17:
            r=237.0f/225;g=160.0f/225;b=116.0f/255;
            break;
        case 18:
            r=142.0f/225;g=88.0f/225;b=64.0f/255;
            break;
        case 19:
            r=87.0f/225;g=42.0f/225;b=31.0f/255;
            break;
        case 20:
            r=136.0f/225;g=136.0f/225;b=134.0f/255;
            break;
        default:
            r=0;g=0;b=0;
            break;
    }
    [self selColorAnim:_penColorBtn SelButton:BtnColor];
    if(_penColorBtn ==nil || _penColorBtn.tag!=BtnColor.tag) _penColorBtn=BtnColor;
    [self setPencilColorRed:r Green:g Blue:b Alpha:a];
}
-(void) selColorAnim:(UIButton *) prvBtn SelButton:(UIButton*) selBtn
{
    
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:0 animations:^{
        [self.view layoutIfNeeded];
        [selBtn setFrame:CGRectMake(selBtn.frame.origin.x, 710.0f, selBtn.frame.size.width, selBtn.frame.size.height)];
        if(prvBtn !=nil && prvBtn.tag!=selBtn.tag)
        {
            [prvBtn setFrame:CGRectMake(prvBtn.frame.origin.x, 727.0f, prvBtn.frame.size.width, prvBtn.frame.size.height)];
            
        }
    } completion:^(BOOL finished){}];
}

@end
