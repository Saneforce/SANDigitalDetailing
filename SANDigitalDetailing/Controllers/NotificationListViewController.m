//
//  NotificationListViewController.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/06/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "NotificationListViewController.h"
#import "MsngrCell.h"
@interface NotificationListViewController ()
@property (nonatomic, strong) NSArray* SelDepartsList;
@property (nonatomic, strong) NSMutableArray* SelMsgHeader;
@property (nonatomic, strong) NSMutableArray* SelMsgFor;
@property (nonatomic,weak) NSString* SelToDept;
@property (nonatomic,weak) NSString* MsgParent;
@property (nonatomic,strong) NSPredicate* filterPredic;
@property (nonatomic,strong) NSString* FiltrMsgHead;
@property (nonatomic,strong) NSString* FiltrMsgFor;
@property (nonatomic,strong) NSString* SelFiltrMsgHead;
@property (nonatomic,strong) NSString* SelFiltrMsgFor;

@property(nonatomic,assign) CGSize keyboardSize;
@property(nonatomic,strong) UITextField* CtxtFld;
@property(nonatomic,assign) CGFloat animatedDistance;
@end

@implementation NotificationListViewController
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
static const CGFloat ANIMATION_DURATION = 0.4;
static const CGFloat LITTLE_SPACE = 25;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
bool LoadASFilter=NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.config=[Config sharedConfig];
    self.SelDepartsList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Departs.SANAPP"] mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tvNotify.delegate=self;
    self.tvNotify.dataSource=self;
    self.tvMsgHead.delegate=self;
    self.tvMsgHead.dataSource=self;
    self.tvMsgFor.delegate=self;
    self.tvMsgFor.dataSource=self;
    
    self.clMsngrView.delegate=self;
    self.clMsngrView.dataSource=self;
    self.vwImgProfile.layer.cornerRadius=10.0f;
    CALayer* layer = [self.lblMsgFltrHadr layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.11f].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1,layer.frame.size.width, 1);
   // [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    [layer addSublayer:bottomBorder];
    [self ClearmFilter:nil];
    if ([_SelDepartsList count]>0) {
        self.lblCurrFrom.text=[_SelDepartsList[0] objectForKey:@"Name"];
        self.SelToDept=[NSString stringWithFormat:@"%@",[_SelDepartsList[0] valueForKey:@"Code"]];
        [self setFilter];
    }
    [self reloadMessages];
    
    ///UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterCmb)];
   /// [_vwFilterWin addGestureRecognizer:singleTap];
    /*self.MessageList=[[NSMutableArray alloc] init];
    NSMutableDictionary *item=[[NSMutableDictionary alloc] init];
    [item setValue:@"Notification" forKey:@"MsgSubject"];
    [item setValue:@"Good Morning" forKey:@"Message"];
    [item setValue:@"2019-09-20 10:00 AM" forKey:@"MsgDt"];
    [item setValue:[NSNumber numberWithBool:NO] forKey:@"isSender"];
    [_MessageList addObject:item];
    
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"Dr. Muralikrishnan Send Query" forKey:@"MsgSubject"];
    [item setValue:@"How do you think you would get a Physician to switch to your drug?" forKey:@"Message"];
    [item setValue:@"2019-09-20 10:00 AM" forKey:@"MsgDt"];
    [item setValue:[NSNumber numberWithBool:NO] forKey:@"isSender"];
    [_MessageList addObject:item];
    
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"You" forKey:@"MsgSubject"];
    [item setValue:@"The biggest challenge comes with a physician who is happy with his current drug. In such a case, your first step is to make your presence felt by setting small goals and making small in roads. As you gain more knowledge about the drugs and the physician’s prescribing behavior you would use your product knowledge and other tools to make the physician view your drug favorably. Then your next step is to get the physician to prescribe to one patient type, and you have a foot in the door. Follow up with the doctor to see the results on the patient type and then you can push for other patient types" forKey:@"Message"];
    [item setValue:@"2019-09-20 10:00 AM" forKey:@"MsgDt"];
    [item setValue:[NSNumber numberWithBool:YES] forKey:@"isSender"];
    [_MessageList addObject:item];
    
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"Dr. Muralikrishnan Send Scribbles" forKey:@"MsgSubject"];
    [item setValue:@"Give clear Explaination" forKey:@"Message"];
    [item setValue:@"2019-09-20 10:00 AM" forKey:@"MsgDt"];
    [item setValue:[NSNumber numberWithBool:NO] forKey:@"isSender"];
    [_MessageList addObject:item];
    
    
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"Notification" forKey:@"MsgSubject"];
    [item setValue:@"Good Morning" forKey:@"Message"];
    [item setValue:@"2019-09-20 10:00 AM" forKey:@"MsgDt"];
    [item setValue:[NSNumber numberWithBool:NO] forKey:@"isSender"];
    [_MessageList addObject:item];
    
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"Dr. Muralikrishnan Send Query" forKey:@"MsgSubject"];
    [item setValue:@"How do you think you would get a Physician to switch to your drug?" forKey:@"Message"];
    [item setValue:@"2019-09-20 10:00 AM" forKey:@"MsgDt"];
    [item setValue:[NSNumber numberWithBool:NO] forKey:@"isSender"];
    [_MessageList addObject:item];
    
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"You" forKey:@"MsgSubject"];
    [item setValue:@"who is happy with his current drug. As you gain more knowledge." forKey:@"Message"];
    [item setValue:@"2019-09-20 10:00 AM" forKey:@"MsgDt"];
    [item setValue:[NSNumber numberWithBool:YES] forKey:@"isSender"];
    [_MessageList addObject:item];
    
    item=[[NSMutableDictionary alloc] init];
    [item setValue:@"Dr. Muralikrishnan Send Scribbles" forKey:@"MsgSubject"];
    [item setValue:@"The biggest challenge comes with a physician who is happy with his current drug. In such a case, your first step is to make your presence felt by setting small goals and making small in roads. As you gain more knowledge." forKey:@"Message"];
    [item setValue:@"2019-09-20 10:00 AM" forKey:@"MsgDt"];
    [item setValue:[NSNumber numberWithBool:NO] forKey:@"isSender"];
    [_MessageList addObject:item];*/
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tvNotify) return 50;
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==_tvMsgHead) return self.SelMsgHeader.count;
    if(tableView==_tvMsgFor) return self.SelMsgFor.count;
    return self.SelDepartsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBSelectionBxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *optLst =[[NSDictionary alloc] init];
    if(tableView==_tvMsgHead) optLst = self.SelMsgHeader[indexPath.row];
    if(tableView==_tvMsgFor) optLst = self.SelMsgFor[indexPath.row];
    if(tableView==_tvNotify) {
        optLst = self.SelDepartsList[indexPath.row];
        cell.lOptImg.layer.cornerRadius=20.0f;
    }
    cell.lOptText.text=[optLst objectForKey:@"Name"];
    //cell.lOptText.text = [optLst objectForKey:@"msg"];
    //[cell.lOptText sizeToFit];
    //cell.lOptVal.text = [optLst objectForKey:@"Dt"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *optLst =[[NSDictionary alloc] init];
    if(tableView==_tvMsgHead){
         optLst = self.SelMsgHeader[indexPath.row];
         self.cmbMsgHead.text=[optLst objectForKey:@"Name"];
         self.SelFiltrMsgHead=[optLst objectForKey:@"Name"];
        _tvMsgHead.alpha=0;
    }
    if(tableView==_tvMsgFor) {
        optLst = self.SelMsgFor[indexPath.row];
        self.cmbMsgFor.text=[optLst objectForKey:@"Name"];
        self.SelFiltrMsgFor=[optLst objectForKey:@"Code"];
        _tvMsgFor.alpha=0;
    }
    if(tableView==_tvNotify) {
        optLst = self.SelDepartsList[indexPath.row];
        self.lblCurrFrom.text=[optLst objectForKey:@"Name"];
        self.SelToDept=[NSString stringWithFormat:@"%@",[optLst valueForKey:@"Code"]];
         //self.MessageList=[[self.MessagesList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"MsgOwnerID contains[c] %@", self.SelToDept]] mutableCopy];
        [self ClearmFilter:nil];
        [self setFilter];
        [self refreshMessage];
    }
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MsngrCell* cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"CellId" forIndexPath:indexPath];
    ///cell.backgroundColor=[UIColor blueColor];
    cell.lblMsgFor.text=[_MessageList[indexPath.row] valueForKey:@"MsgSubject"];
    cell.lblMsgDt.text=[_MessageList[indexPath.row] valueForKey:@"MsgDt"];
    cell.lblMsgbox.text=[_MessageList[indexPath.row] valueForKey:@"Message"];
    
    CGSize size=CGSizeMake(collectionView.frame.size.width-(collectionView.frame.size.width/4), 1000);
    CGRect lblFrame=[[NSString stringWithFormat:@"%@", [_MessageList[indexPath.row] valueForKey:@"Message"]] boundingRectWithSize:size
       options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
       attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Poppins-Regular" size: cell.lblMsgbox.font.pointSize]}
       context:nil];
    CGRect lblHeadFrame=[[NSString stringWithFormat:@"%@", [_MessageList[indexPath.row] valueForKey:@"MsgSubject"]] boundingRectWithSize:size
    options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Poppins-SemiBold" size: cell.lblMsgFor.font.pointSize]}
    context:nil];
    CGFloat xpos=10.0f;
    CGFloat wdframe=lblFrame.size.width;
    if (lblHeadFrame.size.width>wdframe) wdframe=lblHeadFrame.size.width;
    cell.btnReply.frame=CGRectMake(wdframe+45, (lblFrame.size.height/2)+30, 20, 20);
    cell.btnReply.hidden=NO;
    cell.btnReply.tag=indexPath.row;
    if([[_MessageList[indexPath.row] valueForKey:@"isSender"] boolValue]==YES){
        xpos=collectionView.frame.size.width-wdframe-25.0f;/*
        cell.MsgViewer.backgroundColor=[UIColor colorWithRed:0 green:137.0f/255 blue:249.0f/255 alpha:0.85f];
        cell.lblMsgbox.textColor=[UIColor whiteColor];
        cell.lblMsgFor.textColor=[UIColor whiteColor];*/
        cell.btnReply.hidden=YES;
    }
    
    [cell.MsgViewer setFrame:CGRectMake(xpos, 20, wdframe+15, lblFrame.size.height+20)];
   // [self showIncomingMessage:cell.MsgViewer];
    [cell.MsgVwrImg setFrame:CGRectMake(0, 0, cell.MsgViewer.frame.size.width, cell.MsgViewer.frame.size.height+20)];
    [cell.lblMsgbox setFrame:CGRectMake(8, 25, wdframe, lblFrame.size.height)];
    [cell.lblMsgFor setFrame:CGRectMake(8, 8, wdframe, 20)];
    [cell.lblMsgDt setFrame:CGRectMake(0, 0, collectionView.frame.size.width, 20)];
    //cell.MsgVwrImg.hidden=YES;//[UIColor redColor];
    cell.MsgVwrImg.contentMode=UIViewContentModeScaleToFill;
    if([[_MessageList[indexPath.row] valueForKey:@"isSender"] boolValue]==YES){
        cell.MsgVwrImg.image=[[[UIImage imageNamed:@"redbub"] resizableImageWithCapInsets:UIEdgeInsetsMake(25,42,25,42)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.MsgVwrImg.tintColor=[UIColor colorWithRed:0 green:137.0f/255 blue:249.0f/255 alpha:0.85f];
        cell.lblMsgbox.textColor=[UIColor whiteColor];
        cell.lblMsgFor.textColor=[UIColor whiteColor];
    }else{
        cell.MsgVwrImg.image=[[[UIImage imageNamed:@"lredbub"] resizableImageWithCapInsets:UIEdgeInsetsMake(25,42,25,42)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.MsgVwrImg.tintColor=[UIColor colorWithWhite:0.95 alpha:1];
            cell.lblMsgbox.textColor=[UIColor blackColor];
        cell.lblMsgFor.textColor=[UIColor blackColor];
    }
    cell.lblMsgDt.textAlignment=NSTextAlignmentCenter;
    cell.MsgViewer.layer.cornerRadius=10;
    NSMutableArray* Fileslst=[[_MessageList[indexPath.row] valueForKey:@"Files"] mutableCopy];
    
    for (UIView* b in cell.AttchFileViewer.subviews)
    {
       [b removeFromSuperview];
    }
    
    if([Fileslst count]>0){
        [cell.AttchFileViewer setFrame:CGRectMake(0, lblFrame.size.height+60, collectionView.frame.size.width, 60)];
        //cell.AttchFileViewer.backgroundColor=[UIColor grayColor];
        for(int il=0;il<[Fileslst count];il++){
        UIImageView* imgAtt=[[UIImageView alloc] init];
        NSString*url=[Fileslst[il] valueForKey:@"File_path"];

            
        url=[NSString stringWithFormat:@"%@iosserver/%@",self.config.WebUrl,url];
        [self loadAttImg:imgAtt imgurl:url];
        /**

        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        imgAtt.image = [UIImage imageWithData:imageData];
*/
        //imgAtt.image=[UIImage imageNamed:@"iSend"];
        imgAtt.contentMode=UIViewContentModeScaleToFill;
        [imgAtt setFrame:CGRectMake((collectionView.frame.size.width-((([Fileslst count]-il)*85)+5)), 5, 80, 50)];
           // imgAtt.backgroundColor=[UIColor grayColor];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewFullImage:)];
        singleTap.numberOfTapsRequired = 1;
        [imgAtt setUserInteractionEnabled:YES];
        [imgAtt addGestureRecognizer:singleTap];

        [cell.AttchFileViewer addSubview:imgAtt];
        }
    }
    //cell.lblMsgbox.backgroundColor=[UIColor whiteColor];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_MessageList count];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size=CGSizeMake(collectionView.frame.size.width-(collectionView.frame.size.width/4), 1000);
    CGRect lblFrame=[[NSString stringWithFormat:@"%@", [_MessageList[indexPath.row] valueForKey:@"Message"]] boundingRectWithSize:size
       options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
       attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Poppins-Regular" size:13.0f]}
       context:nil];
    
    NSMutableArray* Fileslst=[[_MessageList[indexPath.row] valueForKey:@"Files"] mutableCopy];
    int exH=60;
    if([Fileslst count]>0) exH=140;
    return CGSizeMake(collectionView.frame.size.width, lblFrame.size.height+exH);
    //return CGSizeMake(collectionView.frame.size.width	, 100);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(IBAction)searchDepartment:(id)sender{
   self.SelDepartsList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Departs.SANAPP"] mutableCopy];
    if (![_txtSearchDept.text isEqualToString:@""]) {
       self.SelDepartsList= [[self.SelDepartsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.txtSearchDept.text]] mutableCopy];
    }
    [_tvNotify reloadData];
}
-(IBAction) closeFullImage:(id)sender{
    _vwScrbleWin.alpha=1;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
                         self.vwScrbleWin.alpha=0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}
-(void) viewFullImage:(UITapGestureRecognizer*)sender{
    _vwScrbleWin.alpha=0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{

                         UIImageView* imgvw=(UIImageView*) sender.view;
                         self.imgScrbView.image=imgvw.image;
                         self.vwScrbleWin.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}

-(void) loadAttImg:(UIImageView*) imgView imgurl:(NSString*)sUrl{
    dispatch_async(kBgQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:sUrl]];

        dispatch_async(dispatch_get_main_queue(), ^{
            imgView.image = [UIImage imageWithData:imgData];
        });
    });
}
-(void) reloadMessages{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary* Param=[[NSMutableDictionary alloc] init];
    [Param setValue:stringFromDate forKey:@"MsgDt"];
    [WBService SendServerRequest:@"GET/Conversation" withParameter:Param withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
               NSMutableDictionary *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
               [WBService saveData:receivedDta forKey:@"MsgConversation.SANAPP"];
        
                [self refreshMessage];
           }
           error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
              NSLog(@"%@",errorMsg);
           }
        ];
    
}
-(void) setFilter{
    /*NSString *sFiltr=[NSString stringWithFormat:@"MsgOwnerID contains[c] %@", self.SelToDept];
     
    if(![self.FiltrMsgHead isEqualToString:@""]){
        sFiltr=[NSString stringWithFormat:@"%@ and MsgSubject contains[c] %@", sFiltr,self.FiltrMsgHead];
    }
    if(![self.FiltrMsgFor isEqualToString:@""]){
        sFiltr=[NSString stringWithFormat:@"%@ and MsgFor contains[c] %@", sFiltr,self.FiltrMsgFor];
    }

     self.filterPredic=[NSPredicate predicateWithFormat:sFiltr];*/
    self.filterPredic=[NSPredicate predicateWithFormat:@"MsgOwnerID contains[c] %@", self.SelToDept];
    if(![self.FiltrMsgHead isEqualToString:@""] && ![self.FiltrMsgFor isEqualToString:@""]){
        self.filterPredic=[NSPredicate predicateWithFormat:@"MsgOwnerID contains[c] %@ and MsgSubject contains[c] %@ and Ref_ID contains[c] %@",  self.SelToDept,self.FiltrMsgHead,self.FiltrMsgFor];
    }else{
        if(![self.FiltrMsgHead isEqualToString:@""]){
            self.filterPredic=[NSPredicate predicateWithFormat:@"MsgOwnerID contains[c] %@ and MsgSubject contains[c] %@",  self.SelToDept,self.FiltrMsgHead];
        }
        if(![self.FiltrMsgFor isEqualToString:@""]){
            self.filterPredic=[NSPredicate predicateWithFormat:@"MsgOwnerID contains[c] %@ and Ref_ID contains[c] %@",  self.SelToDept,self.FiltrMsgFor];
        }
        
    }
    if ([_txtSearchMsg.text isEqualToString:@""]==NO) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Message contains[c] %@",_txtSearchMsg.text];
        self.filterPredic = [NSCompoundPredicate andPredicateWithSubpredicates:@[self.filterPredic, predicate]];
    }
}
-(void) refreshMessage{
    self.MessagesList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"MsgConversation.SANAPP"] mutableCopy];
     self.MessageList=[[self.MessagesList filteredArrayUsingPredicate:self.filterPredic] mutableCopy];
    if(LoadASFilter==NO){
        self.SelMsgHeader=[[NSMutableArray alloc] init];
        self.SelMsgFor=[[NSMutableArray alloc] init];
        for (int ij=0; ij<[_MessageList count]; ij++) {
            NSMutableArray* sItms=[[self.SelMsgHeader filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@",[_MessageList[ij] valueForKey:@"MsgSubject"]]] mutableCopy];
            if([sItms count]<1){
                NSMutableDictionary* itm=[[NSMutableDictionary alloc] init];
                [itm setValue:[_MessageList[ij] valueForKey:@"MsgSubject"] forKey:@"Name"];
                [self.SelMsgHeader addObject:itm];
            }
            NSMutableArray* sItmsf=[[self.SelMsgFor filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Code contains[c] %@",[_MessageList[ij] valueForKey:@"Ref_ID"]]] mutableCopy];
            if([sItmsf count]<1){
                NSMutableDictionary* itmf=[[NSMutableDictionary alloc] init];
                [itmf setValue:[_MessageList[ij] valueForKey:@"Ref_ID"] forKey:@"Code"];
                [itmf setValue:[_MessageList[ij] valueForKey:@"Ref_ID_Name"] forKey:@"Name"];
                [self.SelMsgFor addObject:itmf];
            }
            [_tvMsgHead reloadData];
            [_tvMsgFor reloadData];
        }
    }
    [_clMsngrView reloadData];
}
-(void) clearMessage{
    _txtMsgText.text=@"";
    self.MsgParent=@"0";
    
}

- (UIImage *)imageByRenderingView:(UIView*) srcView
{
    UIGraphicsBeginImageContext(srcView.bounds.size);
    [srcView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
-(IBAction)replyMessage:(id)sender{
    UIButton *btn=(UIButton*) sender;
    MsngrCell* Cell=(MsngrCell*)[self getCollectViewCell:btn];
    long indx=btn.tag;
    UIView *mView=[[UIView alloc] initWithFrame:CGRectMake(_txtMsgText.superview.superview.frame.origin.x+10, (_txtMsgText.superview.superview.frame.origin.y+_txtMsgText.superview.superview.frame.size.height)-(_txtMsgText.superview.superview.frame.size.height/2), _txtMsgText.superview.frame.size.width-57, 115)];
    
   // UIView *mView=[[UIView alloc] initWithFrame:CGRectMake(_txtMsgText.superview.superview.frame.origin.x+10, (_txtMsgText.superview.superview.frame.origin.y+_txtMsgText.superview.superview.frame.size.height)-150, _txtMsgText.superview.frame.size.width-100, 115)];
    self.MsgParent=[self.MessageList[indx] valueForKey:@"Msg_Id" ];
    UIImageView *mImgVw=[[UIImageView alloc] initWithFrame:CGRectMake(0,-5, _txtMsgText.frame.size.width, 110)];
    btn.hidden=YES;
    mImgVw.contentMode=UIViewContentModeTopLeft;
    mImgVw.image=[self imageByRenderingView:Cell.MsgViewer];
    btn.hidden=NO;
    UIButton *btnClImg=[[UIButton alloc] initWithFrame:CGRectMake(_txtMsgText.frame.size.width-25,5,10, 10)];
    [btnClImg addTarget:self action:@selector(closeReply:) forControlEvents:UIControlEventTouchUpInside];
    [btnClImg setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [mView addSubview:mImgVw];
    [mView addSubview:btnClImg];
    mView.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:mView];
    self.vwrlpy=mView;
    mView.alpha=0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
    mView.frame=CGRectMake(_txtMsgText.superview.superview.frame.origin.x+10, (_txtMsgText.superview.superview.frame.origin.y+_txtMsgText.superview.superview.frame.size.height)-150, _txtMsgText.superview.frame.size.width-57, 115);
        mView.alpha=1;
    }completion:^(BOOL finished) {    }];
}
-(IBAction)closeReply:(id)sender{
    UIButton *btn=(UIButton*) sender;
    self.MsgParent=@"";
    self.vwrlpy=nil;
    [btn.superview removeFromSuperview];
}
-(IBAction)sendMessage:(id)sender{
    NSMutableDictionary* Messanger=[[NSMutableDictionary alloc] init];
    
    [Messanger setValue:self.SelToDept forKey:@"MsgTo"];
    [Messanger setValue:self.lblCurrFrom.text forKey:@"MsgToName"];
    [Messanger setValue:_txtMsgText.text forKey:@"MsgText"];
    [Messanger setValue:self.MsgParent forKey:@"MsgParent"];
    
    [WBService SendServerRequest:@"SAVE/Converstion" withParameter:[Messanger mutableCopy] withImages:nil
                         DataSF:nil
                     completion:^(BOOL success, id respData,NSMutableDictionary *uData)
     {
         [self reloadMessages];
        [self.vwrlpy removeFromSuperview];
        self.vwrlpy=nil;
        [self clearMessage];
        
     }
                           error:^(NSString *errorMsg,NSMutableDictionary *uData){
         [BaseViewController Toast:[NSString stringWithFormat:@"Message not sent.\n %@",errorMsg.description]];
         [SVProgressHUD dismiss];
         //[self ClearandCloseView];
    }];
}
-(IBAction)GotoHome:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction) winOpenFilter:(id)sender
{
    self.vwFilterWin.alpha=0;

    self.vwFilterWin.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width-5, self.vwFilterWin.frame.origin.y, self.vwFilterWin.frame.size.width, self.vwFilterWin.frame.size.height);
    //UIScreen.mainScreen.bounds.size.width ;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options: 0
                     animations:^{
                     self.vwFilterWin.frame=CGRectMake((UIScreen.mainScreen.bounds.size.width+5)-self.vwFilterWin.frame.size.width, self.vwFilterWin.frame.origin.y, self.vwFilterWin.frame.size.width, self.vwFilterWin.frame.size.height);
                         self.vwFilterWin.alpha=1;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}

-(IBAction) ShowMsgHead:(id)sender{
    
    _tvMsgFor.alpha=0;
    _tvMsgHead.alpha=1;
}

-(IBAction) ShowMsgFor:(id)sender{
    
    _tvMsgHead.alpha=0;
    _tvMsgFor.alpha=1;
}
-(IBAction) SearchMsg:(id) sender{
    [self setFilter];
    [self refreshMessage];
}
-(void) hideFilterCmb{
    if(_tvMsgFor.isFirstResponder || _tvMsgHead.isFirstResponder){}{
        _tvMsgFor.alpha=0;
        _tvMsgHead.alpha=0;
    }
}
-(IBAction) ApplymFilter:(id)sender
{
    self.FiltrMsgHead=self.SelFiltrMsgHead;
    if(self.FiltrMsgHead==nil) self.FiltrMsgHead=@"";
    self.FiltrMsgFor=self.SelFiltrMsgFor;
    if(self.FiltrMsgFor==nil) self.FiltrMsgFor=@"";
    LoadASFilter=YES;
    [self setFilter];
    [self refreshMessage];
}
-(IBAction) ClearmFilter:(id)sender
{
    self.cmbMsgHead.text=@"----All Headers----";
    self.FiltrMsgHead=@"";
    self.cmbMsgFor.text=@"----All Headers----";
    self.FiltrMsgFor=@"";
    [self setFilter];
    LoadASFilter=NO;
    [self refreshMessage];
}
-(IBAction) winCloseFilter:(id)sender
{
    self.vwFilterWin.alpha=1;
self.vwFilterWin.frame=CGRectMake((UIScreen.mainScreen.bounds.size.width+5)-self.vwFilterWin.frame.size.width, self.vwFilterWin.frame.origin.y, self.vwFilterWin.frame.size.width, self.vwFilterWin.frame.size.height);
    //UIScreen.mainScreen.bounds.size.width ;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: 0
                     animations:^{
                    self.vwFilterWin.frame=CGRectMake(UIScreen.mainScreen.bounds.size.width-5, self.vwFilterWin.frame.origin.y, self.vwFilterWin.frame.size.width, self.vwFilterWin.frame.size.height);
                        self.vwFilterWin.alpha=0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {   }];
}

-(IBAction)ShowSearch:(id)sender{
    CGFloat mWidth=self.txtSearchMsg.superview.bounds.size.width;
    self.txtSearchMsg.frame=CGRectMake(mWidth-38, 8,0 , 34);
    self.btnCloseSearch.frame=CGRectMake(mWidth-63 , 5,40, 40);
    self.txtSearchMsg.alpha=0;
    self.btnSearch.alpha=1;
    self.btnCloseSearch.alpha=0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
        self.txtSearchMsg.frame=CGRectMake(mWidth-348, 8,mWidth-((mWidth-348)+38), 34);
                          self.txtSearchMsg.alpha=1;
                          self.btnSearch.alpha=0;
                     }
                     completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
             delay:0.2
           options: 0
                         animations:^{
                           // self.txtSearchMsg.frame=CGRectMake(47 , 10,UIScreen.mainScreen.bounds.size.width-155, 30);
                            self.btnCloseSearch.alpha=1;
                            self.btnCloseSearch.frame=CGRectMake(mWidth-43 , 5,40, 40);
        }completion:^(BOOL finished) {    }];
     }];
    
}
-(IBAction)HideSearch:(id)sender{
    CGFloat mWidth=self.txtSearchMsg.superview.bounds.size.width;
    self.btnCloseSearch.alpha=1;
    self.btnCloseSearch.frame=CGRectMake(mWidth-43 , 5,40, 40);
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: 0
                     animations:^{
                         self.btnCloseSearch.frame=CGRectMake(mWidth-63 , 5,40, 40);
                            self.btnCloseSearch.alpha=0;
                         //self.txtSearchMsg.frame=CGRectMake(mWidth-348, 8,mWidth-((mWidth-348)+38), 34);
                                           self.btnSearch.alpha=0;
                     }
                     completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
             delay:0.2
           options: 0
                         animations:^{
                             self.txtSearchMsg.frame=CGRectMake(mWidth-38, 8,0 , 34);
                             self.txtSearchMsg.alpha=0;
                             self.btnSearch.alpha=1;
            
        }completion:^(BOOL finished) {    }];
     }];
    
}

-(UITableView *) getTableView:(UIView *)view{
    UITableView *tbView=(UITableView *) view;
    while(![tbView isKindOfClass: [UITableView class]])
    {
        tbView=(UITableView *) tbView.superview;
    }
    return tbView;
}

-(UICollectionViewCell *) getCollectViewCell:(UIView *)view{
    UICollectionViewCell *tbCell=(UICollectionViewCell *) view;
    while(![tbCell isKindOfClass: [UICollectionViewCell class]])
    {
        tbCell=(UICollectionViewCell *) tbCell.superview;
    }
    return tbCell;
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
    if(self.txtMsgText.isFirstResponder) _CtxtFld=self.txtMsgText;
    
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

-(void) showIncomingMessage:(UIView *) MsgViewer {
    CGFloat w=MsgViewer.frame.size.width;
    CGFloat h=MsgViewer.frame.size.height;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(22,h)];
    
    [bezierPath addLineToPoint:CGPointMake(w-17,h)];
    [bezierPath addCurveToPoint:CGPointMake(w,h-17) controlPoint1:CGPointMake(w-7.61,h) controlPoint2:CGPointMake(w,h-7.61)];
    [bezierPath addLineToPoint:CGPointMake(w,17)];
    [bezierPath addCurveToPoint:CGPointMake(w - 17, 0) controlPoint1: CGPointMake(w, 7.61) controlPoint2: CGPointMake(w - 7.61, 0)];
    [bezierPath addLineToPoint:CGPointMake(21, 0)];
    [bezierPath addCurveToPoint:CGPointMake(4, 17) controlPoint1: CGPointMake(11.61,0) controlPoint2: CGPointMake(4, 7.61)];
    [bezierPath addLineToPoint: CGPointMake(4, h - 11)];
    [bezierPath addCurveToPoint: CGPointMake(0, h) controlPoint1: CGPointMake(4,h - 1) controlPoint2: CGPointMake(0, h)];
    [bezierPath addLineToPoint:CGPointMake(-0.05,h - 0.01)];
    [bezierPath addCurveToPoint:CGPointMake(11.04, h - 4.04) controlPoint1: CGPointMake(4.07, h + 0.43) controlPoint2: CGPointMake(8.16,h - 1.06)];
    [bezierPath addCurveToPoint:CGPointMake(22, h) controlPoint1: CGPointMake(16,  h) controlPoint2: CGPointMake(19, h)];
    /*[bezierPath addCurveToPoint:CGPointMake(51,0) controlPoint1:CGPointMake(68,7.61) controlPoint2:CGPointMake(60.39,0)];
    [bezierPath addLineToPoint:CGPointMake(21,0)];
    [bezierPath addCurveToPoint:CGPointMake(4,17) controlPoint1:CGPointMake(11.61,0) controlPoint2:CGPointMake(4,17.61)];
    [bezierPath addLineToPoint:CGPointMake(4,23)];
    [bezierPath addCurveToPoint:CGPointMake(0,34) controlPoint1:CGPointMake(4,33) controlPoint2:CGPointMake(0,34)];

    [bezierPath addLineToPoint:CGPointMake(-0.05,33.99)];
    [bezierPath addCurveToPoint:CGPointMake(11,29.96) controlPoint1:CGPointMake(4.07,34.43) controlPoint2:CGPointMake(8.16,32.94)];
    
    [bezierPath addCurveToPoint:CGPointMake(22,34) controlPoint1:CGPointMake(16,34) controlPoint2:CGPointMake(19,34)];*/
    [bezierPath closePath];

    CAShapeLayer *incomingMessageLayer = [[CAShapeLayer alloc] init];
    incomingMessageLayer.path = bezierPath.CGPath;
    incomingMessageLayer.frame = CGRectMake(0,0,MsgViewer.frame.size.width,MsgViewer.frame.size.height);
    incomingMessageLayer.fillColor = [UIColor colorWithRed:0.09 green:0.54 blue:1 alpha:1].CGColor;

    [MsgViewer.layer  addSublayer:incomingMessageLayer];
}
@end

