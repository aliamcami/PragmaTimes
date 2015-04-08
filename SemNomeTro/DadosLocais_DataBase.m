#import "DadosLocais_DataBase.h"
#define GRAVA(DATA, RES, ARQUIVO) BOOL RES = [DATA writeToFile:ARQUIVO atomically:YES];
#define CHECA_GRAVACAO(RES, ARQUIVO) if (RES) NSLog(@"Arquivo %@ gravado com sucesso.", ARQUIVO); else NSLog(@"Erro na gravação do arquivo: %@.", ARQUIVO);
#define GRAVA_E_CHECA_GRAVACAO(DATA, RES, ARQUIVO) GRAVA(DATA, RES, ARQUIVO) CHECA_GRAVACAO(RES, ARQUIVO)

@interface DadosLocais_DataBase ()

@property (nonatomic, readonly) NSString *arquivoTempos, *arquivoAtletas, *arquivoTreinador;

@end

@implementation DadosLocais_DataBase

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

-(void)gravarTempos:(NSArray *)arrayDeTempos identificadorDoAtleta:(NSString *)identificadorDoAtleta {
  NSMutableDictionary *tempos = [NSMutableDictionary dictionaryWithContentsOfFile:self.arquivoTempos];
  // Se o arquivo não existir
  if (tempos == nil)
    tempos = [[NSMutableDictionary alloc] init];

  NSMutableArray *temposDoAtleta = [tempos objectForKey:identificadorDoAtleta];
  // Se o atleta não existir
  if (temposDoAtleta == nil)
    temposDoAtleta = [[NSMutableArray alloc] init];
  
  [temposDoAtleta addObject:arrayDeTempos];
  [tempos setValue:temposDoAtleta forKey:identificadorDoAtleta];
  
  GRAVA_E_CHECA_GRAVACAO(tempos, res, self.arquivoTempos);
}

-(void)removerGrupoDeTempos:(int)posicao identificadorDoAtleta:(NSString *)identificadorDoAtleta {
  NSMutableDictionary *tempos = [NSMutableDictionary dictionaryWithContentsOfFile:self.arquivoTempos];
  NSMutableArray *temposDoAtleta = [tempos objectForKey:identificadorDoAtleta];

  [temposDoAtleta removeObjectAtIndex:posicao];
  [tempos setValue:temposDoAtleta forKey:identificadorDoAtleta];

  GRAVA_E_CHECA_GRAVACAO(tempos, res, self.arquivoTempos);
}

-(void)removerTempoIndividual:(int)posicaoDoTempo grupoDeTempos:(int)posicaoDoGrupoDeTempos
        identificadorDoAtleta:(NSString *)identificadorDoAtleta {
  NSMutableDictionary *tempos = [NSMutableDictionary dictionaryWithContentsOfFile:self.arquivoTempos];
  NSMutableArray *temposDoAtleta = [tempos objectForKey:identificadorDoAtleta];
  
  NSMutableArray *grupoDeTempos = [temposDoAtleta objectAtIndex:posicaoDoGrupoDeTempos];
  
  [grupoDeTempos removeObjectAtIndex:posicaoDoTempo];
  [temposDoAtleta setObject:grupoDeTempos atIndexedSubscript:posicaoDoGrupoDeTempos];
  
  [tempos setValue:temposDoAtleta forKey:identificadorDoAtleta];
  
  GRAVA_E_CHECA_GRAVACAO(tempos, res, self.arquivoTempos);
}

-(NSArray *)recuperarTempos:(NSString *)identificadorDoAtleta {
  NSMutableDictionary *tempos = [NSMutableDictionary dictionaryWithContentsOfFile:self.arquivoTempos];
  return [tempos objectForKey:identificadorDoAtleta];
}


// Treinador

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

-(NSString *)geraEmail {
  return [NSString stringWithFormat:@"%@-algumnumeroIdentificadorunico",
          [self recuperaEmailDoTreinador]]; // TODO implementar isso aqui
}

-(void) adicionarAtleta:(NSString *)nome email:(NSString *)email foto:(NSString *)foto
                   peso:(double)peso altura:(double)altura sexo:(NSString *)sexo {
    NSMutableDictionary *atletas = [NSMutableDictionary dictionaryWithContentsOfFile:self.arquivoAtletas];
  
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

-(void) atualizarAtleta:(NSString *)identificadorDoAtleta nome:(NSString *)nome
                  email:(NSString *)email foto:(NSString *)foto peso:(double)peso
                 altura:(double)altura sexo:(NSString *)sexo {
  NSMutableDictionary *atletas = [NSMutableDictionary dictionaryWithContentsOfFile:self.arquivoAtletas];
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
  NSMutableDictionary *atletas = [NSMutableDictionary dictionaryWithContentsOfFile:self.arquivoAtletas];
  [atletas removeObjectForKey:identificadorDoAtleta];
  

GRAVA_E_CHECA_GRAVACAO(atletas, res, self.arquivoAtletas);
}

-(NSDictionary *) recuperarAtleta:(NSString *)identificadorDoAtleta {
  NSMutableDictionary *atletas = [NSMutableDictionary dictionaryWithContentsOfFile:self.arquivoAtletas];
  return [atletas objectForKey:identificadorDoAtleta];
}

@end























































