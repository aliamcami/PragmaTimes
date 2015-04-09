//
//  Chronometer.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "chronometer.h"

@implementation chronometer

#pragma mark - Instance Methods

//Metodo de instancia que inicia o cronometro em um tamanho especifico, fornecido previamente
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //Inicia todos os arrays controladores de tempo
        self.pauseTimes = [[NSMutableArray alloc] init];
        self.startTimes = [[NSMutableArray alloc] init];
        self.lapTimes = [[NSMutableArray alloc] init];
        
        //Inicia a property dateFormatter, informa qual formato de data sera usado
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"HH:mm:ss.SS"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    }
    
    return self;
}

//Metodo para ja iniciar o cronometro com o tamanho e as informascoes a serem mostradas da forma desejada
- (instancetype)initWithFrame:(CGRect)frame andFocus:(int)focus
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        [self resizeCronometer:frame andFocus:focus];
    }
    
    return self;
}

#pragma mark - Chronometer Organization

//Metodo que vai alterar a organizaçao do espaço da view
//Sem condiçoes de implementar sem saber como sera o espaço
-(void)resizeCronometer:(CGRect)size andFocus:(int)focus
{
    //Lembrar de alignment Center, AdjustFontSizeToFitWidht, minimunScaleFactor(????)
    self.focus = focus;
    self.frame = size;
    
    int const origin = 0;
    
    int screenDivisions;
    
    //Retira tudo da tela, para nao haver sobreposicao de itens na tela
    [self.chronometer removeFromSuperview];
    [self.chronometerBestLap removeFromSuperview];
    [self.chronometerName removeFromSuperview];
    [self.tableViewLaps removeFromSuperview];
    
    switch (self.focus) {
            
        //MOSTRA O NOME E O TEMPO
        //Divide o cronometro em duas partes:
        // - Label nome: ocupa o primeiro 1/3 da tela
        // Mostra em uma label o nome do cronometro
        // - Label cronometro: ocupar 2/3 da tela
        // Mostra em uma label o tempo que esta sendo marcado
        case 0:
            screenDivisions = 3;    //Seta em quantos pedacos a view em que o cronometro aparecera sera mostrado
            
            //atribui pedacos da tela as labels que mostram o nome e o tempo
            [self.chronometer setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions), self.frame.size.width, (self.frame.size.height / screenDivisions) * 2)];
            [self.chronometerName setFrame:CGRectMake(origin, origin, self.frame.size.width, self.frame.size.height / screenDivisions)];
            
            break;
            
        //MOSTRA O NOME, TEMPO E AS LAPS
        //Divide o frame do cronometro em 5 partes
        // - 1/6 fica com o a label que contem o nome do cronometro
        // - 2/6 ficam com o label que mostra o tempo
        // - 3/6 ficam com o a table viwe que mostra todas as lap
        case 1:
        {
            screenDivisions = 6;    //Seta em quantos pedacos a view em que o cronometro aparecera sera mostrado
            
            //atribui pedacos da tela as labels que mostram o nome e o tempo
            [self.chronometerName setFrame:CGRectMake(origin, origin, self.frame.size.width, self.frame.size.height / screenDivisions)];
            [self.chronometer setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions), self.frame.size.width, (self.frame.size.height / screenDivisions) * 2)];
            
            //Define o tamanho que a tableview com as laps ocupara
            CGRect tableViewLapsSize = CGRectMake(origin, (self.frame.size.height / screenDivisions) * 3, self.frame.size.width, (self.frame.size.height / screenDivisions) * 3);
            
            //Instancia uma tableview com o tamanho definido
            self.tableViewLaps = [[TableView_Model alloc] initWithFrame:tableViewLapsSize
                                                                           LapTimes:[self getLapsContent]
                                                                andSelectedLapTimes:self.lapTimes];
            
            //Adiciona a tableview a tela
            [self addSubview:self.tableViewLaps];
            
            break;
        }
            
        //MOSTRA O NOME, O TEMPO, AS LAPS E A MELHOR LAP
        //Divide a tela aem 7 pedacos:
        // - 1/7 fica com a label que mostra o nome do cronometro na tela
        // - 2/7 ficam com a label que mostra o tempo que esta sendo marcado na tela
        // - 3/7 ficam com a table view que mostra as laps do cronometro
        // - 1/7 fica com a label que mostra qual a melhor volta até o momento
        case 2:
        {
            screenDivisions = 7;    //Seta em quantos pedacos a view em que o cronometro aparecera sera mostrado
            
            //atribui pedacos da tela as labels que mostram o nome e o tempo
            [self.chronometerName setFrame:CGRectMake(origin, origin, self.frame.size.width, self.frame.size.height / screenDivisions)];
            [self.chronometer setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions), self.frame.size.width, (self.frame.size.height / screenDivisions) * 2)];
            
            //Define o tamanho que a tableview com as laps ocupara
            CGRect tableViewLapsSize = CGRectMake(origin, (self.frame.size.height / screenDivisions) * 3, self.frame.size.width, (self.frame.size.height / screenDivisions) * 3);
            
            //Instancia uma tableview com o tamanho definido
            self.tableViewLaps = [[TableView_Model alloc] initWithFrame:tableViewLapsSize
                                                                           LapTimes:[self getLapsContent]
                                                                andSelectedLapTimes:self.lapTimes];
            
            //separa um pedaco da tela para a label que vai mostrar a melhor volta
            [self.chronometerBestLap setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions) * 6, self.frame.size.width, self.frame.size.height / screenDivisions)];
            
            //adiciona a tableview e a label com o melhor tempo a tela
            [self addSubview:self.tableViewLaps];
            [self addSubview:self.chronometerBestLap];
            
            break;
        }
            
        //TRATAMENTO DE ERRO - A principio para testes - RETIRAR DEPOOSI
        default:
            NSLog(@"Ta entrando onde nao deveria");
            break;
    }
    
    [self editChronometerName:self.name];
    
    //Adiciona as labels que mostram o nome e o tempo do cronometro a tela
    [self addSubview:self.chronometerName];
    [self addSubview:self.chronometer];
}

//Ajusta todas as labels, para facilitar edicao dos textos das labels futuramente
-(void)adjustLabelTexts
{
    self.chronometer = [[UILabel alloc] init];
    self.chronometerBestLap = [[UILabel alloc] init];
    self.chronometerName = [[UILabel alloc] init];
    
    self.chronometerName.textAlignment = NSTextAlignmentCenter;
    self.chronometerBestLap.textAlignment = NSTextAlignmentCenter;
    self.chronometer.textAlignment = NSTextAlignmentCenter;
    
    self.chronometerName.adjustsFontSizeToFitWidth = YES;
    self.chronometerBestLap.adjustsFontSizeToFitWidth = YES;
    self.chronometer.adjustsFontSizeToFitWidth = YES;
    
}

//Atualiza o texto da label ao mesmo em que o nome do cronometro foi alterado, sem necessidade de arranjar um jeito de dar refresh na tela
-(void)editChronometerName:(NSString*)name
{
    self.name = name;
    self.chronometerName.text = self.name;
}

#pragma mark - Time Control Methods

//Controlador de tempo do cronometro
-(void)play_pauseChronometer
{
    if (!self.chronometerTimer) {   //Verifica se o cronometro está parado
        //Ativa o cronometro
        self.chronometerTimer = [NSTimer scheduledTimerWithTimeInterval:0.06
                                                                 target:self
                                                               selector:@selector(updateTimer)
                                                               userInfo:nil repeats:YES];
        //Adiciona ao array de inicio o momento em que o cronometro começou a correr
        [self.startTimes addObject:[NSDate date]];
        
    }else   //Caso o cronometro ja esteja ativo
    {
        //Destroi o timer do cronometro, resultando na nao atualizaçao do cronometro
        [self.chronometerTimer invalidate];
        
        //Libera a memoria ocupada pelo timer
        self.chronometerTimer = nil;
        
        //Adiciona ao array de pausas o momento em que o cronometro foi pausado
        [self.pauseTimes addObject:[NSDate date]];
    }
}

-(void)lapChronometer
{
    //Adiciona ao array de voltas o momento em que foi solicitado uma volta
    [self.lapTimes addObject:[NSDate date]];
    [self.tableViewLaps refreshTableViewWithLapTimes:[self getLapsContent] andSelectedLapTimes:self.lapTimes];
}


//Método que altera o texto contido na label, mostrando o tempo do relogio
-(void)updateTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval;
    
    if (self.pauseTimes){       //Verifica se o cronometro ja foi pausado alguma vez
        NSTimeInterval timeOfPause = 0.0;   //Conta a quantidade de tempo que o cronometro ficou parado
        for (int i = 0; i < [self.pauseTimes count]; i++) {     //Percorre o array que armazena todas as pausas
            //Adiciona ao contador, todo o tempo entre a pausa e o proximo start
            timeOfPause += [[self.startTimes objectAtIndex:i + 1] timeIntervalSinceDate:[self.pauseTimes objectAtIndex:i]];
        }
        //Calcula o intervalo de tempo entre o momento em que o cronometro foi startado e o momento atual
        timeInterval = [currentDate timeIntervalSinceDate:[self.startTimes firstObject]];
        
        //Subtrai todo o intervalo em que o cronometro ficou pausado do tempo total de execuçao do cronometro
        timeInterval -= timeOfPause;
        
    }else       //Caso o cronometro nao tenha sido pausado nenhuma vez
    {
        timeInterval = [currentDate timeIntervalSinceDate:[self.startTimes lastObject]];
    }
    //transforma o tempo do cronometro em uma NSDate
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    //Altera o texto do label de acordo com o date formater setado anteriormente
    NSString *timeString = [self.dateFormatter stringFromDate:timerDate];
    self.chronometer.text = timeString;
}



#pragma mark - Returning Informations

//Retorna um array contendo:
//- NSDate de inicio do cronometro
//- de 0 a N NSNumber contendo o tempo de cada volta
//Ou nao retorna nada se nao tiver nenhuma volta
-(NSArray*)getLapsContent
{
    if ([self.lapTimes count] == 0) {
        return nil;
    }else{
        NSMutableArray *lapContents = [[NSMutableArray alloc] init];
        NSTimeInterval interval = 0.0;
        
        //adicionando o NSDate de quando o cronometro foi startado
        [lapContents addObject:[self.startTimes firstObject]];
        
        //Calcula o tempo entre a primeira volta e o horario de inicio do cronometro
        //Evita passar por if toda hora dentro do loop
        interval = [[self.lapTimes firstObject] timeIntervalSinceDate:[self.startTimes firstObject]];
        [lapContents addObject:[NSNumber numberWithFloat:interval]];
        
        //Percorre o array de voltas, a partir da segunda volta
        for (int i = 1; i < [self.lapTimes count]; i++) {
            
            //Calcula o intervalo de tempo entre a volta atual e a volta passada
            interval = [self.lapTimes[i] timeIntervalSinceDate:self.lapTimes[i - 1]];
            NSNumber *numb = [NSNumber numberWithFloat:interval];
            
            [lapContents addObject:numb];
        }
        
        return lapContents;
    }
}

@end
