#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
//#import "DadosLocais_DataBase.h"

#define DB DadosLocais_DataBase *db = [[DadosLocais_DataBase alloc] init];

@interface SemNomeTroTests : XCTestCase

@end

@implementation SemNomeTroTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
//  DB
//  [@[] writeToFile:db.arquivoAtletas atomically:YES];
//  [@[] writeToFile:db.arquivoTempos atomically:YES];
//  [@[] writeToFile:db.arquivoTreinador atomically:YES];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
    // Put the code you want to measure the time of here.
  }];
}

/*
// Testes de atletas
#pragma mark - Testes de atletas

- (void)testarGravacaoERecuperacaoDeAtleta {
  DB
  NSString *idDoAtleta = @"andremiramor@gmail.com";
  [db adicionarAtleta:idDoAtleta nome:@"André" foto:@"" peso:80.0 altura:1.85 sexo:@"M"];
  NSDictionary *atletaAndreEsperado = @{@"nome": @"André",
                                        @"foto": @"",
                                        @"peso": @80.0,
                                        @"altura": @1.85,
                                        @"sexo": @"M"};
  XCTAssertEqualObjects(atletaAndreEsperado, [db recuperarAtleta:idDoAtleta]);
}

- (void)testarGravarAtletaDuplicado {
  DB
  NSString *idDoAtleta = @"aliamcamil@gmail.com";
  [db adicionarAtleta:idDoAtleta nome:@"Camila" foto:@"" peso:80.0 altura:1.85 sexo:@"F"];
  [db adicionarAtleta:idDoAtleta nome:@"Camila2" foto:@"" peso:80.0 altura:1.85 sexo:@"F"];
  
  NSDictionary *atletaCamilaEsperada = @{@"nome": @"Camila", // e não @"Camila2"
                                         @"foto": @"",
                                         @"peso": @80.0,
                                         @"altura": @1.85,
                                         @"sexo": @"F"};
  XCTAssertEqualObjects(atletaCamilaEsperada, [db recuperarAtleta:idDoAtleta]);
}

- (void)testarAdicionarERemoverAtleta {
  DB
  NSString *idDoAtleta = @"andrecabeludo@hotmail.com";
  [db adicionarAtleta:idDoAtleta nome:@"André" foto:@"" peso:80.0 altura:1.85 sexo:@"M"];
  
  NSDictionary *atletaAndreEsperado = @{@"nome": @"André",
                                        @"foto": @"",
                                        @"peso": @80.0,
                                        @"altura": @1.85,
                                        @"sexo": @"M"};
  
  XCTAssertEqualObjects(atletaAndreEsperado, [db recuperarAtleta:idDoAtleta]);
  
  [db removerAtleta:idDoAtleta];
  XCTAssertNil([db recuperarAtleta:idDoAtleta]);
}

// TODO: adicionar mais testes de atletas, principalmente de atualizacao
// TODO: CRUD do treinador

// Testes de tempos
#pragma mark - Testes de tempos

-(void) testarGravarTemposERecuperar {
  DB
  NSArray *arrayDeTempos = @[[NSDate date], @1.23, @4.56];
  NSString *idDoAtleta = @"andre@silvassauro.com";
  [db removerAtleta:idDoAtleta];

  [db gravarTempos:arrayDeTempos identificadorDoAtleta:idDoAtleta];
  
  NSArray *tempos = [db recuperarTempos:idDoAtleta];

  XCTAssert(tempos);
  XCTAssertEqual(1, [tempos count]);
  
  XCTAssertEqualWithAccuracy([tempos[0][0] timeIntervalSinceReferenceDate],
                             [arrayDeTempos[0] timeIntervalSinceReferenceDate],
                             0.9); // Aff imprecisao do parada TODO consertar isso!
}

- (void) testarGravarDoisGruposDeTempoNoMesmoDia {
  DB
  NSString *idDoAtleta = @"andre@silvassauro.org";
  NSArray *arrayDeTempos1 = @[[NSDate date], @0.12, @3.45];
  sleep(1);
  NSArray *arrayDeTempos2 = @[[NSDate date], @0.12, @3.45];
  [db removerAtleta:idDoAtleta];
  
  float precisao = 0.9;
  
  [db gravarTempos:arrayDeTempos1 identificadorDoAtleta:idDoAtleta];
  [db gravarTempos:arrayDeTempos2 identificadorDoAtleta:idDoAtleta];
  
  NSArray *tempos = [db recuperarTempos:idDoAtleta];
  XCTAssert(tempos);
  XCTAssertEqual(2, [tempos count]);
  XCTAssertEqualWithAccuracy([tempos[0][0] timeIntervalSinceReferenceDate],
                             [arrayDeTempos1[0] timeIntervalSinceReferenceDate],
                             precisao);
  XCTAssertEqualWithAccuracy([tempos[1][0] timeIntervalSinceReferenceDate],
                             [arrayDeTempos2[0] timeIntervalSinceReferenceDate],
                             precisao);
  XCTAssertNotEqualWithAccuracy([tempos[0][0] timeIntervalSinceReferenceDate],
                                [tempos[1][0] timeIntervalSinceReferenceDate],
                                precisao);
}

- (void)testarRecuperarTemposDeAtletaRemovido {
  DB
  NSString *idDoAtleta = @"1@2.3";
  [db adicionarAtleta:idDoAtleta nome:@"" foto:@"" peso:0.0 altura:0.0 sexo:@""];
  [db gravarTempos:@[[NSDate date], @0.1, @2.3] identificadorDoAtleta:idDoAtleta];
  
  XCTAssert([db recuperarTempos:idDoAtleta]);
  XCTAssert([db recuperarAtleta:idDoAtleta]);
  [db removerAtleta:idDoAtleta];
  XCTAssertNil([db recuperarTempos:idDoAtleta]);
  XCTAssertNil([db recuperarAtleta:idDoAtleta]);
}

-(void)testarRemoverTemposDeAtleta {
  DB
  NSString *idDoAtleta = @"arroba@ponto.com";
  [db adicionarAtleta:idDoAtleta nome:@"" foto:@"" peso:0.0 altura:0.0 sexo:@""];
  [db gravarTempos:@[[NSDate date], @0.1, @2.3] identificadorDoAtleta:idDoAtleta];

  XCTAssert([db recuperarTempos:idDoAtleta]);
  XCTAssert([db recuperarAtleta:idDoAtleta]);
  [db removerTemposDoAtleta:idDoAtleta];
  XCTAssertNil([db recuperarTempos:idDoAtleta]);
  XCTAssert([db recuperarAtleta:idDoAtleta]);
}

-(void)testarEmailDoAtualizarAtleta {
  DB
  NSString *atletaAntes = @"antes@doesporte.vai";
  NSString *atletaDepois = @"depois@doesporte.foi";
  NSArray *arrayDeTempos = @[[NSDate date], @1.1, @2.2];
  
  [db removerAtleta:atletaAntes];
  [db removerAtleta:atletaDepois];
  
  XCTAssertNil([db recuperarAtleta:atletaAntes]);
  XCTAssertNil([db recuperarTempos:atletaAntes]);
  XCTAssertNil([db recuperarAtleta:atletaDepois]);
  XCTAssertNil([db recuperarTempos:atletaDepois]);
  
  NSString *nome = @"", *foto = @"", *sexo = @"";
  float peso = 0.0, altura = 0.0;
  
  [db adicionarAtleta:atletaAntes nome:nome foto:foto peso:peso altura:altura sexo:@""];
  [db gravarTempos:arrayDeTempos identificadorDoAtleta:atletaAntes];
  
  XCTAssert([db recuperarAtleta:atletaAntes]);
  XCTAssert([db recuperarTempos:atletaAntes]);
  XCTAssertNil([db recuperarAtleta:atletaDepois]);
  XCTAssertNil([db recuperarTempos:atletaDepois]);
  [db atualizarAtletaComEmailNovo:atletaAntes emailNovo:atletaDepois nome:nome foto:foto peso:peso altura:altura sexo:sexo];
  XCTAssertNil([db recuperarAtleta:atletaAntes]);
  XCTAssertNil([db recuperarTempos:atletaAntes]);
  XCTAssert([db recuperarAtleta:atletaDepois]);
  XCTAssert([db recuperarTempos:atletaDepois]);
  
  NSArray *tempos = [db recuperarTempos:atletaDepois];
  XCTAssert(tempos);
  XCTAssertEqual(1, [tempos count]);
  XCTAssertEqualWithAccuracy([tempos[0][0] timeIntervalSinceReferenceDate],
                             [arrayDeTempos[0] timeIntervalSinceReferenceDate],
                             0.9); // Aff imprecisao do parada TODO consertar isso!
}

   
-(void)testarAtualizarAtleta {
  DB
  NSString *idDoAtleta = @"testar@o.atleta";
  NSString *nomeAntes = @"sem", *fotoAntes = @"sem", *sexoAntes = @"sem";
  float pesoAntes = 0.0, alturaAntes = 0.0;
  NSString *nomeDepois = @"com", *fotoDepois = @"com", *sexoDepois = @"com";
  float pesoDepois = 10.0, alturaDepois = 10.0;
  
  NSDictionary *atletaAntes = @{@"nome": nomeAntes,
                                @"foto": fotoAntes,
                                @"peso": [NSNumber numberWithFloat:pesoAntes],
                                @"altura": [NSNumber numberWithFloat:alturaAntes],
                                @"sexo": sexoAntes};
  NSDictionary *atletaDepois = @{@"nome": nomeDepois,
                                 @"foto": fotoDepois,
                                 @"peso": [NSNumber numberWithFloat:pesoDepois],
                                 @"altura": [NSNumber numberWithFloat:alturaDepois],
                                 @"sexo": sexoDepois};
  
  [db removerAtleta:idDoAtleta];
  [db adicionarAtleta:idDoAtleta nome:nomeAntes foto:fotoAntes peso:pesoAntes altura:alturaAntes sexo:sexoAntes];
  XCTAssertEqualObjects(atletaAntes, [db recuperarAtleta:idDoAtleta]);
  [db atualizarAtleta:idDoAtleta nome:nomeDepois foto:fotoDepois peso:pesoDepois altura:alturaDepois sexo:sexoDepois];
  XCTAssertEqualObjects(atletaDepois, [db recuperarAtleta:idDoAtleta]);
}
 */
@end


























