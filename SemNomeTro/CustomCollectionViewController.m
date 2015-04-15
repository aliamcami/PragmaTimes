//
//  CustomCollectionViewController.m
//  UltimoTeste
//
//  Created by camila oliveira on 4/9/15.
//  Copyright (c) 2015 camila oliveira. All rights reserved.
//

#import "CustomCollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "Chronometer.h"
#import "MyColorHolder.h"

#define MAX_QNT_CHRONOMETERS_PAGINA 8

@interface CustomCollectionViewController ()

@end

@implementation CustomCollectionViewController{
    CGSize chronometerSize;
    int workWidth;
    int workHeight;
    int qntColuna;
    NSArray *colors;
    NSMutableArray *usedCollors;
    int lastUsedColor;
    int tipoChronometro;
    NSIndexPath *originalIndexPathBeforeEditable;
    BOOL bagaca;
    
    
}


static int const minimunSpaceBetweenElements = 10;
static int const horizontalBorder = 10;
static int const verticalBorder = 14;
static float const alphaColor = 0.2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MyCell"];
    
    
    //temporariamente atribui a qnt total de chronometros na tela para que os calculos de tamanhos possam ser feitos
    self.qntChronometers = 2;
    
    //coloca em um array de cores todas as cores basicas dos cronometros
    colors = [self getPossibleColors];
    
    //inicializa o array de cores ja usada
    lastUsedColor = -1;
    usedCollors = [[NSMutableArray alloc]init];
    [self setColorsArray];
    
    //Seta os chronometros no array de chronometros
    [self setChronometersIntoArray];
}

#pragma  mark delAdd
-(void) deleteCellatIndexPath:(NSIndexPath*)indexPath{
    long int row = [indexPath row];
    [self.arrayChronometers[row] removeFromSuperview];
    [self.arrayChronometers removeObjectAtIndex:row];
    [usedCollors removeObjectAtIndex:row];
    self.qntChronometers--;
    NSArray *deleteItems = @[indexPath];
    [self.collectionView deleteItemsAtIndexPaths:deleteItems];
}

-(void) addNewCell{
    NSIndexPath *indexp = [NSIndexPath indexPathForItem:self.qntChronometers inSection:0];
    self.qntChronometers++;
    [self.arrayChronometers addObject:[self getNewChronometer]];
    [self addColorToUsedColorsArray];
    NSArray *indexes = [NSArray arrayWithObjects:indexp, nil];
    [self.collectionView insertItemsAtIndexPaths:indexes];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //calcula a quantidade de colunas necessarias para a apresentacao dos cronometros
    qntColuna = [self getQntColuna];
    
    //calcula o espaco disponivel para apresentar os cronometros
    workWidth = self.view.frame.size.width- horizontalBorder*2 - (qntColuna - 1)*minimunSpaceBetweenElements;
    workHeight = self.view.frame.size.height - verticalBorder*2 - MIN(ceil((((float)[self qntChronometers]/qntColuna))),MAX_QNT_CHRONOMETERS_PAGINA/2+1)*minimunSpaceBetweenElements;
    
    //calcula o tamanho de cada cronometro e seta na variavel chronometerSize
    [self calcChronometerSize];
    
    
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self qntChronometers];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    //coloca o crhonometro em cada celula
    Chronometer *chron = [[self arrayChronometers] objectAtIndex:indexPath.row];
    [cell addSubview:chron];
    
    //arredonda os cantos
    [cell.layer setCornerRadius:20];
    
    //atribui cor a celula
    MyColorHolder *color = [usedCollors objectAtIndex:indexPath.row];
    [cell setBackgroundColor:color.theColor];
    //    [cell.myCellView setBackgroundColor:color.theColor];
    
    //add geresture recognizer
    [self setGestureRecognizers:[self.arrayChronometers objectAtIndex:indexPath.row] atCell:cell];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Reajusta a ultima celulas
    CGSize novo = CGSizeMake(0, 0);
    long int count = indexPath.row+1;
    if (count == 1) {
        if ([self qntChronometers] > 3) {
            if ([self getQntColuna] == 3) {
                if (count % 3 == 2) {
                    novo = CGSizeMake(chronometerSize.width*2 + 10, chronometerSize.height);
                }else if ([self qntChronometers] % 3 == 1){
                    novo = CGSizeMake(chronometerSize.width*3 + 20, chronometerSize.height);
                }
            }else{
                if (count % 2 != 0) {
                    novo = CGSizeMake(chronometerSize.width*2 + 10, chronometerSize.height);
                }
                
            }
        }
    }
    CGSize paraAtribuir = novo.height == 0? chronometerSize : novo;
    
    

        CGRect rect = CGRectMake(0, 0, paraAtribuir.width, paraAtribuir.height);
        Chronometer *chron = [[self arrayChronometers]objectAtIndex:indexPath.row];
        [chron resizeCronometer:rect andFocus:tipoChronometro];
        [chron setNeedsDisplay];
    
    
    
    return paraAtribuir;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 
 
 
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 
 
 
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 NSLog(@"action");
	return YES;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	NSLog(@"SELEC");
 }
 */


#pragma mark - Cronometros Instancias

-(void)setChronometersIntoArray{
    
    //Instancia os cronometros de acordo com a quantidade existente
    self.arrayChronometers = [[NSMutableArray alloc]init];
    for (int i = 0; i < [self qntChronometers]; i++) {
        [[self arrayChronometers] addObject:[self getNewChronometer]];
        
    }
}
-(Chronometer*)getNewChronometer {
    Chronometer *chron =[[Chronometer alloc] init];
    chron.backgroundColor = [UIColor clearColor];
    return chron;
}

#pragma mark Ajuste de Tamanho dos Cronometros

-(void)chronometroEditableAtIndex:(NSIndexPath*)indexPath{
    NSLog(@"editable");
    [self.collectionView performBatchUpdates:^{
        if (originalIndexPathBeforeEditable != nil) {
            [self returnChronometersToOriginalLocationsFromEditableUI];
        }
        originalIndexPathBeforeEditable = indexPath;
        
        Chronometer *cTemp = [self.arrayChronometers objectAtIndex:indexPath.row];
        MyColorHolder *colorTemp = [usedCollors objectAtIndex:indexPath.row];
        
        [self.arrayChronometers removeObjectAtIndex:indexPath.row];
        [usedCollors removeObjectAtIndex:indexPath.row];
        
        [self.arrayChronometers insertObject:cTemp atIndex:0];
        [usedCollors insertObject:colorTemp atIndex:0];
        
        //    [self.collectionView reloadData];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    } completion:^(BOOL finished) {}];
}
-(void)returnChronometersToOriginalLocationsFromEditableUI{
    NSLog(@"return");
    Chronometer *cTemp = [self.arrayChronometers objectAtIndex:0];
    [self.arrayChronometers removeObjectAtIndex:0];
    [self.arrayChronometers insertObject:cTemp atIndex:originalIndexPathBeforeEditable.row];
    originalIndexPathBeforeEditable = nil;

}

- (void)calcChronometerSize{
    //set tamanho dos cronometros dependendo da quantidade de cronometros
    int altura;
    switch ([self qntChronometers]) {
        case 1:
            chronometerSize = CGSizeMake(workWidth, workHeight);
            tipoChronometro = CRONOMETRO_COMPLETO;
            break;
        case 2:
        case 3:
            chronometerSize = CGSizeMake(workWidth, workHeight/[self qntChronometers]);
            tipoChronometro = CRONOMETRO_INTERMEDIARIO;
            break;
        default:
            tipoChronometro = CRONOMETRO_BASE;
            altura =[self getChronometerHeight];
            chronometerSize = CGSizeMake(workWidth/qntColuna, altura);
            
    }
    
}

-(int) getChronometerHeight{
    
    //calcula altura dos cronometros dependendo da quantidade de cronometros
    if ([self qntChronometers] > MAX_QNT_CHRONOMETERS_PAGINA) {
        return (workHeight)/(int)ceil((float)MAX_QNT_CHRONOMETERS_PAGINA/qntColuna);
    }
    return (workHeight)/(int)ceil((float)[self qntChronometers]/qntColuna);
    
}
-(int)getQntColuna{
    if ([self isTresColunas]) {
        return 3;
    }else{
        if ([self qntChronometers] <= 3) {
            return 1;
        }
        return 2;
    }
}
-(BOOL)isTresColunas{
    int qntMaximaDeCronometrosParaPassarParaTresColunas = 35;
    if ([self qntChronometers] > qntMaximaDeCronometrosParaPassarParaTresColunas) {
        return YES;
    }
    return NO;
}


#pragma mark Tudo sobre Cores


-(NSArray*)getPossibleColors{
    return [[NSMutableArray alloc]initWithObjects:
            COR_AZUL,
            COR_VERMELHO,
            COR_VERDE,
            COR_LARANJA,
            COR_AMARELO,
            nil];
}


-(void)setColorsArray{
    //retorna uma cor diferente toda vez
    //    usedCollors = [[NSMutableArray alloc]init];
    int count = -1;
    int alphaMult = 0;
    for (int i = 0; i < [self qntChronometers]; i++) {
        MyColorHolder *color = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
        CGFloat r, g, b, alpha;
        [color.theColor getRed:&r green:&g blue:&b alpha:&alpha];
        if (count == MAX_QNT_CORES_DISPONIVEIS) {
            count = -1;
            alphaMult++;
            if ( (alphaColor*alphaMult) > 0.6) {
                alphaMult = 0;
            }
        }
        count++;
        color.theColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha-alphaColor*alphaMult];
        
        [usedCollors addObject:color];
    }
    //    usedCollors = [[NSMutableArray alloc] initWithArray:[usedCollorsUnicas allObjects]];
    
}
-(void)addColorToUsedColorsArray{
    //deveria pegar a proxima cor
    MyColorHolder *colorPura = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
    if ([[usedCollors lastObject]isEqual: colorPura]) {
        colorPura = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
    }
    
    CGFloat r, g, b, alpha;
    [colorPura.theColor getRed:&r green:&g blue:&b alpha:&alpha];
    
    int alphaMult = floor((float)[usedCollors count]/MAX_QNT_CORES_DISPONIVEIS);
    
    while ( (alphaColor*alphaMult) > 0.6) {
        alphaMult = alphaMult%3 ;
    }
    
    colorPura.theColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha- (alphaColor*alphaMult)];
    
    [usedCollors addObject:colorPura];
}
-(int)getNextColorIndex{
    MyColorHolder *last = [usedCollors lastObject];
    long int lastColorIndex = [usedCollors indexOfObject:last];
    if (lastColorIndex == MAX_QNT_CORES_DISPONIVEIS-1) {
        return 0;
    }
    return (int)lastColorIndex + 1;
}


//retorna a proxima cor original a ser usada
-(UIColor*)getOriginalColor{
    lastUsedColor++;
    if (lastUsedColor == [colors count]) {
        lastUsedColor = 0;
    }
    return [colors objectAtIndex:lastUsedColor];
}


#pragma mark GestureRecognizer
-(void)setGestureRecognizers:(Chronometer*)chron atCell:(CustomCollectionViewCell*)cell {
    
    
//    //Um clique em cima do cronometro
        UITapGestureRecognizer *playStop = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(play_pauseChronometer)];
    
//    //dois cliques em cima do cronometro
        UITapGestureRecognizer *lapMark = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(lapChronometer)];
//        [playStop requireGestureRecognizerToFail:lapMark]; //da um delay grande no pause
        lapMark.numberOfTapsRequired = 1;
        lapMark.numberOfTouchesRequired = 2;
    
//    //inicia o tempo de descanso
        UITapGestureRecognizer *restTime = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(restChronometer)];
        [chron editRestTime:5];
    [lapMark requireGestureRecognizerToFail:restTime];
        restTime.numberOfTouchesRequired = 2;
        restTime.numberOfTapsRequired = 2;
    
//    //temporariamente adiciona cronometro
        UISwipeGestureRecognizer *addChron= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(addNewCell)];
    
    //    UISwipeGestureRecognizer *deleteChron = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(deleteCellatIndexPath:)];
    
    
        [cell addGestureRecognizer:playStop];
        [cell addGestureRecognizer:lapMark];
        [cell addGestureRecognizer:restTime];
        [cell addGestureRecognizer: addChron];
    //    [cell addGestureRecognizer: deleteChron];
    
}

@end
