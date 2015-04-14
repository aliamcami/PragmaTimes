//
//  TableView_Model.h
//  chronometer
//
//  Created by Giovani Ferreira Silvério da Silva on 08/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableView_Model : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *lapTimes;
@property (nonatomic) NSArray *chronometerTotalTimeAtLap;

//Formatacao para apresentacao
@property (nonatomic) NSDateFormatter *dateFormatter;

- (instancetype)initWithFrame:(CGRect)frame LapTimes:(NSArray*)lapTimes andchronometerTotalTimeAtLap:(NSArray*)selectedLapTimes;

-(void)refreshTableViewWithLapTimes:(NSArray*)lapTimes andchronometerTotalTimeAtLap:(NSArray*)selectedLapTimes;

@end
