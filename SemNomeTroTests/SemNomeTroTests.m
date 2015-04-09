#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DadosLocais_DataBase.h"

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
  DadosLocais_DataBase *db = [[DadosLocais_DataBase alloc] init];
  [db adicionarAtleta:@"André" email:@"andremiramor@gmail.com" foto:@"" peso:80.0 altura:1.85 sexo:@"M"];
  
  NSDictionary *atletaAndre = [db recuperarAtleta:@"andremiramor@gmail.com"];
  
  NSDictionary *atletaAndreEsperado = @{@"nome": @"André",
                                        @"foto": @"",
                                        @"peso": @80.0,
                                        @"altura": @1.85,
                                        @"sexo": @"M"};
  NSLog(@"%@", atletaAndre);
  NSLog(@"%@", atletaAndreEsperado);

  XCTAssertEqualObjects(atletaAndre, atletaAndreEsperado);
}

@end

