//
//  RbMacrosHeader.h
//  Spinning
//
//  Created by Robin on 7/27/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#ifndef Spinning_RbMacrosHeader_h
#define Spinning_RbMacrosHeader_h

//NONE/NSLOG/DLOG
#define DEBUG_LOG_MODE 2

#ifdef DEBUG_LOG_MODE
#
#
#	if   DEBUG_LOG_MODE==0
#		define QFDebugLog @"RbDebugLogDismiss"
#		define NSLog(...) /* */
#       define DLog(fmt, ...) /* */
#
#	elif DEBUG_LOG_MODE==1
#		define QFDebugLog @"RbDebugLog"
#        define DLog(fmt, ...) /* */
#
#	elif DEBUG_LOG_MODE==2
#		define QFDebugLog @"RbDebugLog"
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#	endif
#
#   else
#	define NSLog(...) /* */
#	define QFDebugLog @"RbDebugLogDismiss"
#endif




#pragma mark - Memory functions ---------------------------------------------------------------------------------------------

#if ! __has_feature(objc_arc)
#define RbAutorelease(__v) ([__v autorelease]);
#define RbReturnAutoreleased SDWIAutorelease

#define RbRetain(__v) ([__v retain]);
#define RbReturnRetained SDWIRetain

#define RbRelease(__v) ({if(__v){[__v release]; }});
#define RbSafeRelease(__v) ({if(__v){[__v release]; __v = nil; }});
#define RbSuperDealoc [super dealloc];

#define RbWeak
#else
// -fobjc-arc
#define RbAutorelease(__v)
#define RbReturnAutoreleased(__v) (__v)

#define RbRetain(__v)
#define RbReturnRetained(__v) (__v)

#define RbRelease(__v)
#define RbSafeRelease(__v) (__v = nil);
#define RbSuperDealoc

#define RbWeak __unsafe_unretained
#endif



#pragma mark - Devices functions ---------------------------------------------------------------------------------------------

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iOS_Version [[UIDevice currentDevice].systemVersion doubleValue]
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height 
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define StatusBarHeight 20



#pragma mark - Global constants ---------------------------------------------------------------------------------------------

#define NavigationHorizonGap 0
#define NavigationVerticalGap 2
#define NavigationBtnWith 40
#define NavigationBtnheight 40
#define NavigationHeight 44
#define TabBarHeight 50
#define TagBegin 1000


#pragma mark - SelectScroll constants ---------------------------------------------------------------------------------------------

#define ScrollSelectWidth 300
#define ScrollSelectOtherWidth 20
#define ScrollSelectHeight 25
#define ScrollSelectGap 5
#define ScrollSelectFont 14
#define ScrollSelectBgNormalColor ([UIColor colorWithRed:45./255. green:35./255 blue:35./255 alpha:1])
#define ScrollSelectBgSelectColor ([UIColor whiteColor])


#pragma mark - NewsCell constants ---------------------------------------------------------------------------------------------
#define NewsCellGap 10
#define NewsCellImageWith 80
#define NewsCellHeight 70


#pragma mark - PHCell constants ---------------------------------------------------------------------------------------------
#define PHCellGap 10
#define PHCellImageWith 80
#define PHCellHeight 70

#pragma mark - NotificationCell constants ---------------------------------------------------------------------------------------------
#define NotificationCellGap 10
#define NotificationCellTitleWith 150
#define NotificationCellHeight 72

#pragma mark - MoreCell constants ---------------------------------------------------------------------------------------------
#define MoreCellHeight 44

#pragma mark - NotificationCell constants ---------------------------------------------------------------------------------------------
#define HistoryCellGap 10
#define HistoryCellTitleWith 150
#define HistoryCellHeight 72

#pragma mark - TopicCell constants ---------------------------------------------------------------------------------------------
#define TopicCellGap 10
#define TopicCellImgWith 300
#define TopicCellImgheight 150
#define TopicCellHeight 257

#pragma mark - LoginView constants ---------------------------------------------------------------------------------------------
#define LoginViewVerticalGap 40
#define LoginViewHorizontalGap 10
#define LoginViewTextWidth 300
#define LoginViewTextHeight 44
#define LoginViewOriginY 100

#endif