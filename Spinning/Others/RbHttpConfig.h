//
//  RbHttpConfig.h
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>

enum Environment {APIDEV = 0, APIQA , APILIVE ,APIEND};

struct EnvConfig{
    char apiRequestUrlPrefix[128];
    char apiAppId[64];
};

@interface RbHttpConfig : NSObject

+ (enum Environment) onEnv;
+ (void) setEnv:(enum Environment) env;
+ (NSString*) onApiRequestUrlPrefix;
+ (NSString*) onApiAppId;

@end
