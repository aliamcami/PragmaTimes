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

#import <UIKit/UIKit.h>
#import "TableView_Model.h"

@interface chronometer : UIView

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *startRest;
@property (nonatomic) int restTime;

@property (nonatomic) NSTimer *timeController;
//Para mostrar mais informações sobre o cronometro
@property (nonatomic) short focus;

//Formatacao para apresentacao
@property (nonatomic) NSDateFormatter *formatterChronometer;
@property (nonatomic) NSDateFormatter *formatterRest;

//Possiveis coisas a serem mostradas no cronometro, tudo depende do tamanho que ele for ocupar na tela
@property (nonatomic) UILabel *lblChronometer;
@property (nonatomic) UILabel *lblChronometerName;
@property (nonatomic) UILabel *lblChronometerBestLap;
@property (nonatomic) TableView_Model *tbLaps;

//Arrays para manipular o tempo do cronometro
@property (nonatomic) NSMutableArray *pauseTimes;
@property (nonatomic) NSMutableArray *startTimes;
@property (nonatomic) NSMutableArray *lapTimes;


- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andFocus:(int)focus;

-(void)resizeCronometer:(CGRect)size andFocus:(int)focus;
-(void)editChronometerName:(NSString*)name;
-(void)editRestTime:(int)restTime;

-(void)resetChronometer;
-(void)play_pauseChronometer;
-(void)restChronometer;
-(void)lapChronometer;

-(NSArray*)getChronometerContent;

@end
