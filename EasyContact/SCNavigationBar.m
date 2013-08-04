//
//  ECNavigationBar.m
//  EasyContact
//
//  Created by Maxime de Chalendar on 12/07/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import "SCConstantStrings.h"

#import "SCNavigationBar.h"

#import "SCSettingsTableViewController.h"


/*----------------------------------------------------------------------------*/
#pragma mark - Implementation
/*----------------------------------------------------------------------------*/
@implementation SCNavigationBar

/*----------------------------------------------------------------------------*/
#pragma mark - UIView
/*----------------------------------------------------------------------------*/
- (void)drawRect:(CGRect)rect {
    UIImage * img = [UIImage imageNamed:ImgNavBarBg];
    [img drawInRect:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
}


/*----------------------------------------------------------------------------*/
#pragma mark - Misc public methods
/*----------------------------------------------------------------------------*/
- (void)displaySettingsOnNavigationController:(UINavigationController *)controller andDelegate:(id<SCSettingsDelegate>)delegate {
    static NSString * const VCIdSettings = @"ECSettingsViewController";
    UIStoryboard *sb = [UIStoryboard storyboardWithName:MainStoryBoard bundle:nil];
    SCSettingsTableViewController * tvc = [sb instantiateViewControllerWithIdentifier:VCIdSettings];
    [tvc setDelegate:delegate];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [controller presentViewController:nc animated:YES completion:nil];
}

@end
