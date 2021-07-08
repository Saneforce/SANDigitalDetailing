//
//  PdfDataViewerCtrlr.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 22/02/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import "PdfDataViewerCtrlr.h"

@implementation PdfDataViewerCtrlr

-(void) dealloc {
    if( self.page != NULL ) CGPDFPageRelease( self.page );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //int tPage= (int)CGPDFDocumentGetNumberOfPages( self.pdf );
    self.page = CGPDFDocumentGetPage( self.pdf, self.pageNumber );
    NSLog(@"self.page==NULL? %@",self.page==NULL?@"yes":@"no");
    
    if( self.page != NULL ) {
        CGPDFPageRetain( self.page );
        [self.scrollVw setPDFPage:self.page]; //];
        [self restoreScale];
    }
}

-(void)viewDidLayoutSubviews {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    //[self restoreScale];
}


-(void)restoreScale {
    // Called on orientation change.
    // We need to zoom out and basically reset the scrollview to look right in two-page spline view.
    CGRect pageRect = CGPDFPageGetBoxRect( self.page, kCGPDFMediaBox );
  ////  CGFloat yScale = self.view.frame.size.height/pageRect.size.height;
    CGFloat xScale = self.view.frame.size.width/pageRect.size.width;
    self.myScale =xScale; //MIN( xScale, yScale );
    NSLog(@"%s self.myScale=%f",__PRETTY_FUNCTION__, self.myScale);
    CGRect insetFrame = CGRectMake(0, 0, self.view.frame.size.width, pageRect.size.height*self.myScale);
    self.scrollView.bounds = self.view.bounds;
    
    self.scrollView.maximumZoomScale = 20; // set as you want.
    self.scrollView.minimumZoomScale = 1; // set as you want.
    
    self.scrollView.zoomScale = 1.0;
    self.scrollView.PDFScale = self.myScale;
    
    self.scrollView.contentSize=CGSizeMake( [[UIScreen mainScreen] bounds].size.width,pageRect.size.height*self.myScale);
    self.scrollView.tiledPDFView.bounds = insetFrame;
    self.scrollView.tiledPDFView.myScale = self.myScale;
    [self.scrollView.tiledPDFView.layer setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
