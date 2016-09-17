//
//  iState.m
//  YYPlay
//
//  Created by jeremy on 9/12/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import "iState.h"

@implementation iState

static iState *_sharedInstance = nil;
static dispatch_once_t onece = 0;

+ (id)shearedInstance
{
    dispatch_once(&onece, ^{
        if (_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
    });
    return _sharedInstance;
}

+ (void)setSharedInstance:(iState *)instance
{
    onece = 0;
    _sharedInstance = instance;
    
}

- (id)initStateMachineForObject:(id)object withOptions:(NSDictionary *)options eventNotificationType:(iStateEventNotificationType)eventNotificationType
{
    self = [iState shearedInstance];
    if (self) {
        if (eventNotificationType) {
            _sendEventsUsingNotificationType = eventNotificationType;
        }
        
        NSDictionary *states = [options objectForKey:@"states"];
        iStateLog(@"STATES = %@",states);
        if (states) {
            _iStates = states;
        }
        
        if ([options objectForKey:@"initialState"]) {
            _currentState = [options objectForKey:@"initialState"];
        }
        if (object) {
            _delegate = object;
        }
    }
    
    return self;
}

- (BOOL)handle:(SEL)method withArguments:(NSArray *)args
{
    BOOL canHandle = NO;
    Method m = class_getInstanceMethod([_delegate class], method);
    char returnType[128];
    method_getReturnType(m, returnType, sizeof(returnType));
    
    NSArray *allowedMethods;
    NSString *desiredMethodString = NSStringFromSelector(method);
    NSMutableDictionary *eventdata = [[NSMutableDictionary alloc] init];
    if ([self stateHasDefinedAllowedMethods:_currentState]) {
        allowedMethods = [[[_iStates objectForKey:_currentState] objectForKey:iStateAllowedMethods] copy];
        for (NSString *methodName in allowedMethods) {
            if ([methodName isEqualToString:desiredMethodString] && [_delegate respondsToSelector:method]) {
                [eventdata setObject:desiredMethodString forKey:@"method"];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_delegate methodSignatureForSelector:method]];
                [invocation setTarget:_delegate];
                [invocation setSelector:method];
                size_t ind = 2;
                for (id arg in args) {
                    id argd = [args objectAtIndex:(ind - 2)];
                    [invocation setArgument:&argd atIndex:ind];
                    ind++;
                }
                
                [invocation invoke];
                
                // If we have a non-void method then we get the return value and pass along
                if (strncmp(returnType, "v", 1) != 0){
                    id returnValue;
                    [invocation getReturnValue:&returnValue];
                    [eventdata setObject:returnValue forKey:@"returnValue"];
                }
                [self sendEvent:kStateEventHandled withData:eventdata];
                canHandle = YES;
                break;
            }
        }
    }
    
    if(!canHandle){
        [self sendEvent:kStateEventNoHandler withData:@{@"method":desiredMethodString}];
    }
    
    return canHandle;
}

- (BOOL)transition:(NSString *)desiredState
{
    NSArray *allowedTransitions;
    BOOL canTransition = NO;
    if ([self stateHasDefineAllowedTransitions:_currentState]) {
        allowedTransitions = [[[_iStates objectForKey:_currentState] objectForKey:iStateAllowedTransitions] copy];
        for (NSString *allowedStates in allowedTransitions) {
            if ([allowedStates isEqualToString:desiredState]) {
                canTransition = YES;
                [self callOnExitBlock:_currentState];
                _previousState = _currentState;
                _currentState = desiredState;
                [self callOnEnterBlock:_currentState];
                [self sendEvent:kStateEventTransitioned withData:@{@"currentState":_currentState, @"previousState":_previousState}];
                break;
            }
        }
    }
    if (!canTransition) {
        [self sendEvent:kStateEventTransitionFailed withData:@{@"desiredState":desiredState}];
    }
    return canTransition;
}

- (NSString *)getState
{
    return _currentState;
}

- (void)setSendEventsUsingNotificationType:(iStateEventNotificationType)type
{
    _sendEventsUsingNotificationType = type;
}

- (void)callOnEnterBlock:(NSString *)state
{
    if (![_iStates objectForKey:state]) {
        return;
    }
    if ([[_iStates objectForKey:state] objectForKey:iStateOnEnter]) {
        if ([[[_iStates objectForKey:state] objectForKey:iStateOnEnter] isKindOfClass:NSClassFromString(@"NSBlock")]) {
            iStateLog(@"have a value for on enter");
            void (^afunc)(void) = [[_iStates objectForKey:state] objectForKey:iStateOnEnter];
            afunc();
        } else {
            iStateLog(@"No a block so onEnter cant be called");
        }
    }
}

- (void)callOnExitBlock:(NSString *)state
{
    if (![_iStates objectForKey:state]) {
        return;
    }
    if ([[_iStates objectForKey:state] objectForKey:iStateOnExit]) {
        if ([[[_iStates objectForKey:state] objectForKey:iStateOnExit] isKindOfClass:NSClassFromString(@"NSBlock")]) {
            iStateLog(@"have a value for on exit");
            void (^afunc)(void) = [[_iStates objectForKey:state] objectForKey:iStateOnExit];
            afunc();
        } else {
            iStateLog(@"Not a block so onExit cant  be called");
        }
    }
}

- (BOOL)stateHasDefinedAllowedMethods:(NSString *)state
{
    if (_iStates && [[_iStates objectForKey:state] objectForKey:iStateAllowedMethods]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)stateHasDefineAllowedTransitions:(NSString *)state
{
    if (_iStates && [[_iStates objectForKey:state] objectForKey:iStateAllowedTransitions]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)trigger:(NSString *)customEventName withData:(NSDictionary *)data
{
    NSString *selectorName = customEventName;
    if (data) {
        selectorName = [NSString stringWithFormat:@"%@:", customEventName];
    }
    
    switch (_sendEventsUsingNotificationType) {
        case iStateEventNotificationUseDelegate:
            if ([_delegate respondsToSelector:NSSelectorFromString(selectorName)]) {
                iStateLog(@"Trigger custom event %@", customEventName);
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_delegate methodSignatureForSelector:NSSelectorFromString(selectorName)]];
                [invocation setTarget:_delegate];
                [invocation setSelector:NSSelectorFromString(selectorName)];
                [invocation setArgument:&data atIndex:2];
                [invocation invoke];
            }
            break;
        case iStateEventNotificationUseNotificationCenter:
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@%@", @"iState", customEventName] object:nil userInfo:data];
            break;
        default:
            break;
    }
}

- (void)sendEvent:(iStateEvent)event withData:(NSDictionary *)data
{
    switch (_sendEventsUsingNotificationType) {
        case iStateEventNotificationUseDelegate:
            [self sendEventToDelegate:event withData:data];
            break;
        case iStateEventNotificationUseNotificationCenter:
            [self sendEventToNotificationCenter:event withData:data];
            break;
        default:
            break;
    }
}

- (void)sendEventToDelegate:(iStateEvent)event withData:(NSDictionary *)data
{
    switch (event) {
        case kStateEventHandled:
            if ([_delegate respondsToSelector:@selector(iStateMethodHandled:)]) {
                [_delegate iStateMethodHandled:data];
            }
            break;
        case kStateEventNoHandler:
            if ([_delegate respondsToSelector:@selector(iStateMethodNoHandler:)]) {
                [_delegate iStateMethodNoHandler:data];
            }
            break;
        case kStateEventTransitioned:
            if ([_delegate respondsToSelector:@selector(iStateTransitionCompleted:)]) {
                [_delegate iStateTransitionCompleted:data];
            }
            break;
        case kStateEventTransitionFailed:
            if ([_delegate respondsToSelector:@selector(iStateTransitionFailed:)]) {
                [_delegate iStateTransitionFailed:data];
            }
            break;
        default:
            break;
    }
}

- (void)sendEventToNotificationCenter:(iStateEvent)event withData:(NSDictionary *)data
{
    NSString *notificationName = @"";
    switch (event) {
        case kStateEventHandled:
            notificationName = iStateEventHandled;
            break;
        case kStateEventNoHandler:
            notificationName = iStateEventNoHandler;
            break;
        case kStateEventTransitioned:
            notificationName = iStateEventTransitionComplete;
            break;
        case kStateEventTransitionFailed:
            notificationName = iStateEventTransitionFailed;
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:data];
}

@end
