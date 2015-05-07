//
//  DataTreinoController.h
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 28/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataTreinoController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *email;

@end
