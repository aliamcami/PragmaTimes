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

@interface chronometer : UIView

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) UILabel *chronometer;
@property (nonatomic) NSTimer *chronometerTimer;


- (instancetype)initWithFrame:(CGRect)frame;

-(void)startedChronometer;
-(void)stopedChronometer;

-(void)updateTimer;

@end
