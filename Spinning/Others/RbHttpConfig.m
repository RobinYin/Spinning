//
//  RbHttpConfig.m
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbHttpConfig.h"

static enum Environment apiEnv = APIDEV;

static struct EnvConfig envConfigArray[APIEND] = {
    //API Dev
    {
        .apiRequestUrlPrefix = "http://client.ckia.org:8080",
        .apiAppId = "/srv",
    },
    //API QA
    {
        .apiRequestUrlPrefix = "http://www.baike.com/api",
        .apiAppId = "3619919282",
    },
    //API Live
    {
        .apiRequestUrlPrefix = "http://www.baike.com/api",
        .apiAppId = "97b291a1eae2f6020708c169512f9478",
    }
};

@implementation RbHttpConfig

+ (enum Environment) onEnv{
    return apiEnv;
}

static const struct EnvConfig* getEnvConfig() {
    
    return &envConfigArray[apiEnv];
}

static const char* getApiRequestUrlPrefix() {
    return getEnvConfig()->apiRequestUrlPrefix;
}

static const char* getApiAppId() {
    return getEnvConfig()->apiAppId;
}

+ (void) setEnv:(enum Environment) env{
    apiEnv = env;
}


+ (NSString*) onApiRequestUrlPrefix{
    return [NSString stringWithUTF8String:getApiRequestUrlPrefix()];
}

+ (NSString*) onApiAppId{
    return [NSString stringWithUTF8String:getApiAppId()];
}



@end
