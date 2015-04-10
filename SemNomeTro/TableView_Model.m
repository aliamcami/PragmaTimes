//
//  TableView_Model.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 08/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "TableView_Model.h"

@implementation TableView_Model

#pragma mark - InstanceType Methods

- (instancetype)initWithFrame:(CGRect)frame LapTimes:(NSArray*)lapTimes andSelectedLapTimes:(NSArray*)selectedLapTimes
{
    self = [self initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.lapTimes = lapTimes;
        self.selectedLapTimes = selectedLapTimes;
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - Edit TableView

//Atualiza as celulas da tableView
-(void)refreshTableViewWithLapTimes:(NSArray*)lapTimes andSelectedLapTimes:(NSArray*)selectedLapTimes
{
    self.lapTimes = lapTimes;
    self.selectedLapTimes = selectedLapTimes;
    [self.tableView reloadData];    //Funcao que atualiza os dados das celulas da tableview
}

#pragma mark - TableView Config

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectedLapTimes count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Lap %li: %@", (long)indexPath.row, [self.lapTimes objectAtIndex:indexPath.row]]; //+1
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Horario da Volta: %@", [self.selectedLapTimes objectAtIndex:indexPath.row]];
    
    return cell;
}

@end

