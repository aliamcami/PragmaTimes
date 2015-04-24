//
//  SingletonData.h
//  UltimoTeste
//
//  Created by camila oliveira on 4/17/15.
//  Copyright (c) 2015 camila oliveira. All rights reserved.
//
#define RGB(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define COR_AZUL RGB(49, 76, 94)
#define COR_VERMELHO RGB(226, 71, 70)
#define COR_VERDE RGB(40, 191, 164)
#define COR_LARANJA RGB(230, 122, 54)
#define COR_AMARELO RGB(240, 203, 68)
#define MAX_QNT_CORES_DISPONIVEIS 5

#import <Foundation/Foundation.h>
#import "Chronometer.h"

@interface SingletonData : NSObject
+(SingletonData*)sharedSingleton;
@property NSMutableArray *arrayChronometers;
@property NSMutableArray *arrayColors;
@property int mainChronIndex;
@property int lastUsedColor;
@property NSArray *colors;
@end
