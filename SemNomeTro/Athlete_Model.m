//
//  Athlete_Model.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "Athlete_Model.h"

@implementation Athlete_Model

#pragma mark - Instance Methods

//Método de instancia para iniciar um atleta somente com o nome dado no cronometro
- (instancetype)initWithName:(NSString*)name
{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

//Método de instancia para criar um atleta a partir da tela de cadastro (opcao do usuario)
- (instancetype)initWithName:(NSString*)name
                       Email:(NSString*)email
                       Photo:(NSData*)photo
                     Wheight:(float)wheight
                   andHeight:(float)height
{
    self = [super init];
    if (self) {
        self.name = name;
        self.email = email;
        self.photo = photo;
        self.wheight = wheight;
        self.height = height;
    }
    
    return self;
}



@end
