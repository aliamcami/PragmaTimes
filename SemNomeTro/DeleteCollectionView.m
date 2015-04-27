//
//  DeleteCollectionView.m
//  UltimoTeste
//
//  Created by camila oliveira on 4/22/15.
//  Copyright (c) 2015 camila oliveira. All rights reserved.
//

#import "DeleteCollectionView.h"
#import "CustomCollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "Chronometer.h"
#import "MyColorHolder.h"
#import "SingletonData.h"
#import "GeneralController.h"

@interface DeleteCollectionView ()
@property (nonatomic)SingletonData *shared;

@end

@implementation DeleteCollectionView{
    CGSize chronometerSize;
    int workWidth;
    int workHeight;
    int qntColuna;
    int lastUsedColor;
    int tipoChronometro;
    NSMutableArray *selectedArray;
}

//constantes
static int const minimunSpaceBetweenElements = 10;
static int const horizontalBorder = 10;
static int const verticalBorder = 15;
static float const diferenceForAlphaColor = 0.2;

#pragma mark Configuracoes
//-(void)configCelulaGrande:(int)celulaGrande {
//    self.configCelulaGrande = celulaGrande;
//}
//-(void)configQuantidadeColunas:(int)qntColunas{
//    self.configQntColunas = qntColunas;
//}
//-(void)configMaxCronometrosPorPagina:(int)qntCronometroPagina{
//    self.configMaxChronometerPerPage = qntCronometroPagina;
//}


#pragma mark principais
-(void)viewDidAppear:(BOOL)animated{
    [self.collectionView reloadData];
}
- (void)viewDidLoad {
    
    self.collectionView.allowsMultipleSelection = YES;
    selectedArray = [[ NSMutableArray alloc]init];
    
    
    [super viewDidLoad];
    self.shared = [SingletonData sharedSingleton];
    //temporariamente atribui a qnt total de chronometros na tela para que os calculos de tamanhos possam ser feitos
    self.configQntColunas = 2;
    self.configMaxChronometerPerPage = 8;
    self.configCelulaGrande = CONFIG_NENHUMA_CELULA_DESTAQUE;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MyCell"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.shared arrayChronometers]count];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
//    
    //removendo as subviews lixo das celulas
    for (UIView *v in cell.subviews) {
        [v removeFromSuperview];
    }
    
    //    //coloca o crhonometro em cada celula
    Chronometer *chron = [[self.shared arrayChronometers] objectAtIndex:indexPath.row];
    [cell addSubview:chron];
    
    //arredonda os cantos da celula
    [cell.layer setCornerRadius:20];
    
    //atribui cor a celula
    MyColorHolder *color = [[self.shared arrayColors] objectAtIndex:indexPath.row];
    [cell setBackgroundColor:color.theColor];
    
    cell.selectedBackgroundView.layer.borderColor = [UIColor redColor].CGColor;
    cell.selectedBackgroundView.layer.borderWidth = 4.0f;
    
    //retorna a celula ja com um chronometro em cada e cor de background
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    //calcula a quantidade de colunas necessarias para a apresentacao dos cronometros
    qntColuna = [self getQntColuna];
    
    //calcula o espaco disponivel para apresentar os cronometros já descontando o espado de bordas
    [self ajusteDoEpacoDeApresentacaoWidth:self.collectionView.frame.size.width andHeight: self.collectionView.frame.size.height];
    
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
        if (count == 1 & [[self.shared arrayChronometers]count] > 3) {
            if ([[self.shared arrayChronometers]count] > 3) {
                if ([self getQntColuna] == 3) {
                    if (count % 3 == 2) {
                        novo = CGSizeMake(chronometerSize.width*2 + 10, chronometerSize.height);
                    }else if ([[self.shared arrayChronometers]count] % 3 == 1){
                        novo = CGSizeMake(chronometerSize.width*3 + 20, chronometerSize.height);
                    }
                }else{
                    if ([[self.shared arrayChronometers]count] % 2 != 0) {
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
    [[[self.shared arrayChronometers]objectAtIndex:indexPath.row] resizeCronometer:rect andFocus:tipoChronometro];
    
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
#pragma mark select items
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"lkjlk %lu", [selectedArray count]);
    //    Chronometer *item = self.shared.arrayChronometers[indexPath.row];
    [selectedArray addObject: indexPath];
    [self.collectionView cellForItemAtIndexPath:indexPath].layer.borderColor = [UIColor redColor].CGColor;
    [self.collectionView cellForItemAtIndexPath:indexPath].layer.borderWidth = 3.0f;
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    Chronometer *item = self.shared.arrayChronometers[indexPath.row];
    [selectedArray removeObject:indexPath];
    [self.collectionView cellForItemAtIndexPath:indexPath].layer.borderColor = [UIColor clearColor].CGColor;
    [self.collectionView cellForItemAtIndexPath:indexPath].layer.borderWidth = .0f;
}

// // Uncomment this method to specify if the specified item should be highlighted during tracking
// - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//     NSLog(@"should hith");
//	return YES;
// }
//
// // Uncomment this method to specify if the specified item should be selected
// - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//     NSLog(@"should select");
//     return YES;
// }

 
/*
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
    workWidth = width - horizontalBorder*2 - (qntColuna - 1)*minimunSpaceBetweenElements;
    workHeight = height - verticalBorder*2 -
    MIN(ceil((((float)[[self.shared arrayChronometers]count]/qntColuna))),
        self.configMaxChronometerPerPage/2+1)*minimunSpaceBetweenElements;
}

- (void)calcChronometerSize{
    //set tamanho dos cronometros dependendo da quantidade de cronometros
    int altura;
    switch ([[self.shared arrayChronometers]count]) {
        case 1:
            chronometerSize = CGSizeMake(workWidth, workHeight);
            tipoChronometro = CRONOMETRO_COMPLETO;
            break;
        case 2:
            chronometerSize = CGSizeMake(workWidth, workHeight/[[self.shared arrayChronometers]count]);
            tipoChronometro = CRONOMETRO_INTERMEDIARIO;
            break;
        case 3:
            //nao sei porque.. mas o -10 eh importante
            chronometerSize = CGSizeMake(workWidth, (workHeight - 10)/[[self.shared arrayChronometers]count]);
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
    if ([[self.shared arrayChronometers]count] > self.configMaxChronometerPerPage) {
        return (workHeight)/(int)ceil((float)self.configMaxChronometerPerPage/qntColuna);
    }
    return (workHeight)/(int)ceil((float)[[self.shared arrayChronometers]count]/qntColuna);
    
}
-(int)getQntColuna{
    if ([[self.shared arrayChronometers]count] < 3) {
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



-(void)goToEditableChronView:(UILongPressGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSIndexPath *i = [self.collectionView indexPathForItemAtPoint: [gestureRecognizer locationInView:self.collectionView] ];
        if (i != nil) {
            self.shared.mainChronIndex = (int) i.row;
            [self performSegueWithIdentifier:@"goToEditable" sender:nil];
        }
        
    }
    
}
//- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
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
-(void) deleteCellsIndexPaths:(NSArray*)indexPaths{
    
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc]init];
    
    if ([self.shared.arrayChronometers count] - [indexPaths count] == 0) {
        [self addNewCell];
    }
    for (NSIndexPath *indexPath in indexPaths) {
        [indexes addIndex:indexPath.row];
        [[self.collectionView cellForItemAtIndexPath:indexPath] removeFromSuperview];
        [[self.shared arrayChronometers][indexPath.row] removeFromSuperview]; //remove da superview
    }
    [self.shared.arrayChronometers removeObjectsAtIndexes:indexes];
    [self.shared.arrayColors removeObjectsAtIndexes:indexes];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths]; //deleta da collection
    [selectedArray removeAllObjects];
}

-(void) addNewCell{
    NSIndexPath *indexp = [NSIndexPath
                           indexPathForItem:[[self.shared arrayChronometers]count]
                           inSection:0];
    [[self.shared arrayChronometers]addObject:[self getNewChronometer]]; //adiciona um cronometro no array
    [self addColorToUsedColorsArray]; //adiciona uma cor no array de cores
    NSArray *indexes = [NSArray arrayWithObjects:indexp, nil];
    [self.collectionView insertItemsAtIndexPaths:indexes];
    [self.collectionView scrollToItemAtIndexPath:indexp atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

//metodo long pres

/*
 [self performSegueWithIdentifier:@"detail"];
 */
#pragma mark toolbar
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)remove:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Deseja salvar os dados antes de excluir?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelar Exclusao"
                                          otherButtonTitles:@"Salvar",@"Nao Salvar", nil];
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            for (int i = 0; i < [selectedArray count]; i++) {
                //Preciso da Camila aqui para resolver isso.
                NSIndexPath *index = selectedArray[i];
                Chronometer *c = [self.shared.arrayChronometers objectAtIndex:index.row];
                
                //Mandar isso pro metodo do andré
              GeneralController *gc = [[GeneralController alloc] init];
              [gc adicionarTempos:nil eTempos:c];
            }

            [self deleteCellsIndexPaths:selectedArray];
            break;
        case 2:
            [self deleteCellsIndexPaths:selectedArray];
            break;
    }
}



@end
