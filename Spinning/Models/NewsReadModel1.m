//
//  NewsReadModel1.m
//  Spinning
//
//  Created by Robin on 9/26/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "NewsReadModel1.h"

@implementation NewsReadModel1
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
    return NSStringFromClass([self class]);
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
