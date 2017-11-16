//
//  PUCalendar.h
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

@class MXLCalendarEvent;

@interface PUCalendar : NSObject <NSCopying>

@property (nonatomic, retain) NSTimeZone *timeZone;
@property (nonatomic, retain) NSArray *events;

- (void)addEvent:(MXLCalendarEvent *)event;

- (void)addEvent:(MXLCalendarEvent *)event onDateWithDay:(NSInteger)day month:(NSInteger)month andYear:(NSInteger)year;
- (void)addEvent:(MXLCalendarEvent *)event onDateRepresentedAsString:(NSString *)dateString;
- (void)addEvent:(MXLCalendarEvent *)event onDate:(NSDate *)date;

- (BOOL)hasLoadedAllEventsForDate:(NSDate *)date;
- (void)loadedAllEventsForDate:(NSDate *)date;
- (NSMutableArray *)eventsForDate:(NSDate *)date;

@end
//Keep compatibility to MXLCalendar
@compatibility_alias MXLCalendar PUCalendar;
