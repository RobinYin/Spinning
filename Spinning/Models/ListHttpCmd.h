//
//  ListHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/1/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbHttpCmd.h"
#import "RbBaseModel.h"
@interface ListModel : RbBaseModel

@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)NSString *time;
@property (nonatomic, retain)NSString *mid;
@property (nonatomic, retain)NSString *icon;
@property (nonatomic, retain)NSString *content;
@property (nonatomic, retain)NSString *source;
@property (nonatomic, retain)NSString *articleurl;
@property (nonatomic, retain)NSString *totalcount;

@end

@interface ListHttpCmd : RbHttpCmd

@property (nonatomic, retain)NSString *cursor;
@property (nonatomic, retain)NSString *userId;
@property (nonatomic, retain)NSMutableArray *lists;

@end
