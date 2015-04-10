/**
 arrayDeTempos é um array com o seguinte formato:
 na posição 0, está o NSDate de quando o grupo de tempos começou a ser gravado
 nas posições seguintes estão os tempos, no formato NSNumber, tipop float
 
 identificadorDoAtleta é o identificador único de cada atleta: o email dele, caso fornecido, ou o email do treinador prefixador de um número único.
 
 Quando o treinador adicionar posteriormente o email do atleta, os registros anteriores do atleta também devem ser atualizados.
 
 O formato do arquivo tempos.plist é:
 @{$identificadorDoAtleta1: @[[data0, tempo0-1, tempo0-2, tempo0-3], @[data1, tempo1-1, tempo1-2, tempo1-3, tempo1-4]],
 $identificadorDoAtleta2: @[[data0, tempo0-1, tempo0-2, tempo0-3], @[data1, tempo1-1, tempo1-2, tempo1-3, tempo1-4]]}
 
 O método recuperaTempos retorna um array no formato @[data0, tempo0-1, tempo0-2, tempo0-3]
 
 O formato do arquivo atletas.plist é:
 @{$identificadorDoAtleta1: @{@"nome": $nomeDoAtleta1,
 @"foto": $fotoDoAtleta.jpg,
 @"peso": $pesoDoAtleta,
 @"altura: $alturaDoAtleta,
 @"sexo": $sexoDoAtleta},
 $identificadorDoAtleta2: etc...}
 Se foto for diferente de @"", a uri da foto é a foto padrão. Se não, é pastaDasFotos/identificadorDoAtleta.png
 TODO: decidir se o perfil do atleta vai ter dataDeNascimento
 
 
 O formato do arquivo treinador.plist é:
 @{@"nome": $nomeDoTreinador,
 @"email": $emailDoTreinador, etc...}
 Os dados são os obrigatórios e os opcionais do perfil do treinador.
 
 O identificadorDoAtleta é ou o email do atleta, ou o email do treinador com um sufixo único. Algo como @"emaildotreinador@icloud.com-atleta132" ou @"emaildotreinador@icloud.com-atleta133"
 */

#import <Foundation/Foundation.h>

@interface DadosLocais_DataBase : NSObject

// Arquivos
@property (nonatomic, readonly) NSString *arquivoTempos, *arquivoAtletas, *arquivoTreinador;

// Tempos
-(void)gravarTempos:(NSArray *)arrayDeTempos identificadorDoAtleta:(NSString *)identificadorDoAtleta;
-(void)removerGrupoDeTempos:(int)posicao identificadorDoAtleta:(NSString *)identificadorDoAtleta;
-(void)removerTempoIndividual:(int)posicaoDoTempo grupoDeTempos:(int)posicaoDoGrupoDeTempos
        identificadorDoAtleta:(NSString *)identificadorDoAtleta;
-(NSArray *)recuperarTempos:(NSString *)identificadorDoAtleta;

// Treinador
-(NSDictionary *) recuperaTreinador;
-(NSString *)recuperaEmailDoTreinador;
-(void) loginTreinador;
-(void) atualizarTreinador;
-(void) logoutTreinador;

// Atletas
-(NSString *)geraEmail;

-(void) adicionarAtleta:(NSString *)email nome:(NSString *)nome foto:(NSString *)foto
                   peso:(double)peso altura:(double)altura sexo:(NSString *)sexo;
-(void) atualizarAtleta:(NSString *)identificadorDoAtleta nome:(NSString *)nome
                   foto:(NSString *)foto peso:(double)peso
                 altura:(double)altura sexo:(NSString *)sexo;
-(void) atualizarAtletaComEmailNovo:(NSString *)identificadorDoAtletaVelho
                          emailNovo:(NSString *)emailNovo nome:(NSString *)nome
                               foto:(NSString *)foto peso:(double)peso
                             altura:(double)altura sexo:(NSString *)sexo;
-(void) removerAtleta:(NSString *)identificadorDoAtleta;
-(NSDictionary *) recuperarAtleta:(NSString *)identificadorDoAtleta;
-(void) removerTemposDoAtleta:(NSString *)identificadorDoAtleta;

//-(BOOL)testarTeste;

@end