//
//  Volta.h
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 23/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GrupoDeTempos;

@interface Volta : NSManagedObject

@property (nonatomic, retain) NSNumber * tempo;
@property (nonatomic, retain) GrupoDeTempos *grupo;

@end
