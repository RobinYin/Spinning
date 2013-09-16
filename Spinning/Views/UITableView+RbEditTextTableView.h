//
//  UITableView+RbEditTextTableView.h
//  Spinning
//
//  Created by Robin on 9/11/13.
//  Copyright (c) 2013 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (RbEditTextTableView)

-(NSIndexPath *) indexPathForFirstResponder;
-(UITextField *) currentFirstResponderTextField;

-(void) makeNextCellWithTextFieldFirstResponder;
-(void) makeFirstResponderForIndexPath: (NSIndexPath *) indexPath;
-(void) makeFirstResponderForIndexPath: (NSIndexPath *) indexPath scrollPosition: (UITableViewScrollPosition) scrollPosition;

-(void) beginWatchingForKeyboardStateChanges;
-(void) endWatchingForKeyboardStateChanges;

-(NSMutableArray *) notificationObservers;
-(UITextField *) textFieldForCell: (UITableViewCell *) cell;
-(BOOL) indexPath: (NSIndexPath *) indexPath isInRangeFromIndexPath: (NSIndexPath *) fromIndexPath  toIndexPath: (NSIndexPath *) toIndexPath;
-(BOOL) makeNextCellWithTextFieldFirstResponderFromIndexPath: (NSIndexPath *) fromIndexPath
												 toIndexPath: (NSIndexPath *) toIndexPath;

@end
