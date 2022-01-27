//
//  MeetingCalenderVC.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 02/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import "MeetingCalenderVC.h"
#import "GraphManager.h"
#import "AuthenticationManager.h"
#import "KeyboardView.h"
#import "NSDate+MSSerialization.h"
@interface MeetingCalenderVC ()

    @property(nonatomic,assign) CGSize keyboardSize;
    @property(nonatomic,strong) UITextView* CtxtFld;
    @property(nonatomic,assign) CGFloat animatedDistance;

    @property (nonatomic, strong) NSMutableArray* ObjCustomerList;
    @property (nonatomic, strong) NSMutableArray* ObjCustList;
    @property (nonatomic, strong) NSMutableArray* ObjSelData;
    @property (nonatomic, strong) NSMutableArray* ObjAllSelData;
    @property (nonatomic, strong) NSMutableArray* JWList;

    @property(nonatomic,retain) NSString* SelPartIDs;
    @property(nonatomic,retain) NSString* SelPartMails;
    @property(nonatomic,retain) NSString* SelDrIDs;
    @property(nonatomic,retain) NSString* SelDrMails;

    @property(nonatomic,retain) NSString* EditMeetID;
    @property(nonatomic,retain) NSString* EditMeetUrl;


    @property (nonatomic, strong) NSArray* Durations;
    @property (nonatomic, strong) NSArray* Hours;
    @property (nonatomic, strong) NSArray* Mins;
    @property (nonatomic, assign) BOOL isEditing;
@end

@implementation MeetingCalenderVC
    int SelMonth,SelYear,intMode;
NSString* SelItmsID;
NSString* SelItmsNm;
NSString* SelItmsMails;
NSString* SelRItmsID;
NSString* SelRItmsNm;
NSString* SelRItmsMails;
static const CGFloat ANIMATION_DURATION = 0.4;
static const CGFloat LITTLE_SPACE = 25;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UserDet=[UserDetails sharedUserDetails];
    self.meetData=[CallMeetData sharedDatas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.CalenderView.delegate=self;
    self.CalenderView.dataSource=self;
    self.selTableView.delegate=self;
    self.selTableView.dataSource=self;
    self.tbMeetDetails.delegate=self;
    self.tbMeetDetails.dataSource=self;
    
    self.tbReqCusts.delegate=self;
    self.tbReqCusts.dataSource=self;
    
    _txEventCust.delegate=self;
    _txEventDtTm.delegate=self;
    _txEventDur.delegate=self;
    _txEventParticipants.delegate=self;
    _txEventDesc.delegate=self;
    
    _txEventDesc.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _txEventDesc.layer.cornerRadius=5;
    _txEventDesc.layer.borderWidth=0.3f;
    self.lblDispSF.text=self.UserDet.SFName;
    
    
    self.Durations=[[NSArray alloc] initWithObjects:@{@"Id":@"15",@"Name":@"00 Hours 15 Min"},@{@"Id":@"30",@"Name":@"00 Hours 30 Min"},@{@"Id":@"45",@"Name":@"00 Hours 45 Min"},@{@"Id":@"60",@"Name":@"01 Hours 00 Min"},@{@"Id":@"75",@"Name":@"01 Hours 15 Min"},@{@"Id":@"90",@"Name":@"01 Hours 30 Min"},@{@"Id":@"105",@"Name":@"01 Hours 45 Min"},@{@"Id":@"120",@"Name":@"02 Hours 00 Min"},@{@"Id":@"135",@"Name":@"02 Hours 15 Min"},@{@"Id":@"150",@"Name":@"02 Hours 30 Min"},@{@"Id":@"165",@"Name":@"02 Hours 45 Min"},@{@"Id":@"180",@"Name":@"03 Hours 00 Min"},@{@"Id":@"195",@"Name":@"03 Hours 15 Min"},@{@"Id":@"210",@"Name":@"03 Hours 30 Min"},@{@"Id":@"225",@"Name":@"03 Hours 45 Min"},@{@"Id":@"240",@"Name":@"04 Hours 00 Min"},@{@"Id":@"255",@"Name":@"04 Hours 15 Min"},@{@"Id":@"270",@"Name":@"04 Hours 30 Min"},@{@"Id":@"285",@"Name":@"04 Hours 45 Min"},@{@"Id":@"300",@"Name":@"05 Hours 00 Min"},@{@"Id":@"315",@"Name":@"05 Hours 15 Min"},@{@"Id":@"330",@"Name":@"05 Hours 30 Min"},@{@"Id":@"345",@"Name":@"05 Hours 45 Min"},@{@"Id":@"360",@"Name":@"06 Hours 00 Min"},@{@"Id":@"375",@"Name":@"06 Hours 15 Min"},@{@"Id":@"390",@"Name":@"06 Hours 30 Min"},@{@"Id":@"405",@"Name":@"06 Hours 45 Min"},@{@"Id":@"420",@"Name":@"07 Hours 00 Min"},@{@"Id":@"435",@"Name":@"07 Hours 15 Min"},@{@"Id":@"450",@"Name":@"07 Hours 30 Min"},@{@"Id":@"465",@"Name":@"07 Hours 45 Min"},@{@"Id":@"480",@"Name":@"08 Hours 00 Min"},@{@"Id":@"495",@"Name":@"08 Hours 15 Min"},@{@"Id":@"510",@"Name":@"08 Hours 30 Min"},@{@"Id":@"525",@"Name":@"08 Hours 45 Min"},@{@"Id":@"540",@"Name":@"09 Hours 00 Min"},@{@"Id":@"555",@"Name":@"09 Hours 15 Min"},@{@"Id":@"570",@"Name":@"09 Hours 30 Min"},@{@"Id":@"585",@"Name":@"09 Hours 45 Min"},@{@"Id":@"600",@"Name":@"10 Hours 00 Min"},@{@"Id":@"615",@"Name":@"10 Hours 15 Min"},@{@"Id":@"630",@"Name":@"10 Hours 30 Min"},@{@"Id":@"645",@"Name":@"10 Hours 45 Min"},@{@"Id":@"660",@"Name":@"11 Hours 00 Min"},@{@"Id":@"675",@"Name":@"11 Hours 15 Min"},@{@"Id":@"690",@"Name":@"11 Hours 30 Min"},@{@"Id":@"705",@"Name":@"11 Hours 45 Min"},@{@"Id":@"720",@"Name":@"12 Hours 00 Min"}, nil];
    self.Hours=[[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    self.Mins=[[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59", nil];
    NSString *DataKey=[[NSString alloc] initWithFormat:@"DoctorDetails_%@.SANAPP",self.UserDet.SF];
    self.ObjCustomerList =[[[NSUserDefaults standardUserDefaults] objectForKey:DataKey] mutableCopy];
    
    NSSortDescriptor *NameField = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:NameField, nil];
    
    self.ObjCustomerList = [[self.ObjCustomerList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [myFormatter setDateFormat:@"yyyy"];
    int Yr=(int)[[myFormatter stringFromDate:[NSDate date]] intValue];
    [myFormatter setDateFormat:@"MM"];
    int Mnth=(int)[[myFormatter stringFromDate:[NSDate date]] intValue];

    SelMonth=Mnth;
    SelYear=Yr;
    NSDate* TPDate=[BaseViewController str2date:[NSString stringWithFormat:@"%d-%d-01 00:00:00",SelYear,SelMonth]];
    [self prepareCalender:TPDate];
    _vwAddModalView.hidden=YES;
    SelItmsID=@"";
    SelItmsNm=@"";SelItmsMails=@"";
    _SelDrIDs=@"";
    _SelDrMails=@"";
    _SelPartIDs=@"";
    _SelPartMails=@"";
    SelRItmsID=@"";
    SelRItmsNm=@"";SelRItmsMails=@"";
    self.JWList =[[[NSUserDefaults standardUserDefaults] objectForKey:[[NSString alloc] initWithFormat:@"JointWork_%@.SANAPP",self.UserDet.SF]] mutableCopy];
    //self.FeedBkList=@[@"Not Accepted",@"Partially Accepted",@"Accepted"];
    
    //self.JWList=[[self.JWList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Typ.intValue!=1"]] mutableCopy];
}
-(IBAction)movePrvMonth:(id)sender{
    NSDate* TPDate=[self GetPrvMonth];
    [self prepareCalender:TPDate];
}

-(IBAction)moveNextMonth:(id)sender{
    NSDate* TPDate=[self GetNextMonth];
    [self prepareCalender:TPDate];
}

-(IBAction) CloseWindow:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeetingCalenderVC *popVC = [storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
    //[self presentViewController:popVC animated:YES completion:nil];
    [self showViewController:popVC sender:self];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger tag=textField.tag;
    if(tag>0) return NO;
    return YES;
}
-(void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    _keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _CtxtFld=NULL;
    if(self.txEventDesc.isFirstResponder) _CtxtFld=self.txEventDesc;
    
    
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

-(IBAction) OpenSelWindow:(id)sender{
    UITextField *tx=(UITextField*) sender;intMode=0;
    _txtSelSearch.text=@"";
    if(tx==_txEventDtTm) {
        _DtTmPicker.hidden=NO;
        intMode=5;
        _selTableView.hidden=YES;
    }else{
        _DtTmPicker.hidden=YES;
        _selTableView.hidden=NO;
    }
    _ObjSelData=[[NSMutableArray alloc] init];
    _ObjAllSelData=[[NSMutableArray alloc] init];
    if(tx==_txEventCust)
    {
        _selWinCaption.text=NSLocalizedString(@"Select the Customer", @"Select the Customer");
        SelItmsID=_SelDrIDs;
        SelItmsNm=_txEventCust.text;
        SelItmsMails=_SelDrMails;
        _ObjSelData=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CContact==%@",[NSString stringWithFormat:@"1"]]] mutableCopy];
        _ObjAllSelData=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CContact==%@",[NSString stringWithFormat:@"1"]]] mutableCopy];
        intMode=1;
    }
    if(tx==_txEventParticipants)
    {
        _selWinCaption.text=NSLocalizedString(@"Select the Participants", @"Select the Participants");
        SelItmsID=_SelPartIDs;
        SelItmsNm=_txEventParticipants.text;
        SelItmsMails=_SelPartMails;
        _ObjSelData=[self.JWList mutableCopy];
        _ObjAllSelData=[self.JWList mutableCopy];
        intMode=2;
    }
    if(tx==_txEventDur)
    {
        _selWinCaption.text=NSLocalizedString(@"Select the Duration", @"Select the Duration");
        _ObjSelData=[self.Durations mutableCopy];
        _ObjAllSelData=[self.Durations mutableCopy];
        
    }
    [_selTableView reloadData];
    self.vwAddSelView.hidden=NO;
}
-(void)ClearForms{
    _txEventReqTitle.text=@"";
    _txEventTitle.text=@"";
    _txEventParticipants.text=@"";
    _txEventCust.text=@"";
    _txEventDur.text=@"";
    _txEventDtTm.text=@"";
    _txEventDesc.text=@"";
    
    SelItmsID=@"";
    SelItmsMails=@"";
    _SelDrIDs=@"";
    _SelDrMails=@"";
    _SelPartIDs=@"";
    _SelPartMails=@"";
    SelItmsMails=@"";
    SelRItmsID=@"";
    SelRItmsMails=@"";
}
-(IBAction) setSelValues:(id)sender{
    if(intMode==1){
        _txEventCust.text=SelItmsNm;
        self.SelDrIDs=SelItmsID;
        self.SelDrMails=SelItmsMails;
    }else if(intMode==2){
        _txEventParticipants.text=SelItmsNm;
        self.SelPartIDs=SelItmsID;
        self.SelPartMails=SelItmsMails;
    }if(intMode==5){
        _txEventDtTm.text=[BaseViewController  date2str:_DtTmPicker.date onlyDate:false];
    }
    self.vwAddSelView.hidden=YES;

}
-(IBAction) CloseSelWindow:(id)sender{
    _txtSelSearch.text=@"";
    self.vwAddSelView.hidden=YES;
}

-(IBAction) OpenModalWindow:(id)sender{
    [self ClearForms];
    _isEditing=NO;
    [_segEvtType setSelectedSegmentIndex:0];
    _vwReqForm.hidden=YES;
    self.vwAddModalView.hidden=NO;
}
-(IBAction) CloseModalWindow:(id)sender{
    [self ClearForms];
    self.vwAddModalView.hidden=YES;
    self.vwMeetDetails.hidden=YES;
}
-(IBAction) editMeeting:(id)sender{
    UIButton* btn=(UIButton*) sender;
    _isEditing=YES;
    [_segEvtType setSelectedSegmentIndex:0];
    _vwReqForm.hidden=YES;
    NSArray* DrCds=[[_DayMeetDatas[btn.tag] valueForKey:@"DrDets"] componentsSeparatedByString:@","];
    NSArray* PrtCds=[[_DayMeetDatas[btn.tag] valueForKey:@"Parti"] componentsSeparatedByString:@","];
    _EditMeetID=[_DayMeetDatas[btn.tag] valueForKey:@"API_Meeting_ID"];
    _EditMeetUrl=[_DayMeetDatas[btn.tag] valueForKey:@"API_Meeting_Url"];
    SelItmsID=@"";
    SelItmsNm=@"";
    SelItmsMails=@"";
    if([DrCds count]>0){
        for(int il=0;il<[DrCds count]-1;il++){
            NSArray* DrDets=[DrCds[il]  componentsSeparatedByString:@"^"];
            SelItmsID=[NSString stringWithFormat:@"%@%@;",SelItmsID,DrDets[0]];
            SelItmsNm=[NSString stringWithFormat:@"%@%@;",SelItmsNm,DrDets[1]];
            SelItmsMails=[NSString stringWithFormat:@"%@%@;",SelItmsMails,DrDets[5]];
        }
        
    }
    SelRItmsID=@"";
    SelRItmsNm=@"";
    SelRItmsMails=@"";
    if([PrtCds count]>0){
        for(int il=0;il<[PrtCds count]-1;il++){
            NSArray* prDets=[PrtCds[il]  componentsSeparatedByString:@"^"];
            SelRItmsID=[NSString stringWithFormat:@"%@%@;",SelItmsID,prDets[0]];
            SelRItmsNm=[NSString stringWithFormat:@"%@%@;",SelRItmsNm,prDets[1]];
            SelRItmsMails=[NSString stringWithFormat:@"%@%@;",SelRItmsMails,prDets[2]];
        }
        
    }
    
    NSMutableArray* itm=[[_Durations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Id==%@",[_DayMeetDatas[btn.tag] objectForKey:@"Dur"]]] mutableCopy];
    
    _txEventTitle.text=[self.DayMeetDatas[btn.tag] valueForKey:@"Meeting_Sub"];
    
    _SelDrIDs=SelItmsID;
    _SelDrMails=SelItmsMails;
    _txEventCust.text=SelItmsNm;
    
    _txEventDtTm.text=[[_DayMeetDatas[btn.tag] objectForKey:@"Sch_StartTime"] objectForKey:@"date"];
    
    _txEventDur.text=@"";
    _txEventDur.tag=0;
    if ([itm count]>0) {
        _txEventDur.text=[itm[0] valueForKey:@"Name"];
        _txEventDur.tag=[[itm[0] valueForKey:@"Id"] intValue];
    }
    
    _txEventDesc.text=[_DayMeetDatas[btn.tag] objectForKey:@"MeetDesc"];
    
    _SelPartIDs=SelRItmsID;
    _SelPartMails=SelRItmsMails;
    _txEventParticipants.text=SelRItmsNm;
    self.vwAddModalView.hidden=NO;
}
-(IBAction) openMeeting:(id)sender{
    UIButton* btn=(UIButton*) sender;
    NSString* Dtstr=[[_DayMeetDatas[btn.tag] objectForKey:@"Sch_EndTime"] objectForKey:@"date"];
    NSDate* Dt=[BaseViewController str2date:Dtstr];
    NSDate* Dt1=[NSDate date];
    if(Dt<Dt1){
        [btn setTitle:NSLocalizedString(@"Meeting Ended", @"Meeting Ended") forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1.0f];
        btn.enabled=NO;
        [BaseViewController Toast:NSLocalizedString(@"You can't Start this Meeting...", @"You can't Start this Meeting...")];
    }
    NSString* url=[[_DayMeetDatas[btn.tag] valueForKey:@"API_Meeting_Url"]  stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    
    NSString *mystr=[[NSString alloc] initWithFormat:@"msteams://%@",url];
    NSLog(@"%@",mystr);
    NSURL *myurl=[[NSURL alloc] initWithString:mystr];
    
    [[UIApplication sharedApplication] openURL:myurl];
    
    NSArray* DrCds=[[_DayMeetDatas[btn.tag] valueForKey:@"DrDets"] componentsSeparatedByString:@","];
    if([DrCds count]>0){
        NSArray* DrDets=[DrCds[0] componentsSeparatedByString:@"^"];
        self.meetData.CustCode=DrDets[0];
        self.meetData.CustName=DrDets[1];
        self.meetData.CusType=@"1";
        self.meetData.SpecCode=DrDets[2];
        self.meetData.CateCode=DrDets[3];
        self.meetData.vstTime=[BaseViewController getDateTime];
        self.meetData.ModTime=[BaseViewController getDateTime];
        self.meetData.DataSF=DrDets[4];
        NSMutableArray* sArr=[[NSMutableArray alloc] init];
        for(int il=1;il<[DrCds count]-1;il++){
            NSMutableDictionary* itm=[[NSMutableDictionary alloc] init];
            NSArray* DrDets=[DrCds[il]  componentsSeparatedByString:@"^"];
            [itm setValue:DrDets[0] forKey:@"Code"];
            [itm setValue:DrDets[1] forKey:@"Name"];
            [sArr addObject:itm];
        }
        self.meetData.AdCuss=sArr;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MeetingCalenderVC *popVC = [storyboard instantiateViewControllerWithIdentifier:@"sbStartDemo"];
        //[self presentViewController:popVC animated:YES completion:nil];
        [self showViewController:popVC sender:self];
        //[self dismissViewControllerAnimated:YES completion:nil];
        //[self performSegueWithIdentifier:@"mGoPresentation" sender:self];
        //self.meetData.mappedProds=self.mappedProds;
        
    }
}
-(IBAction) sendMeetRequest:(id)sender{
    NSString *sMsg=@"";
    NSMutableDictionary* MeetData=[[NSMutableDictionary alloc] init];
    if([_txEventReqTitle.text isEqualToString:@""]){
        sMsg=@"Enter the Event Title";
    }
    if([SelRItmsID isEqualToString:@""] && [sMsg isEqualToString:@""]){
        sMsg=@"Select the Customers";
    }
    
    if(![sMsg isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]
              initWithTitle:@"Digital Detailing"
                    message:sMsg
                   delegate:self
          cancelButtonTitle:@"OK"
        otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else{
        [MeetData setValue:_txEventReqTitle.text forKey:@"MTitle"];
        [MeetData setValue:SelRItmsID forKey:@"MCustCd"];
        [MeetData setValue:SelRItmsMails forKey:@"MCustEMail"];
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Sending Request Please Wait...",@"Sending Request Please Wait...")];
        [WBService SendServerRequest:@"save/sndMeetRequest" withParameter:MeetData withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
            
                UIAlertView *alertView = [[UIAlertView alloc]
                      initWithTitle:@"Digital Detailing"
                            message:@"Request Sent Successfully."
                           delegate:self
                  cancelButtonTitle:@"OK"
                otherButtonTitles:nil, nil];
                [alertView show];
            
                [self getMeetingDatas];
                [self CloseModalWindow:self];
                [SVProgressHUD dismiss];
            } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
                [SVProgressHUD dismiss];
                    UIAlertView *alertView = [[UIAlertView alloc]
                          initWithTitle:@"Digital Detailing"
                                message:errorMsg
                               delegate:self
                      cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil];
                    [alertView show];
        }];
    }
    
    
   
}
-(void)SignTeams{
    [AuthenticationManager.instance
     getTokenInteractivelyWithParentView:self
     andCompletionBlock:^(NSString * _Nullable accessToken, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];

             if (error || !accessToken) {
                 // Show the error and stay on the sign-in page
                 UIAlertController* alert = [UIAlertController
                                             alertControllerWithTitle:@"Error signing in"
                                             message:error.debugDescription
                                             preferredStyle:UIAlertControllerStyleAlert];

                 UIAlertAction* okButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:nil];

                 [alert addAction:okButton];
                 [self presentViewController:alert animated:true completion:nil];
                 return;
             }

             //self.userProfilePhoto.image = [UIImage imageNamed:@"DefaultUserPhoto"];

             [GraphManager.instance
              getMeWithCompletionBlock:^(MSGraphUser * _Nullable user, NSError * _Nullable error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[self.spinner stop];

                     if (error) {
                         // Show the error
                         UIAlertController* alert = [UIAlertController
                                                     alertControllerWithTitle:@"Error getting user profile"
                                                     message:error.debugDescription
                                                     preferredStyle:UIAlertControllerStyleAlert];

                         UIAlertAction* okButton = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:nil];

                         [alert addAction:okButton];
                         [self presentViewController:alert animated:true completion:nil];
                         return;
                     }
                     NSLog(@"%@", user.mail ? : user.userPrincipalName);
                     // Set display name
                     /*self.userDisplayName.text = user.displayName ? : @"Mysterious Stranger";
                     [self.userDisplayName sizeToFit];

                     // AAD users have email in the mail attribute
                     // Personal accounts have email in the userPrincipalName attribute
                     self.userEmail.text = user.mail ? : user.userPrincipalName;
                     [self.userEmail sizeToFit];*/
                 });
              }];
             
             // Since we got a token, user is signed in
             // Go to welcome page
             //[self performSegueWithIdentifier: @"login_success" sender: nil];
         });
     }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0) //Settings button pressed
    {
        if (alertView.tag == 200)
        {
            [self SignTeams];
        }
    }
}
-(IBAction) sendMeeting:(id)sender{
    
    NSString *sMsg=@"";
    NSMutableDictionary* MeetData=[[NSMutableDictionary alloc] init];
    if([_txEventTitle.text isEqualToString:@""]){
        sMsg=@"Enter the Event Title";
    }
    if([_txEventCust.text isEqualToString:@""] && [sMsg isEqualToString:@""]){
        sMsg=@"Select the Customer";
    }
    if([_txEventDtTm.text isEqualToString:@""] && [sMsg isEqualToString:@""]){
        sMsg=@"Select the Event Date & Time";
    }
    if([_txEventDur.text isEqualToString:@""] && [sMsg isEqualToString:@""]){
        sMsg=@"Select the Duration";
    }
    if([_txEventDesc.text isEqualToString:@""] && [sMsg isEqualToString:@""]){
        sMsg=@"Select the Description";
    }
    
    if(![sMsg isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]
              initWithTitle:@"Digital Detailing"
                    message:sMsg
                   delegate:self
          cancelButtonTitle:@"OK"
        otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else{
        NSString* selCustIds=  [NSString stringWithFormat:@"%@%@",_SelDrIDs,_SelPartIDs];
        NSString* selMailIds=  [NSString stringWithFormat:@"%@%@",_SelDrMails,_SelPartMails];
        
        [MeetData setValue:_txEventTitle.text forKey:@"MTitle"];
        [MeetData setValue:selCustIds forKey:@"MCustCd"];
        [MeetData setValue:selMailIds forKey:@"MCustEMail"];
        [MeetData setValue:_txEventCust.text forKey:@"MCust"];
        [MeetData setValue:_txEventDtTm.text forKey:@"MDtTm"];
        [MeetData setValue:_txEventDur.text forKey:@"MDuration"];
        [MeetData setValue:_txEventDesc.text forKey:@"MDesc"];
        [MeetData setValue:_txEventParticipants.text forKey:@"MParti"];
    }
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Event Creating Please Wait...",@"Event Creating Please Wait...")];
    
    NSDate *FDate=[BaseViewController addDate:[BaseViewController str2date:_txEventDtTm.text] andType:@"mn" valueAhead:0];
    NSDate *toDate=[BaseViewController addDate:[BaseViewController str2date:_txEventDtTm.text] andType:@"mn" valueAhead:_txEventDur.tag];
    [MeetData setValue:[BaseViewController str2Format:[BaseViewController date2str:toDate onlyDate:NO] withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"MToTime"];
    NSMutableDictionary *meetParam = [[NSMutableDictionary alloc] init];
   
    [meetParam setValue:[BaseViewController str2Format:_txEventDtTm.text withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"] forKey:@"startDateTime"];
    [meetParam setValue:[BaseViewController str2Format:[BaseViewController date2str:toDate onlyDate:NO] withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"]  forKey:@"endDateTime"];
    [meetParam setValue:_txEventTitle.text forKey:@"subject"];
    NSString *externalId =[NSString stringWithFormat:@"f%d-t%d-%@",[BaseViewController str2date:_txEventDtTm.text], toDate,[_txEventTitle.text stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
    [meetParam setValue:externalId forKey:@"externalId"];
    
    if(_isEditing==YES){
        [MeetData setValue:_EditMeetID  forKey:@"MeetID"];
        [MeetData setValue:_EditMeetUrl forKey:@"MeetUrl"];
        [WBService SendServerRequest:@"save/sndMeeting" withParameter:MeetData withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
            
                UIAlertView *alertView = [[UIAlertView alloc]
                      initWithTitle:@"Digital Detailing"
                            message:@"Meeting Created Successfully."
                           delegate:self
                  cancelButtonTitle:@"OK"
                otherButtonTitles:nil, nil];
                [alertView show];
                [self ClearForms];
                [self getMeetingDatas];
            [self CloseModalWindow:self];
            [SVProgressHUD dismiss];
            } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
                [SVProgressHUD dismiss];
                    UIAlertView *alertView = [[UIAlertView alloc]
                          initWithTitle:@"Digital Detailing"
                                message:errorMsg
                               delegate:self
                      cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil];
                    [alertView show];
        }];
    }else{
        [GraphManager.instance CreateMeetingWithCompletionBlock:meetParam Success:^(NSMutableDictionary* _Nullable Response ,NSArray<MSGraphEvent *> * _Nullable events, NSError * _Nullable error) {
            if(error!=nil){
                [SVProgressHUD dismiss];
                UIAlertView *alertView = [[UIAlertView alloc]
                      initWithTitle:@"Digital Detailing"
                            message:error.description
                           delegate:self
                  cancelButtonTitle:@"Login to MSTeams"
                otherButtonTitles:nil, nil];
                alertView.tag = 200;
                [alertView show];
                
                return;
            }
            [MeetData setValue:[Response valueForKey:@"id"]  forKey:@"MeetID"];
            [MeetData setValue:[Response valueForKey:@"joinUrl"]  forKey:@"MeetUrl"];
            if([[Response valueForKey:@"joinUrl"] isEqual:@""]){
                UIAlertView *alertView = [[UIAlertView alloc]
                      initWithTitle:@"Digital Detailing"
                            message:@"Meeting Not Generated. Try Again."
                           delegate:self
                  cancelButtonTitle:@"OK"
                otherButtonTitles:nil, nil];
                [alertView show];
            
                [SVProgressHUD dismiss];
            }
            [WBService SendServerRequest:@"save/sndMeeting" withParameter:MeetData withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
                
                    UIAlertView *alertView = [[UIAlertView alloc]
                          initWithTitle:@"Digital Detailing"
                                message:@"Meeting Created Successfully."
                               delegate:self
                      cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil];
                    [alertView show];
                    [self ClearForms];
                    [self getMeetingDatas];
                [self CloseModalWindow:self];
                [SVProgressHUD dismiss];
                } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
                    [SVProgressHUD dismiss];
                        UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Digital Detailing"
                                    message:errorMsg
                                   delegate:self
                          cancelButtonTitle:@"OK"
                        otherButtonTitles:nil, nil];
                        [alertView show];
            }];
        }];
        
    }
}
-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl{
    if(SControl.selectedSegmentIndex==0){
        _vwReqForm.hidden=YES;
    }else{
        _txtCusSearch.text=@"";
        _ObjCustList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CContact!=%@",[NSString stringWithFormat:@"1"]]] mutableCopy];
        [_tbReqCusts reloadData];
        _vwReqForm.hidden=NO;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(collectionView.bounds)/7)-0.1f, (CGRectGetHeight(collectionView.bounds)/6));
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.CalnDates.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    mSlideCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
    
    NSDictionary *item=self.CalnDates[indexPath.row];
    cell.bkCap.text = [item objectForKey:@"dayno"];
//    cell.layer.borderWidth=0.0f;
    cell.ImgView.hidden=YES;
    cell.bgView.hidden=YES;
    cell.lblSubTitle.hidden=YES;
    cell.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    cell.layer.borderWidth=0.3f;
    if (![[item objectForKey:@"dayno"] isEqualToString:@""]){
        if([item objectForKey:@"Meeting_Sub"]!=nil && ![[item objectForKey:@"Meeting_Sub"] isEqualToString:@""] )
        {
            cell.bgView.hidden=NO;
            cell.titleLabel.text=[item objectForKey:@"Meeting_Sub"];
            if([[item objectForKey:@"meetCnt"] longValue]>0)
            {
                cell.lblSubTitle.text=[NSString stringWithFormat:@"+%ld %@",[[item objectForKey:@"meetCnt"] longValue],NSLocalizedString(@"more", @"more")];
                cell.lblSubTitle.hidden=NO;
            }
            
           /* UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellSingleTap:)];
            [cell addGestureRecognizer:tap];*/
        }
    }
    
    return cell;
}
-(IBAction) searchCustomer:(id)sender{
    if([self.txtCusSearch.text isEqual:@""]){
        _ObjCustList=[_ObjCustomerList mutableCopy];
    }else{
       _ObjCustList=[[_ObjCustomerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@ or DrEmail contains[c] %@", self.txtCusSearch.text,self.txtCusSearch.text]] mutableCopy];
    }
    _ObjCustList=[[_ObjCustList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"CContact!=%@",[NSString stringWithFormat:@"1"]]] mutableCopy];
    [_tbReqCusts reloadData];
}
-(IBAction) searchItems:(id)sender{
    if([self.txtSelSearch.text isEqual:@""]){
        _ObjSelData=[_ObjAllSelData mutableCopy];
    }else{
        if(intMode==1)
            _ObjSelData=[[_ObjAllSelData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@ or DrEmail contains[c] %@", self.txtSelSearch.text,self.txtSelSearch.text]] mutableCopy];
        else if(intMode==2)
            _ObjSelData=[[_ObjAllSelData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@ or SF_Email contains[c] %@", self.txtSelSearch.text,self.txtSelSearch.text]] mutableCopy];
         else
             _ObjSelData=[[_ObjAllSelData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name contains[c] %@", self.txtSelSearch.text]] mutableCopy];
    }
    [_selTableView reloadData];
}
- (void)handleCellSingleTap:(UITapGestureRecognizer *) sender
{
    NSLog(@"Click Event");
    mSlideCell* VwCell= (mSlideCell*) sender.view;
    NSLog(@"%@", VwCell.bkCap.text);
    /*UIView* vwModl=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    vwModl.backgroundColor=[UIColor colorWithRed:6.0f/255 green:6.0f/255 blue:6.0f/255 alpha:0.7f];
    float hlfWidth=self.view.frame.size.width-300;
    float hlfHeight=self.view.frame.size.height-200;
    UIView* vwMeetlst=[[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(hlfWidth/2), (self.view.frame.size.height/2)-(hlfHeight/2), hlfWidth, hlfHeight)];
    vwMeetlst.backgroundColor=[UIColor whiteColor];
    
    
    
    [vwModl addSubview: vwMeetlst];
    [self.view addSubview: vwModl];*/
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSMutableDictionary* Item=_CalnDates[indexPath.row];
    NSString* DyNo=[Item objectForKey:@"dayno"];
    if (![DyNo isEqualToString:@""]){
        [self openDayPlan:DyNo andTPDt:[Item objectForKey:@"TPDt"] andIndex:(int)indexPath.row];
    }*/
    NSMutableDictionary* Item=_CalnDates[indexPath.row];
    NSString* DyNo=[Item objectForKey:@"dayno"];
    
    self.lblTitleDets.text= [NSString stringWithFormat:@"%@  %@/%d/%d",NSLocalizedString(@"Event Details For", @"Event Details For"),DyNo,SelMonth,SelYear];
    NSMutableDictionary* itmParm=[[NSMutableDictionary alloc] init];
    [itmParm setValue:[NSString stringWithFormat:@"%d-%d-%@",SelYear,SelMonth,DyNo] forKey:@"RptDt"];
    [WBService SendServerRequest:@"GET/Meetings" withParameter:itmParm withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        
        self.DayMeetDatas =[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
        [_tbMeetDetails reloadData];
            
        } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
    }];
    
    _vwMeetDetails.hidden=NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=40;
    if(intMode==1||intMode==2) h=55;
    if(tableView==_tbMeetDetails) h=151;
    if(tableView==_tbReqCusts) h=60;
    return h;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.selTableView) return self.ObjSelData.count;
    if(tableView==self.tbMeetDetails) return self.DayMeetDatas.count;
    if(tableView==self.tbReqCusts) return _ObjCustList.count;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectionBxCell* cell;
    if(tableView==self.tbReqCusts) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [_ObjCustList[indexPath.row] objectForKey:@"Name"];
        cell.lOptVal.text = [_ObjCustList[indexPath.row] objectForKey:@"DrEmail"];
        NSString* DrCode=[_ObjCustList[indexPath.row] objectForKey:@"Code"];
        if([SelRItmsID containsString:[NSString stringWithFormat:@"%@;", DrCode]] && [cell.lOptVal.text isEqual:@""]==NO ){
            cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.lOptImg.tintColor=[UIColor colorWithRed:0.0f/255 green:255.0f/255 blue:0.0f/255 alpha:1.0f];
            
            /*cell.lOptImg.image=[UIImage replaceColor:[UIColor colorWithRed:0.0f/255 green:255.0f/255 blue:0.0f/255 alpha:1.0f] inImage:[UIImage imageNamed:@"chkRed"] withTolerance:1.0f];*/
        }else{
            cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        }
    }
    if(tableView==self.tbMeetDetails) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [self.DayMeetDatas[indexPath.row] valueForKey:@"Meeting_Sub"];
        cell.lOptFDate.text=[[_DayMeetDatas[indexPath.row] objectForKey:@"Sch_StartTime"] objectForKey:@"date"];
        cell.lOptTDate.text=[[_DayMeetDatas[indexPath.row] objectForKey:@"Sch_EndTime"] objectForKey:@"date"];
        cell.lOptLDays.text=[_DayMeetDatas[indexPath.row] objectForKey:@"Duration"];
        cell.lOptDesc.text=[_DayMeetDatas[indexPath.row] objectForKey:@"MeetDesc"];
        NSString* Dtstr=[[_DayMeetDatas[indexPath.row] objectForKey:@"Sch_EndTime"] objectForKey:@"date"];
        NSDate* Dt=[BaseViewController str2date:Dtstr];
        NSDate* Dt1=[NSDate date];
        cell.btnSync.enabled=YES;
        cell.btnEdit.hidden=NO;
        UIColor* clr=nil;
        NSString *Stat=[_DayMeetDatas[indexPath.row] objectForKey:@"Stat"];
        if([Stat isEqual: @"NO"]){
            clr=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        } else if ([Stat isEqual: @"YES"]) {
            clr=[UIColor colorWithRed:48.0f/255 green:202.0f/255 blue:65.0f/255 alpha:1.0f];
        } else if ([Stat isEqual: @"MAYBE"]) {
            clr=[UIColor colorWithRed:243.0f/255 green:123.0f/255 blue:12.0f/255 alpha:1.0f];
        }
        //if(clr!=nil){    txtInField.layer.borderWidth=1.0f;
            cell.lOptImg.image=nil;
            cell.lOptImg.tintColor=clr;
        cell.lOptImg.backgroundColor=clr;
        cell.lOptImg.layer.cornerRadius=5;
        cell.lOptImg.layer.borderWidth=1.0f;
        cell.lOptImg.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
        //}
        [cell.btnSync setTitle:NSLocalizedString(@"Start Meeting", @"Start Meeting") forState:UIControlStateNormal];
        cell.btnSync.backgroundColor=[UIColor colorWithRed:74.0f/255 green:85.0f/255 blue:115.0f/255 alpha:1.0f];
        if(Dt.timeIntervalSince1970<Dt1.timeIntervalSince1970){
            [cell.btnSync setTitle:NSLocalizedString(@"Meeting Ended", @"Meeting Ended") forState:UIControlStateNormal];
            cell.btnSync.backgroundColor=[UIColor colorWithRed:220.0f/255 green:220.0f/255 blue:220.0f/255 alpha:1.0f];
            cell.btnSync.enabled=NO;
            cell.btnEdit.hidden=YES;
        }
        cell.btnSync.tag=indexPath.row;
        cell.btnEdit.tag=indexPath.row;
        [cell.btnSync addTarget:self action:@selector(openMeeting:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit addTarget:self action:@selector(editMeeting:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lOptDrCnt.text=[NSString stringWithFormat:@"%i %@",[[_MeetDatas[indexPath.row] objectForKey:@"PartiCnt"] intValue],NSLocalizedString(@"Customers", @"Customers")];
        cell.lOptParti.text=[NSString stringWithFormat:@"%i %@",[[_MeetDatas[indexPath.row] objectForKey:@"PartiCnt"] intValue],NSLocalizedString(@"Participants", @"Participants")];
        
    }
    if(tableView==self.selTableView) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        if(intMode==0) {
            cell.lOptText.text = [self.Durations[indexPath.row] valueForKey:@"Name"];
            cell.lOptVal.text =@"";
            cell.lOptImg.image=nil;
        }
        if(intMode==1 || intMode==2)
        {
            cell.lOptText.text = [_ObjSelData[indexPath.row] objectForKey:@"Name"];
            if(intMode==1){
                cell.lOptVal.text = [_ObjSelData[indexPath.row] objectForKey:@"DrEmail"];
            }else{
                cell.lOptVal.text = [_ObjSelData[indexPath.row]     objectForKey:@"SF_Email"];
                    
            }
            NSString* DrCode=[_ObjSelData[indexPath.row] objectForKey:@"Code"];
            if([SelItmsID containsString:[NSString stringWithFormat:@"%@;", DrCode]]){
                cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                cell.lOptImg.tintColor=[UIColor colorWithRed:0.0f/255 green:255.0f/255 blue:0.0f/255 alpha:1.0f];
                
                /*cell.lOptImg.image=[UIImage replaceColor:[UIColor colorWithRed:0.0f/255 green:255.0f/255 blue:0.0f/255 alpha:1.0f] inImage:[UIImage imageNamed:@"chkRed"] withTolerance:1.0f];*/
            }else{
                cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
            }
        }
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TBSelectionBxCell* cell;
    if(tableView==self.tbReqCusts){
        cell =[tableView cellForRowAtIndexPath:indexPath];
        NSString* DrCode=[_ObjCustList[indexPath.row] objectForKey:@"Code"];
        NSString* DrName=[_ObjCustList[indexPath.row] objectForKey:@"Name"];
        NSString* DrMail=[_ObjCustList[indexPath.row] objectForKey:@"DrEmail"];
        if([SelRItmsID containsString:[NSString stringWithFormat:@"%@;", DrCode]] || [cell.lOptVal.text isEqual:@""]==YES){
            cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
            
            SelRItmsID=[SelRItmsID stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;", DrCode] withString:@""];
            SelRItmsNm=[SelRItmsNm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;", DrName] withString:@""];
            SelRItmsMails=[SelRItmsMails stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;", DrMail] withString:@""];
        }else{
            cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.lOptImg.tintColor=[UIColor colorWithRed:0.0f/255 green:255.0f/255 blue:0.0f/255 alpha:1.0f];
            SelRItmsID=[NSString stringWithFormat:@"%@%@;",SelRItmsID,DrCode];
            SelRItmsNm=[NSString stringWithFormat:@"%@%@;",SelRItmsNm,DrName];
            SelRItmsMails=[NSString stringWithFormat:@"%@%@;",SelRItmsMails,DrMail];
            
            
        }
    }
    if(tableView==self.selTableView) {
        
        cell =[tableView cellForRowAtIndexPath:indexPath];
        if(intMode==0){
            _txEventDur.text=[self.Durations[indexPath.row] valueForKey:@"Name"];
            _txEventDur.tag=[[self.Durations[indexPath.row] valueForKey:@"Id"] intValue];//self.Hours[indexPath.row];
            self.vwAddSelView.hidden=YES;
        }else{
            NSString* DrCode=[_ObjSelData[indexPath.row] objectForKey:@"Code"];
            NSString* DrName=[_ObjSelData[indexPath.row] objectForKey:@"Name"];
            NSString* DrMail=@"";
            if(intMode==1){
                DrMail=[_ObjSelData[indexPath.row] objectForKey:@"DrEmail"];
            }else{
                DrMail=[_ObjSelData[indexPath.row] objectForKey:@"SF_Email"];
            }
            if([DrMail isEqual:@""]==NO){
                if([SelItmsID containsString:[NSString stringWithFormat:@"%@;", DrCode]]){
                    cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
                    
                    SelItmsID=[SelItmsID stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;", DrCode] withString:@""];
                    SelItmsNm=[SelItmsNm stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;", DrName] withString:@""];
                    SelItmsMails=[SelItmsMails stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;", DrMail] withString:@""];
                }else{
                    cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    cell.lOptImg.tintColor=[UIColor colorWithRed:0.0f/255 green:255.0f/255 blue:0.0f/255 alpha:1.0f];
                    SelItmsID=[NSString stringWithFormat:@"%@%@;",SelItmsID,DrCode];
                    SelItmsNm=[NSString stringWithFormat:@"%@%@;",SelItmsNm,DrName];
                    SelItmsMails=[NSString stringWithFormat:@"%@%@;",SelItmsMails,DrMail];
                    
                    
                }
            }
        }
    }
    
}

//User Define Function

-(NSDate *) GetPrvMonth
{
    SelMonth=SelMonth-1;
    if (SelMonth<1) {SelMonth=12;SelYear=SelYear-1;}
    return [BaseViewController str2date:[NSString stringWithFormat:@"%d-%d-01 00:00:00",SelYear,SelMonth]];
}
-(NSDate *) GetNextMonth
{
    SelMonth=SelMonth+1;
    if (SelMonth>12) {SelMonth=1;SelYear=SelYear+1;}
    return [BaseViewController str2date:[NSString stringWithFormat:@"%d-%d-01 00:00:00",SelYear,SelMonth]];
}
- (int) getMaxDate:(int)month andYear:(int) year{
    int mxDy=31;
    if(month==2){
        mxDy=28;
        if((year % 4)==0) mxDy=29;
    }
    else if(month==4 || month==6 || month==9 || month==11)
        mxDy=30;
    return mxDy;
}
-(void) prepareCalender:(NSDate *)ClnDate{
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    _CalnDates=[[NSMutableArray alloc]init];
    _PrevDates=[[NSMutableArray alloc]init];
    [myFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [myFormatter setDateFormat:@"MMMM"];
    NSString *MonthNm = [myFormatter stringFromDate:ClnDate];
    self.MonYrCaption.text=[NSString stringWithFormat:@"%@ - %d", MonthNm,SelYear];
    
    [self getMeetingDatas];
    [self renderCalender:SelMonth year:SelYear];
}
-(void) getMeetingDatas{
    NSMutableDictionary* MeetParam=[[NSMutableDictionary alloc] init];
    [MeetParam setValue:[NSNumber numberWithInt:SelMonth] forKey:@"Month"];
    [MeetParam setValue:[NSNumber numberWithInt:SelYear] forKey:@"Year"];
    [WBService SendServerRequest:@"GET/MNMeetings" withParameter:MeetParam withImages:nil DataSF:nil completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage) {
        
            self.MeetDatas=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            [self renderCalender:SelMonth  year:SelYear];
            
        } error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage) {
    }];
}
-(void) renderCalender:(int) mon year:(int) Yr {
    NSDate * ClnDate=[BaseViewController str2date:[NSString stringWithFormat:@"%d-%d-01 00:00:00",Yr,mon]];
    int maxDy=[self getMaxDate:mon andYear:Yr];
   // if( [self.CalnDates count]<1)
    //{
        
        _CalnDates=[[NSMutableArray alloc]init];
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:ClnDate];
        
        //[myFormatter setDateFormat:@"c"];
        NSString *dayOfWeek = [NSString stringWithFormat:@"%ld", (long)[comp weekday] ];//[myFormatter stringFromDate:ClnDate];
        for(int il=0;il<[dayOfWeek intValue]-1;il++){
            NSMutableDictionary* itm=[[NSMutableDictionary alloc] init];
            [itm setValue:@"" forKey:@"dayno"];
            [itm setValue:@"0" forKey:@"access"];
            [self.CalnDates addObject:itm];
        }
        for(int il=1;il<=maxDy;il++){
            NSMutableDictionary* itm=[[NSMutableDictionary alloc] init];
           
            NSString *sDay=[NSString stringWithFormat:@"%i", il];
            NSMutableArray* FData=[[_MeetDatas filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"dayno==%i",il]] mutableCopy];
            if ([FData count]>0) {
                itm=[FData[0] mutableCopy];
                
                [itm setValue:[NSNumber numberWithLong:([FData count]-1)] forKey:@"meetCnt"];
            }
            [itm setValue:[NSString stringWithFormat:@"%d",il] forKey:@"dayno"];
            [itm setValue:[NSString stringWithFormat:@"%d-%d-%d 00:00:00",Yr,mon,il] forKey:@"TPDt"];
            [itm setValue:@"1" forKey:@"access"];
            
            [self.CalnDates addObject:itm];
        }
        for(int il=(int)[self.CalnDates count];il<42;il++){
            NSMutableDictionary* itm=[[NSMutableDictionary alloc] init];
            [itm setValue:@"" forKey:@"dayno"];
            [itm setValue:@"0" forKey:@"access"];
            [self.CalnDates addObject:itm];
        }
       /* _TPData=[[NSMutableDictionary alloc] init];
        [_TPData setValue:_UserDet.SF forKey:@"SFCode"];
        [_TPData setValue:_UserDet.SFName forKey:@"SFName"];
        [_TPData setValue:_UserDet.DivCode forKey:@"DivCode"];
        [_TPData setValue:self.SelMonth forKey:@"TPMonth"];
        [_TPData setValue:self.SelYear forKey:@"TPYear"];
        [_TPData setValue:[NSString stringWithFormat:@"%i", flg] forKey:@"TPFlag"];
        [_TPData setObject:_CalnDates forKey:@"TPDatas"];*/
    //}
    
    /*self.submitTP.hidden=NO;
    self.saveDayPl.hidden=NO;
    self.ApproveTP.hidden=YES;
    self.RejectTP.hidden=YES;
    
    if([[_TPData valueForKey:@"TPFlag"] isEqualToString:@"1"])
    {
        self.submitTP.hidden=YES;
        self.saveDayPl.hidden=YES;
    }
    if(_TPEntryDet.Flag==1)
    {
        self.submitTP.hidden=YES;
        self.ApproveTP.hidden=NO;
        self.RejectTP.hidden=NO;
    }*/
    [self.CalenderView reloadData];
}
/*
 -(void) sendMeetings{
    MSHTTPClient *httpClient = [MSClientFactory createHTTPClientWithAuthenticationProvider:AuthenticationManager.instance];

    NSString *MSGraphBaseURL = @"https://graph.microsoft.com/v1.0/";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me/onlineMeetings/createOrGet"]]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableDictionary *payloadDictionary = [[NSMutableDictionary alloc] init];

    NSString *startDateTimeDateTimeString = @"02/06/2020 01:49:21";
    NSDate *startDateTime = [BaseViewController str2date: startDateTimeDateTimeString];
    payloadDictionary[@"startDateTime"] = startDateTime;

    NSString *endDateTimeDateTimeString = @"02/06/2020 02:19:21";
    NSDate *endDateTime = [BaseViewController str2date: endDateTimeDateTimeString];
    payloadDictionary[@"endDateTime"] = endDateTime;

    NSString *subject = @"Create a meeting with customId provided";
    payloadDictionary[@"subject"] = subject;

    NSString *externalId = @"7eb8263f-d0e0-4149-bb1c-1f0476083c56";
    payloadDictionary[@"externalId"] = externalId;
/
    MSGraphMeetingParticipants *participants = [[MSGraphMeetingParticipants alloc] init];
    NSMutableArray *attendeesList = [[NSMutableArray alloc] init];
    MSGraphMeetingParticipantInfo *attendees = [[MSGraphMeetingParticipantInfo alloc] init];
    MSGraphIdentitySet *identity = [[MSGraphIdentitySet alloc] init];
    MSGraphIdentity *user = [[MSGraphIdentity alloc] init];
    [user setId:@"1f35f2e6-9cab-44ad-8d5a-b74c14720000"];
    [identity setUser:user];
    [attendees setIdentity:identity];
    [attendees setUpn:@"test1@contoso.com"];
    [attendeesList addObject: attendees];
    [participants setAttendees:attendeesList];
    payloadDictionary[@"participants"] = participants;
* //
    NSData *data = [NSJSONSerialization dataWithJSONObject:payloadDictionary options:kNilOptions error:nil];
    [urlRequest setHTTPBody:data];

    MSURLSessionDataTask *meDataTask = [httpClient dataTaskWithRequest:urlRequest
        completionHandler: ^(NSData *data, NSURLResponse *response, NSError *nserror) {

            //Request Completed

    }];

    [meDataTask execute];
}*/
@end
