//
//  UserControls.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 29/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "userLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserControls : NSObject

@end

NS_ASSUME_NONNULL_END

typedef NS_ENUM(NSUInteger, SANContolType) {
    TitleLabel          = 0,
    TextField           = 1,
    NumberField         = 2,
    TextArea            = 3,
    DatePicker          = 4,
    DatePickerRange     = 5,
    TimePicker          = 6,
    TimePickerRange     = 7,
    Combobox            = 8,
    ComboboxMultiple    = 9,
    Files               = 10,
    Currency            = 11,
    CustomSingle        = 12,
    CustomMultiple      = 13,
    Table               = 14,
    ListOptional        = 31,
    ListMultiple        = 32
    
};

@protocol UserControlDelegate

-(void) didClick:(id) Control;
-(void) didChecked:(id) Control;
-(void) deleteFile:(NSString*) FileUrl;
@end

@interface SANControlsBox : UIView <UITextFieldDelegate,UITextViewDelegate>

- (id)initWithFrame:(CGRect)frame title:(NSString*)caption ControlType:(SANContolType) controlType isRange:(BOOL) isRng;
- (id)initWithFrame:(CGRect)frame title:(NSString*)caption ControlType:(SANContolType) controlType ListValues:(NSString*) values isRange:(BOOL) isRng;

@property (nonatomic,assign) NSString* Caption;
@property (nonatomic,assign) NSString* ID;
@property (nonatomic,assign) NSString* ICurrency;
@property (nonatomic,assign) int index;
@property (nonatomic,assign) SANContolType ControlType;
@property (nonatomic, weak) id<UserControlDelegate> delegate;

@property (nonatomic,assign) BOOL isRange;
@property (nonatomic,assign) BOOL isToCtrl;
@property (nonatomic,assign) BOOL isMandate;
@property (nonatomic,assign) long MaxLength;
@property (nonatomic,assign) UIColor* HeadColor;
@property (nonatomic,assign) UIColor* BgColor;
@property (nonatomic,retain) NSString* selectedText;
@property (nonatomic,retain) NSString* selectedValue;
@property (nonatomic,retain) NSString* selectedToText;
@property (nonatomic,retain) NSString* selectedToValue;

@property (nonatomic,strong) UILabel* lblHead;
@property (nonatomic,strong) UILabel* lblToHead;
@property (nonatomic,strong) userLabel* lblText;
@property (nonatomic,strong) userLabel* lblToText;
@property (nonatomic,strong) UITextField* txtField;
@property (nonatomic,strong) UITextView* txtView;
@property (nonatomic,strong) UIButton* cbButton;
@property (nonatomic,strong) UIButton* cbToButton;
@property (nonatomic,strong) UIView* prvwImg;
@property (nonatomic,strong) UIView* prvwimglst;
@property (nonatomic,strong) NSMutableArray* Files;



@end
