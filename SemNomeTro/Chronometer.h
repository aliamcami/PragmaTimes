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

@interface Chronometer : UIView

@property (nonatomic) NSString *name;
@property (nonatomic) int restTime;

//- (instancetype)initWithFrame:(CGRect)frame andFocus:(int)focus; //Nao necessario por enquanto

-(void)resizeCronometer:(CGRect)size andFocus:(int)focus;
-(void)editChronometerName:(NSString*)name;
-(void)editRestTime:(int)restTime;

-(void)resetChronometer;
-(void)play_pauseChronometer;
-(void)restChronometer;
-(void)lapChronometer;

-(NSArray*)getChronometerContent;

@end
