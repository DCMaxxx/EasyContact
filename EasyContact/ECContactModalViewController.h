//
//  BCContactModalViewController.h
//  BetterContacts
//
//  Created by Maxime de Chalendar on 17/05/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECKindHandler.h"


@class ECContact;


@interface ECContactModalViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) ECContact * contact;
@property (nonatomic) eContactNumberKind kind;

-(void)hidePopup;

@end
