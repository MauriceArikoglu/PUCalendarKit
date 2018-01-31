//
//  PUCalendarEvent.h
//
//  Created by Maurice Arikoglu, based on MXLCalendarManager Framework by Kiran Panesar created on 09/04/2013.
//  Copyright (c) 2017 Maurice Arikoglu. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "PUEventAttendee.h"
#import "PUCalendarEnumerations.h"

@class EKEvent;
@class EKEventStore;

@class PURecurrenceRules, PUExceptionRules;
@interface PUCalendarEvent : NSObject <NSCopying>

@property (nonatomic, retain) NSDate *eventStartDate;
@property (nonatomic, retain) NSDate *eventEndDate;
@property (assign, nonatomic) BOOL eventIsAllDay;

@property (nonatomic, retain) NSDate *eventCreatedDate;
@property (nonatomic, retain) NSDate *eventLastModifiedDate;
@property (nonatomic, copy) NSString *eventUniqueId;

@property (nonatomic, copy) NSString *eventRecurrenceId;
@property (nonatomic, copy) NSString *eventSummary;
@property (nonatomic, copy) NSString *eventDescription;
@property (nonatomic, copy) NSString *eventLocation;

@property (nonatomic, copy) PURecurrenceRules *recurrenceRules;
@property (nonatomic, copy) NSString *recurrenceRuleString;
@property (nonatomic, copy) PUExceptionRules *exceptionRules;
@property (nonatomic, copy) NSString *exceptionRuleString;

@property (nonatomic, assign) PUStatus eventStatus;

@property (nonatomic, retain) NSArray<PUEventAttendee *> *eventAttendees;

- (id)initWithStartDate:(NSDate *)startDate
           eventEndDate:(NSDate *)endDate
          eventIsAllDay:(BOOL)isAllDay
            createdDate:(NSDate *)createdDate
       lastModifiedDate:(NSDate *)lastModifiedDate
               uniqueId:(NSString *)uniqueId
           recurrenceId:(NSString *)recurrenceId
         summaryOrTitle:(NSString *)summary
       eventDescription:(NSString *)description
          eventLocation:(NSString *)location
            eventStatus:(PUStatus)status
   recurrenceRuleString:(NSString *)recurrenceRuleString
    exceptionRuleString:(NSString *)exceptionRuleString
         exceptionDates:(NSArray *)exceptionDates
               timeZone:(NSString *)timeZoneAbbreviationOrId
         eventAttendees:(NSArray<PUEventAttendee *> *)attendees;

- (NSDate *)dateFromString:(NSString *)dateString;

- (BOOL)checkDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;

- (BOOL)checkDate:(NSDate *)date;

- (BOOL)exceptionOnDate:(NSDate *)date;

- (EKEvent *)convertToEKEventOnDate:(NSDate *)date withEventStore:(EKEventStore *)eventStore;

@end
@compatibility_alias MXLCalendarEvent PUCalendarEvent;
