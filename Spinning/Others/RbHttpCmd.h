//
//  RbHttpCmd.h
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RbHttpDelegate.h"
#import "ASIFormDataRequest.h"
@interface RbHttpCmd : NSObject
{
    id<RbHttpDelegate> _delegate;
}

@property (nonatomic, assign)id<RbHttpDelegate> delegate;
@property (nonatomic, retain)NSMutableDictionary* errorDict;
@property (nonatomic, assign)BOOL isFromCache;
- (void)setHttpRequest:(ASIFormDataRequest *)req;
- (NSString *)onSuffixUrl;

- (NSMutableDictionary*) paramDict;

- (void) parseResultData:(NSDictionary*) dictionary;

- (NSString*) cacheFilePath;

- (void) parseHttpData:(NSData*) data;

@end
