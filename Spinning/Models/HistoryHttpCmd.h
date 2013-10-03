//
//  HistoryHttpCmd.h
//  Spinning
//
//  Created by Robin on 10/3/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "ListHttpCmd.h"

@interface HistoryModel : ListModel
@property (nonatomic, retain)NSString *code;
@property (nonatomic, retain)NSString *registertime;
@property (nonatomic, retain)NSString *name;
@end

@interface HistoryHttpCmd : ListHttpCmd

@end
