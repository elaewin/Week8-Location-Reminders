//
//  Reminder.m
//  location-reminders
//
//  Created by Erica Winberry on 12/7/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

// this tells the compiler to ignore these properties until runtime.
@dynamic title;
@dynamic radius;
@dynamic location;
@dynamic body;


+(NSString *)parseClassName {
    return @"Reminder";
}

+(void)load {
    [self registerSubclass];
}

@end
