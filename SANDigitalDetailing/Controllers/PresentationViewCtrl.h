//
//  PresentationViewCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 04/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "BaseViewController.h"
#import "PDFViewerController.h"
#import "ImageScale.h"
#import "ScribbleView.h"

@interface PresentationViewCtrl : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate,UIGestureRecognizerDelegate,CAAnimationDelegate,UIPopoverPresentationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) AppSetupData* SetupData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lBarLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lBarTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lBarBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerLeft;
@property (nonatomic, weak) IBOutlet ScribbleView* vwScribble;
@property (nonatomic, retain) AVPlayerViewController *playerViewController;

@property (nonatomic, weak) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic, strong) Slide* currentSlide;


@property (nonatomic,assign) NSInteger filterType;


@property (nonatomic, weak) IBOutlet UICollectionView* slideCollectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* slideLayout;

@property (nonatomic,weak) IBOutlet UITextView* SlideRemarks;
@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnFilterType;
@property (nonatomic, weak) IBOutlet UITableView* tvFilterType;
@property (nonatomic, weak) IBOutlet UITableView* tvProdList;
@property (nonatomic, weak) IBOutlet UIView* vwFilter;
@property (nonatomic,weak) IBOutlet UIView* vwAboutSlide;

@property (nonatomic,weak) IBOutlet UIView* vwWinAboutSlide;
@property (nonatomic,weak) IBOutlet UIView* vwWinScribble;
@property (nonatomic,strong) IBOutlet UIView* vwDrawWin;
@property (nonatomic,weak) IBOutlet UIView* vwWinBgMenu;
@property (nonatomic,weak) IBOutlet UIView* vwWinMenu;
@property (nonatomic,weak) IBOutlet UIButton* btnBlack;
@property (nonatomic,weak) IBOutlet UIButton* btnLikeButton;
@property (nonatomic,weak) IBOutlet UIButton* btnDislikeButton;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl * segmentedControl;

/*@property (nonatomic,weak) IBOutlet UIImageView* vwScribSlideImg;
@property (nonatomic,weak) IBOutlet UIImageView* vwScribbleImg;*/
-(void)setStartProductSlide:(NSMutableDictionary *)selSlide;

- (UIImage *)imageByRenderingView:(UIView*) srcView;

@property CGPDFDocumentRef pdf;

@end
