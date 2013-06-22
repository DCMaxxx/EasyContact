//
//  ECFavoriteNumber.h
//  EasyContact
//
//  Created by Maxime de Chalendar on 18/06/13.
//  Copyright (c) 2013 Maxime de Chalendar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ECFavoritesHandler.h"

@class ECContact;


@interface ECFavoriteNumber : NSObject

@property (strong, nonatomic) NSString * contactNumber;
@property (nonatomic) eContactNumberKind kind;
@property (strong, nonatomic) ECContact * contact;

- (id)initWithContact:(ECContact *)contact kind:(eContactNumberKind)kind andNumber:(NSString *) contactNumber;

@end
