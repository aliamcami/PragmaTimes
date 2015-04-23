#import <Foundation/Foundation.h>
#import "GrupoDeTempos.h"
#import "Inicio.h"
#import "Parada.h"
#import "Volta.h"

@class Atleta;

@interface GrupoDeTemposOrdenados : NSObject

@property (nonatomic, retain) NSDate * dataDeInicio;
@property (nonatomic, retain) Atleta *atleta;
@property (nonatomic, retain) NSArray *inicios;
@property (nonatomic, retain) NSArray *paradas;
@property (nonatomic, retain) NSArray *voltas; // Mutable??

- (instancetype)initComGrupoDeTempos:(GrupoDeTempos *)tempos;

@end
 