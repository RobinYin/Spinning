//
//  NewsReadModel0.m
//  Spinning
//
//  Created by Robin on 9/26/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "NewsReadModel0.h"

@implementation NewsReadModel0
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