//
//  UserControls.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 29/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import "UserControls.h"

@implementation UserControls

@end

@implementation SANControlsBox
- (id)initWithFrame:(CGRect)frame title:(NSString*)caption ControlType:(SANContolType) controlType isRange:(BOOL) isRng{
    return [self initWithFrame:frame title:caption ControlType:controlType ListValues:@"" isRange:isRng];
}
- (id)initWithFrame:(CGRect)frame title:(NSString*)caption ControlType:(SANContolType) controlType ListValues:(NSString*) values isRange:(BOOL) isRng{
    CGRect pframe=CGRectMake(0, frame.origin.y,  frame.size.width+(frame.origin.x*2), frame.size.height);
    self = [super initWithFrame:pframe];
    if (self) {
       // UIEdgeInsets insets = {0, 15, 0, 0};
        //self.edgeInsets = insets;
        CGRect cframe=CGRectMake(frame.origin.x,0,frame.size.width, frame.size.height);
        UIView* uContainer=[[UIView alloc] initWithFrame:cframe];
        
        self.ControlType=controlType;
        self.Caption=[NSString stringWithFormat:@"%@", caption];
        self.isRange=isRng;
        if(controlType==TitleLabel){
            _lblHead=[[userLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,30)];
            _lblHead.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
            _lblHead.text=caption;
            _lblHead.backgroundColor=[UIColor colorWithRed:89.0f/255 green:89.0f/255 blue:89.0f/255 alpha:1.0f];
            _lblHead.textColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];
            [uContainer addSubview:_lblHead];
        }
        else{
            float CtrlWidth=frame.size.width;
            if(isRng==YES){
                CtrlWidth=frame.size.width/2;
            }
            
            if(isRng==YES){
                _lblHead=[[UILabel alloc] initWithFrame:CGRectMake(2, 2, CtrlWidth-4,25)];
                _lblHead.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"From", @"From"),caption];
                _lblHead.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
                [_lblHead setClipsToBounds:YES];
                [uContainer addSubview:_lblHead];
                
                _lblToHead=[[UILabel alloc] initWithFrame:CGRectMake(CtrlWidth+2, 2, CtrlWidth-4,25)];
                _lblToHead.text=[NSString stringWithFormat:@"%@ %@",@"To",caption];
                _lblToHead.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
                [_lblToHead setClipsToBounds:YES];
                [uContainer addSubview:_lblToHead];
            }else{
                _lblHead=[[UILabel alloc] initWithFrame:CGRectMake(2, 2, CtrlWidth-4,25)];
                _lblHead.text=caption;
                _lblHead.font=[UIFont fontWithName:@"Poppins-SemiBold" size:13.0];
                [_lblHead setClipsToBounds:YES];
                [uContainer addSubview:_lblHead];
            }
            if(controlType==ListOptional||controlType==ListMultiple){
                NSArray* aryVals=[values componentsSeparatedByString:@","];
                UIView* vwList=[[UIView alloc] initWithFrame:CGRectMake(2, 28, CtrlWidth-4, [aryVals count]*40)];
                CGFloat iLeft=0,iTop=0,iWid=CtrlWidth/3,clCnt=0;
                for (int ic=0; ic<[aryVals count]; ic++) {
                    if(![aryVals[ic] isEqualToString:@""]){
                        UIView* vwParntChk=[[UIView alloc] initWithFrame:CGRectMake(iLeft, iTop,iWid, 30)];
                        //vwParntChk.backgroundColor=[UIColor grayColor];
                        
                        UIImageView* ChkItemImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 7,15, 15)];
                        //ChkItemImg.backgroundColor=[UIColor darkGrayColor];
                        ChkItemImg.layer.borderWidth=2.0f;
                        ChkItemImg.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
                        ChkItemImg.layer.cornerRadius=5;
                        [ChkItemImg setContentMode:UIViewContentModeScaleAspectFit];
                        CGFloat imageInset= 1.0;
                        if([[NSString stringWithFormat:@",%@,",_selectedValue] rangeOfString:[NSString stringWithFormat:@",%@,",aryVals[ic]]].length>0){
                            ChkItemImg.image = [[UIImage imageNamed:@"Check"] resizableImageWithCapInsets:UIEdgeInsetsMake(imageInset, imageInset+3.0, imageInset, imageInset+3.0) resizingMode:UIImageResizingModeStretch];
                        }else{
                            ChkItemImg.image = nil;
                        }
                        
                        [vwParntChk addSubview:ChkItemImg];
                        UILabel* lblListText=[[UILabel alloc] initWithFrame:CGRectMake(20, 0,iWid-25, 30)];
                        lblListText.text=aryVals[ic];
                        lblListText.font=[UIFont fontWithName:@"Poppins-SemiBold" size:12.0];
                        //lblListText.textColor=[UIColor blueColor];
                        [vwParntChk addSubview:lblListText];
                        
                        UIButton* btnChk=[[UIButton alloc] initWithFrame:CGRectMake(0, 0,iWid-5, 30)];
                        [btnChk addTarget:self action:@selector(btnChk:) forControlEvents: UIControlEventTouchUpInside];
                        if(controlType==ListMultiple)
                            btnChk.tag=1;
                        else
                            btnChk.tag=0;
                        [vwParntChk addSubview:btnChk];
                        
                        [vwList addSubview:vwParntChk];
                        iLeft=iLeft+iWid;
                        clCnt++;
                        if(clCnt>2){iLeft=0;iTop=iTop+35;clCnt=0;}
                        
                    }
                }
                //vwList.backgroundColor=[UIColor greenColor];
                [uContainer addSubview:vwList];
            }
            else if(controlType==TextField || controlType==NumberField || controlType==Currency){
                _txtField=[[UITextField alloc] initWithFrame:CGRectMake(2, 28, CtrlWidth-4,30)];
                _txtField.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
                _txtField.borderStyle=UITextBorderStyleRoundedRect;
                _txtField.layer.borderWidth=1.0f;
                _txtField.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
                _txtField.layer.cornerRadius=5;
                [_txtField setClipsToBounds:YES];
                _txtField.delegate=self;
                if(controlType==NumberField || controlType==Currency){
                    [_txtField setKeyboardType:UIKeyboardTypeNumberPad];
                }
                [uContainer addSubview:_txtField];
            }else if (controlType==TextArea){
                _txtView=[[UITextView alloc] initWithFrame:CGRectMake(2, 28, CtrlWidth-4,80)];
                _txtView.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
                _txtView.layer.borderWidth = 1.0f;
                _txtView.layer.borderColor = [[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
                _txtView.layer.cornerRadius = 5;
                [_txtView setClipsToBounds:YES];
                _txtView.delegate=self;
                [uContainer addSubview:_txtView];
            }else{
                NSString* btnImg=@"DwnArrw";
                UIEdgeInsets imgEdg=UIEdgeInsetsMake(38, CtrlWidth-14,  19,  15);
                float eh=30;
                float bh=63;
                
                if(controlType==Files){
                    btnImg=@"Approval";eh=80;bh=113;
                    //imgEdg=UIEdgeInsetsMake(28, CtrlWidth-33,  12,  5);
                    imgEdg=UIEdgeInsetsMake(10, 10,  10,  10);
                    _prvwImg=[[UIView alloc] initWithFrame:CGRectMake(0, 28, CtrlWidth-4, eh)];
                    [uContainer addSubview:_prvwImg];
                    
                    self.Files=[[NSMutableArray alloc] init];
                }
                _lblText=[[userLabel alloc] initWithFrame:CGRectMake(2, 28, CtrlWidth-4,eh)];
                //lblText.text=Caption;
                _lblText.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
                _lblText.layer.borderWidth=1.0f;
                _lblText.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
                _lblText.layer.cornerRadius=5;
                [_lblText setClipsToBounds:YES];
                [uContainer addSubview:_lblText];
                UIImage *img;
                if(controlType==Files){
                    _cbButton=[[UIButton alloc] initWithFrame:CGRectMake(CtrlWidth-64, 28, 60,eh)];
                    _cbButton.backgroundColor=[UIColor colorWithRed:89.0f/255 green:89.0f/255 blue:89.0f/255 alpha:1.0f];
                    img = [[UIImage imageNamed:btnImg] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    _cbButton.tintColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];
                }else{
                    _cbButton=[[UIButton alloc] initWithFrame:CGRectMake(2, 2, CtrlWidth-4,bh)];
                    img = [UIImage imageNamed:btnImg];
                }
                [_cbButton setClipsToBounds:YES];
                [_cbButton setImage:img forState:UIControlStateNormal];
                _cbButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                //cbButton.backgroundColor=[UIColor grayColor];
                _cbButton.tag=0;
                [_cbButton setImageEdgeInsets: imgEdg];
                [_cbButton addTarget:self action:@selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
                [uContainer addSubview:_cbButton];
                
                if(isRng==YES){
                    _lblToText=[[userLabel alloc] initWithFrame:CGRectMake(CtrlWidth+2, 28, CtrlWidth-4,30)];
                    //lblText.text=Caption;
                    _lblToText.font=[UIFont fontWithName:@"Poppins-Regular" size:13.0];
                    _lblToText.layer.borderWidth=1.0f;
                    _lblToText.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
                    _lblToText.layer.cornerRadius=5;
                    [_lblToText setClipsToBounds:YES];
                    [uContainer addSubview:_lblToText];
                    
                    _cbToButton=[[UIButton alloc] initWithFrame:CGRectMake(CtrlWidth+2, 2, CtrlWidth-4,65)];
                    [_cbToButton setClipsToBounds:YES];
                    _cbToButton.tag=1;
                    UIImage *img = [UIImage imageNamed:@"DwnArrw"];
                    [_cbToButton setImage:img forState:UIControlStateNormal];
                    _cbToButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                    //cbButton.backgroundColor=[UIColor grayColor];
                    [_cbToButton setImageEdgeInsets: UIEdgeInsetsMake(38, _cbToButton.frame.size.width-10,  19,  15)];
                    [_cbToButton addTarget:self action:@selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
                    
                    [uContainer addSubview:_cbToButton];
                }
                
            }
        }
        [self addSubview:uContainer];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
}
-(void) setSelectedText:(NSString *)selectedText{
    _selectedText=selectedText;
    _lblText.text=selectedText;
    _txtView.text=selectedText;
    _txtField.text=selectedText;
    if(self.ControlType==NumberField){
        _lblHead.textColor=[UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:1.0f];
        if([self validateString:selectedText withPattern:[self getPattern]]==NO){
            _lblHead.textColor=[UIColor colorWithRed:255.0f/255 green:0.0f/255 blue:0.0f/255 alpha:1.0f];
        }
    }
    if(self.ControlType==Files){
        _lblText.text=@"";
        NSMutableDictionary* itmFile=[[NSMutableDictionary alloc] init];
        [itmFile setValue:_selectedValue forKey:@"Path"];
        [itmFile setValue:selectedText forKey:@"Name"];
        [self.Files addObject:itmFile];
        [self generatePreview];
    }
}
-(void)generatePreview{
    [_prvwimglst removeFromSuperview];
    _prvwimglst=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _prvwImg.frame.size.width-4, 80)];
    [_prvwImg addSubview:_prvwimglst];
    for (int il=0; il<[self.Files count]; il++) {
        UIImageView* ImgView=[[UIImageView alloc] initWithFrame:CGRectMake((il*60)+10, 5, 60, 65)];
        ImgView.image=[UIImage imageNamed:@"report-6"];
        
        UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(2, 57, 60,20)];
        //lblText.text=Caption;
        lbl.font=[UIFont fontWithName:@"Poppins-Regular" size:11.0];
        lbl.text=[self.Files[il] valueForKey:@"Name"];
        /*lbl.layer.borderWidth=1.0f;
        lbl.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
        lbl.layer.cornerRadius=5;*/
        [lbl setClipsToBounds:YES];
        [ImgView addSubview:lbl];
        
        UIButton* btnDel=[[UIButton alloc] initWithFrame:CGRectMake((il*60)+47, 9, 15, 15)];
        btnDel.tag=il;
        [btnDel addTarget:self action:@selector(deleteFile:) forControlEvents:UIControlEventTouchUpInside];
        [btnDel setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
        [_prvwimglst addSubview:ImgView];
        [_prvwimglst addSubview:btnDel];
    }
}
-(IBAction) deleteFile:(id)sender{
    UIButton* btn=(UIButton*) sender;
    [self.delegate deleteFile:[self.Files[btn.tag] valueForKey:@"Path"]];
    [self.Files removeObjectAtIndex:btn.tag];
    [self generatePreview];
}
-(void) setSelectedValue:(NSString *)selectedValue{
    _selectedValue=selectedValue;
}
-(void) setSelectedToText:(NSString *)selectedText{
    _selectedToText=selectedText;
    _lblToText.text=selectedText;
}
-(void) setSelectedToValue:(NSString *)selectedToValue{
    _selectedToValue=selectedToValue;
    
}
-(void)setCaption:(NSString *)Caption{
    _Caption=Caption;
    if(_isRange==YES){
        _lblHead.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"From", @"From"),Caption];
        _lblToHead.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"To", @"To"),Caption];
    }else{
        _lblHead.text=Caption;
    }
}
-(void)setICurrency:(NSString *)ICurrency{
        UIImageView* lIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 14, 14, 14)];
        lIconImage.image = [[UIImage imageNamed:ICurrency] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        lIconImage.tintColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f];
        UIView* lIconContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 41)];
        lIconContainer.backgroundColor=[UIColor colorWithRed:89.0f/255 green:89.0f/255 blue:89.0f/255 alpha:1.0f];
        [lIconContainer addSubview:lIconImage];
        NSLog(@"Currency:%@",ICurrency);
        _txtField.leftViewMode = UITextFieldViewModeAlways;
        _txtField.leftView = lIconContainer;
}
-(void)setIndex:(int)index{
    _index=index;
}
-(void)setIsMandate:(BOOL)isMandate{
    _isMandate=isMandate;
    if (isMandate==YES) {
        _lblHead.text=[NSString stringWithFormat:@"%@ ",_lblHead.text],NSLocalizedString(@"*", @"*");
    }
}
-(void)setHeadColor:(UIColor *)HeadColor{
    _HeadColor=HeadColor;
    _lblHead.textColor=_HeadColor;
}
-(void)setBgColor:(UIColor *)BgColor{
    _BgColor=BgColor;
    self.backgroundColor=_BgColor;
}

-(IBAction) btnChk:(id)sender{
    
    UIButton* btn=(UIButton*) sender;
    UIView* parent=btn.superview;
    NSString* SelText=@"";
    UIImageView* ChkItemImg=nil;
    UILabel* lblLabel=nil;
    if(btn.tag==0){
        _selectedValue=@"";
        UIView* supParent=parent.superview;
        NSArray *allSubviewsOfWindow = [self allSubviewsOfView:supParent];
        for(UIView *subview in allSubviewsOfWindow){
            if([subview isKindOfClass: [UIImageView class]]){
                ChkItemImg=(UIImageView*) subview;
                ChkItemImg.image = nil;
                ChkItemImg.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
            }
        }
    }
    for (int ij=0; ij<parent.subviews.count; ij++) {
        UIView* cVw=parent.subviews[ij];
        if([cVw isKindOfClass: [UIImageView class]]){
            ChkItemImg=(UIImageView*) cVw;
        }
        if([cVw isKindOfClass: [UILabel class]]){
            lblLabel=(UILabel*) cVw;
            SelText=lblLabel.text;
        }
    }
    CGFloat imageInset= 1.0;
    if(_selectedValue==nil) _selectedValue=@"";
    if([[NSString stringWithFormat:@",%@,",_selectedValue] rangeOfString:[NSString stringWithFormat:@",%@,",SelText]].length>0){
        ChkItemImg.image = nil;
        ChkItemImg.layer.borderColor=[[UIColor colorWithRed:223.0f/255 green:225.0f/255 blue:229.0f/255 alpha:1.0f] CGColor];
        if(btn.tag==1){SelText=[NSString stringWithFormat:@"%@,",SelText];}
        _selectedValue=[_selectedValue stringByReplacingOccurrencesOfString:SelText withString:@""];
    }else{
        ChkItemImg.image = [[UIImage imageNamed:@"Check"] resizableImageWithCapInsets:UIEdgeInsetsMake(imageInset, imageInset+3.0, imageInset, imageInset+3.0) resizingMode:UIImageResizingModeStretch];
        
        ChkItemImg.layer.borderColor=[[UIColor colorWithRed:30.0f/255 green:225.0f/255 blue:9.0f/255 alpha:1.0f] CGColor];
        if(btn.tag==1){SelText=[NSString stringWithFormat:@"%@,",SelText];}
        _selectedValue=[NSString stringWithFormat:@"%@%@",_selectedValue,SelText];
    }
    NSLog(@"%@", _selectedValue);
    [self.delegate didChecked:self];
}
-(IBAction) btnClick:(id)sender{
   _isToCtrl=NO;
    UIButton* btn=(UIButton*) sender;
    if(btn.tag==1) _isToCtrl=YES;
    [self.delegate didClick:self];
}
-(NSString*)getPattern{
    NSString* sPattern=[[NSString alloc] init];
    if(self.ControlType==NumberField){
        sPattern=@"^[0-9]{0,4}$";
    }
    return sPattern;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_MaxLength==nil) return YES;
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
        
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return newLength <= _MaxLength;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if(textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                NSString *expression = @"^[0-9]+$";
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
                NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                                    options:0
                                                                      range:NSMakeRange(0, [newString length])];
                if (numberOfMatches == 0)
                    return NO;
        
    }
    if (_MaxLength==nil) return YES;
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= _MaxLength;
}
- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];

    NSAssert(regex, @"Unable to create regular expression");

    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];

    BOOL didValidate = NO;

    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;

    return didValidate;
}

- (NSArray *)allSubviewsOfView:(UIView *)view
{
    NSMutableArray *subviews = [[view subviews] mutableCopy];
    for (UIView *subview in [view subviews])
        [subviews addObjectsFromArray:[self allSubviewsOfView:subview]]; //recursive
    return subviews;
}
@end
