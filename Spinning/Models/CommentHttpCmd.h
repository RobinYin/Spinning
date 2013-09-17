//
//  CommentHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/16/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbHttpCmd.h"

@interface CommentModel : RbBaseModel
@property (nonatomic, retain)NSString *commentid;
@property (nonatomic, retain)NSString *username;
@property (nonatomic, retain)NSString *commentip;
@property (nonatomic, retain)NSString *content;
@property (nonatomic, retain)NSString *time;
@end

@interface CommentHttpCmd : RbHttpCmd
@property (nonatomic, retain)NSString *userId;
@property (nonatomic, retain)NSString *commentid;
@property (nonatomic, retain)NSString *mid;
@property (nonatomic, retain)NSMutableArray *lists;
@end
