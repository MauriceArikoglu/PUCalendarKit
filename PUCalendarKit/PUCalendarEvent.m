//
//  PUCalendarEvent.m
//
//  Created by Maurice Arikoglu, based on MXLCalendarManager Framework by Kiran Panesar created on 09/04/2013.
//  Algorithm optimised by Cory Withers
//  Copyright (c) 2017 Maurice Arikoglu. All rights reserved.
//
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

#import "PUCalendarEvent.h"
#import "PUCalendarEnumerations.h"

#import <EventKit/EventKit.h>

#import "PUEventParser.h"
#import "PURecurrenceRules.h"
#import "PUExceptionRules.h"

#import "NSDateFormatter+ICS.h"

static NSString *const kDayOfWeekSunday = @"SU";
static NSString *const kDayOfWeekMonday = @"MO";
static NSString *const kDayOfWeekTuesday = @"TU";
static NSString *const kDayOfWeekWednesday = @"WE";
static NSString *const kDayOfWeekThursday = @"TH";
static NSString *const kDayOfWeekFriday = @"FR";
static NSString *const kDayOfWeekSaturday = @"SA";

@interface PUCalendarEvent ()

@property (nonatomic, retain) NSDateFormatter *dateFormatterICS;
@property (nonatomic, retain) NSDateFormatter *dateFormatterHumanReadable;

@property (nonatomic, retain) NSArray *eventExceptionDates;

@property (nonatomic, retain) NSCalendar *calendar;

@end

@implementation MXLCalendarEvent

- (id)copyWithZone:(NSZone *)zone {
    
    MXLCalendarEvent *copy = [[MXLCalendarEvent allocWithZone:zone] init];
    
    if (copy) {
        
        //private properties
        [copy setDateFormatterICS:[self.dateFormatterICS copyWithZone:zone]];
        [copy setDateFormatterHumanReadable:[self.dateFormatterHumanReadable copyWithZone:zone]];
        [copy setEventExceptionDates:[self.eventExceptionDates copyWithZone:zone]];
        [copy setCalendar:[self.calendar copyWithZone:zone]];

        [copy setRecurrenceRules:[self.recurrenceRules copyWithZone:zone]];
        [copy setRecurrenceRuleString:[self.recurrenceRuleString copyWithZone:zone]];
        [copy setExceptionRules:[self.exceptionRules copyWithZone:zone]];
        [copy setExceptionRuleString:[self.exceptionRuleString copyWithZone:zone]];

        //Public properties
        [copy setEventIsAllDay:self.eventIsAllDay];

        [copy setEventStartDate:[self.eventStartDate copyWithZone:zone]];
        [copy setEventEndDate:[self.eventEndDate copyWithZone:zone]];

        [copy setEventCreatedDate:[self.eventCreatedDate copyWithZone:zone]];
        [copy setEventLastModifiedDate:[self.eventLastModifiedDate copyWithZone:zone]];
        
        [copy setEventUniqueId:[self.eventUniqueId copyWithZone:zone]];

        [copy setEventRecurrenceId:[self.eventRecurrenceId copyWithZone:zone]];
        [copy setEventSummary:[self.eventSummary copyWithZone:zone]];
        [copy setEventDescription:[self.eventDescription copyWithZone:zone]];
        [copy setEventLocation:[self.eventLocation copyWithZone:zone]];
        
        [copy setEventStatus:self.eventStatus];

        [copy setEventAttendees:[self.eventAttendees copyWithZone:zone]];
        [copy setOrganizerEmail:[self.organizerEmail copyWithZone:zone]];
    }
    
    return copy;
}

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
         eventAttendees:(NSArray<PUEventAttendee *> *)attendees
         organizerEmail:(NSString *)organizerEmail {

    self = [super init];

    if (self) {
        
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        // Set up the shared NSDateFormatter instance to convert the ics formatted strings to NSDate objects
        self.dateFormatterICS = NSDateFormatter.new;
        self.dateFormatterICS.dateFormat = @"yyyyMMddTHHmmss";
        self.dateFormatterICS.timeZone = ([NSTimeZone timeZoneWithName:timeZoneAbbreviationOrId]) ?: [NSTimeZone localTimeZone];
        
        self.dateFormatterHumanReadable = NSDateFormatter.new;
        self.dateFormatterHumanReadable.dateFormat = @"dd-MM-yyyy HH:mm:ss";
        self.dateFormatterHumanReadable.timeZone = ([NSTimeZone timeZoneWithName:timeZoneAbbreviationOrId]) ?: [NSTimeZone localTimeZone];

        self.eventStartDate = startDate;
        self.eventEndDate = endDate;

        self.eventIsAllDay = isAllDay;
        
        self.eventCreatedDate = createdDate;
        
        self.eventLastModifiedDate = lastModifiedDate;
        
        PURecurrenceRules *recurrenceRules = [PUEventParser parseRecurrenceRulesWithICSEventRecurrenceRuleString:recurrenceRuleString inCalendarContext:timeZoneAbbreviationOrId];
        PUExceptionRules *exceptionRules = [PUEventParser parseExceptionRulesWithICSEventExceptionRuleString:exceptionRuleString inCalendarContext:timeZoneAbbreviationOrId];

        self.recurrenceRules = recurrenceRules;
        self.recurrenceRuleString = recurrenceRuleString;
        self.exceptionRules = exceptionRules;
        self.exceptionRuleString = exceptionRuleString;
        
        self.eventUniqueId = uniqueId;
        self.eventRecurrenceId  = recurrenceId;
        self.eventSummary = [summary stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        self.eventDescription = [description stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        self.eventLocation = [location stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        self.eventStatus = status;
        self.eventAttendees = attendees.copy;
        self.organizerEmail = organizerEmail.copy;
    }
    
    return self;
}

- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterForICSDateString:&dateString];

    return [dateFormatter dateFromString:dateString];
}

- (BOOL)checkDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitMonth| NSCalendarUnitYear fromDate:[NSDate date]];

    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];

    return [self checkDate:[self.calendar dateFromComponents:components]];
}

- (BOOL)checkDate:(NSDate *)date {

    // If the event starts in the future
    if ([self.eventStartDate compare:date] == NSOrderedDescending) {
        return NO;
    }


    // If the event does not repeat, the 'date' must be the event's start date for event to occur on this date
    if (!self.recurrenceRules.repeatRuleFrequency) {

        NSCalendarUnit definiteTimeUnits = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
        // Load date into NSDateComponent from the NSCalendar instance
        NSDateComponents *difference = [self.calendar components:definiteTimeUnits fromDate:self.eventStartDate toDate:date options:0];

        // Check if the event's start date is equal to the provided date
        if (difference.day == 0 &&
            difference.month == 0 &&
            difference.year == 0 &&
            difference.hour == 0 &&
            difference.minute == 0 &&
            difference.second == 0) {
            
            return ![self exceptionOnDate:date]; // Check if there's an exception rule covering this date. Return accordingly
        } else {
            
            return NO; // Event won't occur on this date
        }
    }

    // If the date is in the event's exception dates, event won't occur
    if ([self.eventExceptionDates containsObject:date]) {
        
        return NO;
    }

    // Extract the components from the provided date
    NSCalendarUnit dateAndWeekdayComponents = (NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday);
    NSDateComponents *components = [self.calendar components:dateAndWeekdayComponents fromDate:date];
    
//    NSInteger d = [components day];
//    NSInteger m = [components month];
    
    NSInteger dayOfYear = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];

    NSString *dayString = [self gregorianCalendarICSDayOfWeekFromInteger:components.weekday];
    
    NSString *weekNumberString = [NSString stringWithFormat:@"%li", (long)components.weekOfYear];
    NSString *monthString = [NSString stringWithFormat:@"%li", (long)components.month];

    // If the event is set to repeat on a certain day of the week,
    // it MUST be the current date's weekday for it to occur
    if (self.recurrenceRules.repeatRulesByDay &&
        ((![self.recurrenceRules.repeatRulesByDay containsObject:dayString]) &&
         (![self.recurrenceRules.repeatRulesByDay containsObject:[NSString stringWithFormat:@"1%@", dayString]]) &&
         (![self.recurrenceRules.repeatRulesByDay containsObject:[NSString stringWithFormat:@"2%@", dayString]]) &&
         (![self.recurrenceRules.repeatRulesByDay containsObject:[NSString stringWithFormat:@"3%@", dayString]]))) {
        // These checks are to catch if the event is set to repeat on a particular weekday of the month (e.g., every third Sunday)
            
        return NO;
    }

    // Same as above (and below)
    if ((self.recurrenceRules.repeatRulesByDayOfMonth   &&
         ![self.recurrenceRules.repeatRulesByDayOfMonth containsObject:[NSString stringWithFormat:@"%li", (long)components.day]])
                                                        ||
        (self.recurrenceRules.repeatRulesByDayOfYear    &&
         ![self.recurrenceRules.repeatRulesByDayOfYear containsObject:[NSString stringWithFormat:@"%li", (long)dayOfYear]])
                                                        ||
        (self.recurrenceRules.repeatRulesByWeekOfYear   &&
         ![self.recurrenceRules.repeatRulesByWeekOfYear containsObject:weekNumberString])
                                                        ||
        (self.recurrenceRules.repeatRulesByMonth        &&
         ![self.recurrenceRules.repeatRulesByMonth containsObject:monthString])) {
        
        return NO;
    }

    // If there's no repetition interval provided, it means the interval = 1.
    // We explicitly set it to "1" for use in calculations below
    self.recurrenceRules.repeatRuleInterval = (self.recurrenceRules.repeatRuleInterval == 0) ? 1 : self.recurrenceRules.repeatRuleInterval;

    // If it's set to repeat weekly...
    if (self.recurrenceRules.repeatRuleFrequency == PUFrequencyWeekly) {

        // Is there a limit on the number of repetitions
        // (e.g., event repeats for the 3 occurrences after it first occurred)
        if (self.recurrenceRules.repeatRuleCount) {

            // Get the final possible time the event will be repeated
            NSDateComponents *finalDateComponents = [[NSDateComponents alloc] init];
            finalDateComponents.day = self.recurrenceRules.repeatRuleCount * self.recurrenceRules.repeatRuleInterval;
            
            // Create a date by adding the final week it'll occur onto the first occurrence
            NSDate *maximumDate = [self.calendar dateByAddingComponents:finalDateComponents toDate:self.eventCreatedDate options:0];

            // If the final possible occurrence is in the future...
            if ([maximumDate compare:date] == NSOrderedDescending || [maximumDate compare:date] == NSOrderedSame) {

                // Get the number of weeks between the final date and current date
                  NSInteger difference = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:maximumDate toDate:date options:0].weekOfYear + 1;
              

                // If the difference between the two dates fits the recurrence pattern
                if (difference % self.recurrenceRules.repeatRuleInterval) {
                    // If it doesn't fit into the pattern, it won't occur on this date
                    return NO;
                } else {
                    // If it does fit the pattern, check the EXRULEs of the event
                    return ![self exceptionOnDate:date];
                }
            } else {
                
                return NO;
            }
            // If, instead of a count, a date is specified to cap repetitions...
        } else if (self.recurrenceRules.repeatRuleUntilDate) {
            // See if the repeat until date is AFTER the provided date
            if ([self.recurrenceRules.repeatRuleUntilDate compare:date] == NSOrderedDescending ||
                [self.recurrenceRules.repeatRuleUntilDate compare:date] == NSOrderedDescending) {

                // Find the difference (as before)
                NSInteger difference = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:self.recurrenceRules.repeatRuleUntilDate toDate:date options:0].weekOfYear + 1;

                // If the difference between the two dates fits the recurrence pattern
                if (difference % self.recurrenceRules.repeatRuleInterval) {
                    // if not, event won't occur on date
                    return NO;
                } else {
                    // If it does fit the pattern, check the EXRULEs of the event
                    return ![self exceptionOnDate:date];
                }
            } else {
                
                return NO;
            }
        } else {
            // If there's no recurrence limit, we just have to check if the
            NSInteger difference = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:self.eventStartDate toDate:date options:0].weekOfYear + 1;
            
            if (difference % self.recurrenceRules.repeatRuleInterval) {
                return NO;
            } else {
                
                return ![self exceptionOnDate:date];
            }
        }
        // Same rules apply to above tests
    } else if (self.recurrenceRules.repeatRuleFrequency == PUFrequencyMonthly) {
        
        if (self.recurrenceRules.repeatRuleCount) {

            NSInteger finalMonth = self.recurrenceRules.repeatRuleCount * self.recurrenceRules.repeatRuleInterval;

            NSDateComponents *finalDateComponents = [[NSDateComponents alloc] init];
            finalDateComponents.month = finalMonth;

            NSDate *maximumDate = [self.calendar dateByAddingComponents:finalDateComponents toDate:self.eventCreatedDate options:0];

            if ([maximumDate compare:date] == NSOrderedDescending ||
                [maximumDate compare:date] == NSOrderedSame) {
                
                NSInteger difference = [[self.calendar components:NSCalendarUnitMonth fromDate:[self.calendar dateFromComponents:finalDateComponents] toDate:date options:0] month];
                
                if (difference % self.recurrenceRules.repeatRuleInterval) {
                    
                    return NO;
                } else {
                    
                    return ![self exceptionOnDate:date];
                }
            } else {
                
                return NO;
            }
        } else if (self.recurrenceRules.repeatRuleUntilDate) {
            
            if ([self.recurrenceRules.repeatRuleUntilDate compare:date] == NSOrderedDescending ||
                [self.recurrenceRules.repeatRuleUntilDate compare:date] == NSOrderedSame) {
                
                NSInteger difference = [self.calendar components:NSCalendarUnitMonth fromDate:self.recurrenceRules.repeatRuleUntilDate toDate:date options:0].month;

                if (difference % self.recurrenceRules.repeatRuleInterval) {
                    
                    return NO;
                } else {
                    
                    return ![self exceptionOnDate:date];
                }
            } else {
                
                return NO;
            }
        } else {
            
            NSInteger difference = [self.calendar components:NSCalendarUnitMonth fromDate:self.eventCreatedDate toDate:date options:0].month;
            
            if (difference % self.recurrenceRules.repeatRuleInterval) {
                
                return NO;
            } else {
                
                return ![self exceptionOnDate:date];
            }
        }
    } else if (self.recurrenceRules.repeatRuleFrequency == PUFrequencyYearly) {
        
        if (self.recurrenceRules.repeatRuleCount) {
            
            NSInteger finalYear = self.recurrenceRules.repeatRuleCount * self.recurrenceRules.repeatRuleInterval;

            NSDateComponents *finalDateComponents = [[NSDateComponents alloc] init];
            finalDateComponents.year = finalYear;

            NSDate *maximumDate = [self.calendar dateByAddingComponents:finalDateComponents toDate:self.eventCreatedDate options:0];

            if ([maximumDate compare:date] == NSOrderedDescending ||
                [maximumDate compare:date] == NSOrderedSame) {
                
                NSInteger difference = [self.calendar components:NSCalendarUnitYear fromDate:[self.calendar dateFromComponents:finalDateComponents] toDate:date options:0].year;

                if (difference % self.recurrenceRules.repeatRuleInterval) {
                    
                    return NO;
                } else {
                    
                    return ![self exceptionOnDate:date];
                }
            }
        } else if (self.recurrenceRules.repeatRuleUntilDate) {
            
            NSInteger difference = [self.calendar components:NSCalendarUnitYear fromDate:self.recurrenceRules.repeatRuleUntilDate toDate:date options:0].year;

            if (difference % self.recurrenceRules.repeatRuleInterval) {
                
                return NO;
            } else {
                
                return ![self exceptionOnDate:date];
            }
        } else {
            
            NSInteger difference = [self.calendar components:NSCalendarUnitYear fromDate:self.eventCreatedDate toDate:date options:0].year;
            
            if (difference % self.recurrenceRules.repeatRuleInterval) {
                
                return NO;
            } else {
                
                return ![self exceptionOnDate:date];
            }
        }
    } else {
        
        return NO;
    }

    return NO;
}

// This algorithm functions the same as checkDate: except rather than checking repeatRule parameters, it checks exRule
- (BOOL)exceptionOnDate:(NSDate *)date {
    // If the event does not repeat, the 'date' must be the event's start date for event to occur on this date
    if (!self.exceptionRules.exceptionRuleFrequency) {
        
        return NO;
    }

    // If the date is in the event's exception dates, event won't occur
    if ([self.eventExceptionDates containsObject:date]) {
        
        return NO;
    }

    NSCalendarUnit fullWeekdayUnits = (NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday);
    
    NSDateComponents *checkDateComponents = [self.calendar components:fullWeekdayUnits fromDate:date];

//    NSInteger d = [components day];
//    NSInteger m = [components month];

    NSInteger dayOfYear = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];

    NSString *dayString = [self gregorianCalendarICSDayOfWeekFromInteger:checkDateComponents.weekday];
    NSString *weekNumberString  = [NSString stringWithFormat:@"%li", (long)checkDateComponents.weekOfYear];
    NSString *monthString = [NSString stringWithFormat:@"%li", (long)checkDateComponents.month];

    // If the event is set to repeat on a certain day of the week,
    // it MUST be the current date's weekday for it to occur
    if (self.exceptionRules.exceptionRulesByDay &&
        (![self.exceptionRules.exceptionRulesByDay containsObject:dayString] &&
        ![self.exceptionRules.exceptionRulesByDay containsObject:[NSString stringWithFormat:@"1%@", dayString]] &&
        ![self.exceptionRules.exceptionRulesByDay containsObject:[NSString stringWithFormat:@"2%@", dayString]] &&
        ![self.exceptionRules.exceptionRulesByDay containsObject:[NSString stringWithFormat:@"3%@", dayString]])) {
        // These checks are to catch if the event is set to repeat on a particular weekday of the month (e.g., every third Sunday)
        return NO;
    }

    // Same as above (and below)
    if ((self.exceptionRules.exceptionRulesByDayOfMonth   &&
         ![self.exceptionRules.exceptionRulesByDayOfMonth containsObject:[NSString stringWithFormat:@"%li", (long)checkDateComponents.day]])
        ||
        (self.exceptionRules.exceptionRulesByDayOfYear    &&
         ![self.exceptionRules.exceptionRulesByDayOfYear containsObject:[NSString stringWithFormat:@"%li", (long)dayOfYear]])
        ||
        (self.exceptionRules.exceptionRulesByWeekOfYear   &&
         ![self.exceptionRules.exceptionRulesByWeekOfYear containsObject:weekNumberString])
        ||
        (self.exceptionRules.exceptionRulesByMonth        &&
         ![self.exceptionRules.exceptionRulesByMonth containsObject:monthString])) {
            
            return NO;
        }

    self.exceptionRules.exceptionRuleInterval = (self.exceptionRules.exceptionRuleInterval == 0) ? 1 : self.exceptionRules.exceptionRuleInterval;

    // If it's set to repeat every week...
    if (self.exceptionRules.exceptionRuleFrequency == PUFrequencyWeekly) {

        // Is there a limit on the number of repetitions
        // (e.g., event repeats for the 3 occurrences after it first occurred)
        if (self.exceptionRules.exceptionRuleCount) {

            // Get the final possible time the event will be repeated
            NSDateComponents *maximumComponents = [[NSDateComponents alloc] init];
            maximumComponents.day = self.exceptionRules.exceptionRuleCount * self.exceptionRules.exceptionRuleInterval;

            // Create a date by adding the final week it'll occur onto the first occurrence
            NSDate *maximumDate = [self.calendar dateByAddingComponents:maximumComponents toDate:self.eventCreatedDate options:0];

            // If the final possible occurrence is in the future...
            if ([maximumDate compare:date] == NSOrderedDescending ||
                [maximumDate compare:date] == NSOrderedSame) {

                // Get the number of weeks between the final date and current date
                NSInteger difference = [self.calendar components:NSCalendarUnitDay fromDate:maximumDate toDate:date options:0].day;

                return !(difference % self.exceptionRules.exceptionRuleInterval);
            } else {
                
                return NO;
            }
        } else if (self.exceptionRules.exceptionRuleUntilDate) {
            
            if ([self.exceptionRules.exceptionRuleUntilDate compare:date] == NSOrderedDescending ||
                [self.exceptionRules.exceptionRuleUntilDate compare:date] == NSOrderedDescending) {
                
                NSInteger difference = [self.calendar components:NSCalendarUnitDay fromDate:self.exceptionRules.exceptionRuleUntilDate toDate:date options:0].day;

                return !(difference % self.exceptionRules.exceptionRuleInterval);
            } else {
                return NO;
            }
        } else {
            
            NSInteger difference = [self.calendar components:NSCalendarUnitDay fromDate:self.eventCreatedDate toDate:date options:0].day;

            return !(difference % self.exceptionRules.exceptionRuleInterval);
        }
    } else if (self.exceptionRules.exceptionRuleFrequency == PUFrequencyMonthly) {
        
        if (self.exceptionRules.exceptionRuleCount) {

            NSInteger finalMonth = self.exceptionRules.exceptionRuleCount * self.exceptionRules.exceptionRuleInterval;

            NSDateComponents *maximumComponents = [[NSDateComponents alloc] init];
            maximumComponents.month = finalMonth;

            NSDate *maximumDate = [self.calendar dateByAddingComponents:maximumComponents toDate:self.eventCreatedDate options:0];

            if ([maximumDate compare:date] == NSOrderedDescending ||
                [maximumDate compare:date] == NSOrderedSame) {
                
                NSInteger difference = [self.calendar components:NSCalendarUnitMonth fromDate:[self.calendar dateFromComponents:maximumComponents] toDate:date options:0].month;

                return !(difference % self.exceptionRules.exceptionRuleInterval);
            } else {
                return NO;
            }
        } else if (self.exceptionRules.exceptionRuleUntilDate) {
            
            if ([self.exceptionRules.exceptionRuleUntilDate compare:date] == NSOrderedDescending ||
                [self.exceptionRules.exceptionRuleUntilDate compare:date] == NSOrderedSame) {
                
                NSInteger difference = [self.calendar components:NSCalendarUnitMonth fromDate:self.exceptionRules.exceptionRuleUntilDate toDate:date options:0].month;

                return !(difference % self.exceptionRules.exceptionRuleInterval);
            } else {
                return NO;
            }
        } else {
            
            NSInteger difference = [self.calendar components:NSCalendarUnitDay fromDate:self.eventCreatedDate toDate:date options:0].month;

            return !(difference % self.exceptionRules.exceptionRuleInterval);
        }
    } else if (self.exceptionRules.exceptionRuleFrequency == PUFrequencyYearly) {
        
        if (self.exceptionRules.exceptionRuleCount) {
            
            NSInteger finalYear = self.exceptionRules.exceptionRuleCount * self.exceptionRules.exceptionRuleInterval;

            NSDateComponents *maximumComponents = [[NSDateComponents alloc] init];
            maximumComponents.year = finalYear;

            NSDate *maximumDate = [self.calendar dateByAddingComponents:maximumComponents toDate:self.eventCreatedDate options:0];

            if ([maximumDate compare:date] == NSOrderedDescending ||
                [maximumDate compare:date] == NSOrderedSame) {
                
                NSInteger difference = [self.calendar components:NSCalendarUnitYear fromDate:[self.calendar dateFromComponents:maximumComponents] toDate:date options:0].year;

                return !(difference % self.exceptionRules.exceptionRuleInterval);
            }
        } else if (self.exceptionRules.exceptionRuleUntilDate) {
            
            NSInteger difference = [self.calendar components:NSCalendarUnitYear fromDate:self.exceptionRules.exceptionRuleUntilDate toDate:date options:0].year;

            return !(difference % self.exceptionRules.exceptionRuleInterval);
        } else {
            
            NSInteger difference = [self.calendar components:NSCalendarUnitYear fromDate:self.eventCreatedDate toDate:date options:0].year;
            
            return !(difference % self.exceptionRules.exceptionRuleInterval);
        }
    } else {
        
        return NO;
    }

    return NO;
}

- (EKEvent *)convertToEKEventOnDate:(NSDate *)date withEventStore:(EKEventStore *)eventStore {
    
    NSCalendarUnit fullUnit = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    
    //Create Date Components from event
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:fullUnit fromDate:self.eventStartDate];
    NSDateComponents *endComponents = [[NSCalendar currentCalendar] components:fullUnit fromDate:self.eventEndDate];

    //Create Date Components from selected date
    NSCalendarUnit calendarDateUnit = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    
    NSDateComponents *selectedDayComponents = [[NSCalendar currentCalendar] components:calendarDateUnit fromDate:date];

    startComponents.day = selectedDayComponents.day;
    startComponents.month = selectedDayComponents.month;
    startComponents.year = selectedDayComponents.year;
    
    endComponents.day = selectedDayComponents.day;
    endComponents.month = selectedDayComponents.month;
    endComponents.year = selectedDayComponents.year;

    EKEvent *event = [self convertToEKEventWithEventStore:eventStore];
    
    event.startDate = [self.calendar dateFromComponents:startComponents];
    event.endDate = [self.calendar dateFromComponents:endComponents];
    
    return event;
}

- (EKEvent *)convertToEKEventWithEventStore:(EKEventStore *)eventStore {
    
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = self.eventSummary;
    event.notes = self.eventDescription;
    event.location = self.eventLocation;
    event.allDay = self.eventIsAllDay;

    event.startDate = self.eventStartDate;
    event.endDate = self.eventEndDate;
    
    return event;
}

-(NSString *)gregorianCalendarICSDayOfWeekFromInteger:(NSInteger)day {
    
    switch (day) {
        case 1:
            return kDayOfWeekSunday;
            break;
        case 2:
            return kDayOfWeekMonday;
            break;
        case 3:
            return kDayOfWeekTuesday;
            break;
        case 4:
            return kDayOfWeekWednesday;
            break;
        case 5:
            return kDayOfWeekThursday;
            break;
        case 6:
            return kDayOfWeekFriday;
            break;
        case 7:
            return kDayOfWeekSaturday;
            break;
        default:
            return @"";
            break;
    }
}

//- (NSString *)gregorianCalendarLocalizedDayOfWeekStringFromInteger:(NSInteger)day {
//
//    NSDateComponents *weekDayComponents = [self.calendar components:NSCalendarUnitWeekday fromDate:NSDate.date];
//
//    weekDayComponents.weekday = day;
//
//    NSDate *localizedDate = [NSCalendar.currentCalendar dateFromComponents:weekDayComponents];
//
//    NSDateFormatter *localizedWeekDayFormatter = [NSDateFormatter new];
//    localizedWeekDayFormatter.dateFormat = @"EE";
//
//    NSString *weekDayString = [localizedWeekDayFormatter stringFromDate:localizedDate];
//    return weekDayString;
//}

@end
