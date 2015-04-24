//
//  Inicio.h
//  SemNomeTro
//
//  Created by André on 22/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GrupoDeTempos;

@interface Inicio : NSManagedObject

@property (nonatomic, retain) NSDate * tempo;
@property (nonatomic, retain) GrupoDeTempos *grupo;

@end
