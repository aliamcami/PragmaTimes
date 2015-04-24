//
//  Athlete_Model.h
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Athlete_Model : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSData *photo;
@property (nonatomic) NSString *email;
@property (nonatomic) float wheight;
@property (nonatomic) float height;

//Métodos diferentes de instancia para ocasiões especiais:
//- Criação de atleta a partir de um nome no cronometro
//- Criação de atleta a partir do cadastro completo
- (instancetype)initWithName:(NSString*)name;
- (instancetype)initWithName:(NSString*)name
                       Email:(NSString*)email
                       Photo:(NSData*)photo
                     Wheight:(float)wheight
                   andHeight:(float)height;

@end
