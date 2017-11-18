//
//  NSDateFormatter+ICS.m
//  ICSExporter
//
//  Created by Maurice Arikoglu on 17.11.17.
//  Copyright © 2017 MobileX Labs. All rights reserved.
//

#import "NSDateFormatter+ICS.h"
#import <objc/runtime.h>

@implementation NSDateFormatter (ICS)

- (void)setContainsTime:(BOOL)containsTime {
    
    objc_setAssociatedObject(self, @selector(containsTime), [NSNumber numberWithBool:containsTime], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)containsTime {
 
    return [objc_getAssociatedObject(self, @selector(containsTime)) boolValue];
}

- (void)setContainsZone:(BOOL)containsZone {
 
    objc_setAssociatedObject(self, @selector(containsZone), [NSNumber numberWithBool:containsZone], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)containsZone {
    
    return [objc_getAssociatedObject(self, @selector(containsZone)) boolValue];
}


+ (instancetype)dateFormatterForICSDateString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = NSDateFormatter.new;
    dateFormatter.dateFormat = @"yyyyMMdd HHmmss";
    dateFormatter.containsTime = YES;
    
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    dateFormatter.containsZone = [dateString rangeOfString:@"z" options:NSCaseInsensitiveSearch].location != NSNotFound;
    
    if (dateFormatter.containsZone) {
        dateFormatter.dateFormat = @"yyyyMMdd HHmmssz";
    }
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    if (!date) {
        
        dateFormatter.dateFormat = (dateFormatter.containsZone) ? @"yyyyMMddz" : @"yyyyMMdd";
        
        date = [dateFormatter dateFromString:dateString];
        
        if (date) {
            dateFormatter.containsTime = NO;
        }
    }
        
    return dateFormatter;
}

@end
