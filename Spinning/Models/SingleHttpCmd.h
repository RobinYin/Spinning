//
//  SingleHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/3/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbHttpCmd.h"

@interface SingleModel : RbBaseModel
@property (nonatomic, retain)NSString *code;
@property (nonatomic, retain)NSString *msg;
@end

@interface SingleHttpCmd : RbHttpCmd
@property (nonatomic, retain)NSString *userId;
@property (nonatomic, retain)SingleModel *model;
@end
