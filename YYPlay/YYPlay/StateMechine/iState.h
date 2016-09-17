//
//  iState.h
//  YYPlay
//
//  Created by jeremy on 9/12/16.
//  Copyright © 2016 MF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#if RELEASE
#define iStateLog(fmt, ...)
#else
#define iStateLog(fmt, ...) NSLog((@"[%s Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#define iStateInitialState            @"initialState"
#define iStateAllowedMethods          @"iStateAllowedMethods"
#define iStateAllowedTransitions      @"iStateAllowedTransitions"
#define iStateEventHandled            @"iStateEventHandled"
#define iStateEventNoHandler          @"iStateEventNoHandler"
#define iStateEventTransitionComplete @"iStateEventTransitionComplete"
#define iStateEventTransitionFailed   @"iStateEventTransitionFailed"
#define iStateOnEnter                 @"iStateOnEnter"
#define iStateOnExit                  @"iStateOnExit"

@protocol iStateMachineDelegate <NSObject>

@optional
- (void)iStateMethodHandled:(NSDictionary *)data;
- (void)iStateMethodNoHandler:(NSDictionary *)data;
- (void)iStateTransitionCompleted:(NSDictionary *)data;
- (void)iStateTransitionFailed:(NSDictionary *)data;

@end

typedef NS_ENUM(NSInteger, iStateEvent) {
    kStateEventHandled,
    kStateEventNoHandler,
    kStateEventTransitioned,
    kStateEventTransitionFailed
};

typedef NS_ENUM(NSInteger, iStateEventNotificationType) {
    iStateEventNotificationUseDelegate,
    iStateEventNotificationUseNotificationCenter
};

@interface iState : NSObject
{
    NSDictionary *_iStates;
    id _delegate;
    iStateEventNotificationType _sendEventsUsingNotificationType;
}

@property (nonatomic, strong, readonly) NSString *currentState;
@property (nonatomic, strong, readonly) NSString *previousState;

+(id)shearedInstance;

-(id)initStateMachineForObject:(id)object withOptions:(NSDictionary *)options
         eventNotificationType:(iStateEventNotificationType)eventNotificationType;

+ (void)setSharedInstance:(iState *)instance;
- (void)setSendEventsUsingNotificationType:(iStateEventNotificationType)type;
- (BOOL)handle:(SEL)method withArguments:(NSArray *)args;
- (void)trigger:(NSString *)customEventName withData:(NSDictionary *)data;
- (BOOL)transition:(NSString *)desiredState;
- (NSString *)getState;


@end
