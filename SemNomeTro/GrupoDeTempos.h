//
//  GrupoDeTempos.h
//  SemNomeTro
//
//  Created by André on 22/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Atleta, Inicio, Parada, Volta;

@interface GrupoDeTempos : NSManagedObject

@property (nonatomic, retain) NSDate * dataDeInicio;
@property (nonatomic, retain) Atleta *atleta;
@property (nonatomic, retain) NSSet *inicios;
@property (nonatomic, retain) NSSet *paradas;
@property (nonatomic, retain) NSSet *voltas;
@end

@interface GrupoDeTempos (CoreDataGeneratedAccessors)

- (void)addIniciosObject:(Inicio *)value;
- (void)removeIniciosObject:(Inicio *)value;
- (void)addInicios:(NSSet *)values;
- (void)removeInicios:(NSSet *)values;

- (void)addParadasObject:(Parada *)value;
- (void)removeParadasObject:(Parada *)value;
- (void)addParadas:(NSSet *)values;
- (void)removeParadas:(NSSet *)values;

- (void)addVoltasObject:(Volta *)value;
- (void)removeVoltasObject:(Volta *)value;
- (void)addVoltas:(NSSet *)values;
- (void)removeVoltas:(NSSet *)values;

@end
