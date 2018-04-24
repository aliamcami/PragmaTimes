//
//  GeneralController.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 23/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "GeneralController.h"

@interface GeneralController()

@property (nonatomic) DB *db;

@end

@implementation GeneralController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.db = [[DB alloc] init];
    }
    return self;
}

-(BOOL)adicionarAtleta:(NSString *)email nome:(NSString *)nome
                  foto:(NSString *)foto peso:(NSNumber *)peso
                altura:(NSNumber *)altura sexo:(NSString *)sexo
{
    return [self.db adicionarAtleta:email nome:nome foto:foto peso:peso altura:altura sexo:sexo];
}

-(Atleta *)encontraAtleta:(NSString *)email
{
    return [self.db encontraAtleta:email];
}

-(BOOL)removeAtleta:(NSString *)email
{
    return [self.db removeAtleta:email];
}

-(BOOL)atualizarAtleta:(NSString *)email nome:(NSString *)nome
                  foto:(NSString *)foto peso:(NSNumber *)peso
                altura:(NSNumber *)altura sexo:(NSString *)sexo
{
    return [self.db atualizarAtleta:email nome:nome foto:foto peso:peso altura:altura sexo:sexo];
}

-(BOOL)atualizarEmailDoAtleta:(NSString *)email emailNovo:(NSString *)emailNovo
{
    return [self.db atualizarEmailDoAtleta:email emailNovo:emailNovo];
}

-(NSArray *)temposDoAtleta:(NSString *)email
{
    return [self.db temposDoAtleta:email];
}

-(BOOL)adicionarTempos:(NSString *)email eTempos:(Chronometer *)c
{
    email = @"email@testes.com";
    [self.db adicionarAtleta:email nome:@"" foto:@"" peso:@0 altura:@0 sexo:@""];
    GrupoDeTempos *g = [self.db encontraGrupoDeTempos:email dataDeInicio:[[c getStartTimes] objectAtIndex:0]];
    
    if (g != nil) {
        GrupoDeTemposOrdenados *grupoDeTemposOrdenados = [[GrupoDeTemposOrdenados alloc] initComGrupoDeTempos:g];
        grupoDeTemposOrdenados.voltas = [c getLapsContent];
        return [self.db atualizaVoltas:grupoDeTemposOrdenados];
    } else {
    
        return [self.db adicionarTempos:email dataDeInicio:[[c getStartTimes] objectAtIndex:0]
                                inicios:[c getStartTimes] paradas:[c getPauseTimes]
                                 voltas:[c getLapsContent]];
    }
}

@end
