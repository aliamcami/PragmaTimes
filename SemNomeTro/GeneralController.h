//
//  GeneralController.h
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 23/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DB.h"
#import "Chronometer.h"

@interface GeneralController : NSObject

-(NSArray *)todosAtletas;

-(BOOL)adicionarAtleta:(NSString *)email nome:(NSString *)nome foto:(NSString *)foto
                  peso:(NSNumber *)peso altura:(NSNumber *)altura sexo:(NSString *)sexo;

-(Atleta *)encontraAtleta:(NSString *)email;

-(BOOL)removeAtleta:(NSString *)email;

-(BOOL)atualizarAtleta:(NSString *)email nome:(NSString *)nome foto:(NSString *)foto
                  peso:(NSNumber *)peso altura:(NSNumber *)altura sexo:(NSString *)sexo;

-(BOOL)atualizarEmailDoAtleta:(NSString *)email emailNovo:(NSString *)emailNovo;

-(NSArray *)temposDoAtleta:(NSString *)email;

-(BOOL)adicionarTempos:(NSString *)email eTempos:(Chronometer *)c;

//-(BOOL)atualizaVoltas:(GrupoDeTemposOrdenados *)grupoDeTemposOrdenados;

@end