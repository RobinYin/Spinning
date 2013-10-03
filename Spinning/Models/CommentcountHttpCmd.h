//
//  CommentcountHttpCmd.h
//  Spinning
//
//  Created by Robin on 10/4/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "ListHttpCmd.h"
@interface CommentcountModel : ListModel
@property (nonatomic, retain)NSString *count;
@property (nonatomic, retain)NSString *mid;
@end
@interface CommentcountHttpCmd : ListHttpCmd

@end
