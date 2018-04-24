//
//  DeleteCollectionView.h
//  UltimoTeste
//
//  Created by camila oliveira on 4/22/15.
//  Copyright (c) 2015 camila oliveira. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DeleteCollectionView : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//quantidade de colunas que os chronometros serão divididos
@property (nonatomic) int configQntColunas;
//Quantidade maxima de chronometros exibidos por pagina
@property (nonatomic) int configMaxChronometerPerPage;
//qual será a celula a ser redimencionada caso haja espaço
@property (nonatomic) int configCelulaGrande;



@end
