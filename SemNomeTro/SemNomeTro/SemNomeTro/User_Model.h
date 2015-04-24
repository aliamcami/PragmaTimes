//
//  User_Model.h
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User_Model : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSDate *birthDate;
@property (nonatomic) int age;

- (instancetype)initWithName:(NSString*)name Email:(NSString*)email andBirthDate:(NSDate*)birthDate;

@end
