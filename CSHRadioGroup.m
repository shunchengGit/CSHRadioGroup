//
//  CSHRadioGroup.m
//  CSHRadioGroup
//
//  Created by shuncheng on 16/7/17.
//  Copyright © 2016年 shuncheng. All rights reserved.
//

#import "CSHRadioGroup.h"

#import <objc/runtime.h>

@interface CSHRadioGroup()

@property (nonatomic, readonly, strong) NSMutableSet *forwardDelegates;
@property (nonatomic, readonly, strong) NSMutableSet *flagIDs;

@end

@implementation CSHRadioGroup

- (instancetype)init
{
    if (self = [super init]) {
        _forwardDelegates = [[NSMutableSet alloc] init];
        _flagIDs = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Helper

+ (NSIndexPath *)indexPathForFlagID:(NSString *)flagID
{
    NSArray *components = [flagID componentsSeparatedByString:@"."];
    if (components.count != 2) {
        return nil;
    }

    NSInteger section = [[components firstObject] integerValue];
    NSInteger row = [components[1] integerValue];
    return [NSIndexPath indexPathForRow:row inSection:section];
}

+ (NSString *)flagIDForIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%@.%@", @(indexPath.section), @(indexPath.row)];
}

#pragma mark - Forward Invocations

- (BOOL)shouldForwardSelector:(SEL)selector
{
    struct objc_method_description description;
    description = protocol_getMethodDescription(@protocol(UITableViewDelegate), selector, NO, YES);
    return (description.name != NULL && description.types != NULL);
}

- (BOOL)respondsToSelector:(SEL)selector
{
    if ([super respondsToSelector:selector]) {
        return YES;
    } else if ([self shouldForwardSelector:selector]) {
        for (id delegate in self.forwardDelegates) {
            if ([delegate respondsToSelector:selector]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature == nil) {
        for (id delegate in self.forwardDelegates) {
            if ([delegate respondsToSelector:selector]) {
                signature = [delegate methodSignatureForSelector:selector];
            }
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    BOOL didForward = NO;

    if ([self shouldForwardSelector:invocation.selector]) {
        for (id delegate in self.forwardDelegates) {
            if ([delegate respondsToSelector:invocation.selector]) {
                [invocation invokeWithTarget:delegate];
                didForward = YES;
                break;
            }
        }
    }

    if (!didForward) {
        [super forwardInvocation:invocation];
    }
}

- (id<UITableViewDelegate>)forwardingTo:(id<UITableViewDelegate>)forwardDelegate
{
    [self.forwardDelegates addObject:forwardDelegate];
    return self;
}

- (void)removeForwarding:(id<UITableViewDelegate>)forwardDelegate
{
    [self.forwardDelegates removeObject:forwardDelegate];
}

#pragma mark - Public

- (void)addIndexPath:(NSIndexPath *)indexPath
{
    NSString *flagID = [CSHRadioGroup flagIDForIndexPath:indexPath];
    if (flagID) {
        [self.flagIDs addObject:flagID];
    }
}

- (void)removeIndexPath:(NSIndexPath *)indexPath
{
    NSString *flagID = [CSHRadioGroup flagIDForIndexPath:indexPath];
    if (flagID) {
        [self.flagIDs removeObject:flagID];
    }
}

- (BOOL)containIndexPath:(NSIndexPath *)indexPath
{
    NSString *flagID = [CSHRadioGroup flagIDForIndexPath:indexPath];
    if (flagID) {
        return [self.flagIDs containsObject:flagID];
    } else {
        return NO;
    }
}

- (void)addSection:(NSInteger)section withRowCount:(NSInteger)rowCount
{
    for (NSInteger i = 0; i != rowCount; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [self addIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self containIndexPath:indexPath]) {
        if (self.currentSelectedIndexPath && self.currentSelectedIndexPath.row == indexPath.row &&
            self.currentSelectedIndexPath.section == indexPath.section) {
            if ([self.delegate respondsToSelector:@selector(radioGroup:needCheckCell:atIndexPath:)]) {
                [self.delegate radioGroup:self needCheckCell:cell atIndexPath:indexPath];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(radioGroup:needUncheckCell:atIndexPath:)]) {
                [self.delegate radioGroup:self needUncheckCell:cell atIndexPath:indexPath];
            }
        }
    }

    // Forward the invocation along.
    for (id<UITableViewDelegate> delegate in self.forwardDelegates) {
        if ([delegate respondsToSelector:_cmd]) {
            [delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self containIndexPath:indexPath]) {
        if (self.currentSelectedIndexPath && self.currentSelectedIndexPath.row == indexPath.row &&
            self.currentSelectedIndexPath.section == indexPath.section) {

        } else {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([self.delegate respondsToSelector:@selector(radioGroup:needCheckCell:atIndexPath:)]) {
                [self.delegate radioGroup:self needCheckCell:cell atIndexPath:indexPath];
            }
            
            cell = [tableView cellForRowAtIndexPath:self.currentSelectedIndexPath];
            if ([self.delegate respondsToSelector:@selector(radioGroup:needUncheckCell:atIndexPath:)]) {
                [self.delegate radioGroup:self needUncheckCell:cell atIndexPath:self.currentSelectedIndexPath];
            }
            
            self.currentSelectedIndexPath = indexPath;
            
            if ([self.delegate respondsToSelector:@selector(radioGroup:didSelectIndexPath:)]) {
                [self.delegate radioGroup:self didSelectIndexPath:indexPath];
            }
        }
    }

    // Forward the invocation along.
    for (id<UITableViewDelegate> delegate in self.forwardDelegates) {
        if ([delegate respondsToSelector:_cmd]) {
            [delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

@end
