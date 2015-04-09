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


























































@end