//
//  PUEventParser.m
//
//  Created by Maurice Arikoglu on 16.11.17.
//  Copyright © 2017 Maurice Arikoglu. All rights reserved.
//

#import "PUEventParser.h"
#import "PUCalendarEvent.h"
#import "PUExceptionRules.h"
#import "PURecurrenceRules.h"
#import "NSDateFormatter+ICS.h"

@implementation PUEventParser

#pragma mark - Parsing ICS Event Recurrence Rules

+ (PURecurrenceRules *)parseRecurrenceRulesWithICSEventRecurrenceRuleString:(NSString *)recurrenceRuleString inCalendarContext:(NSString *)calendarContext {
    
    PURecurrenceRules *recurrenceRules = PURecurrenceRules.new;
    
    NSArray *rulesArray = [recurrenceRuleString componentsSeparatedByString:@";"]; // Split up rules string into array

    for (NSString *rule in rulesArray) {
        
        if ([rule rangeOfString:@"FREQ"].location != NSNotFound) {
            // If the rule is for the FREQuency
            recurrenceRules.repeatRuleFrequency = [PUEventParser parseFrequencyRule:rule];
            
        } else if ([rule rangeOfString:@"COUNT"].location != NSNotFound) {
            // If the rule is for the COUNT
            recurrenceRules.repeatRuleCount = [PUEventParser parseCountRule:rule];
            
        } else if ([rule rangeOfString:@"UNTIL"].location != NSNotFound) {
            // If the rule is for the UNTIL date
            NSString *parsedRule = [PUEventParser parseUntilRule:rule];
            NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterForICSDateString:parsedRule];
            dateFormatter.timeZone = ([NSTimeZone timeZoneWithName:calendarContext]) ?: [NSTimeZone localTimeZone];

            recurrenceRules.repeatRuleUntilDate = [dateFormatter dateFromString:parsedRule];
            
        } else if ([rule rangeOfString:@"INTERVAL"].location != NSNotFound) {
            // If the rule is for the INTERVAL
            recurrenceRules.repeatRuleInterval = [PUEventParser parseIntervalRule:rule];
            
        } else if ([rule rangeOfString:@"BYDAY"].location != NSNotFound) {
            // If the rule is for the BYDAY
            recurrenceRules.repeatRulesByDay = [[PUEventParser parseByDayRule:rule] componentsSeparatedByString:@","];
            
        } else if ([rule rangeOfString:@"BYMONTHDAY"].location != NSNotFound) {
            // If the rule is for the BYMONTHDAY
            recurrenceRules.repeatRulesByDayOfMonth = [[PUEventParser parseByDayOfMonthRule:rule] componentsSeparatedByString:@","];
            
        } else if ([rule rangeOfString:@"BYYEARDAY"].location != NSNotFound) {
            // If the rule is for the BYYEARDAY
            recurrenceRules.repeatRulesByDayOfYear = [[PUEventParser parseByDayOfYearRule:rule] componentsSeparatedByString:@","];
            
        } else  if ([rule rangeOfString:@"BYWEEKNO"].location != NSNotFound) {
            // If the rule is for the BYWEEKNO
            recurrenceRules.repeatRulesByWeekOfYear = [[PUEventParser parseWeekOfYearRule:rule] componentsSeparatedByString:@","];
            
        } else if ([rule rangeOfString:@"BYMONTH"].location != NSNotFound) {
            // If the rule is for the BYMONTH
            recurrenceRules.repeatRulesByMonth = [[PUEventParser parseByMonthRule:rule] componentsSeparatedByString:@","];
            
        } else if ([rule rangeOfString:@"WKST"].location != NSNotFound) {
            // If the rule is for the WKST
            recurrenceRules.repeatRuleWeekStart = [PUEventParser parseWeekStartRule:rule];
        }
    }

    return recurrenceRules;
}

#pragma mark - Parsing ICS Event Exception Rules

+ (PUExceptionRules *)parseExceptionRulesWithICSEventExceptionRuleString:(NSString *)exceptionRuleString inCalendarContext:(NSString *)calendarContext{
    
    PUExceptionRules *exceptionRules = PUExceptionRules.new;
    
    NSArray *rulesArray = [exceptionRuleString componentsSeparatedByString:@";"]; // Split up rules string into array

    for (NSString *rule in rulesArray) {
        
        if ([rule rangeOfString:@"FREQ"].location != NSNotFound) {
            // If the rule is for the FREQuency
            exceptionRules.exceptionRuleFrequency = [PUEventParser parseFrequencyRule:rule];
            
        } else if ([rule rangeOfString:@"COUNT"].location != NSNotFound) {
            // If the rule is for the COUNT
            exceptionRules.exceptionRuleCount = [PUEventParser parseCountRule:rule];
            
        } else if ([rule rangeOfString:@"UNTIL"].location != NSNotFound) {
            // If the rule is for the UNTIL date
            NSString *parsedRule = [PUEventParser parseUntilRule:rule];
            
            NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterForICSDateString:parsedRule];
            dateFormatter.timeZone = ([NSTimeZone timeZoneWithName:calendarContext]) ?: [NSTimeZone localTimeZone];
            
            exceptionRules.exceptionRuleUntilDate = [dateFormatter dateFromString:parsedRule];
            
        } else if ([rule rangeOfString:@"INTERVAL"].location != NSNotFound) {
            // If the rule is for the INTERVAL
            exceptionRules.exceptionRuleInterval = [PUEventParser parseIntervalRule:rule];
            
        } else if ([rule rangeOfString:@"BYDAY"].location != NSNotFound) {
            // If the rule is for the BYDAY
            exceptionRules.exceptionRulesByDay = [[PUEventParser parseByDayRule:rule] componentsSeparatedByString:@","];
            
        } else if ([rule rangeOfString:@"BYMONTHDAY"].location != NSNotFound) {
            // If the rule is for the BYMONTHDAY
            exceptionRules.exceptionRulesByDayOfMonth = [[PUEventParser parseByDayOfMonthRule:rule] componentsSeparatedByString:@","];
            
        } else if ([rule rangeOfString:@"BYYEARDAY"].location != NSNotFound) {
            // If the rule is for the BYYEARDAY
            exceptionRules.exceptionRulesByDayOfYear = [[PUEventParser parseByDayOfYearRule:rule] componentsSeparatedByString:@","];
            
        } else  if ([rule rangeOfString:@"BYWEEKNO"].location != NSNotFound) {
            // If the rule is for the BYWEEKNO
            exceptionRules.exceptionRulesByWeekOfYear = [[PUEventParser parseWeekOfYearRule:rule] componentsSeparatedByString:@","];
            
        } else if ([rule rangeOfString:@"BYMONTH"].location != NSNotFound) {
            // If the rule is for the BYMONTH
            exceptionRules.exceptionRulesByMonth = [[PUEventParser parseByMonthRule:rule] componentsSeparatedByString:@","];
            
        } else if ([rule rangeOfString:@"WKST"].location != NSNotFound) {
            // If the rule is for the WKST
            exceptionRules.exceptionRuleWeekStart = [PUEventParser parseWeekStartRule:rule];
        }
    }

    return exceptionRules;
}

#pragma mark - Parsing ICS Event Rule Properties

+ (NSString *)parseFrequencyRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *frequency;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&frequency];
    
    return [frequency stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseWeekStartRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *weekStart;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&weekStart];
    
    return [weekStart stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseCountRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *count;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&count];
    
    return [count stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseUntilRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *until;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&until];

    return [until stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseIntervalRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *interval;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&interval];

    return [interval stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseByDayRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *byDay;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&byDay];

    return [byDay stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseByDayOfMonthRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *byMonthDay;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&byMonthDay];

    return [byMonthDay stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseByDayOfYearRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *byYearDay;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&byYearDay];

    return [byYearDay stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseWeekOfYearRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *byWeekNo;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&byWeekNo];

    return [byWeekNo stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

+ (NSString *)parseByMonthRule:(NSString *)weekStartRule {
    
    NSScanner *ruleScanner = [[NSScanner alloc] initWithString:weekStartRule];
    NSString *byMonth;
    
    [ruleScanner scanUpToString:@"=" intoString:nil];
    [ruleScanner scanUpToString:@";" intoString:&byMonth];

    return [byMonth stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

#pragma mark - Parsing ICS Events

+ (PUCalendarEvent *)parseEventWithICSEventString:(NSString *)eventString inCalendarContext:(NSString *)calendarContext {
    
    if (!eventString) {
        
        return nil;
    }
    
    //Extract Time Zone
    NSString *timezoneIdString = [self extractTimeZoneInformationFromICSEventString:eventString];
    
    //Extract Event Start Date
    NSString *startDateTimeString = [self extractStartDateInformationFromICSEventString:eventString withTimeZoneString:timezoneIdString];
    
    //Extract Event End Date
    NSString *endDateTimeString = [self extractEndDateInformationFromICSEventString:eventString withTimeZoneString:timezoneIdString];
    
    // Extract Event Timestamp
    NSString *timeStampString = [self extractTimeStampInformationFromICSEventString:eventString];
    
    // Extract Event Unique Id
    NSString *eventUniqueIdString = [self extractUniqueIdInformationFromICSEventString:eventString];
    
    // Extract the attendees
    NSArray <MXLCalendarAttendee *> *attendees = [self extractAttendeesInformationFromICSEventString:eventString];
    
    // Extract the recurrence Id
    NSString *recurrenceIdString = [self extractRecurrenceInformationFromICSEventString:eventString withTimeZoneString:timezoneIdString];
    
    // Extract the created datetime
    NSString *createdDateTimeString = [self extractCreatedDateInformationFromICSEventString:eventString];
    
    // Extract event description
    NSString *descriptionString = [self extractDescriptionInformationFromICSEventString:eventString];
    
    // Extract last modified datetime
    NSString *lastModifiedDateTimeString = [self extractLastModifiedInformationFromICSEventString:eventString];
    
    // Extract the event location
    NSString *locationString = [self extractLocationInformationFromICSEventString:eventString];
    
    // Extract the event sequence
    NSString *sequenceString = [self extractSequenceInformationFromICSEventString:eventString];
    
    // Extract the event status
    NSString *statusString = [self extractStatusInformationFromICSEventString:eventString];
    
    // Extract the event summary
    NSString *summaryString = [self extractSummaryInformationFromICSEventString:eventString];
    
    // Extract the event transString
    NSString *transparentString = [self extractTransparentInformationFromICSEventString:eventString];
    
    // Extract the event repetition rules
    NSString *recurrenceRuleString = [self extractRepetitionInformationFromICSEventString:eventString];
    
    // Extract the event exception rules
    NSString *exceptionRuleString = [self extractExceptionInformationFromICSEventString:eventString];
    
    // Extract event exception dates
    NSArray *exceptionDates = [self extractExceptionDateInformationFromICSEventString:eventString];
    
    PUCalendarEvent *event = [[PUCalendarEvent alloc] initWithStartDate:startDateTimeString
                                                                endDate:endDateTimeString
                                                              createdAt:createdDateTimeString
                                                           lastModified:lastModifiedDateTimeString
                                                               uniqueId:eventUniqueIdString
                                                           recurrenceId:recurrenceIdString
                                                                summary:summaryString
                                                            description:descriptionString
                                                               location:locationString
                                                                 status:statusString
                                                        recurrenceRules:recurrenceRuleString
                                                         exceptionDates:exceptionDates
                                                          exceptionRule:exceptionRuleString
                                                             timeZoneId:timezoneIdString ?: calendarContext
                                                              attendees:attendees];
    
    return event;
}

#pragma mark - Parsing ICS Event Properties

+ (NSArray *)extractExceptionDateInformationFromICSEventString:(NSString *)extractString {
    
    NSMutableArray *exceptionDates = [NSMutableArray new];
    
    NSScanner *exceptionScanner = [NSScanner scannerWithString:extractString];
    [exceptionScanner scanUpToString:@"EXDATE;" intoString:nil];
    
    //Extract exception dates
    while (![exceptionScanner isAtEnd]) {
        
        [exceptionScanner scanUpToString:@":" intoString:nil];
        
        NSString *exceptionString = @"";
        
        [exceptionScanner scanUpToString:@"\n" intoString:&exceptionString];
        
        exceptionString = [[exceptionString stringByReplacingOccurrencesOfString:@":" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
        
        if (exceptionString) {
            
            [exceptionDates addObject:exceptionString];
        }
        
        [exceptionScanner scanUpToString:@"EXDATE;" intoString:nil];
    }
    
    return exceptionDates.copy;
}

+ (NSString *)extractExceptionInformationFromICSEventString:(NSString *)extractString {
    
    NSString *exceptionRuleString;
    
    NSScanner *exceptionScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the event exception rules
    [exceptionScanner scanUpToString:@"EXRULE:" intoString:nil];
    [exceptionScanner scanUpToString:@"\n" intoString:&exceptionRuleString];
    
    return [[exceptionRuleString stringByReplacingOccurrencesOfString:@"EXRULE:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractRepetitionInformationFromICSEventString:(NSString *)extractString {
    
    NSString *repetitionString;
    
    NSScanner *repetitionScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the event repetition rules
    [repetitionScanner scanUpToString:@"RRULE:" intoString:nil];
    [repetitionScanner scanUpToString:@"\n" intoString:&repetitionString];
    
    return [[repetitionString stringByReplacingOccurrencesOfString:@"RRULE:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractTransparentInformationFromICSEventString:(NSString *)extractString {
    
    NSString *transparentString;
    
    NSScanner *transparentScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the event transString
    [transparentScanner scanUpToString:@"TRANSP:" intoString:nil];
    [transparentScanner scanUpToString:@"\n" intoString:&transparentString];
    
    return [[transparentString stringByReplacingOccurrencesOfString:@"TRANSP:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractSummaryInformationFromICSEventString:(NSString *)extractString {
    
    NSString *summaryString;
    
    NSScanner *summaryScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the event summary
    [summaryScanner scanUpToString:@"SUMMARY:" intoString:nil];
    [summaryScanner scanUpToString:@"\n" intoString:&summaryString];
    
    return [[summaryString stringByReplacingOccurrencesOfString:@"SUMMARY:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractStatusInformationFromICSEventString:(NSString *)extractString {
    
    NSString *statusString;
    
    NSScanner *statusScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the event status
    [statusScanner scanUpToString:@"STATUS:" intoString:nil];
    [statusScanner scanUpToString:@"\n" intoString:&statusString];
    
    return [[statusString stringByReplacingOccurrencesOfString:@"STATUS:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractSequenceInformationFromICSEventString:(NSString *)extractString {
    
    NSString *sequenceString;
    
    NSScanner *sequenceScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the event sequence
    [sequenceScanner scanUpToString:@"SEQUENCE:" intoString:nil];
    [sequenceScanner scanUpToString:@"\n" intoString:&sequenceString];
    
    return [[sequenceString stringByReplacingOccurrencesOfString:@"SEQUENCE:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractLocationInformationFromICSEventString:(NSString *)extractString {
    
    NSString *locationString;
    
    NSScanner *locationScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the event location
    [locationScanner scanUpToString:@"LOCATION:" intoString:nil];
    [locationScanner scanUpToString:@"\n" intoString:&locationString];
    
    return [[locationString stringByReplacingOccurrencesOfString:@"LOCATION:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractLastModifiedInformationFromICSEventString:(NSString *)extractString {
    
    NSString *lastModifiedDateTimeString;
    
    NSScanner *lastModifiedScanner = [NSScanner scannerWithString:extractString];
    
    // Extract last modified datetime
    [lastModifiedScanner scanUpToString:@"LAST-MODIFIED:" intoString:nil];
    [lastModifiedScanner scanUpToString:@"\n" intoString:&lastModifiedDateTimeString];
    
    return [[lastModifiedDateTimeString stringByReplacingOccurrencesOfString:@"LAST-MODIFIED:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractDescriptionInformationFromICSEventString:(NSString *)extractString {
    
    NSString *descriptionString;
    
    NSScanner *descriptionScanner = [NSScanner scannerWithString:extractString];
    
    // Extract event description
    [descriptionScanner scanUpToString:@"DESCRIPTION:" intoString:nil];
    [descriptionScanner scanUpToString:@"\n" intoString:&descriptionString];
    
    return [[descriptionString stringByReplacingOccurrencesOfString:@"DESCRIPTION:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractCreatedDateInformationFromICSEventString:(NSString *)extractString {
    
    NSString *createdDateTimeString;
    
    NSScanner *createdDateScanner = [NSScanner scannerWithString:extractString];
    
    // Extract created Date
    [createdDateScanner scanUpToString:@"CREATED:" intoString:nil];
    [createdDateScanner scanUpToString:@"\n" intoString:&createdDateTimeString];
    
    return [[createdDateTimeString stringByReplacingOccurrencesOfString:@"CREATED:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractRecurrenceInformationFromICSEventString:(NSString *)extractString withTimeZoneString:(NSString *)timeZoneString {
    
    NSString *recurrenceString;
    
    NSScanner *recurrenceScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the recurrence Id
    [recurrenceScanner scanUpToString:[NSString stringWithFormat:@"RECURRENCE-ID;TZID=%@:", timeZoneString] intoString:nil];
    [recurrenceScanner scanUpToString:@"\n" intoString:&recurrenceString];
    
    return [[recurrenceString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"RECURRENCE-ID;TZID=%@:", timeZoneString] withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSArray <MXLCalendarAttendee *>*)extractAttendeesInformationFromICSEventString:(NSString *)extractString {
    
    NSMutableArray <MXLCalendarAttendee *> *attendees = [NSMutableArray new];
    
    NSScanner *attendeesScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the attendees
    BOOL scannerStatus;
    
    do {
        
        NSString *attendeeString;
        
        //Check if there is at least one attendee
        if ([attendeesScanner scanUpToString:@"ATTENDEE;" intoString:nil]) {
            
            scannerStatus = [attendeesScanner scanUpToString:@"\n" intoString:&attendeeString];
            
            if (scannerStatus) {
                
                attendeeString = [[attendeeString stringByReplacingOccurrencesOfString:@"ATTENDEE;" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
                
                //Create a new attendee instance from the extracted string
                MXLCalendarAttendee *attendee = [MXLCalendarAttendee attendeeForString:attendeeString];
                
                if (attendee) {
                    
                    [attendees addObject:attendee];
                }
            }
        } else {
            scannerStatus = NO;
        }
    } while (scannerStatus);
    
    //return a immutable copy
    return attendees.copy;
}

+ (NSString *)extractUniqueIdInformationFromICSEventString:(NSString *)extractString {
    
    NSString *eventUniqueIdString;
    
    NSScanner *uniqueIdScanner = [NSScanner scannerWithString:extractString];
    
    // Extract the unique ID
    [uniqueIdScanner scanUpToString:@"UID:" intoString:nil];
    [uniqueIdScanner scanUpToString:@"\n" intoString:&eventUniqueIdString];
    
    return [[eventUniqueIdString stringByReplacingOccurrencesOfString:@"UID:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractTimeStampInformationFromICSEventString:(NSString *)extractString {
    
    NSString *timeStampString;
    
    NSScanner *timestampScanner = [NSScanner scannerWithString:extractString];
    
    // Extract timestamp
    [timestampScanner scanUpToString:@"DTSTAMP:" intoString:nil];
    [timestampScanner scanUpToString:@"\n" intoString:&timeStampString];
    
    return [[timeStampString stringByReplacingOccurrencesOfString:@"DTSTAMP:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
}

+ (NSString *)extractEndDateInformationFromICSEventString:(NSString *)extractString withTimeZoneString:(NSString *)timeZoneString {
    
    NSString *endDateTimeString;
    
    NSScanner *endDateScanner = [NSScanner scannerWithString:extractString];
    
    // Extract end time
    [endDateScanner scanUpToString:[NSString stringWithFormat:@"DTEND;TZID=%@:", timeZoneString] intoString:nil];
    [endDateScanner scanUpToString:@"\n" intoString:&endDateTimeString];
    
    endDateTimeString = [[endDateTimeString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"DTEND;TZID=%@:", timeZoneString] withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
    
    if (!endDateTimeString) {
        
        endDateScanner = [NSScanner scannerWithString:extractString];
        
        [endDateScanner scanUpToString:@"DTEND:" intoString:nil];
        [endDateScanner scanUpToString:@"\n" intoString:&endDateTimeString];
        
        endDateTimeString = [[endDateTimeString stringByReplacingOccurrencesOfString:@"DTEND:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
        
        if (!endDateTimeString) {
            
            endDateScanner = [NSScanner scannerWithString:extractString];
            
            [endDateScanner scanUpToString:@"DTEND;VALUE=DATE:" intoString:nil];
            [endDateScanner scanUpToString:@"\n" intoString:&endDateTimeString];
            
            endDateTimeString = [[endDateTimeString stringByReplacingOccurrencesOfString:@"DTEND;VALUE=DATE:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
        }
    }
    
    return endDateTimeString;
}

+ (NSString *)extractStartDateInformationFromICSEventString:(NSString *)extractString withTimeZoneString:(NSString *)timeZoneString {
    
    NSString *startDateTimeString;
    
    NSScanner *startDateScanner = [NSScanner scannerWithString:extractString];
    
    // Extract start time
    [startDateScanner scanUpToString:[NSString stringWithFormat:@"DTSTART;TZID=%@:", timeZoneString] intoString:nil];
    [startDateScanner scanUpToString:@"\n" intoString:&startDateTimeString];
    
    startDateTimeString = [[startDateTimeString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"DTSTART;TZID=%@:", timeZoneString] withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
    
    if (!startDateTimeString) {
        
        NSScanner *startDateScanner = [NSScanner scannerWithString:extractString];
        
        [startDateScanner scanUpToString:@"DTSTART:" intoString:nil];
        [startDateScanner scanUpToString:@"\n" intoString:&startDateTimeString];
        
        startDateTimeString = [[startDateTimeString stringByReplacingOccurrencesOfString:@"DTSTART:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
        
        if (!startDateTimeString) {
            
            NSScanner *startDateScanner = [NSScanner scannerWithString:extractString];
            
            [startDateScanner scanUpToString:@"DTSTART;VALUE=DATE:" intoString:nil];
            [startDateScanner scanUpToString:@"\n" intoString:&startDateTimeString];
            
            startDateTimeString = [[startDateTimeString stringByReplacingOccurrencesOfString:@"DTSTART;VALUE=DATE:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
        }
    }
    
    return startDateTimeString;
}

+ (NSString *)extractTimeZoneInformationFromICSEventString:(NSString *)extractString {
    
    NSString *timeZoneString;
    
    //Initialize Scanner with extract string
    NSScanner *timeZoneScanner = [NSScanner scannerWithString:extractString];
    
    // Extract event time zone ID
    [timeZoneScanner scanUpToString:@"DTSTART;TZID=" intoString:nil];
    [timeZoneScanner scanUpToString:@":" intoString:&timeZoneString];
    
    timeZoneString = [[timeZoneString stringByReplacingOccurrencesOfString:@"DTSTART;TZID=" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
    
    if (!timeZoneString) {
        
        //re-Initialize Scanner with extract string
        timeZoneScanner = [NSScanner scannerWithString:extractString];
        
        // Extract event time zone ID
        [timeZoneScanner scanUpToString:@"TZID:" intoString:nil];
        [timeZoneScanner scanUpToString:@"\n" intoString:&timeZoneString];
        
        timeZoneString = [[timeZoneString stringByReplacingOccurrencesOfString:@"TZID:" withString:@""] stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet];
    }
    
    return timeZoneString;
}

@end
