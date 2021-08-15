//
//  DynamicActivityCtrl.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 22/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import "DynamicActivityCtrl.h"


#define kCtrlStart 16

@interface DynamicActivityCtrl ()
@property (nonatomic, strong) NSMutableArray* SelObj;
@property (nonatomic, strong) NSMutableArray* AllSelObj;
@property (nonatomic, strong) NSString* fldName;
@property (nonatomic, strong) NSString* CodeName;

@property (nonatomic, strong) NSMutableArray* arrMainActivity;
@property (nonatomic, strong) NSMutableArray* arrAllMainActivity;
@property (nonatomic, strong) NSMutableArray* arrControlsDets;

@property (nonatomic, strong) NSMutableArray* FormsCtrls;
@property (nonatomic, strong) NSArray* Hours;
@property (nonatomic, strong) NSArray* Mins;

@property(nonatomic,assign) CGSize keyboardSize;
@property(nonatomic,strong) UITextView* CtxtFld;
@property(nonatomic,assign) CGFloat animatedDistance;

@end

@implementation DynamicActivityCtrl
float cyAxis,scrlHeight;
NSString* AMode;
NSString* ActvityCode;
NSString* selectedHour;
NSString* selectedMinute;
NSString* selectedText;
NSString* selectedValue;
NSDate* selectedDate;
SANControlsBox* eCtrl;
static const CGFloat ANIMATION_DURATION = 0.4;
static const CGFloat LITTLE_SPACE = 25;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.selTableView.delegate=self;
    self.selTableView.dataSource=self;
    self.selOptTableView.delegate=self;
    self.selOptTableView.dataSource=self;
    
    self.pikFT.delegate=self;
    self.pikFT.dataSource=self;
    self.pikTT.delegate=self;
    self.pikTT.dataSource=self;
    
    self.UserDet=[UserDetails sharedUserDetails];
    self.meetData=[CallMeetData sharedDatas];
    self.locationData=[LocationDetail sharedLocationData];
    self.Hours=[[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    self.Mins=[[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59", nil];
    
    if(self.EMode==nil) {
        self.EMode=@"0,";
        AMode=@"O";
    }
    //if([self.EMode isEqualToString:@"1"]){
    _vwTabHeaderView.hidden=YES;
    [_vwsegView setSelectedSegmentIndex:1];
    AMode=@"";
    //}
    [self.vwScrlContView setFrame:CGRectMake(0, 0, _vwActivityScr.frame.size.width, _vwActivityScr.frame.size.height)];
    //self.pikFT
    NSMutableDictionary* Param=[[NSMutableDictionary alloc] init];
    [Param setValue:self.UserDet.DivCode forKey:@"div"];
    [WBService SendServerRequest:@"get/dynactivity" withParameter:Param withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
            NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
            _arrAllMainActivity=[receivedDta mutableCopy];
       // _arrMainActivity=[_arrAllMainActivity mutableCopy];
        //_arrMainActivity=[[_arrAllMainActivity filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Activity_For contains[c] %@ and Activity_Available==%@",self.EMode,AMode]] mutableCopy];
            _arrMainActivity=[[_arrAllMainActivity filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Activity_For contains[c] %@",self.EMode]] mutableCopy];
            [_selTableView reloadData];
            [SVProgressHUD dismiss];
        }
        error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
           NSLog(@"%@",errorMsg);
           [SVProgressHUD dismiss];
       }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
   // [self.view addGestureRecognizer:tap];
}
- (void)handleSingleTap
{
    _CtxtFld=[UIResponder currentFirstResponder];
    if(_CtxtFld!=nil)
    [_CtxtFld endEditing:YES];
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
    selectedHour = self.Hours[row];
    if(pickerView==self.pikTT)
    selectedMinute = self.Mins[row];
}
-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _lblSelDt.text=[dateFormatter stringFromDate:date];
    selectedDate=date;
    if(eCtrl.ControlType==DatePicker || eCtrl.ControlType==DatePickerRange){
        if(eCtrl.isToCtrl==YES){
            eCtrl.selectedToValue=[dateFormatter stringFromDate:date];
            dateFormatter.dateFormat = @"dd-MM-yyyy";
            eCtrl.selectedToText=[dateFormatter stringFromDate:date];
        }else{
            eCtrl.selectedValue=[dateFormatter stringFromDate:date];
            dateFormatter.dateFormat = @"dd-MM-yyyy";
            eCtrl.selectedText=[dateFormatter stringFromDate:date];
        }
        [self CloseOptWindow:self];
    }
}
-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl{
    if(SControl.selectedSegmentIndex == 0)
    {
        _arrMainActivity=[[_arrAllMainActivity filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Activity_For contains[c] %@ and Activity_Available=='O'",self.EMode]] mutableCopy];
    }
    if(SControl.selectedSegmentIndex == 1)
    {
        _arrMainActivity=[[_arrAllMainActivity filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Activity_For contains[c] %@ and Activity_Available==''",self.EMode]] mutableCopy];
    }
    if(SControl.selectedSegmentIndex == 2)
    {
        _arrMainActivity=[[_arrAllMainActivity filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Activity_For contains[c] %@ and Activity_Available=='O' and Approval_Needed=='1'",self.EMode]] mutableCopy];
    }
    [_selTableView reloadData];
}
-(IBAction) CloseOptWindow:(id)sender{
        _vwModalView.hidden=YES;
        _vwCmbView.hidden=YES;
        _vwClndrView.hidden=YES;
}
-(IBAction) CloseWindow:(id)sender{
    if([self.EMode isEqualToString:@"0,"]){
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:NO];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        //[self performSegueWithIdentifier:@"GotoFeedback" sender:self];
    }
}
- (void)deleteFile:(NSString *)FileUrl{
    
}
- (void)didClick:(id)Control{
    _CtxtFld=[UIResponder currentFirstResponder];
    if(_CtxtFld!=nil)
    [_CtxtFld endEditing:YES];
    
    eCtrl=(SANControlsBox*) Control;
    //SANContolType ControlType=eCtrl.ControlType;
    _lblSelHead.text=[NSString stringWithFormat:@"Select the %@",eCtrl.Caption];
    _lblSelHead1.text=[NSString stringWithFormat:@"Select the %@",eCtrl.Caption];
    selectedText=@"";
    selectedValue=@"";
    if(!([eCtrl.selectedValue isEqualToString:@""] || eCtrl.selectedValue==nil)){
        selectedValue=eCtrl.selectedValue;
        selectedText=eCtrl.selectedText;
    }
    int ControlIndex=eCtrl.index;
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
        eCtrl.selectedValue=sFilePath;
        eCtrl.selectedText=arrayOfComponents[[arrayOfComponents count]-1];
    }
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
    if(eCtrl.ControlType==TimePicker || eCtrl.ControlType==TimePickerRange){
        if(selectedDate==nil)
        {
            [BaseViewController Toast:NSLocalizedString(@"Date Not Seleted...", @"Date Not Seleted...")];
            return;
        }
        if(selectedHour==nil) selectedHour=@"00";
        if(selectedMinute==nil) selectedMinute =@"00";
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        selectedValue=[NSString stringWithFormat:@"%@ %@:%@",[dateFormatter stringFromDate:selectedDate],selectedHour,selectedMinute];
        
        dateFormatter.dateFormat = @"dd-MM-yyyy";
        selectedText=[NSString stringWithFormat:@"%@ %@:%@",[dateFormatter stringFromDate:selectedDate],selectedHour,selectedMinute];
        
    }
    if(eCtrl.isToCtrl==YES){
        [eCtrl setSelectedToText:selectedText];
        [eCtrl setSelectedToValue:selectedValue];
    }else{
        [eCtrl setSelectedText:selectedText];
        [eCtrl setSelectedValue:selectedValue];
    }
    if(eCtrl.ControlType==TimePicker || eCtrl.ControlType==TimePickerRange){
        [self.pikFT selectRow:0 inComponent:0 animated:YES];
        [self.pikTT selectRow:0 inComponent:0 animated:YES];
        selectedHour=@"00";
        selectedMinute =@"00";
    }
    [self CloseOptWindow:sender];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=42;
    return h;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TBSelectionBxCell* cell;
    if(tableView==self.selTableView) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [_arrMainActivity[indexPath.row] objectForKey:@"Activity_Name"];
    }
    if(tableView==self.selOptTableView) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lOptText.text = [_SelObj[indexPath.row] objectForKey:_fldName];
        cell.lOptImg.hidden=YES;
        if(eCtrl.ControlType==ComboboxMultiple||eCtrl.ControlType==CustomMultiple){
            cell.lOptImg.hidden=NO;
            cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if([selectedValue rangeOfString:[_SelObj[indexPath.row] objectForKey:_CodeName]].length>0){
                cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        }
    }
    return cell;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.selTableView) return [_arrMainActivity count];
    if(tableView==self.selOptTableView) return [_SelObj count];
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TBSelectionBxCell* cell;
    
   if(tableView==self.selTableView) {
       
       [SVProgressHUD showWithStatus:NSLocalizedString(@"LoadinStatus", @"Loading..")];
       cell =[tableView cellForRowAtIndexPath:indexPath];
       ActvityCode=[_arrMainActivity[indexPath.row] objectForKey:@"Activity_SlNo"];
       NSMutableDictionary* Param=[[NSMutableDictionary alloc] init];
       [Param setValue:ActvityCode forKey:@"slno"];
       [Param setValue:self.UserDet.DivCode forKey:@"div"];
       [WBService SendServerRequest:@"get/dynviewTest" withParameter:Param withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
           NSMutableArray *receivedDta=[NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingAllowFragments error:nil];
           _arrControlsDets=[receivedDta mutableCopy];
           cyAxis=0;scrlHeight=0;
           if(self.vwCtrlsView!=nil){
               [self.vwCtrlsView removeFromSuperview];
           }
           self.vwCtrlsView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vwScrlContView.frame.size.width, scrlHeight)];
           _FormsCtrls=[[NSMutableArray alloc] init];
           for (int il=0; il<[receivedDta count]; il++) {
               NSLog(@"%@",[receivedDta[il] valueForKey:@"Field_Name"]);
               NSString* Caption=[[[receivedDta[il] valueForKey:@"Field_Name"] stringByReplacingOccurrencesOfString:@"From / To " withString:@""] stringByReplacingOccurrencesOfString:@"Start / End " withString:@""];
               int CtrlID=[[receivedDta[il] valueForKey:@"Control_Id"] intValue];
               
               float height=65.0f;
               if (CtrlID==3 || CtrlID==Files) height=110.0f;
               if (CtrlID==0) height=30.0f;
               BOOL isRange=NO;
               if (CtrlID==5 || CtrlID==7) isRange=YES;
               
               SANControlsBox *CardView=[[SANControlsBox alloc] initWithFrame:CGRectMake(kCtrlStart, cyAxis, _vwContentView.frame.size.width-((kCtrlStart*2)+4) , height) title:Caption ControlType:CtrlID isRange:isRange];
               
               CardView.Caption=Caption;
               CardView.ID=[NSString stringWithFormat:@"Ctrl_%d_%d",CtrlID,il];
               CardView.index=il;
               CardView.isMandate=[[receivedDta[il] valueForKey:@"Mandatory"] boolValue];
               if(CtrlID==Currency){
                   CardView.ICurrency=[receivedDta[il] valueForKey:@"Control_Para"] ;
               }else if(CtrlID==TextField||CtrlID==NumberField||CtrlID==TextArea) {
                   CardView.MaxLength=[[_arrControlsDets[il] valueForKey:@"Control_Para"] integerValue];
               }
               CardView.delegate=self;
               [self.vwCtrlsView addSubview:CardView];
               cyAxis+=CardView.frame.size.height+5;
               scrlHeight+=CardView.frame.size.height+5;
               [_FormsCtrls addObject:CardView];
           }
           [self.vwCtrlsView setFrame:CGRectMake(0, 0, self.vwScrlContView.frame.size.width-0, scrlHeight)];
           [self.vwContentView setFrame:CGRectMake(0, 0, self.vwScrlContView.frame.size.width-0, scrlHeight)];
           [self.vwContentView addSubview:self.vwCtrlsView];
           [self.vwScrlContView setContentSize: CGSizeMake(self.vwCtrlsView.frame.size.width, self.vwCtrlsView.frame.size.height+16)];
          [SVProgressHUD dismiss];
           
       }
       error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
          NSLog(@"%@",errorMsg);
          [SVProgressHUD dismiss];
      }];
    }
    if(tableView==self.selOptTableView) {
        cell =[tableView cellForRowAtIndexPath:indexPath];
        if(eCtrl.ControlType==Combobox||eCtrl.ControlType==CustomSingle)
        {
            [eCtrl setSelectedText:[NSString stringWithFormat:@"%@",[_SelObj[indexPath.row] objectForKey:_fldName]]];
            [eCtrl setSelectedValue:[NSString stringWithFormat:@"%@",[_SelObj[indexPath.row] objectForKey:_CodeName]]];
            
            _vwModalView.hidden=YES;
            _vwCmbView.hidden=YES;
            _vwClndrView.hidden=YES;
            //cell.lOptText.text = [_SelObj[indexPath.row] objectForKey:_fldName];
        }
        if(eCtrl.ControlType==ComboboxMultiple || eCtrl.ControlType==CustomMultiple){
            if([selectedValue rangeOfString:[_SelObj[indexPath.row] objectForKey:_CodeName]].length<=0){
                selectedText=[NSString stringWithFormat:@"%@%@, ",selectedText,[_SelObj[indexPath.row] objectForKey:_fldName]];
                selectedValue=[NSString stringWithFormat:@"%@%@, ",selectedValue,[_SelObj[indexPath.row] objectForKey:_CodeName]];
                cell.lOptImg.image=[[UIImage imageNamed:@"checkbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                
            }
            else{
                selectedText=[selectedText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@, ",[_SelObj[indexPath.row] objectForKey:_fldName]] withString:@""];
                selectedValue=[selectedValue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@, ",[_SelObj[indexPath.row] objectForKey:_CodeName]] withString:@""];
                cell.lOptImg.image=[[UIImage imageNamed:@"uncheckbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            cell.lOptImg.tintColor=[UIColor colorWithRed:255.0f/255 green:29.0f/255 blue:37.0f/255 alpha:1.0f];
        }
    }
}
-(IBAction)saveDyActivityData:(id)sender{
    
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
        [dataItem setValue:ActvityCode forKey:@"slno"];
        [dataItem setValue:[NSString stringWithFormat:@"%i",CType] forKey:@"ctrl_id"];
        [dataItem setValue:[_arrControlsDets[cCtrl.index] objectForKey:@"Creation_Id"] forKey:@"creat_id"];
        [dataItem setValue:[_arrControlsDets[cCtrl.index] objectForKey:@"Group_Creation_Id"] forKey:@"group_creat_id"];
        if(self.meetData.WT==nil){
            [dataItem setValue:@"0" forKey:@"WT"];
            [dataItem setValue:@"0" forKey:@"Pl"];
            [dataItem setValue:@"0" forKey:@"cus_code"];
            [dataItem setValue:@""  forKey:@"cusname"];
            [dataItem setValue:self.UserDet.SF forKey:@"DataSF"];
        }else{
            [dataItem setValue:self.meetData.WT forKey:@"WT"];
            [dataItem setValue:self.meetData.Pl forKey:@"Pl"];
            [dataItem setValue:self.meetData.CustCode forKey:@"cus_code"];
            [dataItem setValue:self.meetData.CustName  forKey:@"cusname"];
            [dataItem setValue:self.meetData.DataSF forKey:@"DataSF"];
        }
        [dataItem setValue:_locationData.latitude forKey:@"lat"];
        [dataItem setValue:_locationData.longitude forKey:@"lng"];
        [dataItem setValue:[self.EMode stringByReplacingOccurrencesOfString:@"," withString:@""] forKey:@"type"];
        
        if(cCtrl.ControlType<3){
            cCtrl.selectedValue=cCtrl.txtField.text;
            cCtrl.selectedText=cCtrl.txtField.text;
        }else if(cCtrl.ControlType<4){
            cCtrl.selectedValue=cCtrl.txtView.text;
            cCtrl.selectedText=cCtrl.txtView.text;
        }
        if(cCtrl.isMandate==YES){
            if([cCtrl.selectedValue isEqualToString:@""] || cCtrl.selectedValue==nil){
                [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Kindly Fill the Validation_Message", @"Kindly Fill the"),cCtrl.Caption]];
                return;
            }
            if(cCtrl.ControlType==DatePickerRange || cCtrl.ControlType==TimePickerRange){
                if([cCtrl.selectedToValue isEqualToString:@""] || cCtrl.selectedToValue==nil){
                    [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Kindly Fill the to Range of", @"Kindly Fill the to Range of"),cCtrl.Caption]];
                    return;
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
                    [BaseViewController Toast:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"To Range Must be greater then From Seletion of", @"To Range Must be greater then From Seletion of") ,cCtrl.Caption]];
                    return;
                }
            }
        }
        
        [dataItem setValue:cCtrl.selectedText forKey:@"values"];
        [dataItem setValue:cCtrl.selectedValue forKey:@"codes"];
        [datas addObject:dataItem];
    }
    if([self.EMode isEqualToString:@"0,"]){
        NSMutableDictionary *Param=[[NSMutableDictionary alloc]init];
        [Param setObject:datas forKey:@"val"];
        [WBService SendServerRequest:@"save/dcract" withParameter:Param withImages:nil DataSF:self.UserDet.SF completion:^(BOOL success, id respData, NSMutableDictionary *DatawithImage){
                
                [BaseViewController Toast:NSLocalizedString(@"Submitted Successfully", @"Submitted Successfully")];
            }
            error:^(NSString *errorMsg, NSMutableDictionary *DatawithImage){
              NSLog(@"%@",errorMsg);
              [SVProgressHUD dismiss];
        }];
    }else{
        _meetData.ActivityEntrys=datas;
        NSLog(@"ActivityData : %@",[self.meetData toNSDictionary]);
        [self dismissViewControllerAnimated:YES completion:nil];
        //[self performSegueWithIdentifier:@"GotoFeedback" sender:self];
    }
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
/*-(UILabel *) CreateLabel:(NSString *) Caption{
    UILabel *lblHead=[[userLabel alloc] initWithFrame:CGRectMake(0, cyAxis, _vwCtrlsView.frame.size.width,30)];
    lblHead.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
    cyAxis+=lblHead.frame.size.height+8;
    scrlHeight+=lblHead.frame.size.height+8;
    lblHead.text=Caption;
    lblHead.backgroundColor=[UIColor colorWithRed:89.0f/255 green:89.0f/255 blue:89.0f/255 alpha:1.0f];
    lblHead.textColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];
    [self.vwCtrlsView addSubview:lblHead];
    return lblHead;
}

-(UIView *) CreateInput:(NSString *) Caption{
    UIView *CardView=[[UIView alloc] initWithFrame:CGRectMake(kCtrlStart, cyAxis, _vwContentView.frame.size.width-((kCtrlStart*2)+4) , 60)];
    [CardView setClipsToBounds:YES];
    //CardView.backgroundColor=[UIColor grayColor];
    
    UILabel *lblHead=[[UILabel alloc] initWithFrame:CGRectMake(2, 2, _vwContentView.frame.size.width-((kCtrlStart*2)+8),25)];
    lblHead.text=Caption;
    lblHead.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
    [lblHead setClipsToBounds:YES];
    [CardView addSubview:lblHead];
    
    UITextField *txtInField=[[UITextField alloc] initWithFrame:CGRectMake(2, 28, _vwContentView.frame.size.width-((kCtrlStart*2)+8),30)];
    //txtInField.text=Caption;
    txtInField.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
    txtInField.borderStyle=UITextBorderStyleRoundedRect;
    txtInField.layer.borderWidth=1.0f;
    txtInField.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
    txtInField.layer.cornerRadius=5;
    [txtInField setClipsToBounds:YES];
    [CardView addSubview:txtInField];
    
    [self.vwCtrlsView addSubview:CardView];
    cyAxis+=CardView.frame.size.height+5;
    scrlHeight+=CardView.frame.size.height+5;
    return CardView;
}

-(UIView *) CreateMultiInput:(NSString *) Caption{
    UIView *CardView=[[UIView alloc] initWithFrame:CGRectMake(kCtrlStart, cyAxis,_vwContentView.frame.size.width-((kCtrlStart*2)+4), 110)];
    [CardView setClipsToBounds:YES];
   // CardView.backgroundColor=[UIColor grayColor];
    
    UILabel *lblHead=[[UILabel alloc] initWithFrame:CGRectMake(2, 2, _vwContentView.frame.size.width-((kCtrlStart*2)+8),25)];
    lblHead.text=Caption;
    lblHead.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
    [lblHead setClipsToBounds:YES];
    [CardView addSubview:lblHead];
    
    UITextView *txtInField=[[UITextView alloc] initWithFrame:CGRectMake(2, 28, _vwContentView.frame.size.width-((kCtrlStart*2)+8),80)];
   // txtInField.text=Caption;
    txtInField.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
    txtInField.layer.borderWidth = 1.0f;
    txtInField.layer.borderColor = [[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
    txtInField.layer.cornerRadius = 5;
    [txtInField setClipsToBounds:YES];
    [CardView addSubview:txtInField];
    
    [self.vwCtrlsView addSubview:CardView];
    cyAxis+=CardView.frame.size.height+5;
    scrlHeight+=CardView.frame.size.height+5;
    return CardView;
}*/

/*-(SANControlsBox *) CreateSelectBox:(NSString *) Caption andIndex:(int) cindex{
    //SANControlsBox *CardView=[[SANControlsBox alloc] initWithFrame:CGRectMake(kCtrlStart, cyAxis, _vwContentView.frame.size.width-((kCtrlStart*2)+4) , 65) title:Caption ControlType:Combobox ];
    
    //CardView.backgroundColor=[UIColor grayColor];
    
  *  UILabel *lblHead=[[UILabel alloc] initWithFrame:CGRectMake(2, 2, _vwContentView.frame.size.width-((kCtrlStart*2)+8),25)];
    lblHead.text=Caption;
    lblHead.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
    [lblHead setClipsToBounds:YES];
    [CardView addSubview:lblHead];
    
    UILabel *lblText=[[userLabel alloc] initWithFrame:CGRectMake(2, 28, _vwContentView.frame.size.width-((kCtrlStart*2)+8),30)];
    //lblText.text=Caption;
    lblText.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
    lblText.layer.borderWidth=1.0f;
    lblText.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
    lblText.layer.cornerRadius=5;
    [lblText setClipsToBounds:YES];
    [CardView addSubview:lblText];
    
    UIButton *cbButton=[[UIButton alloc] initWithFrame:CGRectMake(2, 2, _vwContentView.frame.size.width-((kCtrlStart*2)+8),65)];
    [cbButton setClipsToBounds:YES];
    UIImage *img = [UIImage imageNamed:@"DwnArrw"];
    [cbButton setImage:img forState:UIControlStateNormal];
    cbButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    //cbButton.backgroundColor=[UIColor grayColor];
    [cbButton setImageEdgeInsets: UIEdgeInsetsMake(38, cbButton.frame.size.width-10,  19,  15)];
    [cbButton addTarget:self action:@selector(selWindowOpen:) forControlEvents: UIControlEventTouchUpInside];
    cbButton.tag=cindex;
   
    [CardView addSubview:cbButton];*
    
    
    [self.vwCtrlsView addSubview:CardView];
    cyAxis+=CardView.frame.size.height+5;
    scrlHeight+=CardView.frame.size.height+5;
    return CardView;
}
-(UITextField*) CreateDateTimeBox:(NSString *) Caption andType:(int) CtrlID{
    UITextField *txt=[[UITextField alloc] init];
    return txt;
}
-(UITextField*) CreateFileChoose:(NSString *) Caption {
    UITextField *txt=[[UITextField alloc] init];
    return txt;
}*/
@end
