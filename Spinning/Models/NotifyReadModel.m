//
//  NotifyReadModel.m
//  Spinning
//
//  Created by Robin on 9/27/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "NotifyReadModel.h"

@implementation NotifyReadModel
@synthesize mid = _mid;
+(void)dbWillInsert:(NSObject *)entity
{
    LKLog(@"will insert : %@",NSStringFromClass(self));
}

+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result
{
    LKLog(@"did insert : %@",NSStringFromClass(self));
}


+(NSString *)getPrimaryKey
{
    return @"mid";
}

+(NSString *)getTableName
{
    return @"NewsReadModel0";
}

+(int)getTableVersion
{
    return 3;
}

- (void)dealloc
{
    RbSuperDealoc;
}
@end

