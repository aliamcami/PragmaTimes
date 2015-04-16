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

@interface CustomCollectionViewController ()
@property (nonatomic) NSMutableArray *arrayChronometers;

//configuracoes
//quantidade de chronometros que estao sendo mostrados
@property (nonatomic) int configQntChronometers;
//quantidade de colunas que os chronometros serão divididos
@property (nonatomic) int configQntColunas;
//Quantidade maxima de chronometros exibidos por pagina
@property (nonatomic) int configMaxChronometerPerPage;
//qual será a celula a ser redimencionada caso haja espaço
@property (nonatomic) int configCelulaGrande;
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
    
}

//constantes
static int const minimunSpaceBetweenElements = 10;
static int const horizontalBorder = 10;
static int const verticalBorder = 15;
static float const diferenceForAlphaColor = 0.2;

#pragma mark Configuracoes
-(void)configCelulaGrande:(int)celulaGrande {
    self.configCelulaGrande = celulaGrande;
}
-(void)configQuantidadeColunas:(int)qntColunas{
    self.configQntColunas = qntColunas;
}
-(void)configMaxCronometrosPorPagina:(int)qntCronometroPagina{
    self.configMaxChronometerPerPage = qntCronometroPagina;
}
-(void)configQntCronometrosIniciais:(int)qntCronometrosIniciais{
    self.configQntChronometers = qntCronometrosIniciais;
}


#pragma mark principais
- (void)viewDidLoad {
    [super viewDidLoad];
    //temporariamente atribui a qnt total de chronometros na tela para que os calculos de tamanhos possam ser feitos
    self.configQntChronometers= 2;
    self.configQntColunas = 2 ;
    self.configMaxChronometerPerPage = 8;
    self.configCelulaGrande = CONFIG_NENHUMA_CELULA_DESTAQUE;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MyCell"];
    
    //coloca em um array de cores todas as cores basicas que poderão ser usada nos cronometros
    colors = [self getPossibleColors];
    
    //inicializa o array de cores para marcar as ja usadas
    //usedCollors = [[NSMutableArray alloc]init];
    lastUsedColor = -1;
    [self setColorsArray];
    
    //Seta os chronometros no array de chronometros
    [self setChronometersIntoArray];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self configQntChronometers];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
//removendo as subviews lixo das celulas
    for (UIView *v in cell.subviews) {
        [v removeFromSuperview];
    }
    
//    //coloca o crhonometro em cada celula
    Chronometer *chron = [[self arrayChronometers] objectAtIndex:indexPath.row];
    [cell addSubview:chron];
    
    //arredonda os cantos da celula
    [cell.layer setCornerRadius:20];

    //atribui cor a celula
    MyColorHolder *color = [usedCollors objectAtIndex:indexPath.row];
    [cell setBackgroundColor:color.theColor];
    
    //add geresture recognizer para cada uma das celulas
    [self setGestureRecognizers:[self.arrayChronometers objectAtIndex:indexPath.row] atCell:cell];
    
    //retorna a celula ja com um chronometro em cada e cor de background
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    //calcula a quantidade de colunas necessarias para a apresentacao dos cronometros
    qntColuna = [self getQntColuna];
    
    //calcula o espaco disponivel para apresentar os cronometros já descontando o espado de bordas
    [self ajusteDoEpacoDeApresentacaoWidth:self.view.frame.size.width andHeight: self.view.frame.size.height];
    
    //calcula o tamanho de cada cronometro e seta na variavel chronometerSize
    [self calcChronometerSize];
    
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    //Reajusta a celula destaque
    CGSize novo = CGSizeMake(0, 0);
    if (self.configCelulaGrande != CONFIG_NENHUMA_CELULA_DESTAQUE) {
        long int count = indexPath.row+1;
        if (count == 1 & [self configQntChronometers] > 3) {
            if ([self configQntChronometers] > 3) {
                if ([self getQntColuna] == 3) {
                    if (count % 3 == 2) {
                        novo = CGSizeMake(chronometerSize.width*2 + 10, chronometerSize.height);
                    }else if ([self configQntChronometers] % 3 == 1){
                        novo = CGSizeMake(chronometerSize.width*3 + 20, chronometerSize.height);
                    }
                }else{
                    if ([self configQntChronometers] % 2 != 0) {
                        novo = CGSizeMake(chronometerSize.width*2 + 10, chronometerSize.height);
                    }
                    
                }
            }
        }
        
    }
    
    //identifica se o tamanho desta celula foi alterado
    CGSize paraAtribuir = novo.height == 0? chronometerSize : novo;
    
    //configura o tamanho de cada chronometro
    CGRect rect = CGRectMake(0, 0, paraAtribuir.width, paraAtribuir.height);
    [[[self arrayChronometers]objectAtIndex:indexPath.row] resizeCronometer:rect andFocus:tipoChronometro];
    
    //retorna o tamanho da celula... que é o mesmo do cronometro
    return paraAtribuir;
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



//#pragma mark <UICollectionViewDelegate>

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
    for (int i = 0; i < [self configQntChronometers]; i++) {
        [[self arrayChronometers] addObject:[self getNewChronometer]];
        
    }
}
-(Chronometer*)getNewChronometer {
    Chronometer *chron =[[Chronometer alloc] init];
    chron.backgroundColor = [UIColor clearColor];
    return chron;
}


#pragma mark todos os calculos de ajuste de tamanho
-(void)ajusteDoEpacoDeApresentacaoWidth:(int)width andHeight:(int)height{
    workWidth = width - horizontalBorder*2 - (qntColuna - 1)*minimunSpaceBetweenElements;
    workHeight = height - verticalBorder*2 - MIN(ceil((((float)[self configQntChronometers]/qntColuna))),self.configMaxChronometerPerPage/2+1)*minimunSpaceBetweenElements;
}

- (void)calcChronometerSize{
    //set tamanho dos cronometros dependendo da quantidade de cronometros
    int altura;
    switch ([self configQntChronometers]) {
        case 1:
            chronometerSize = CGSizeMake(workWidth, workHeight);
            tipoChronometro = CRONOMETRO_COMPLETO;
            break;
        case 2:
            chronometerSize = CGSizeMake(workWidth, workHeight/[self configQntChronometers]);
            tipoChronometro = CRONOMETRO_INTERMEDIARIO;
            break;
        case 3:
            chronometerSize = CGSizeMake(workWidth, workHeight/[self configQntChronometers]);
            tipoChronometro = CRONOMETRO_BASE;
            break;
        default:
            tipoChronometro = CRONOMETRO_BASE;
            altura =[self getChronometerHeight];
            chronometerSize = CGSizeMake(workWidth/qntColuna, altura);
    }
    
}

-(int) getChronometerHeight{
    
    //calcula altura dos cronometros dependendo da quantidade de cronometros
    if ([self configQntChronometers] > self.configMaxChronometerPerPage) {
        return (workHeight)/(int)ceil((float)self.configMaxChronometerPerPage/qntColuna);
    }
    return (workHeight)/(int)ceil((float)[self configQntChronometers]/qntColuna);
    
}
-(int)getQntColuna{
    if (self.configQntChronometers < 3) {
        return 1;
    }
    return self.configQntColunas;
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
    //inicializa o array de cores
    usedCollors = [[NSMutableArray alloc]init];
    int count = -1;
    int alphaMult = 0;
    
    //seta todas as cores que serão usadas dentro do array, tomando o cuidado para mudar o alpha em clicos
    for (int i = 0; i < [self configQntChronometers]; i++) {
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
        
        [usedCollors addObject:color];
    }
    
}
-(void)addColorToUsedColorsArray{
    //adiciona uma cor ao array de cores, segue o clico de cores
    MyColorHolder *colorPura = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
    if ([[usedCollors lastObject]isEqual: colorPura]) {
        colorPura = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
    }
    
    CGFloat r, g, b, alpha;
    [colorPura.theColor getRed:&r green:&g blue:&b alpha:&alpha];
    
    int alphaMult = floor((float)[usedCollors count]/MAX_QNT_CORES_DISPONIVEIS);
    
    while ( (diferenceForAlphaColor*alphaMult) > 0.6) {
        alphaMult = alphaMult%3 ;
    }
    
    colorPura.theColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha- (diferenceForAlphaColor*alphaMult)];
    
    [usedCollors addObject:colorPura];
}

-(int)getNextColorIndex{
    //idenficia qual o proxima cor a ser usada
    MyColorHolder *last = [usedCollors lastObject];
    long int lastColorIndex = [usedCollors indexOfObject:last];
    if (lastColorIndex == MAX_QNT_CORES_DISPONIVEIS-1) {
        return 0;
    }
    return (int)lastColorIndex + 1;
}

-(UIColor*)getOriginalColor{
    //retorna a proxima cor do ciclo de cores
    lastUsedColor++; //mantem track de qual local no ciclo de cores está
    if (lastUsedColor == [colors count]) {
        lastUsedColor = 0;
    }
    return [colors objectAtIndex:lastUsedColor];
}


#pragma mark GestureRecognizer
-(void)setGestureRecognizers:(Chronometer*)chron atCell:(CustomCollectionViewCell*)cell {
    
//    //Um clique em cima do cronometro
        UITapGestureRecognizer *playStop = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(play_pauseChronometer)];
    
//    //um clique com dois dedos... por enquanto
        UITapGestureRecognizer *lapMark = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(lapChronometer)];
//        [playStop requireGestureRecognizerToFail:lapMark]; //da um delay grande no pause
        lapMark.numberOfTapsRequired = 1;
        lapMark.numberOfTouchesRequired = 2;
    
//    //inicia o tempo de descanso, dois cliques com um dedo
        UITapGestureRecognizer *restTime = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(restChronometer)];
        [chron editRestTime:5];
        restTime.numberOfTouchesRequired = 1;
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


#pragma  mark Add/Del
-(void) deleteCellatIndexPath:(NSIndexPath*)indexPath{
    long int row = [indexPath row]; //locla da celula a ser deletada
    [self.arrayChronometers[row] removeFromSuperview]; //remove da superview
    [self.arrayChronometers[row] removeFromSuperview]; //remove de novo para garantir
    [self.arrayChronometers removeObjectAtIndex:row]; //remove do array
    [usedCollors removeObjectAtIndex:row]; //remove a cor do array de cores
    self.configQntChronometers--; //decrementa a contagem de cronometros
    NSArray *deleteItems = @[indexPath];
    [self.collectionView deleteItemsAtIndexPaths:deleteItems]; //deleta da collection
}

-(void) addNewCell{
    NSIndexPath *indexp = [NSIndexPath indexPathForItem:self.configQntChronometers inSection:0];
    self.configQntChronometers++; //incrementa contador de cronometros
    [self.arrayChronometers addObject:[self getNewChronometer]]; //adiciona um cronometro no array
    [self addColorToUsedColorsArray]; //adiciona uma cor no array de cores
    NSArray *indexes = [NSArray arrayWithObjects:indexp, nil];
    [self.collectionView insertItemsAtIndexPaths:indexes];
}


@end
