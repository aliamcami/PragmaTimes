//
//  Login_Model.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 14/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "Login_Model.h"

@implementation Login_Model

- (instancetype)initWithEmail:(NSString*)email
{
    self = [super init];
    if (self) {
        self.email = email;
    }
    return self;
}

@end
