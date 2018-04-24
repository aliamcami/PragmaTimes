//
//  chronometer.h
//  chronometer
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#define CRONOMETRO_BASE 0
#define CRONOMETRO_INTERMEDIARIO 1
#define CRONOMETRO_COMPLETO 2
#define CRONOMETRO_EDITAVEL 3

#import <UIKit/UIKit.h>

@interface Chronometer : UIView

//- (instancetype)initWithFrame:(CGRect)frame andFocus:(int)focus; //Nao necessario por enquanto
-(void)resizeCronometer:(CGRect)size andFocus:(int)focus;
-(void)enableEditing;

-(void)resetChronometer;
-(void)play_pauseChronometer;
-(void)restChronometer;
-(void)lapChronometer;

//Necessario colocar esses metodos de volta no cabecalho pois precisarao ser chamados por uma classe externa
-(void)playChronometer;
-(void)pauseChronometer;

-(NSArray*)getPauseTimes;
-(NSArray*)getStartTimes;
-(NSArray*)getLapsContent;

-(NSArray*)getChronometerContent;

@end
