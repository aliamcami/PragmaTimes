#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
// #import "../Parse.framework/Parse"
// #import "../Parse.framework/Headers/Parse.h"

#import "Atleta.h"
#import "GrupoDeTempos.h"
#import "Inicio.h"
#import "Parada.h"
#import "Volta.h"

#import "GrupoDeTemposOrdenados.h"


@interface DB : NSObject

-(NSArray *)todosAtletas;
-(BOOL)adicionarAtleta:(NSString *)email nome:(NSString *)nome foto:(NSString *)foto
                  peso:(NSNumber *)peso altura:(NSNumber *)altura sexo:(NSString *)sexo;
-(Atleta *)encontraAtleta:(NSString *)email;
-(BOOL)removeAtleta:(NSString *)email;
-(BOOL)atualizarAtleta:(NSString *)email nome:(NSString *)nome foto:(NSString *)foto
                  peso:(NSNumber *)peso altura:(NSNumber *)altura sexo:(NSString *)sexo;
-(BOOL)atualizarEmailDoAtleta:(NSString *)email emailNovo:(NSString *)emailNovo;

-(NSArray *)temposDoAtleta:(NSString *)email;
-(BOOL)adicionarTempos:(NSString *)email dataDeInicio:(NSDate *)dataDeInicio
               inicios:(NSArray *)inicios paradas:(NSArray *)paradas voltas:(NSArray *)voltas;

-(BOOL)atualizaVoltas:(GrupoDeTemposOrdenados *)grupoDeTemposOrdenados;
-(GrupoDeTempos *)encontraGrupoDeTempos:(NSString *)email dataDeInicio:(NSDate *)dataDeInicio;
@end