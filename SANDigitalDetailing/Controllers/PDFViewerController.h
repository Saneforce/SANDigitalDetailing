//
//  PDFViewerController.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 21/02/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewerController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property CGPDFDocumentRef pdf;
@property int numberOfPages;

@property (weak, nonatomic) IBOutlet UIButton *ClosePDF;
- (IBAction)ClosePDFVwr:(id)sender;

@end
