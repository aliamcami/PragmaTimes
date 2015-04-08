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
        //Define a hora de inicio do cronometro como a hora do sistema no momento que o cronometro foi instanciado
        self.startDate = [NSDate date];
        
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
        
        //Chama o metodo para iniciar o cronometro
        [self startedChronometer];
    }
    
    return self;
}

//Responsavel por iniciar o cronometro
-(void)startedChronometer
{
    //Informa que o timer chamara o metodo updateTimer a cada 60 milisegundos. Após ser executado o teste, com esse intervalo de chamada, o iphone 6 utiliza 50% de sua capacidade de procesamento trabalhando com 540 cronometros.
    self.chronometerTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

//Faz com que o tempo do cronometro pare de rodar - NECESSITA SER ALTERADO, O TEMPO NAO DEVE PARAR DE RODAR
-(void)stopedChronometer
{
    [self.chronometerTimer invalidate];
}

//Método que altera o texto contido na label, mostrando o tempo do relogio
-(void)updateTimer
{
    //Pega a hora atual e calcula o intervalo entre ela e a data de inicio do cronometro
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    //Transforma o tempo em uma string para ser mostrado como texto da label
    NSString *timeString = [self.dateFormatter stringFromDate:timerDate];
    
    //altera o texto da label, mostrando o tempo do cronometro
    self.chronometer.text = timeString;
}

@end
