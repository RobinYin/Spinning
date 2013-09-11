//
//  RbHttpDelegate.h
//  Spinning
//
//  Created by Robin on 9/1/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RbHttpCmd.h"
@protocol RbHttpDelegate <NSObject>
@optional
- (void) httpResult:(id)cmd  error:(NSError*)error;
@end
