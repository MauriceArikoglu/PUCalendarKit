//
//  PUEventParser.h
//
//  Created by Maurice Arikoglu on 16.11.17.
//  Copyright © 2017 Maurice Arikoglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PUCalendarEvent, PURecurrenceRules, PUExceptionRules;
@interface PUEventParser : NSObject

+ (PUCalendarEvent *)parseEventWithICSEventString:(NSString *)eventString inCalendarContext:(NSString *)calendarContext;

+ (PURecurrenceRules *)parseRecurrenceRulesWithICSEventRecurrenceRuleString:(NSString *)recurrenceRuleString inCalendarContext:(NSString *)calendarContext;

+ (PUExceptionRules *)parseExceptionRulesWithICSEventExceptionRuleString:(NSString *)exceptionRuleString inCalendarContext:(NSString *)calendarContext;

@end
