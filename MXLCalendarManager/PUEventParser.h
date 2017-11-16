//
//  PUEventParser.h
//  ICSExporter
//
//  Created by Maurice Arikoglu on 16.11.17.
//  Copyright © 2017 MobileX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXLCalendarEvent;
@interface PUEventParser : NSObject

+ (MXLCalendarEvent *)parseEventWithICSEventString:(NSString *)eventString inCalendarContext:(NSString *)calendarContext;

@end
