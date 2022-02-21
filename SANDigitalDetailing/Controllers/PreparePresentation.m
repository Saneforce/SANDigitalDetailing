//
//  PreparePresentation.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 16/03/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "PreparePresentation.h"
#import "mSlideCell.h"
#import "TBSelectionBxCell.h"
#import "ImageScale.h"
@interface PreparePresentation()

@property (nonatomic,strong) UIButton* btnDelete;
    @property (nonatomic,strong) NSArray* OrgAllSlides;
    @property (nonatomic,strong) NSMutableArray* AllGroupSlides;
    @property (nonatomic,strong) NSMutableArray* prodcutSlide;

    @property (nonatomic,strong) NSMutableArray* currSlideList;
    @property (nonatomic,strong) NSMutableArray* UniqueSlides;
    @property (nonatomic,strong) NSMutableArray* PrsntGrpList;
    @property (nonatomic,strong) NSMutableArray* AllSlides;//ProductsList

    @property (nonatomic,assign) long PrvIndx;//ProductsList



@property (nonatomic,strong) NSMutableArray* SelectedSlides;

@end

@implementation PreparePresentation
NSIndexPath *indexPathOfMovingCell;bool _Dragable;bool _EditMode;

-(void)viewDidLoad{
    _PrvIndx=-1;
    self.slideCollectionView.delegate = self;
    self.slideCollectionView.dataSource = self;
    self.prodCollectionView.delegate = self;
    self.prodCollectionView.dataSource = self;
    
    self.tvPrsntGrpList.delegate = self;
    self.tvPrsntGrpList.dataSource = self;
    
    self.txtGroupName.delegate = self;
    
    _ddrPrsntGrp.layer.cornerRadius=9.0f;
    _tvPrsntGrpList.layer.cornerRadius=9.0f;
    _ddrPrsntGrp.layer.borderWidth=4.0f;
    //_tvPrsntGrpList.layer.borderWidth=4.0f;
    UIColor* imageBorderColor = [UIColor colorWithRed:242.0/255 green:245.0/255 blue:250.0/255 alpha:0.4f];
    _ddrPrsntGrp.layer.borderColor=imageBorderColor.CGColor;
    //_tvPrsntGrpList.layer.borderColor=imageBorderColor.CGColor;
    
    _tvPrsntGrpList.cellLayoutMarginsFollowReadableWidth = NO;
    
    self.prodcutSlide = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SlideBrand.SANAPP"] mutableCopy];
    self.OrgAllSlides =[[[NSUserDefaults standardUserDefaults] objectForKey:@"ProdSlides.SANAPP"] mutableCopy];
    //self.UniqueSlides =[[[NSUserDefaults standardUserDefaults] objectForKey:@"UniqueProdSlides.SANAPP"] mutableCopy];
    self.UniqueSlides = [self filterProductBrand:self.prodcutSlide];

    self.AllGroupSlides=[[[NSUserDefaults standardUserDefaults] objectForKey:@"GroupSlides.SANAPP"]     mutableCopy];
    if(self.OrgAllSlides==nil) self.OrgAllSlides=[[[NSMutableArray alloc] init] mutableCopy];
    if(self.UniqueSlides==nil) self.UniqueSlides=[[[NSMutableArray alloc] init] mutableCopy];
    if(self.AllGroupSlides==nil) self.AllGroupSlides=[[[NSMutableArray alloc] init] mutableCopy];
    self.AllSlides =[self.OrgAllSlides mutableCopy];
    
    self.SelectedSlides=[[[NSArray alloc] init] mutableCopy];
    self.currSlideList=[[[NSMutableArray alloc] init] mutableCopy];
    if (self.UniqueSlides.count>0)
    {
        self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", [self.UniqueSlides[0] valueForKey:@"Code"]]] mutableCopy];
    }
    self.btnBack.layer.cornerRadius=15.0f;
    
    
    
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    UITapGestureRecognizer* PressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CloseModalPresentation:)];

    
    longPressGesture.delegate = self;
    PressGesture.delegate = self;
    PressGesture.cancelsTouchesInView =NO;
    
    _EditMode=NO;
    _btnCancelEdit.hidden=YES;

    self.btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDelete.frame=CGRectMake(self.txtGroupName.superview.frame.origin.x-(self.txtGroupName.frame.size.height), self.txtGroupName.frame.origin.y-4, self.txtGroupName.frame.size.height+8, self.txtGroupName.frame.size.height+8);
    [self.btnDelete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.btnDelete setTitle:NSLocalizedString(@"Delete", @"Delete") forState:UIControlStateNormal];
    [self.btnDelete addTarget:self action:@selector(deleteSlidesGroup:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancelEdit.superview addSubview:self.btnDelete];
    
    self.btnDelete.hidden=YES;
    [self.slideCollectionView addGestureRecognizer:longPressGesture];
    [self.ddrPrsntModal addGestureRecognizer:PressGesture];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count=0;
    if(collectionView==self.slideCollectionView) count=self.currSlideList.count;
    if(collectionView==self.prodCollectionView) count=self.UniqueSlides.count;
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    mSlideCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    NSMutableArray *Selitem=[[NSMutableArray alloc] init];
    NSDictionary *optLst=[[NSDictionary alloc] init];
    
    if(collectionView==self.prodCollectionView){
        
        optLst=[self.UniqueSlides[indexPath.row] mutableCopy];
        Selitem = [[self.SelectedSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [optLst objectForKey:@"Code"]]] mutableCopy];
        
        
        
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
        cell.titleLabel.text = [optLst objectForKey:@"Name"];
    }
    else if(collectionView==self.slideCollectionView)
    {
        NSMutableArray *arr = [self.currSlideList mutableCopy];
        arr = [self sortArrayOnPriority:arr ];
        optLst=[arr[indexPath.row] mutableCopy];
        NSDictionary *effDt=[optLst objectForKey:@"Eff_from"];
        NSDate *dteff=[BaseViewController str2date:[effDt valueForKey:@"date"]];
        NSString *EffDT=[BaseViewController date2str:dteff onlyDate:YES];
    
        NSString *SlidesDirectory = [BaseViewController getSlidesDirectory];
        NSString *fileName=[NSString stringWithFormat:@"%@/%@",EffDT,[optLst objectForKey:@"FilePath"]];
    
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
        /*if([[optLst objectForKey:@"FileTyp"] isEqual:@"H"]){
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
        cell.ImgView.layer.borderWidth=1;*/
    
        Selitem = [[self.SelectedSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@ and FilePath==%@", [optLst objectForKey:@"Code"],[optLst objectForKey:@"FilePath"]]] mutableCopy];
    }
    cell.Selected=([Selitem count]>0)?YES:NO;
    cell.ImgView.alpha =(cell.Selected==YES)?1.0f:0.2f;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    mSlideCell *cell = (mSlideCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray *Selitem=[[NSMutableArray alloc] init];
    NSDictionary *optLst=[[NSDictionary alloc] init];
    if(collectionView==_prodCollectionView){
        optLst=[self.UniqueSlides[indexPath.row] mutableCopy];
        Selitem = [[self.SelectedSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@", [optLst objectForKey:@"Code"]]] mutableCopy];
        if (self.PrvIndx==indexPath.row && cell.Selected==true){
            
            [cell.ImgView setAlpha:0.2f];
            cell.Selected=false;
        }
        else if(_PrvIndx!=indexPath.row && cell.Selected==true){
            _PrvIndx=indexPath.row;
            cell.Selected=true;
            [self performSelector:@selector(ResetIndex) withObject:nil afterDelay:0.5];
        }
        else{
            [cell.ImgView setAlpha:1.0f];cell.Selected=true;
        }
        
        self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp!=\"C\"", [self.UniqueSlides[indexPath.row] valueForKey:@"Code"]]] mutableCopy];
        if([Selitem count]<=0)
        {
//            self.SelectedSlides= [[self.SelectedSlides arrayByAddingObjectsFromArray:self.currSlideList] mutableCopy];
        }
        else if(cell.Selected==false)
        {
            [self.SelectedSlides removeObjectsInArray:Selitem];
        }
        [self.slideCollectionView reloadData];
        
    }
    else if(collectionView==_slideCollectionView)
    {
        optLst=[self.currSlideList[indexPath.row] mutableCopy];
        Selitem = [[self.SelectedSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SlideId==%@", [optLst objectForKey:@"SlideId"]]] mutableCopy];
        
        cell.Selected=([Selitem count]>0)?NO:YES;
        if(cell.Selected==YES)
        {
            [optLst setValue:[[NSNumber numberWithInteger:(indexPath.row+1)] stringValue] forKey:@"OrdNo"];
            [self.SelectedSlides addObject:optLst];
            for(int il=0;il<[_currSlideList count];il++){
                NSMutableArray *Selitem = [[self.SelectedSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SlideId==%@", [_currSlideList[il] objectForKey:@"SlideId"]]] mutableCopy];
                if([Selitem count]>0)
                {
                    NSMutableDictionary *nitem =[Selitem[0] mutableCopy];
                    [self.SelectedSlides removeObject:Selitem[0]];
                    [nitem setValue:[[NSNumber numberWithInteger:(il+1)] stringValue] forKey:@"OrdNo"];
                    [self.SelectedSlides addObject:nitem];
                }
            }
            
        }else
            [self.SelectedSlides removeObject:Selitem[0]];
        
        [self.prodCollectionView reloadData];
    }
    
    cell.ImgView.alpha =(cell.Selected==YES)?1.0f:0.2f;
    
    [cell setNeedsDisplay];
}

//user table view events

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tvPrsntGrpList) return self.AllGroupSlides.count;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    NSDictionary *optLst=[[NSDictionary alloc] init];
    
    cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(tableView==self.tvPrsntGrpList){
        optLst = [self.AllGroupSlides[indexPath.row]mutableCopy];
        cell.lOptText.text = [optLst objectForKey:@"GroupName"];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    _AllSlides=[_OrgAllSlides mutableCopy];
    NSMutableDictionary *optlst = self.AllGroupSlides[indexPath.row];
    self.SelectedSlides = [[optlst objectForKey:@"GroupSlides"] mutableCopy];
    
    for(int i=0;i<[self.SelectedSlides count];i++)
    {
        
        NSDictionary *optLst=self.SelectedSlides[i];
        
        self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ and FileTyp!=\"C\"", [optLst valueForKey:@"Code"]]] mutableCopy];
        NSMutableArray* Selitem = [[self.currSlideList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SlideId==%@", [optLst objectForKey:@"SlideId"]]] mutableCopy];
        
        [self.AllSlides removeObjectsInArray:self.currSlideList];
        [self.currSlideList removeObject:Selitem[0]];
        [self.currSlideList insertObject:optLst atIndex:[[optLst objectForKey:@"OrdNo"] integerValue]-1];
        self.AllSlides= [[self.AllSlides arrayByAddingObjectsFromArray:self.currSlideList] mutableCopy];
    }
    [_slideCollectionView reloadData];
    [_prodCollectionView reloadData];
    _txtGroupName.text=[optlst objectForKey:@"GroupName"];
    _EditMode=YES;
    [_txtGroupName resignFirstResponder];
    _btnDelete.hidden=NO;
    _btnCancelEdit.hidden=NO;
    _ddrPrsntModal.hidden=YES;
    
}

-(void) deleteSlidesGroup:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SAN Digital Detailing"
                                                        message:NSLocalizedString(@"Do you want delete the Presentation",@"Do you want delete the Presentation")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                              otherButtonTitles:NSLocalizedString(@"Ok",@"Ok"), nil];
    
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSMutableArray *Selitem = [[self.AllGroupSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"GroupName contains[c] %@", self.txtGroupName.text]] mutableCopy];
        if([Selitem count]>0) [self.AllGroupSlides removeObject:Selitem[0]];
        
        [[NSUserDefaults standardUserDefaults] setObject:_AllGroupSlides forKey:@"GroupSlides.SANAPP"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self CancelEdit];
    }
}

-(IBAction)SaveSlideGroup:(id)sender{
    if([self.txtGroupName.text isEqualToString:@""]){
        [BaseViewController Toast:@"Please Enter Presentation Name!"];
        
    }else{
        
        NSMutableArray *Selitem = [[self.AllGroupSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"GroupName contains[c] %@", self.txtGroupName.text]] mutableCopy];
        if([Selitem count]>0) [self.AllGroupSlides removeObject:Selitem[0]];
        NSInteger max = [[_AllGroupSlides valueForKeyPath:@"@max.GroupId"] integerValue];
        if(max==0) max=9;
        max=max+1;
        NSMutableDictionary *GrpSlide=[[NSMutableDictionary alloc] init];
        [GrpSlide setValue:[NSNumber numberWithInteger:max]  forKey:@"GroupId"];
        [GrpSlide setValue:self.txtGroupName.text forKey:@"GroupName"];
        [GrpSlide setValue:self.SelectedSlides forKey:@"GroupSlides"];
        [_AllGroupSlides addObject:GrpSlide];
        
        [[NSUserDefaults standardUserDefaults] setObject:_AllGroupSlides forKey:@"GroupSlides.SANAPP"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self CancelEdit];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return (_EditMode==NO);
}

-(IBAction)CancelEditMode:(id)sender
{
    [self CancelEdit];
}
-(void)CancelEdit{
    _AllSlides=[_OrgAllSlides mutableCopy];
    self.SelectedSlides=[[[NSArray alloc] init] mutableCopy];
    self.currSlideList=[[[NSMutableArray alloc] init] mutableCopy];
    if (self.UniqueSlides.count>0) {self.currSlideList= [[self.AllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@", [self.UniqueSlides[0] valueForKey:@"Code"]]] mutableCopy];
    }
    [_slideCollectionView reloadData];
    [_prodCollectionView reloadData];
    _EditMode=NO;
    _txtGroupName.text=@"";
    [_txtGroupName resignFirstResponder];
    _btnDelete.hidden=YES;
    _btnCancelEdit.hidden=YES;
    _ddrPrsntModal.hidden=YES;
    [_tvPrsntGrpList reloadData];

}
-(IBAction)ShowPresentationGroup:(id)sender
{
    _ddrPrsntModal.hidden=NO;
}

-(IBAction)CancelPresentation:(id)sender
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-2] animated:NO];
}

-(void)ResetIndex{
    _PrvIndx=-1;
}
-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)longpressRecognizer {
    
    CGPoint locationPoint = [longpressRecognizer locationInView:self.slideCollectionView];
    
    if (longpressRecognizer.state == UIGestureRecognizerStateBegan) {
        
        indexPathOfMovingCell = [self.slideCollectionView indexPathForItemAtPoint:locationPoint];
        
        NSMutableDictionary *optLst=[self.currSlideList[indexPathOfMovingCell.row] mutableCopy];
        NSArray *Selitem = [self.SelectedSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SlideId==%@", [optLst objectForKey:@"SlideId"]]];
        _Dragable=NO;
        if([Selitem count]>0)
        {
            _Dragable=YES;

            UICollectionViewCell *cell = [self.slideCollectionView cellForItemAtIndexPath:indexPathOfMovingCell];
        
            UIGraphicsBeginImageContext(cell.bounds.size);
            [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        
            self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
            [self.movingCell setCenter:locationPoint];
            [self.movingCell setAlpha:0.75f];
            [self.slideCollectionView addSubview:self.movingCell];
        }
        
    }
    if (longpressRecognizer.state == UIGestureRecognizerStateChanged && _Dragable==YES) {
        [self.movingCell setCenter:locationPoint];
    }
    
    if (longpressRecognizer.state == UIGestureRecognizerStateEnded && _Dragable==YES) {
        NSIndexPath *atIndexPath=indexPathOfMovingCell;
        NSIndexPath *toIndexPath=[self.slideCollectionView indexPathForItemAtPoint:locationPoint];
        NSLog(@"%ld",(long)toIndexPath.row);
        [self.slideCollectionView moveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath];
        [self.movingCell removeFromSuperview];
        
        NSMutableDictionary *optLst=[self.currSlideList[atIndexPath.row] mutableCopy];
        
        [self.AllSlides removeObjectsInArray:self.currSlideList];
        [self.currSlideList removeObjectAtIndex:atIndexPath.row];
        [self.currSlideList insertObject:optLst atIndex:toIndexPath.row];
        for(int il=0;il<[_currSlideList count];il++){
            NSMutableArray *Selitem = [[self.SelectedSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SlideId==%@", [_currSlideList[il] objectForKey:@"SlideId"]]] mutableCopy];
            if([Selitem count]>0)
            {
                NSMutableDictionary *nitem =[Selitem[0] mutableCopy];
                [self.SelectedSlides removeObject:Selitem[0]];
                [nitem setValue:[[NSNumber numberWithInteger:(il+1)] stringValue] forKey:@"OrdNo"];
                [self.SelectedSlides addObject:nitem];
            }
        }
        self.AllSlides= [[self.AllSlides arrayByAddingObjectsFromArray:self.currSlideList] mutableCopy];
        
        

        
    }
}

-(NSMutableArray *)sortArrayOnPriority :(NSMutableArray *)arrToSort
{
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"Priority"
        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    return [[arrToSort sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}
-(void)CloseModalPresentation:(UITapGestureRecognizer *) pressRecognizer {
    CGPoint startPoint = [pressRecognizer locationInView:self.view];
    if(!CGRectContainsPoint(_ddrPrsntGrp.frame, startPoint)){
        _ddrPrsntModal.hidden=YES;
    }
}

-(NSMutableArray *)filterProductBrand:(NSArray *)arrData
{
    NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrData.count; i++) {
        
        
        self.UniqueSlides = [[self.OrgAllSlides filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code == %@ && Priority == %@", [arrData[i] valueForKey:@"Product_Brd_Code"],@"1"]] mutableCopy];
        [arrResponse addObjectsFromArray:self.UniqueSlides];
    }

    return arrResponse;
    
}
@end
