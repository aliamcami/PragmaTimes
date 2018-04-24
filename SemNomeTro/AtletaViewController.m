//
//  AtletaViewController.m
//  SemNomeTro
//
//  Created by camila oliveira on 4/24/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "AtletaViewController.h"
#import "GeneralController.h"

@interface AtletaViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic) NSMutableArray *autocompleteData;
@property (nonatomic) NSMutableArray *names;
@property (nonatomic) NSMutableArray *emails;
@property (nonatomic) GeneralController *gc;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AtletaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gc = [[GeneralController alloc] init];
    
    self.searchBar.delegate = self;
    
    self.names = [[NSMutableArray alloc] init];
    self.emails = [[NSMutableArray alloc] init];
    
    [self.gc adicionarAtleta:nil nome:nil foto:nil peso:nil altura:nil sexo:nil];
    for (Atleta *a in [self.gc todosAtletas]) {
        [self.names addObject:a.nome];
        [self.emails addObject:a.email];
    }
    
//    self.emails = [NSMutableArray arrayWithArray:@[@"Iaeow", @"Inteligencia", @"Iremar", @"Ipopotamo", @"Testando", @"Qualquer", @"Tatu", @"Vamo la", @"Ta Dificil", @"Ah nem"]];
//    
//    self.names = [NSMutableArray arrayWithArray:@[@"Iaeow", @"Inteligencia", @"Iremar", @"Ipopotamo", @"Testando", @"Qualquer", @"Tatu", @"Vamo la", @"Ta Dificil", @"Ah nem"]];
    
    self.autocompleteData = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.names count]; i++) {
        [self.autocompleteData addObject:[NSNumber numberWithInt:i]];
    }
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
//    self.tableView.clipsToBounds = NO;
//    self.tableView.layer.masksToBounds = NO;
//    
//    [self.tableView.layer setShadowColor:[[UIColor blackColor] CGColor]];
//    [self.tableView.layer setShadowOffset:CGSizeMake(0, 0)];
//    [self.tableView.layer setShadowRadius:5.0];
//    [self.tableView.layer setShadowOpacity:1];
    
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
//    self.tableView.hidden = YES;
//    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.autocompleteData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if ([self.autocompleteData count] > 0) {
        cell.textLabel.text = [self.names objectAtIndex:[[self.autocompleteData objectAtIndex:indexPath.row] intValue]];
        cell.detailTextLabel.text = [self.emails objectAtIndex:[[self.autocompleteData objectAtIndex:indexPath.row] intValue]];
    }
    
    return cell;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    self.textField = textField;
    
//    self.tableView.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y,
//                                      textField.frame.size.width, textField.frame.size.height + 75);
//    
//    self.tableView.hidden = YES;
    
    NSString *substring = [NSString stringWithString:searchBar.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:text];
    [self searchAutocompleteEntriesWithSubstring:substring];
    
    if (!([self.autocompleteData count] == 0)) {
//        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected = [[NSString alloc] initWithString:[self.autocompleteData objectAtIndex:indexPath.row]];
    
     [self performSegueWithIdentifier:@"apareceTatu" sender:self];
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    [self.autocompleteData removeAllObjects];
    for (int i = 0; i < [self.names count]; i++) {
        [self.autocompleteData addObject:[NSNumber numberWithInt:i]];
    }
    
    if (![substring  isEqual: @""]) {
        //    [self.autocompleteData removeAllObjects];
        substring = [substring lowercaseString];
        
        for (NSInteger i = [self.names count] - 1; i >= 0; i--) {
            NSString *lower = [[self.names objectAtIndex:i] lowercaseString];
            if (![lower hasPrefix:substring]) {
                [self.autocompleteData removeObjectAtIndex:i];
            }
        }
    }
}

@end
