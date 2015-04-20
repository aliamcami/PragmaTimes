//
//  SecondViewController.m
//  UltimoTeste
//
//  Created by camila oliveira on 4/17/15.
//  Copyright (c) 2015 camila oliveira. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomCollectionViewCell.h"
#import "Chronometer.h"
#import "MyColorHolder.h"
#import "SingletonData.h"

@interface SecondViewController ()
@property (nonatomic)SingletonData *shared;
@end

@implementation SecondViewController{
    CGSize chronometerSize;
    int workWidth;
    int workHeight;
    int lastUsedColor;
    int tipoChronometro;
    int qntChronometros;
}

//constantes
static int const qntColuna = 4;
static int const minimunSpaceBetweenElements = 10;
static int const horizontalBorder = 10;
static int const verticalBorder = 7;
static float const diferenceForAlphaColor = 0.2;

#pragma mark principais
- (void)viewDidLoad {
    [super viewDidLoad];
    self.shared = [SingletonData sharedSingleton];
    qntChronometros = ((int)[self.shared.arrayChronometers count]) -1 ;
   
    
   
    
    // COR DOS BUTOES DA NAVIGATION
//    [[[self navigationController] navigationBar] setTintColor:[UIColor redColor]];
    
    
//    [[[self.shared arrayChronometers]objectAtIndex:self.shared.mainChronIndex] resizeCronometer:rect andFocus:CRONOMETRO_COMPLETO];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"camiCell"];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MyColorHolder *color = [[self.shared arrayColors] objectAtIndex:self.shared.mainChronIndex];
    Chronometer *chron = [[self.shared arrayChronometers] objectAtIndex:self.shared.mainChronIndex];
    CGRect rect = CGRectMake(0, 0, self.mainChronView.frame.size.width, self.mainChronView.frame.size.height);
    [chron resizeCronometer:rect andFocus:CRONOMETRO_INTERMEDIARIO];

    [self setGestureRecognizers:chron atCell:self.mainChronView];
    
    [self.mainChronView addSubview:chron];
    [self.mainChronView setBackgroundColor: color.theColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = color.theColor;

    //muda cor da navigation bar
    //    [[[self navigationController] navigationBar] setTranslucent:YES];
//    [[[self navigationController] navigationBar] setBarTintColor:color.theColor];
    
    return qntChronometros;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"camiCell" forIndexPath:indexPath];
    
    
    if ((int)indexPath.row >= self.shared.mainChronIndex) {
        indexPath = [NSIndexPath  indexPathForRow:indexPath.row+1 inSection:0];
    }
    
    //removendo as subviews lixo das celulas
    for (UIView *v in cell.subviews) {
        [v removeFromSuperview];
    }
    
   
    MyColorHolder *color = [[self.shared arrayColors] objectAtIndex:indexPath.row];
    Chronometer *chron = self.shared.arrayChronometers[indexPath.row];
    
    [cell addSubview:chron];
    [cell setBackgroundColor:color.theColor];
    
    
    //arredonda os cantos da celula
    [cell.layer setCornerRadius:12];
    cell.clipsToBounds = NO;
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shadowOffset = CGSizeMake(0,3);
    cell.layer.shadowOpacity = 0.4f;
    
    
    //add geresture recognizer para cada uma das celulas
    [self setGestureRecognizers:chron atCell:cell];
    
    //retorna a celula ja com um chronometro em cada e cor de background
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    //calcula o espaco disponivel para apresentar os cronometros já descontando o espado de bordas
    [self ajusteDoEpacoDeApresentacaoWidth:self.collectionView.frame.size.width andHeight: self.collectionView.frame.size.height];
    
    //calcula o tamanho de cada cronometro e seta na variavel chronometerSize
    [self calcChronometerSize];
    
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((int)indexPath.row >= self.shared.mainChronIndex) {
        indexPath = [NSIndexPath  indexPathForRow:indexPath.row+1 inSection:0];
    }
    //configura o tamanho de cada chronometro
    CGRect rect = CGRectMake(0, 0, chronometerSize.width, chronometerSize.height);
    [[[self.shared arrayChronometers]objectAtIndex:indexPath.row] resizeCronometer:rect andFocus:tipoChronometro];
    //retorna o tamanho da celula... que é o mesmo do cronometro
    return chronometerSize;
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

-(Chronometer*)getNewChronometer {
    Chronometer *chron =[[Chronometer alloc] init];
    chron.backgroundColor = [UIColor clearColor];
    return chron;
}


#pragma mark todos os calculos de ajuste de tamanho
-(void)ajusteDoEpacoDeApresentacaoWidth:(int)width andHeight:(int)height{
    workWidth = width - horizontalBorder*2 -
    MIN(qntColuna, (ceil(((float)qntChronometros)) - 1))*minimunSpaceBetweenElements;
    workHeight = height - verticalBorder*2 - 2*minimunSpaceBetweenElements;
}

- (void)calcChronometerSize{
    //set tamanho dos cronometros dependendo da quantidade de cronometros
    int largura;
    switch (qntChronometros) {
        case 1:
            chronometerSize = CGSizeMake(workWidth, workHeight);
            tipoChronometro = CRONOMETRO_COMPLETO;
            break;
        case 2:
            chronometerSize = CGSizeMake((workWidth-5)/qntChronometros, workHeight);
            tipoChronometro = CRONOMETRO_INTERMEDIARIO;
            break;
//        case 3:
//            //nao sei porque.. mas o -10 eh importante
//            chronometerSize = CGSizeMake(workWidth, (workHeight - 10)/[[self.shared arrayChronometers]count]);
//            tipoChronometro = CRONOMETRO_BASE;
            break;
        default:
            tipoChronometro = CRONOMETRO_BASE;
            largura = [self getChronometerWidth];
            if (qntChronometros <= qntColuna) {
                chronometerSize = CGSizeMake(largura, workHeight);
            }else{
                chronometerSize = CGSizeMake(largura, (workHeight/2)+2);
            }
    }
    
}

-(int) getChronometerWidth{
    //calcula largura dos cronometros dependendo da quantidade de cronometros
    if (qntChronometros <= qntColuna) {
        return workWidth / qntChronometros;
    }else if (qntChronometros < 8){
        return workWidth / ceil(qntChronometros / 2.0);
    }
    return workWidth / qntColuna;
    
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

-(void)addColorToUsedColorsArray{
    //adiciona uma cor ao array de cores, segue o clico de cores
    MyColorHolder *colorPura = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
    if ([[[self.shared arrayColors] lastObject]isEqual: colorPura]) {
        colorPura = [[MyColorHolder alloc]initWithColor:[self getOriginalColor]];
    }
    
    CGFloat r, g, b, alpha;
    [colorPura.theColor getRed:&r green:&g blue:&b alpha:&alpha];
    
    int alphaMult = floor((float)[[self.shared arrayColors] count]/MAX_QNT_CORES_DISPONIVEIS);
    
    while ( (diferenceForAlphaColor*alphaMult) > 0.6) {
        alphaMult = alphaMult%3 ;
    }
    
    colorPura.theColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha- (diferenceForAlphaColor*alphaMult)];
    
    [[self.shared arrayColors] addObject:colorPura];
}

-(int)getNextColorIndex{
    //idenficia qual o proxima cor a ser usada
    MyColorHolder *last = [[self.shared arrayColors] lastObject];
    long int lastColorIndex = [[self.shared arrayColors] indexOfObject:last];
    if (lastColorIndex == MAX_QNT_CORES_DISPONIVEIS-1) {
        return 0;
    }
    return (int)lastColorIndex + 1;
}

-(UIColor*)getOriginalColor{
    //retorna a proxima cor do ciclo de cores
    lastUsedColor++; //mantem track de qual local no ciclo de cores está
    if (lastUsedColor == [[self.shared colors] count]) {
        lastUsedColor = 0;
    }
    return [[self.shared colors] objectAtIndex:lastUsedColor];
}


#pragma mark GestureRecognizer
-(void)setGestureRecognizers:(Chronometer*)chron atCell:(UIView*)cell {
    //    //Um clique em cima do cronometro
    UITapGestureRecognizer *playStop = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(play_pauseChronometer)];
    playStop.cancelsTouchesInView = NO;
    
    //    //um clique com dois dedos... por enquanto
    UITapGestureRecognizer *lapMark = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(lapChronometer)];
    //        [playStop requireGestureRecognizerToFail:lapMark]; //da um delay grande no pause
    lapMark.numberOfTapsRequired = 1;
    lapMark.numberOfTouchesRequired = 2;
    lapMark.cancelsTouchesInView = NO;
    
    //    //inicia o tempo de descanso, dois cliques com um dedo
    UITapGestureRecognizer *restTime = [[UITapGestureRecognizer alloc]initWithTarget:chron action:@selector(restChronometer)];
    [chron editRestTime:5];
    restTime.numberOfTouchesRequired = 1;
    restTime.numberOfTapsRequired = 2;
    restTime.cancelsTouchesInView = NO;
    
    //    //temporariamente adiciona cronometro
    UISwipeGestureRecognizer *addChron= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(addNewCell)];
    addChron.cancelsTouchesInView = NO;
    
    //    UISwipeGestureRecognizer *deleteChron = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(deleteCellatIndexPath:)];
    
    
    //editaChronometro
    UILongPressGestureRecognizer *edit = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(goToEditableChronView:)];
    edit.minimumPressDuration = 1;
    [cell addGestureRecognizer:playStop];
    [cell addGestureRecognizer:lapMark];
    [cell addGestureRecognizer:restTime];
    [cell addGestureRecognizer: addChron];
    [cell addGestureRecognizer:edit];
    //    [cell addGestureRecognizer: deleteChron];
    
}
-(void)goToEditableChronView:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }
    
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSIndexPath *i = [self.collectionView indexPathForItemAtPoint: [gestureRecognizer locationInView:self.collectionView] ];
        if (i != nil) {
            if (i.row >= self.shared.mainChronIndex) {
                self.shared.mainChronIndex = (int)i.row + 1;
            }else{
                self.shared.mainChronIndex = (int) i.row;
            }
            [self.collectionView reloadData];
            [self.mainChronView reloadInputViews];
            [self reloadInputViews];
    }
    
    }
}//- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
//    if ([sender numberOfTouches] != 2)
//        return;
//
//    // Get the pinch points.
//    CGPoint p1 = [sender locationOfTouch:0 inView:[self collectionView]];
//    CGPoint p2 = [sender locationOfTouch:1 inView:[self collectionView]];
//
//    // Compute the new spread distance.
//    CGFloat xd = p1.x - p2.x;
//    CGFloat yd = p1.y - p2.y;
//    CGFloat distance = sqrt(xd*xd + yd*yd);
//
//    // Update the custom layout parameter and invalidate.
//    MyCustomLayout* myLayout = (MyCustomLayout*)[[self collectionView] collectionViewLayout];
//    [myLayout updateSpreadDistance:distance];
//    [myLayout invalidateLayout];
//}
//-(void)handlePan:(UIPanGestureRecognizer *)panRecognizer {
//
//    CGPoint locationPoint = [panRecognizer locationInView:self.collectionView];
//
//    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
//
//        NSIndexPath indexPathOfMovingCell = [self.collectionView indexPathForItemAtPoint:locationPoint];
//        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPathOfMovingCell];
//
//        UIGraphicsBeginImageContext(cell.bounds.size);
//        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
//        [self.movingCell setCenter:locationPoint];
//        [self.movingCell setAlpha:0.75f];
//        [self.collectionView addSubview:self.movingCell];
//
//    }
//
//    if (panRecognizer.state == UIGestureRecognizerStateChanged) {
//        [self.movingCell setCenter:locationPoint];
//    }
//
//    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
//        [self.movingCell removeFromSuperview];
//    }
//}

#pragma  mark Add/Del
-(void) deleteCellatIndexPath:(NSIndexPath*)indexPath{
    long int row = [indexPath row]; //locla da celula a ser deletada
    [[self.shared arrayChronometers][row] removeFromSuperview]; //remove da superview
    [[self.shared arrayChronometers][row] removeFromSuperview]; //remove de novo para garantir
    [[self.shared arrayChronometers] removeObjectAtIndex:row]; //remove do array
    [[self.shared arrayColors] removeObjectAtIndex:row]; //remove a cor do array de cores
    NSArray *deleteItems = @[indexPath];
    [self.collectionView deleteItemsAtIndexPaths:deleteItems]; //deleta da collection
}

-(void) addNewCell{
    NSIndexPath *indexp = [NSIndexPath
                           indexPathForItem:[[self.shared arrayChronometers]count]
                           inSection:0];
    [[self.shared arrayChronometers]addObject:[self getNewChronometer]]; //adiciona um cronometro no array
    [self addColorToUsedColorsArray]; //adiciona uma cor no array de cores
    NSArray *indexes = [NSArray arrayWithObjects:indexp, nil];
    [self.collectionView insertItemsAtIndexPaths:indexes];
}

//metodo long pres

/*
 [self performSegueWithIdentifier:@"detail"];
 */


@end
