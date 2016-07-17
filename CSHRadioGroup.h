//
//  CSHRadioGroup.h
//  CSHRadioGroup
//
//  Created by shuncheng on 16/7/17.
//  Copyright © 2016年 shuncheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CSHRadioGroup;

@protocol CSHRadioGroupDelegate <NSObject>

@optional
- (void)radioGroup:(CSHRadioGroup *)radioGroup needCheckCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)radioGroup:(CSHRadioGroup *)radioGroup needUncheckCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)radioGroup:(CSHRadioGroup *)radioGroup didSelectIndexPath:(NSIndexPath *)indexPath;

@end

@interface CSHRadioGroup : NSObject <UITableViewDelegate>

@property (nonatomic, weak) id <CSHRadioGroupDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

#pragma mark IndexPath State

- (void)addIndexPath:(NSIndexPath *)indexPath;
- (void)removeIndexPath:(NSIndexPath *)indexPath;
- (BOOL)containIndexPath:(NSIndexPath *)indexPath;
- (void)addSection:(NSInteger)section withRowCount:(NSInteger)rowCount;

#pragma mark Forwarding

- (id<UITableViewDelegate>)forwardingTo:(id<UITableViewDelegate>)forwardDelegate;
- (void)removeForwarding:(id<UITableViewDelegate>)forwardDelegate;

@end

