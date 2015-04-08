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
        
        //Chama o metodo que edita o cronometro do modo necessario
        [self resizeCronometer:frame];
        
        //Adiciona o cronometro como subview dessa classe
        [self addSubview:self.chronometer];
    }
    
    return self;
}

//Metodo que vai alterar a organizaçao do espaço da view
//Sem condiçoes de implementar sem saber como sera o espaço
-(void)resizeCronometer:(CGRect)size
{
    //Lembrar de alignment Center, AdjustFontSizeToFitWidht, minimunScaleFactor(????)
    
    switch (self.focus) {
        //Caso padrão, o tempo ocupara o espaço todo???
        case 0:
            break;
        //Se está num tamanho maior que o normal, mas menor que a metade da tela
        case 1:
            break;
        //Se é do tamanho de metade da tela
        case 2:
            break;
        case 3:
        //Se ocupa a tela toda
            break;
        default:
            break;
    }
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
}


#pragma mark - Returning Informations

//Retorna um array contendo:
//- NSDate de inicio do cronometro
//- de 0 a N NSNumber contendo o tempo de cada volta
-(NSMutableArray*)getLapsContent
{
    NSMutableArray *lapContents = [[NSMutableArray alloc] init];
    NSTimeInterval interval = 0.0;
    
    //adicionando o NSDate de quando o cronometro foi startado
    [lapContents addObject:[self.startTimes firstObject]];
    
    //Calcula o tempo entre a primeira volta e o horario de inicio do cronometro
    //Evita passar por if toda hora dentro do loop
    interval = [[self.lapTimes firstObject] timeIntervalSinceDate:[self.startTimes firstObject]];
    [lapContents addObject:[NSNumber numberWithFloat:interval]];
    
    //Percorre o array de voltas, a partir da volta 2
    for (int i = 1; i < [self.lapTimes count]; i++) {
        
        //Calcula o intervalo de tempo entre a volta atual e a volta passada
        interval = [self.lapTimes[i] timeIntervalSinceDate:self.lapTimes[i - 1]];
        NSNumber *numb = [NSNumber numberWithFloat:interval];
        
        [lapContents addObject:numb];
    }
    
    return lapContents;
}

#pragma mark - Update Time

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

//Informa se o Cronometro está em foco ou nao
//-(BOOL)isFocused
//{
//    
//}

@end
