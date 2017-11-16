//
//  MXLCalendarManager.m
//  Part of MXLCalendarManager framework
//
//  Created by Kiran Panesar on 09/04/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
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

#import "MXLCalendarManager.h"
#import "PUEventParser.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface MXLCalendarManager ()

//- (void)parseICSString:(NSString *)icsString withCompletionHandler:(void (^)(MXLCalendar *, NSError *))completionHandler;

@end

@implementation MXLCalendarManager

- (void)scanICSFileAtRemoteURL:(NSURL *)fileURL withCompletionHandler:(void (^)(MXLCalendar *, NSError *))completionHandler {
    
    #if TARGET_OS_IPHONE
    if (NSThread.currentThread.isMainThread) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    #endif

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *downloadError;
        NSData *fileData = [[NSData alloc] initWithContentsOfURL:fileURL options:0 error:&downloadError];

        if (downloadError) {
            //Hide device network indicator and return error
            #if TARGET_OS_IPHONE
            if ([[UIApplication sharedApplication] isNetworkActivityIndicatorVisible]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                });
            }
            #endif
            
            return completionHandler(nil, downloadError);
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            //Hide device network indicator
            #if TARGET_OS_IPHONE
            if ([[UIApplication sharedApplication] isNetworkActivityIndicatorVisible]) {
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            #endif
            
            //Parse the ICS File String Representation
            NSString *fileString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
            [self parseICSString:fileString withCompletionHandler:completionHandler];
        });
    });
}

- (void)scanICSFileAtLocalPath:(NSString *)filePath withCompletionHandler:(void (^)(MXLCalendar *, NSError *))completionHandler {
    
    NSError *fileError;
    NSString *calendarFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileError];

    if (fileError) {
        
        return completionHandler(nil, fileError);
    }

    [self parseICSString:calendarFile withCompletionHandler:completionHandler];
}

- (void)parseICSString:(NSString *)icsString withCompletionHandler:(void (^)(MXLCalendar *, NSError *))completionHandler {

//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n +" options:NSRegularExpressionCaseInsensitive error:&error];
//    NSString *icsStringWithoutNewlines = [regex stringByReplacingMatchesInString:icsString options:0 range:NSMakeRange(0, [icsString length]) withTemplate:@""];

    //Remove whitespaces and newline characters
    NSString *icsStringWithoutNewlines = [icsString stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];

    // Pull out each line from the calendar file
    NSMutableArray *eventsArray = [NSMutableArray arrayWithArray:[icsStringWithoutNewlines componentsSeparatedByString:@"BEGIN:VEVENT"]];

    MXLCalendar *calendar = [[MXLCalendar alloc] init];

    NSString *calendarString;

    // Remove the first item (that's just all the stuff before the first VEVENT)
    if (eventsArray.count) {
        
        /*
         BEGIN:VCALENDAR
         PRODID:-//Google Inc//Google Calendar 70.9054//EN
         VERSION:2.0
         CALSCALE:GREGORIAN
         METHOD:PUBLISH
         X-WR-CALNAME:Halsted Street
         X-WR-TIMEZONE:America/Chicago
         X-WR-CALDESC:
         BEGIN:VTIMEZONE
         TZID:America/Chicago
         X-LIC-LOCATION:America/Chicago
         BEGIN:DAYLIGHT
         TZOFFSETFROM:-0600
         TZOFFSETTO:-0500
         TZNAME:CDT
         DTSTART:19700308T020000
         RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU
         END:DAYLIGHT
         BEGIN:STANDARD
         TZOFFSETFROM:-0500
         TZOFFSETTO:-0600
         TZNAME:CST
         DTSTART:19701101T020000
         RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU
         END:STANDARD
         END:VTIMEZONE
         BEGIN:VEVENT
         DTSTART;TZID=America/Chicago:20130514T174500
         DTEND;TZID=America/Chicago:20130514T183000
         DTSTAMP:20130418T162901Z
         UID:7tadgfphuapsqglqmjtk3b1754@google.com
         RECURRENCE-ID;TZID=America/Chicago:20130514T174500
         CREATED:20100108T015126Z
         DESCRIPTION:Multilevel (Sub- Sarah)\n
         LAST-MODIFIED:20130417T170827Z
         LOCATION:3
         SEQUENCE:1
         STATUS:CONFIRMED
         SUMMARY:Spinning
         TRANSP:OPAQUE
         END:VEVENT
         */
        NSScanner *scanner = [NSScanner scannerWithString:eventsArray.firstObject];
        
        [scanner scanUpToString:@"TZID:" intoString:nil];
        [scanner scanUpToString:@"\n" intoString:&calendarString];

//        calendarString = [[[calendarString stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"TZID:" withString:@""];

        calendarString = [[calendarString stringByTrimmingCharactersInSet:NSCharacterSet.newlineCharacterSet] stringByReplacingOccurrencesOfString:@"TZID:" withString:@""];

        [eventsArray removeObjectAtIndex:0];
    }

    // For each event string, extract the data
    for (NSString *eventString in eventsArray) {
        
        [calendar addEvent:[PUEventParser parseEventWithICSEventString:eventString inCalendarContext:calendarString]];
    }

    completionHandler(calendar, nil);
}


@end
