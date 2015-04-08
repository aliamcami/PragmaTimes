//
//  Chronometer.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "chronometer.h"

@implementation chronometer

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
        
        //Cria a label cronometro que ocupa todo o tamanho da view
        self.chronometer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        
        //Alinha o texto ao centro da label
        [self.chronometer setTextAlignment:NSTextAlignmentCenter];
        
        //Adiciona o cronometro como subview dessa classe
        [self addSubview:self.chronometer];
    }
    
    return self;
}

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

//Responsavel por iniciar o cronometro
-(void)startChronometer
{
    //Informa que o timer chamara o metodo updateTimer a cada 60 milisegundos. Após ser executado o teste, com esse intervalo de chamada, o iphone 6 utiliza 50% de sua capacidade de procesamento trabalhando com 540 cronometros.
    self.chronometerTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

//Faz com que o tempo do cronometro pare de rodar - NECESSITA SER ALTERADO, O TEMPO NAO DEVE PARAR DE RODAR
-(void)pauseChronometer
{
    [self.chronometerTimer invalidate];
}

-(void)lapChronometer
{
    //Adiciona ao array de voltas o momento em que foi solicitado uma volta
    [self.lapTimes addObject:[NSDate date]];
}


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

@end
