#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DadosLocais_DataBase.h"

#define DB DadosLocais_DataBase *db = [[DadosLocais_DataBase alloc] init];

@interface SemNomeTroTests : XCTestCase

@end

@implementation SemNomeTroTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
  // This is an example of a functional test case.
  XCTAssert(YES, @"Pass");
//  XCTAssert(NO, @"Fail");
  
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testarGravacaoERecuperacaoDeAtleta {
  DB
  [db adicionarAtleta:@"André" email:@"andremiramor@gmail.com" foto:@"" peso:80.0 altura:1.85 sexo:@"M"];
  NSDictionary *atletaAndreEsperado = @{@"nome": @"André",
                                        @"foto": @"",
                                        @"peso": @80.0,
                                        @"altura": @1.85,
                                        @"sexo": @"M"};
  XCTAssertEqualObjects(atletaAndreEsperado, [db recuperarAtleta:@"andremiramor@gmail.com"]);
}

- (void)testarGravarAtletaDuplicado {
  DB
  [db adicionarAtleta:@"Camila" email:@"aliamcamil@gmail.com" foto:@"" peso:80.0 altura:1.85 sexo:@"F"];
  [db adicionarAtleta:@"Camila2" email:@"aliamcamil@gmail.com" foto:@"" peso:80.0 altura:1.85 sexo:@"F"];

  NSDictionary *atletaCamilaEsperada = @{@"nome": @"Camila", // e não @"Camila2"
                                         @"foto": @"",
                                         @"peso": @80.0,
                                         @"altura": @1.85,
                                         @"sexo": @"F"};
  XCTAssertEqualObjects(atletaCamilaEsperada, [db recuperarAtleta:@"aliamcamil@gmail.com"]);
}

- (void)testarAdicionarERemoverAtleta {
  DB
  [db adicionarAtleta:@"André" email:@"andrecabeludo@hotmail.com" foto:@"" peso:80.0 altura:1.85 sexo:@"M"];
  
  NSDictionary *atletaAndreEsperado = @{@"nome": @"André",
                                        @"foto": @"",
                                        @"peso": @80.0,
                                        @"altura": @1.85,
                                        @"sexo": @"M"};
  
  XCTAssertEqualObjects(atletaAndreEsperado, [db recuperarAtleta:@"andrecabeludo@hotmail.com"]);
  
  [db removerAtleta:@"andrecabeludo@hotmail.com"];
  XCTAssertNil([db recuperarAtleta:@"andrecabeludo@hotmail.com"]);
}

@end

