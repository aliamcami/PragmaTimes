#import "DadosLocais_DataBase.h"
#define GRAVA(DATA, RES, ARQUIVO) BOOL RES = [DATA writeToFile:ARQUIVO atomically:YES];
#define CHECA_GRAVACAO(RES, ARQUIVO) if (RES) NSLog(@"Arquivo %@ gravado com sucesso.", ARQUIVO); else NSLog(@"Erro na gravação do arquivo: %@.", ARQUIVO);
#define GRAVA_E_CHECA_GRAVACAO(DATA, RES, ARQUIVO) GRAVA(DATA, RES, ARQUIVO) CHECA_GRAVACAO(RES, ARQUIVO)

#define READ_INIT(VAR, ARQUIVO) NSMutableDictionary *VAR = [NSMutableDictionary dictionaryWithContentsOfFile:ARQUIVO]; if (VAR == nil) VAR = [[NSMutableDictionary alloc] init]
@interface DadosLocais_DataBase ()

@property (nonatomic, readonly) NSString *arquivoTempos, *arquivoAtletas, *arquivoTreinador;


@end

@implementation DadosLocais_DataBase

//-(BOOL)testarTeste {
//  READ_INIT(atletas, self.arquivoAtletas);
//
//  NSString *email = @"andoremiramor@gmail.com";
//  if ([email isEqualToString:@""])
//    email = [self geraEmail];
//  
//  [atletas setValue:@{@"nome": @"Andfeio",
//                      @"foto": @"foto",
//                      @"peso": @"1",
//                      @"altura": @"iOJ",
//                      @"sexo": @"MF"}
//             forKey:email];
//  
//    [@{@"vai":@"logo"} writeToFile:self.arquivoAtletas atomically:YES];
//    NSLog(@"%@", [[NSDictionary alloc] initWithContentsOfFile:self.arquivoAtletas]);
//
//  GRAVA_E_CHECA_GRAVACAO(atletas, res, self.arquivoAtletas);
//
//  
//  NSLog(@"%@", atletas);
//  
//  return [atletas writeToFile:self.arquivoAtletas atomically:YES];
////  return YES;
//}

- (instancetype)init {
  self = [super init];
  if (self) {
    _arquivoTempos = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tempos.plist"];
    _arquivoAtletas = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/atletas.plist"];
    _arquivoTreinador = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/treinador.plist"];
  }
  return self;
}


// Tempos
#pragma mark - Tempos

-(void)gravarTempos:(NSArray *)arrayDeTempos identificadorDoAtleta:(NSString *)identificadorDoAtleta {
  READ_INIT(tempos, self.arquivoTempos);

  NSMutableArray *temposDoAtleta = [tempos objectForKey:identificadorDoAtleta];
  // Se o atleta não existir
  if (temposDoAtleta == nil) // TODO: errado! o atleta tem que existir antes!
    temposDoAtleta = [[NSMutableArray alloc] init];
  
  [temposDoAtleta addObject:arrayDeTempos];
  [tempos setValue:temposDoAtleta forKey:identificadorDoAtleta];
  
  GRAVA_E_CHECA_GRAVACAO(tempos, res, self.arquivoTempos);
}

-(void)removerGrupoDeTempos:(int)posicao identificadorDoAtleta:(NSString *)identificadorDoAtleta {
  READ_INIT(tempos, self.arquivoTempos);
  NSMutableArray *temposDoAtleta = [tempos objectForKey:identificadorDoAtleta];

  [temposDoAtleta removeObjectAtIndex:posicao];
  [tempos setValue:temposDoAtleta forKey:identificadorDoAtleta];

  GRAVA_E_CHECA_GRAVACAO(tempos, res, self.arquivoTempos);
}

-(void)removerTempoIndividual:(int)posicaoDoTempo grupoDeTempos:(int)posicaoDoGrupoDeTempos
        identificadorDoAtleta:(NSString *)identificadorDoAtleta {
  READ_INIT(tempos, self.arquivoTempos);
  NSMutableArray *temposDoAtleta = [tempos objectForKey:identificadorDoAtleta];
  
  NSMutableArray *grupoDeTempos = [temposDoAtleta objectAtIndex:posicaoDoGrupoDeTempos];
  
  [grupoDeTempos removeObjectAtIndex:posicaoDoTempo];
  [temposDoAtleta setObject:grupoDeTempos atIndexedSubscript:posicaoDoGrupoDeTempos];
  
  [tempos setValue:temposDoAtleta forKey:identificadorDoAtleta];
  
  GRAVA_E_CHECA_GRAVACAO(tempos, res, self.arquivoTempos);
}

-(NSArray *)recuperarTempos:(NSString *)identificadorDoAtleta {
  READ_INIT(tempos, self.arquivoTempos);
  return [tempos objectForKey:identificadorDoAtleta];
}


// Treinador
#pragma mark - Treinador

-(NSDictionary *) recuperaTreinador {
  return [NSDictionary dictionaryWithContentsOfFile:self.arquivoTreinador];
}

-(NSString *)recuperaEmailDoTreinador {
  return [[self recuperaTreinador] objectForKey:@"email"];
}

-(void) loginTreinador {
  // TODO
}

-(void) atualizarTreinador {
  NSDictionary *treinador = @{}; // TODO colocar os campos da tela do treinador: quais são os argumentos?
  GRAVA_E_CHECA_GRAVACAO(treinador, res, self.arquivoTreinador);
}

-(void) logoutTreinador {
// TODO
}


// Atletas
#pragma mark - Atletas

-(NSString *)geraEmail {
  return [NSString stringWithFormat:@"%@-algumnumeroIdentificadorunico",
          [self recuperaEmailDoTreinador]]; // TODO implementar isso aqui
}

-(void) adicionarAtleta:(NSString *)email nome:(NSString *)nome foto:(NSString *)foto
                   peso:(double)peso altura:(double)altura sexo:(NSString *)sexo {
  READ_INIT(atletas, self.arquivoAtletas);
  
  if ([atletas objectForKey:email])
    NSLog(@"Atleta já existe! Conserte isso!"); // TODO retornar NO se já existir
  else {
    if ([email isEqualToString:@""])
      email = [self geraEmail];
    
    [atletas setValue:@{@"nome": nome,
                        @"foto": foto,
                        @"peso": [NSNumber numberWithDouble:peso],
                        @"altura": [NSNumber numberWithDouble:altura],
                        @"sexo": sexo}
               forKey:email];
    
    GRAVA_E_CHECA_GRAVACAO(atletas, res, self.arquivoAtletas);
  }
}

-(void) atualizarAtleta:(NSString *)identificadorDoAtleta nome:(NSString *)nome
                   foto:(NSString *)foto peso:(double)peso altura:(double)altura
                   sexo:(NSString *)sexo {
  READ_INIT(atletas, self.arquivoAtletas);
  NSDictionary *atleta = @{@"nome": nome,
                           @"foto": foto,
                           @"peso": [NSNumber numberWithDouble:peso],
                           @"altura": [NSNumber numberWithDouble:altura],
                           @"sexo": sexo};
  
  [atletas setValue:atleta forKey:identificadorDoAtleta];
  GRAVA_E_CHECA_GRAVACAO(atletas, res, self.arquivoAtletas);
}

-(void) atualizarAtletaComEmailNovo:(NSString *)identificadorDoAtletaVelho
                          emailNovo:(NSString *)emailNovo nome:(NSString *)nome
                               foto:(NSString *)foto peso:(double)peso
                             altura:(double)altura sexo:(NSString *)sexo {

  // Cria novo atleta
  [self adicionarAtleta:emailNovo nome:nome foto:foto peso:peso altura:altura sexo:sexo];

  // Remove atleta antigo
  READ_INIT(atletas, self.arquivoAtletas);
  [atletas removeObjectForKey:identificadorDoAtletaVelho];
  GRAVA_E_CHECA_GRAVACAO(atletas, res, self.arquivoAtletas);
  
  // Transfere tempos do atletaVelho para o atletaNovo
  READ_INIT(tempos, self.arquivoTempos);
  [tempos setValue:[self recuperarTempos:identificadorDoAtletaVelho] forKey:emailNovo];
  [tempos removeObjectForKey:identificadorDoAtletaVelho];
  GRAVA_E_CHECA_GRAVACAO(tempos, res2, self.arquivoTempos);
}

-(void) removerAtleta:(NSString *)identificadorDoAtleta {
  READ_INIT(atletas, self.arquivoAtletas);
  [self removerTemposDoAtleta:identificadorDoAtleta];
  [atletas removeObjectForKey:identificadorDoAtleta];
  GRAVA_E_CHECA_GRAVACAO(atletas, res, self.arquivoAtletas);
}

-(NSDictionary *) recuperarAtleta:(NSString *)identificadorDoAtleta {
  READ_INIT(atletas, self.arquivoAtletas);
  return [atletas objectForKey:identificadorDoAtleta];
}

-(void) removerTemposDoAtleta:(NSString *)identificadorDoAtleta {
  READ_INIT(tempos, self.arquivoTempos);
  [tempos removeObjectForKey:identificadorDoAtleta];
  GRAVA_E_CHECA_GRAVACAO(tempos, res, self.arquivoTempos);
}

@end























































