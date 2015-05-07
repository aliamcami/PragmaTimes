//
//  SingletonData.m
//  UltimoTeste
//
//  Created by camila oliveira on 4/17/15.
//  Copyright (c) 2015 camila oliveira. All rights reserved.
//


#import "SingletonData.h"
#import "MyColorHolder.h"
@implementation SingletonData
    static SingletonData *shared = nil;

    static float const diferenceForAlphaColor = 0.2;
    static int const qntInicialBasicaCronometros = 1;
    

+(SingletonData*)sharedSingleton{
    static SingletonData *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        data = [[SingletonData alloc] init];
    });
    return data;
}

- (id)init {
    NSLog(@"sing init");
    if (shared == nil) {
        NSLog(@"sing realInit");
        self.lastUsedColor = -1;
        self.arrayChronometers = [self createNewChronometers];
        self.colors = [self createPossibleColors];
        self.arrayColors = [self createColorsArray];
    }else{
        return shared;
    }
    return self;
}


- (NSMutableArray*)createNewChronometers{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < qntInicialBasicaCronometros; i++) {
        [array addObject:[[Chronometer alloc]init]];
    }
    return array;
}
-(NSArray*)createPossibleColors{
    return [[NSMutableArray alloc]initWithObjects:
            COR_AZUL,
            COR_VERMELHO,
            COR_VERDE,
            COR_LARANJA,
            COR_AMARELO,
            nil];
}

-(UIColor*)getOriginalColor{
    //retorna a proxima cor do ciclo de cores
    self.lastUsedColor++; //mantem track de qual local no ciclo de cores está
    if (self.lastUsedColor == [self.colors count]) {
        self.lastUsedColor = 0;
    }
    return [self.colors objectAtIndex:self.lastUsedColor];
}
-(NSMutableArray*)createColorsArray{
    //retorna uma cor diferente toda vez
    //inicializa o array de cores
    NSMutableArray *cores = [[NSMutableArray alloc]init];
    cores = [[NSMutableArray alloc]init];
    int count = -1;
    int alphaMult = 0;
    
    //seta todas as cores que serão usadas dentro do array, tomando o cuidado para mudar o alpha em clicos
    for (int i = 0; i < qntInicialBasicaCronometros; i++) {
        MyColorHolder *color = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
        CGFloat r, g, b, alpha;
        [color.theColor getRed:&r green:&g blue:&b alpha:&alpha];
        if (count == MAX_QNT_CORES_DISPONIVEIS) {
            count = -1;
            alphaMult++;
            if ( (diferenceForAlphaColor*alphaMult) > 0.6) {
                alphaMult = 0;
            }
        }
        count++;
        color.theColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha-diferenceForAlphaColor*alphaMult];
        
        [cores addObject:color];
    }
    return cores;
}
#pragma  mark Add/Del
-(void) deleteCellatIndexPath:(NSIndexPath*)indexPath forCollectionView:(UICollectionView*)collectionView{
    long int row = [indexPath row]; //locla da celula a ser deletada
    [[shared arrayChronometers][row] removeFromSuperview]; //remove da superview
    [[shared arrayChronometers][row] removeFromSuperview]; //remove de novo para garantir
    [[shared arrayChronometers] removeObjectAtIndex:row]; //remove do array
    [[shared arrayColors] removeObjectAtIndex:row]; //remove a cor do array de cores
    NSArray *deleteItems = @[indexPath];
    [collectionView deleteItemsAtIndexPaths:deleteItems]; //deleta da collection
}

-(void) addNewCellForCollectionView:(UICollectionView*)collectionView{
    NSIndexPath *indexp = [NSIndexPath
                           indexPathForItem:[[shared arrayChronometers]count]
                           inSection:0];
    [[self arrayChronometers]addObject:[self getNewChronometer]]; //adiciona um cronometro no array
    [self addColorToUsedColorsArray]; //adiciona uma cor no array de cores
    NSArray *indexes = [NSArray arrayWithObjects:indexp, nil];
    [collectionView insertItemsAtIndexPaths:indexes];
    [collectionView scrollToItemAtIndexPath:indexp atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}
-(Chronometer*)getNewChronometer {
    Chronometer *chron =[[Chronometer alloc] init];
    chron.backgroundColor = [UIColor clearColor];
    return chron;
}
-(void)addColorToUsedColorsArray{
    //adiciona uma cor ao array de cores, segue o clico de cores
    MyColorHolder *colorPura = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
    if ([[[shared arrayColors] lastObject]isEqual: colorPura]) {
        colorPura = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
    }
    
    CGFloat r, g, b, alpha;
    [colorPura.theColor getRed:&r green:&g blue:&b alpha:&alpha];
    
    int alphaMult = floor((float)[[shared arrayColors] count]/MAX_QNT_CORES_DISPONIVEIS);
    
    while ( (diferenceForAlphaColor*alphaMult) > 0.6) {
        alphaMult = alphaMult%3 ;
    }
    
    colorPura.theColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha- (diferenceForAlphaColor*alphaMult)];
    
    [[shared arrayColors] addObject:colorPura];
}

@end
