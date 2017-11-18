//
//  PURecurrenceRules.m
//
//  Created by Maurice Arikoglu on 17.11.17.
//  Copyright © 2017 Maurice Arikoglu. All rights reserved.
//

#import "PURecurrenceRules.h"

@implementation PURecurrenceRules

- (id)copyWithZone:(NSZone *)zone {
    
    PURecurrenceRules *copy = [[PURecurrenceRules allocWithZone:zone] init];
    
    if (copy) {
        
        [copy setRepeatRuleFrequency:[self.repeatRuleFrequency copyWithZone:zone]];
        [copy setRepeatRuleCount:[self.repeatRuleCount copyWithZone:zone]];
        [copy setRepeatRuleInterval:[self.repeatRuleInterval copyWithZone:zone]];
        [copy setRepeatRuleWeekStart:[self.repeatRuleWeekStart copyWithZone:zone]];
        
        [copy setRepeatRuleUntilDate:[self.repeatRuleUntilDate copyWithZone:zone]];
        
        [copy setRepeatRulesBySecond:[self.repeatRuleFrequency copyWithZone:zone]];
        [copy setRepeatRulesByMinute:[self.repeatRulesByMinute copyWithZone:zone]];
        [copy setRepeatRulesByHour:[self.repeatRulesByHour copyWithZone:zone]];
        [copy setRepeatRulesByDay:[self.repeatRulesByDay copyWithZone:zone]];
        [copy setRepeatRulesByDayOfMonth:[self.repeatRulesByDayOfMonth copyWithZone:zone]];
        [copy setRepeatRulesByDayOfYear:[self.repeatRulesByDayOfYear copyWithZone:zone]];
        [copy setRepeatRulesByWeekOfYear:[self.repeatRulesByWeekOfYear copyWithZone:zone]];
        [copy setRepeatRulesByMonth:[self.repeatRulesByMonth copyWithZone:zone]];
        [copy setRepeatRulesBySetPosition:[self.repeatRulesBySetPosition copyWithZone:zone]];
        
    }
    
    return copy;
}

@end
