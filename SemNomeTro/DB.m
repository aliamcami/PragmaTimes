#import "DB.h"

#import <Parse/Parse.h>

#define WITH_CTX NSManagedObjectContext *ctx = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
#define GET NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; NSError *erroLer;
#define ENCONTRA_ATLETA Atleta *atleta = [self encontraAtleta:email];
#define FN NSLog(@"%s", __FUNCTION__);
#define FLAG_PARSE TRUE
//iweJFPOASEIFJPOASIEJFPOASIEJFOI

#define ATLETA_STR                    @"Atleta"
#define GRUPO_DE_TEMPOS_STR           @"GrupoDeTempos"
#define INICIO_STR                    @"Inicio"
#define PARADA_STR                    @"Parada"
#define VOLTA_STR                     @"Volta"

#define GET_ENTIDADE(CLASSE, VAR_NAME, STR) CLASSE *VAR_NAME = (CLASSE*)[NSEntityDescription entityForName:STR inManagedObjectContext:ctx]; [fetchRequest setEntity:(NSEntityDescription *)VAR_NAME]
#define INSERE_NOVO(CLASSE, VAR_NAME, STR) CLASSE *VAR_NAME = [NSEntityDescription insertNewObjectForEntityForName:STR inManagedObjectContext:ctx]

#define ATLETA                    GET_ENTIDADE(Atleta,                 atleta,       ATLETA_STR);
#define GRUPO_DE_TEMPOS           GET_ENTIDADE(GrupoDeTempos,          grupoDeTempos, GRUPO_DE_TEMPOS_STR);

#define NOVO_ATLETA          INSERE_NOVO(Atleta,        novoAtleta,        ATLETA_STR);
#define NOVO_GRUPO_DE_TEMPOS INSERE_NOVO(GrupoDeTempos, novoGrupoDeTempos, GRUPO_DE_TEMPOS_STR);
#define NOVO_INICIO          INSERE_NOVO(Inicio,        novoInicio,        INICIO_STR);
#define NOVA_PARADA          INSERE_NOVO(Parada,        novaParada,        PARADA_STR);
#define NOVA_VOLTA           INSERE_NOVO(Volta,         novaVolta,         VOLTA_STR);

#define GRAVA_OU_ERRO  NSError *erroGravar; if (![ctx save:&erroGravar]) { NSLog(@"%@", [erroGravar localizedDescription]); return nil; }
#define LE_OU_ERRO if (erroLer != nil) { NSLog(@"%@", [erroLer localizedDescription]); return nil; }

@implementation DB


-(NSArray *)todosAtletas {
  FN WITH_CTX GET ATLETA
  NSArray *todosAtletas = [ctx executeFetchRequest:fetchRequest error:&erroLer];
  LE_OU_ERRO
  return todosAtletas;
}

-(BOOL)adicionarAtleta:(NSString *)email nome:(NSString *)nome foto:(NSString *)foto
                  peso:(NSNumber *)peso altura:(NSNumber *)altura sexo:(NSString *)sexo {
  FN WITH_CTX
  if ([self encontraAtleta:email] != nil) {
    NSLog(@"Atleta já existe: %@", email);
    return NO;
  } else if (email == nil) {
    NSLog(@"Email do atleta é nulo");
    return NO;
  } else {
    NSLog(@"Atleta novo: %@", email);
  }
  // TODO verificar que o email não e null

  if (FLAG_PARSE) {
    PFObject *novoAtletaParse = [PFObject objectWithClassName:@"Atleta"];
    novoAtletaParse[@"email"]  = email;
    novoAtletaParse[@"nome"]   = nome;
    novoAtletaParse[@"foto"]   = foto;
    novoAtletaParse[@"peso"]   = peso;
    novoAtletaParse[@"altura"] = altura;
    novoAtletaParse[@"sexo"]   = sexo;
    [novoAtletaParse saveEventually];
  }
  NOVO_ATLETA
  novoAtleta.email  = email;
  novoAtleta.nome   = nome;
  novoAtleta.foto   = foto;
  novoAtleta.peso   = peso;
  novoAtleta.altura = altura;
  novoAtleta.sexo   = sexo;
  GRAVA_OU_ERRO

  NSLog(@"Gravou!");
  return YES;
}

-(Atleta *)encontraAtleta:(NSString *)email {
  FN WITH_CTX GET ATLETA

  NSString *predicateString = [NSString stringWithFormat:@"email == '%@'", email];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString]];
  NSArray *arrayAtletaUnico = [ctx executeFetchRequest:fetchRequest error:&erroLer];
  LE_OU_ERRO

  if (arrayAtletaUnico == nil) {
    NSLog(@"Atleta(%@) deu erro", email);
    return nil;
  } else if ([arrayAtletaUnico count] > 1) {
    NSLog(@"Atleta(%@) está duplicado no banco", email);
    return nil;
  } else if ([arrayAtletaUnico count] == 1) {
    NSLog(@"Atleta(%@) encontrado!", email);
    return arrayAtletaUnico[0];
  } else {
    NSLog(@"Nenhum atleta(%@) encontrado", email);
    return nil;
  }
}

-(BOOL)removeAtleta:(NSString *)email {
  FN
  WITH_CTX ENCONTRA_ATLETA
  [ctx deleteObject:atleta];
  GRAVA_OU_ERRO
  return YES;
}

-(BOOL)atualizarAtleta:(NSString *)email nome:(NSString *)nome foto:(NSString *)foto
                  peso:(NSNumber *)peso altura:(NSNumber *)altura sexo:(NSString *)sexo {
  FN WITH_CTX ENCONTRA_ATLETA
  atleta.nome = nome;
  atleta.foto = foto;
  atleta.peso = peso;
  atleta.altura = altura;
  atleta.sexo = sexo;
  GRAVA_OU_ERRO
  return YES;
}

-(BOOL)atualizarEmailDoAtleta:(NSString *)email emailNovo:(NSString *)emailNovo {
  FN WITH_CTX ENCONTRA_ATLETA
  atleta.email = emailNovo;
  GRAVA_OU_ERRO
  return YES;
}


-(NSArray *)temposDoAtleta:(NSString *)email {
  FN
  ENCONTRA_ATLETA
  NSArray *arrayDeArraysAindaSemOrdenar = [atleta.tempos allObjects];

  NSMutableArray *arrayDeArraysOrdenados = [[NSMutableArray alloc] init];
  for (GrupoDeTempos *g in arrayDeArraysAindaSemOrdenar)
    [arrayDeArraysOrdenados addObject:[[GrupoDeTemposOrdenados alloc] initComGrupoDeTempos:g]];


  NSLog(@"%@", arrayDeArraysOrdenados);
  return arrayDeArraysOrdenados;
}

-(BOOL)adicionarTempos:(NSString *)email dataDeInicio:(NSDate *)dataDeInicio
               inicios:(NSArray *)inicios paradas:(NSArray *)paradas voltas:(NSArray *)voltas {
  FN
  WITH_CTX NOVO_GRUPO_DE_TEMPOS ENCONTRA_ATLETA

  novoGrupoDeTempos.dataDeInicio = dataDeInicio;

  for (NSDate *inicio in inicios) {
    NOVO_INICIO
    novoInicio.tempo = inicio;
    [novoGrupoDeTempos addIniciosObject:novoInicio];
    novoInicio.grupo = novoGrupoDeTempos;
  }

  for (NSDate *parada in paradas) {
    NOVA_PARADA
    novaParada.tempo = parada;
    [novoGrupoDeTempos addParadasObject:novaParada];
    novaParada.grupo = novoGrupoDeTempos;
  }

  for (NSNumber *volta in voltas) {
    NOVA_VOLTA
    novaVolta.tempo = volta;
    [novoGrupoDeTempos addVoltasObject:novaVolta];
    novaVolta.grupo = novoGrupoDeTempos;
  }

  novoGrupoDeTempos.dataDeInicio = dataDeInicio;

  novoGrupoDeTempos.atleta = atleta;
  [atleta addTemposObject:novoGrupoDeTempos];

  GRAVA_OU_ERRO
  return YES;
}

-(GrupoDeTempos *)encontraGrupoDeTempos:(NSString *)email dataDeInicio:(NSDate *)dataDeInicio {
  FN WITH_CTX GET GRUPO_DE_TEMPOS
  NSString *predicateString = [NSString stringWithFormat:@"atleta.email = '%@'", email];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString]];
  NSArray *arrayGrupoDeTemposUnico = [ctx executeFetchRequest:fetchRequest error:&erroLer];

  if (arrayGrupoDeTemposUnico == nil) {
    NSLog(@"GrupoDeTempos(%@) do atleta(%@) deu erro", dataDeInicio, email);
    return nil;
  } else if ([arrayGrupoDeTemposUnico count] == 1) {
    return arrayGrupoDeTemposUnico[0];
  } else if ([arrayGrupoDeTemposUnico count] > 1) {
    for (GrupoDeTempos *g in arrayGrupoDeTemposUnico)
      if ([g.dataDeInicio isEqualToDate:dataDeInicio])
        return g;
    return nil;
  } else {
    NSLog(@"Nenhum grupoDeTempos(%@) do atleta(%@) encontrado", dataDeInicio, email);
    return nil;
  }
}

-(BOOL)atualizaVoltas:(GrupoDeTemposOrdenados *)grupoDeTemposOrdenadosAtualizado {
  FN WITH_CTX
  GrupoDeTempos *grupoDeTempos = [self
                                  encontraGrupoDeTempos:grupoDeTemposOrdenadosAtualizado.atleta.email
                                  dataDeInicio:grupoDeTemposOrdenadosAtualizado.dataDeInicio];
  grupoDeTempos.voltas = [[NSMutableSet alloc] init];
  for (NSNumber *volta in grupoDeTemposOrdenadosAtualizado.voltas) {
    NOVA_VOLTA
    novaVolta.tempo = volta;
    [grupoDeTempos addVoltasObject:novaVolta];
    novaVolta.grupo = grupoDeTempos;
  }
  GRAVA_OU_ERRO

  return YES;
}


@end
