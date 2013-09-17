//
//  NSObject+MKBlockAdditions.h
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 25/03/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBlockAdditions.h"

@interface NSObject (MKBlockAdditions)

- (void) performBlock:(VoidBlock) block;
- (void) performBlock:(VoidBlock) block afterDelay:(NSTimeInterval) delay;
//执行多个参数的方法
- (id)performSelector:(SEL)aSelector withMultiObjects:(id)object,...;
@end
