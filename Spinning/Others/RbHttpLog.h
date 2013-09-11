//
//  RbHttpLog.h
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>



enum ApiLogLevel{
    ApiLogNone = 0,
    ApiLogError,
    ApiLogWarn,
    ApiLogInfo,
    ApiLogDebug,
};

/**
 * get / set the log level
 **/
extern enum ApiLogLevel apiGetLogLevel();
extern void apiSetLogLevel(enum ApiLogLevel level);

/**
 *  log message
 **/
extern void apiLogError(NSString *format,...);
extern void apiLogWarn(NSString *format,...);
extern void apiLogInfo(NSString *format,...);
extern void apiLogDebug(NSString *format,...);
