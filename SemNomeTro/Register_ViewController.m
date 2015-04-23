//
//  Register_ViewController.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 22/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "Register_ViewController.h"
#import ""

@interface Register_ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswordConfirm;

@end

@implementation Register_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnRegister = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnContinue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    int lblSizeTxt = MIN(self.btnRegister.frame.size.width, self.btnRegister.frame.size.height);
    self.btnRegister.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:lblSizeTxt * 0.7];
    
    lblSizeTxt = MIN(self.btnContinue.frame.size.width, self.btnContinue.frame.size.height);
    self.btnContinue.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:lblSizeTxt * 0.7];
    
    self.btnContinue.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.btnRegister.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRegisterPressed:(id)sender
{
    
    
    
    
}

- (IBAction)onContinuePressed:(id)sender
{
    
}


@end