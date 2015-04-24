//
//  Login_Model.h
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 14/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login_Model : NSObject

@property (nonatomic) NSString *email;

-(instancetype)initWithEmail:(NSString*)email;

@end
