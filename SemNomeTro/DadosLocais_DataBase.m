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
  if (temposDoAtleta == nil)
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

-(void) adicionarAtleta:(NSString *)nome email:(NSString *)email foto:(NSString *)foto
                   peso:(double)peso altura:(double)altura sexo:(NSString *)sexo {
  READ_INIT(atletas, self.arquivoAtletas);
  
  if ([atletas objectForKey:email])
    NSLog(@"Atleta já existe! Conserte isso!");
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
                  email:(NSString *)email foto:(NSString *)foto peso:(double)peso
                 altura:(double)altura sexo:(NSString *)sexo {
  READ_INIT(atletas, self.arquivoAtletas);
  NSDictionary *atleta = @{@"nome": nome,
                           @"foto": foto,
                           @"peso": [NSNumber numberWithDouble:peso],
                           @"altura": [NSNumber numberWithDouble:altura],
                           @"sexo": sexo};
  
  // TODO: verificar se o email foi modificado. Se sim, atualizar tudo: foto, identificadorDoAtleta em todos os lugares e esssas coisas.
  
  [atletas setValue:atleta forKey:identificadorDoAtleta];
  
  GRAVA_E_CHECA_GRAVACAO(atletas, res, self.arquivoAtletas);
}

-(void) removerAtleta:(NSString *)identificadorDoAtleta {
  READ_INIT(atletas, self.arquivoAtletas);
  [atletas removeObjectForKey:identificadorDoAtleta];
  
  GRAVA_E_CHECA_GRAVACAO(atletas, res, self.arquivoAtletas);
}

-(NSDictionary *) recuperarAtleta:(NSString *)identificadorDoAtleta {
  READ_INIT(atletas, self.arquivoAtletas);
  return [atletas objectForKey:identificadorDoAtleta];
}

@end























































