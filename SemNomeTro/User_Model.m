//
//  User_Model.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "User_Model.h"

@implementation User_Model

- (instancetype)initWithName:(NSString*)name Email:(NSString*)email andBirthDate:(NSDate*)birthDate
{
    self = [self init];
    if (self) {
        self.name = name;
        self.email = email;
        self.birthDate = birthDate;
        
        //Calcula a idade da pessoa
        NSDateComponents *age = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                                fromDate:self.birthDate
                                                                  toDate:[NSDate date]
                                                                 options:0];
        //Seta a idade como a difrenca de anos da data ate hoje
        self.age = (int)[age year];
    }
    return self;
}

@end
