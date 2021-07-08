//
//  TabEntryTypes.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 08/06/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "TabEntryTypes.h"

@interface TabEntryTypes ()

@end

@implementation TabEntryTypes

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SetupData=[AppSetupData sharedDatas];
    // Do any additional setup after loading the view.
    self.tabETyp.NavCtrl=self.navigationController;
    [[self.tabETyp.items objectAtIndex:0] setTitle:NSLocalizedString( self.SetupData.CapDr,  self.SetupData.CapDr)];
    [[self.tabETyp.items objectAtIndex:1] setTitle:NSLocalizedString( self.SetupData.CapChm,  self.SetupData.CapChm)];
    [[self.tabETyp.items objectAtIndex:2] setTitle:NSLocalizedString( self.SetupData.CapStk,  self.SetupData.CapStk)];
    [[self.tabETyp.items objectAtIndex:3] setTitle:NSLocalizedString( self.SetupData.CapUdr,  self.SetupData.CapUdr)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
