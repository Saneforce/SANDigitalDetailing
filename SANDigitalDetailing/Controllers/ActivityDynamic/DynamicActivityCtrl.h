//
//  DynamicActivityCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 22/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserControls.h"
#import <FSCalendar/FSCalendar.h>


NS_ASSUME_NONNULL_BEGIN

@interface DynamicActivityCtrl : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,FSCalendarDelegate,FSCalendarDataSource,UserControlDelegate,UIDocumentPickerDelegate>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,strong) LocationDetail* locationData;
@property (nonatomic, assign) NSString* EMode;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* scrlHeight;

@property (nonatomic, weak) IBOutlet UIScrollView* vwTabHeaderView;
@property (nonatomic, weak) IBOutlet UIScrollView* vwScrlContView;
@property (nonatomic, weak) IBOutlet UISegmentedControl* vwsegView;

@property (nonatomic, weak) IBOutlet UIView* vwActivityScr;
@property (nonatomic, weak) IBOutlet UIView* vwContentView;
@property (nonatomic, retain) IBOutlet UIView* vwCtrlsView;

@property (nonatomic, retain) IBOutlet UIView* vwModalView;
@property (nonatomic, retain) IBOutlet UIView* vwCmbView;
@property (nonatomic, retain) IBOutlet UIView* vwClndrView;

@property (nonatomic, weak) IBOutlet UITableView * selTableView;
@property (nonatomic, weak) IBOutlet UITableView * selOptTableView;

@property (nonatomic, weak) IBOutlet UIPickerView *pikFT;
@property (nonatomic, weak) IBOutlet UIPickerView *pikTT;

@property (weak , nonatomic) IBOutlet FSCalendar *calendar;

@property (weak , nonatomic) IBOutlet UILabel *lblSelDt;
@property (weak , nonatomic) IBOutlet UILabel *lblSelHead;
@property (weak , nonatomic) IBOutlet UILabel *lblSelHead1;

@end

NS_ASSUME_NONNULL_END
