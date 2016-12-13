//
//  ErrorDomainInformation.h
//  location-reminders
//
//  Created by Erica Winberry on 12/13/16.
//  Copyright © 2016 Erica Winberry. All rights reserved.
//

@import Foundation;

#ifndef ErrorDomainInformation_h
#define ErrorDomainInformation_h

NSString *locationRemindersErrorDomain = @"LocationRemindersErrorDomain";

typedef enum : NSUInteger {
    ParseQueryFailure = 1,
    ParseSaveFailure,
    UserNotificationCreationFailure,
    UsableLocationInformationMissing,
    AnnotatingFailureWithoutLocationInformation
} LocationRemindersErrors;

#endif /* ErrorDomainInformation_h */
