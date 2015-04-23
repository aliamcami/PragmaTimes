#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
//#import "DadosLocais_DataBase.h"
#import "DB.h"

@interface SemNomeTroTests : XCTestCase
@property DB *db;
@property NSString *email;

@end

@implementation SemNomeTroTests

- (void)setUp {
  self.db = [[DB alloc] init];
  self.email = @"email@teste.com";
  for (Atleta *a in [self.db todosAtletas])
    [self.db removeAtleta:a.email];
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testPerformanceExample {
  [self measureBlock:^{}];
}

-(void)testarAdicionarAtletaDuplicadoERemoverAtleta {
  // [self removeTodosAtletas];
  NSLog(@"%s", __FUNCTION__);
  unsigned long qtdAtletas = [[self.db todosAtletas] count];
  NSLog(@"qtdAtletas: %lu", qtdAtletas);

  XCTAssertFalse([self.db encontraAtleta:self.email], @"Atleta não deve existir");
  XCTAssertTrue([self.db adicionarAtleta:self.email nome:@"André do teste"
                                    foto:@"caminho/da/foto.jpg" peso:@80 altura:@1.85 sexo:@"M"],
                @"Atleta deve continuar não existindo");
  XCTAssertEqual(qtdAtletas+1, [[self.db todosAtletas] count],
                 @"Nenhum atleta deve ter sido adicionado a mais");
  XCTAssertTrue([self.db encontraAtleta:self.email], @"Atleta deve existir agora");

  XCTAssertFalse([self.db adicionarAtleta:self.email nome:@"André do teste"
                                     foto:@"caminho/da/foto.jpg" peso:@80 altura:@1.85 sexo:@"M"],
                 @"Atleta já deve existir e não deve ser possível adicionar mais um");
  NSLog(@"AQUI");
  XCTAssertEqual(qtdAtletas+1, [[self.db todosAtletas] count],
                 @"Nenhum atleta deve ter sido adicionado a mais");

  XCTAssertTrue([self.db removeAtleta:self.email], @"Atleta não pode ser removido");
  XCTAssertFalse([self.db encontraAtleta:self.email], @"Atleta deve existir agora");
  XCTAssertEqual(qtdAtletas, [[self.db todosAtletas] count],
                 @"Nenhum atleta deve ter sido adicionado a mais");
}

-(void)testarEncontrarTodosAtletas {
  NSString *email1 = @"email@teste1.com";
  NSString *email2 = @"email@teste2.com";
  NSString *email3 = @"email@teste3.com";

  XCTAssertEqual(0, [[self.db todosAtletas] count]);

  XCTAssertTrue([self.db adicionarAtleta:email1 nome:@"André do teste"
                                    foto:@"caminho/da/foto.jpg" peso:@80 altura:@1.85 sexo:@"M"],
                @"Atleta não pode ser adicionado.");
  XCTAssertTrue([self.db adicionarAtleta:email2 nome:@"André do teste"
                                    foto:@"caminho/da/foto.jpg" peso:@80 altura:@1.85 sexo:@"M"],
                @"Atleta não pode ser adicionado.");
  XCTAssertTrue([self.db adicionarAtleta:email3 nome:@"André do teste"
                                    foto:@"caminho/da/foto.jpg" peso:@80 altura:@1.85 sexo:@"M"],
                @"Atleta não pode ser adicionado.");
  XCTAssertEqual(3, [[self.db todosAtletas] count]);

  XCTAssertTrue([self.db removeAtleta:email1], @"Atleta não pode ser removido");
  XCTAssertTrue([self.db removeAtleta:email2], @"Atleta não pode ser removido");
  XCTAssertTrue([self.db removeAtleta:email3], @"Atleta não pode ser removido");
  XCTAssertEqual(0, [[self.db todosAtletas] count]);
}

-(void)removeTodosAtletas {
  NSString *email1 = @"email@teste1.com";
  NSString *email2 = @"email@teste2.com";
  NSString *email3 = @"email@teste3.com";

  XCTAssertEqual(0, [[self.db todosAtletas] count]);

  XCTAssertTrue([self.db adicionarAtleta:email1 nome:@"André do teste"
                                    foto:@"caminho/da/foto.jpg" peso:@80 altura:@1.85 sexo:@"M"],
                @"Atleta não pode ser adicionado.");
  XCTAssertTrue([self.db adicionarAtleta:email2 nome:@"André do teste"
                                    foto:@"caminho/da/foto.jpg" peso:@80 altura:@1.85 sexo:@"M"],
                @"Atleta não pode ser adicionado.");
  XCTAssertTrue([self.db adicionarAtleta:email3 nome:@"André do teste"
                                    foto:@"caminho/da/foto.jpg" peso:@80 altura:@1.85 sexo:@"M"],
                @"Atleta não pode ser adicionado.");
  XCTAssertEqual(3, [[self.db todosAtletas] count]);


  for (Atleta *a in [self.db todosAtletas])
    [self.db removeAtleta:a.email];

  XCTAssertEqual(0, [[self.db todosAtletas] count]);
}

-(void)testarAdicionarEEncontrarTemposDeAtleta {
  NSArray *inicios = @[[NSDate date], [NSDate date]];
  NSArray *paradas = @[[NSDate date], [NSDate date]];
  NSArray *voltas  = @[[NSDate date], [NSDate date]];

  XCTAssertEqual(0, [[self.db todosAtletas] count]);
  XCTAssert([self.db adicionarAtleta:self.email nome:@"Atleta com tempos"
                                foto:@"caminho/da/foto.jpg" peso:@100 altura:@2 sexo:@"F"]);
  XCTAssertEqual(0, [[self.db temposDoAtleta:self.email] count],
                 @"Não foi possível encontrar os tempos do atleta.");
  XCTAssert([self.db adicionarTempos:self.email dataDeInicio:[NSDate date] inicios:inicios
                             paradas:paradas voltas:voltas],
            @"Não foi possível adicionar os tempos.");
  XCTAssertEqual(1, [[self.db temposDoAtleta:self.email] count],
                 @"Não foi possível encontrar os tempos do atleta.");

  XCTAssert([self.db temposDoAtleta:self.email], @"Não foi possível encontrar os tempos do atleta.");

  XCTAssertTrue([self.db removeAtleta:self.email], @"Atleta não pode ser removido");
  XCTAssertEqual(0, [[self.db todosAtletas] count]);
  XCTAssertEqual(0, [[self.db temposDoAtleta:self.email] count],
                 @"Os tempos do atleta deletado continuam no banco.");


  // Checar se os tempos de um atleta re-adicionado existem
  XCTAssert([self.db adicionarAtleta:self.email nome:@"Atleta com tempos"
                                foto:@"caminho/da/foto.jpg" peso:@100 altura:@2 sexo:@"F"]);

  XCTAssertEqual(0, [[self.db temposDoAtleta:self.email] count],
                 @"Não foi possível encontrar os tempos do atleta.");
  XCTAssertTrue([self.db removeAtleta:self.email], @"Atleta não pode ser removido");
  XCTAssertEqual(0, [[self.db todosAtletas] count]);
}

-(void)testarAtualizarAtleta {
  NSString *emailDepois = @"email@depois.com";
  XCTAssertEqual(0, [[self.db todosAtletas] count]);
  XCTAssert([self.db adicionarAtleta:self.email nome:@"Nome antes"
                                foto:@"foto antes" peso:@1 altura:@2 sexo:@"M"]);

  Atleta *a = [self.db encontraAtleta:self.email];
  XCTAssertEqual(@"Nome antes", a.nome);
  XCTAssertEqual(@"foto antes", a.foto);
  XCTAssertEqual(@"M", a.sexo);
  XCTAssertEqualWithAccuracy([@1 floatValue], [a.peso   floatValue], 0.1);
  XCTAssertEqualWithAccuracy([@2 floatValue], [a.altura floatValue], 0.1);

  XCTAssert([self.db atualizarAtleta:self.email nome:@"Nome depois" foto:@"foto depois"
                                peso:@3 altura:@4 sexo:@"F"]);

  a = [self.db encontraAtleta:self.email];
  XCTAssertEqual(@"Nome depois", a.nome);
  XCTAssertEqual(@"foto depois", a.foto);
  XCTAssertEqual(@"F", a.sexo);
  XCTAssertEqualWithAccuracy([@3 floatValue], [a.peso   floatValue], 0.1);
  XCTAssertEqualWithAccuracy([@4 floatValue], [a.altura floatValue], 0.1);


  XCTAssert([self.db atualizarEmailDoAtleta:self.email emailNovo:emailDepois]);
  XCTAssertFalse([self.db encontraAtleta:self.email]);
  a = [self.db encontraAtleta:emailDepois];
  XCTAssertEqual(@"Nome depois", a.nome);
  XCTAssertEqual(@"foto depois", a.foto);
  XCTAssertEqual(@"F", a.sexo);
  XCTAssertEqualWithAccuracy([@3 floatValue], [a.peso   floatValue], 0.1);
  XCTAssertEqualWithAccuracy([@4 floatValue], [a.altura floatValue], 0.1);

  XCTAssertTrue([self.db removeAtleta:emailDepois], @"Atleta não pode ser removido");
  XCTAssertFalse([self.db encontraAtleta:emailDepois], @"Atleta deve existir agora");
  XCTAssertEqual(0, [[self.db todosAtletas] count],
                 @"Nenhum atleta deve ter sido adicionado a mais");
}

-(void)testarAtualizarVoltas {
  NSArray *inicios = @[[NSDate date], [NSDate date]];
  NSArray *paradas = @[[NSDate date], [NSDate date]];
  NSArray *voltas  = @[[NSDate date], [NSDate date]];

  XCTAssertEqual(0, [[self.db todosAtletas] count]);
  XCTAssert([self.db adicionarAtleta:self.email nome:@"Atleta com tempos"
                                foto:@"caminho/da/foto.jpg" peso:@100 altura:@2 sexo:@"F"]);
  XCTAssertEqual(0, [[self.db temposDoAtleta:self.email] count],
                 @"Não foi possível encontrar os tempos do atleta.");
  XCTAssert([self.db adicionarTempos:self.email dataDeInicio:[NSDate date] inicios:inicios
                             paradas:paradas voltas:voltas],
            @"Não foi possível adicionar os tempos.");
  XCTAssertEqual(1, [[self.db temposDoAtleta:self.email] count],
                 @"Não foi possível encontrar os tempos do atleta.");

  XCTAssert([self.db temposDoAtleta:self.email], @"Não foi possível encontrar os tempos do atleta.");

  Atleta *a = [self.db encontraAtleta:self.email];
  NSArray *temposAntes = [self.db temposDoAtleta:a.email];
  GrupoDeTemposOrdenados *g1 = temposAntes[0];
  sleep(1);

  NSArray *voltasAntes = g1.voltas;
  g1.voltas = @[[NSDate date], [NSDate date]];
  XCTAssert([self.db atualizaVoltas:g1]);

  NSArray *temposDepois = [self.db temposDoAtleta:a.email];
  GrupoDeTemposOrdenados *g2 = temposDepois[0];
  NSArray *voltasDepois = g2.voltas;

  for (int i = 0; i < [voltas count]; i++) {
    XCTAssertEqualObjects(voltas[i], voltasAntes[i]);
    XCTAssertNotEqualObjects(voltas[i], voltasDepois[i]);
  }
  XCTAssertTrue([self.db removeAtleta:self.email], @"Atleta não pode ser removido");
  XCTAssertEqual(0, [[self.db todosAtletas] count]);

  XCTAssertEqual(0, [[self.db temposDoAtleta:self.email] count], @"Os tempos do atleta deletado continuam no banco.");
}
// TODO: testar adicionar um grupoDeTempos duaz vezes
@end
