//
//  Chronometer.h
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//
/*
 Objeto Cronometro
 
 - Faz o calculo do tempo decorrido desde o inicio ate o momento atual
 
 */

#import <UIKit/UIKit.h>
#import "TableView_Model.h"

@interface chronometer : UIView

@property (nonatomic) NSString *name;
@property (nonatomic) NSTimer *chronometerTimer;
//Para mostrar mais informações sobre o cronometro
@property (nonatomic) short focus;

//Formatacao para apresentacao
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSNumberFormatter *numberFormatter;

//Possiveis coisas a serem mostradas no cronometro, tudo depende do tamanho que ele for ocupar na tela
@property (nonatomic) UILabel *chronometer;
@property (nonatomic) UILabel *chronometerName;
@property (nonatomic) UILabel *chronometerBestLap;
@property (nonatomic) TableView_Model *tableViewLaps;

//Arrays para manipular o tempo do cronometro
@property (nonatomic) NSMutableArray *pauseTimes;
@property (nonatomic) NSMutableArray *startTimes;
@property (nonatomic) NSMutableArray *lapTimes;


- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andFocus:(int)focus;

-(void)resizeCronometer:(CGRect)size andFocus:(int)focus;
-(void)adjustLabelTexts;
-(void)editChronometerName:(NSString*)name;

-(void)play_pauseChronometer;
-(void)lapChronometer;
-(void)updateTimer;

-(NSArray*)getLapsContent;
-(NSNumber*)bestLap;
-(NSArray*)getChronometerContent;

@end
