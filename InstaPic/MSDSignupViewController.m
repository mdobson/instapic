//
//  MSDSignupViewController.m
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDSignupViewController.h"
#import "MSDSharedClient.h"

@interface MSDSignupViewController ()

@end

@implementation MSDSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    NSString *email = self.email.text;
    [[MSDSharedClient sharedClient] addUser:username
                                      email:email
                                       name:username
                                   password:password
                          completionHandler:^(ApigeeClientResponse *response){
                              if (response.transactionState == kApigeeClientResponseSuccess) {
                                  [self performSegueWithIdentifier:@"takePicture" sender:self];
                              } else {
                                  NSLog(@"error");
                              }
                          }];
}

@end
