//
//  PDFViewerController.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 21/02/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "PDFViewerController.h"
#import "PdfDataViewerCtrlr.h"

@interface PDFViewerController ()
@end

@implementation PDFViewerController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    
    
    self.numberOfPages = (int)CGPDFDocumentGetNumberOfPages( self.pdf );
    if( self.numberOfPages % 2 ) self.numberOfPages++;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    PdfDataViewerCtrlr *startingViewController = [self viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    //.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    CGRect pageViewRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (PdfDataViewerCtrlr *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Create a new view controller and pass suitable data.
    PdfDataViewerCtrlr *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"PdfDataViewerCtrlr"];
    dataViewController.pageNumber = (int)index + 1;
    dataViewController.pdf = self.pdf;
    return dataViewController;
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
        
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
    self.pageViewController.doubleSided = NO;
    [self.view bringSubviewToFront:self.ClosePDF];
    
    return UIPageViewControllerSpineLocationMin;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PdfDataViewerCtrlr *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PdfDataViewerCtrlr *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == self.numberOfPages ) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}
- (NSUInteger)indexOfViewController:(PdfDataViewerCtrlr *)viewController
{
    NSInteger pg=0;
    @try {
        pg=viewController.pageNumber - 1;
    } @catch (NSException *exception) {
        pg=0;
    } @finally {
        
        return pg;
    }
    
}
- (IBAction)ClosePDFVwr:(id)sender {
    //[UIPageViewController dealloc];
   // CGPDFDocumentRelease(_pdf);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
