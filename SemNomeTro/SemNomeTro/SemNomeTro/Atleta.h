#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GrupoDeTempos;

@interface Atleta : NSManagedObject

@property (nonatomic, retain) NSNumber * altura;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * foto;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * peso;
@property (nonatomic, retain) NSString * sexo;
@property (nonatomic, retain) NSSet *tempos;
@end

@interface Atleta (CoreDataGeneratedAccessors)

- (void)addTemposObject:(GrupoDeTempos *)value;
- (void)removeTemposObject:(GrupoDeTempos *)value;
- (void)addTempos:(NSSet *)values;
- (void)removeTempos:(NSSet *)values;

@end
