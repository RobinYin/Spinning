//
//  NewsHttpCmd.h
//  Spinning
//
//  Created by Robin on 9/1/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "ListHttpCmd.h"

@interface NewsModel : ListModel

@end

@interface NewsHttpCmd : ListHttpCmd
@property (nonatomic, retain)NSString *typeId;
@end
