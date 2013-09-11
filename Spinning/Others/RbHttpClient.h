//
//  RbHttpClient.h
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RbHttpClient : NSObject

+(RbHttpClient *)sharedInstance;

- (NSError*) onPostCmdAsync:(RbHttpCmd*) cmd;

- (NSError*) onPostCmdSync:(RbHttpCmd*) cmd;

- (NSError*) onGetCmdAsync:(RbHttpCmd*) cmd;

- (NSError*) onGetCmdSync:(RbHttpCmd*) cmd;
@end
