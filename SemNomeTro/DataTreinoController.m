//
//  DataTreinoController.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 28/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "DataTreinoController.h"
#import "GeneralController.h"
#import "GrupoDeTemposOrdenados.h"

@interface DataTreinoController ()

@property (nonatomic) GeneralController *gc;
@property (nonatomic) Atleta *a;
@property (nonatomic) GrupoDeTemposOrdenados *gp;
@property (nonatomic) NSMutableArray *datas;

@end

@implementation DataTreinoController

NSArray* ordenaDatas2(NSArray *arr) {
    NSLog(@"Arr: %@", arr);
    return  [arr sortedArrayUsingComparator:^(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    self.email = sender.selected;
//    Deu ruim desisto!!!! kkkkkkk
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.gc = [[GeneralController alloc] init];
    
    self.a = [[Atleta alloc] init];
    self.a = [self.gc encontraAtleta:self.email];

    //self.gp = [[GrupoDeTemposOrdenados alloc] initComGrupoDeTempos:(GrupoDeTempos*)self.a.tempos];
    self.datas = [[NSMutableArray alloc] init];
    for (GrupoDeTempos *g in [self.a.tempos allObjects])
        [self.datas addObject:g];
    
    self.datas = [self.datas initWithArray:ordenaDatas2(self.datas)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.a.tempos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    
    return cell;
}




@end
