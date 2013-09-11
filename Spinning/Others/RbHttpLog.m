//
//  RbHttpLog.m
//  Spinning
//
//  Created by Robin on 8/31/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import "RbHttpLog.h"

static enum ApiLogLevel currentLevel = ApiLogDebug;

enum ApiLogLevel apiGetLogLevel(){
    return currentLevel;
}

void apiSetLogLevel(enum ApiLogLevel level){
    currentLevel = level;
}


void apiLogError(NSString *format,...){
    
    // check level to determine whether we need to log message
    if (currentLevel < ApiLogError) {
        return;
    }
    
    // log message
    va_list argList;
    va_start(argList,format);
    
    NSLogv(format,argList);
    
    va_end(argList);
    
}

void apiLogWarn(NSString *format,...){
    
    // check level to determine whether we need to log message
    if (currentLevel < ApiLogWarn) {
        return;
    }
    
    // log message
    va_list argList;
    va_start(argList,format);
    
    NSLogv(format,argList);
    
    va_end(argList);
    
}

void apiLogInfo(NSString *format,...){
    
    // check level to determine whether we need to log message
    if (currentLevel < ApiLogInfo) {
        return;
    }
    
    // log message
    va_list argList;
    va_start(argList,format);
    
    NSLogv(format,argList);
    
    va_end(argList);
    
}

void apiLogDebug(NSString *format,...){
    
    // check level to determine whether we need to log message
    if (currentLevel < ApiLogDebug) {
        return;
    }
    
    // log message
    va_list argList;
    va_start(argList,format);
    
    NSLogv(format,argList);
    
    va_end(argList);
    
}
