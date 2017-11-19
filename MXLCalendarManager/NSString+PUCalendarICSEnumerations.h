//
//  NSString+PUCalendarICSEnumerations.h
//  ICSExporter
//
//  Created by Maurice Arikoglu on 19.11.17.
//  Copyright © 2017 MobileX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUCalendarEnumerations.h"

@interface NSString (PUCalendarICSEnumerations)

- (PURole)roleForICSRoleString;
- (PUFrequency)frequencyForICSFrequencyString;
//- (PUShortWeekday)shortWeekdayForICDWeekdayString;
@end
