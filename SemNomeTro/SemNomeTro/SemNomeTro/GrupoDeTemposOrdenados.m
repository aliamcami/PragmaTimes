#import "GrupoDeTemposOrdenados.h"

NSArray* ordenaDatas(NSArray *arr) {
  NSLog(@"Arr: %@", arr);
  return  [arr sortedArrayUsingComparator:^(id obj1, id obj2) {
    return [obj1 compare:obj2];
  }];
}

@implementation GrupoDeTemposOrdenados

- (instancetype)initComGrupoDeTempos:(GrupoDeTempos *)tempos{
  self = [super init];
  if (self) {
    _dataDeInicio = tempos.dataDeInicio;
    _atleta = tempos.atleta;

    NSMutableArray *datas;

    datas = [[NSMutableArray alloc] init];
    for (Inicio *inicio in [tempos.inicios allObjects])
      [datas addObject:inicio.tempo];
    _inicios = ordenaDatas(datas);

    datas = [[NSMutableArray alloc] init];
    for (Parada *parada in [tempos.paradas allObjects])
      [datas addObject:parada.tempo];
    _paradas = ordenaDatas(datas);

    datas = [[NSMutableArray alloc] init];
    for (Volta *volta in [tempos.voltas allObjects])
      [datas addObject:volta.tempo];
    _voltas = ordenaDatas(datas);
  }
  return self;
}

@end
