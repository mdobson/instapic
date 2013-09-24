//
//  MSDSignupViewController.m
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDSignupViewController.h"
#import "MSDSharedClient.h"
#import "KeychainItemWrapper.h"

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
    
    NSString *deviceId = [ApigeeDataClient getUniqueDeviceID];
    [[MSDSharedClient sharedClient] addUser:username
                                      email:email
                                       name:username
                                   password:password
                          completionHandler:^(ApigeeClientResponse *response){
                              if (response.transactionState == kApigeeClientResponseSuccess) {
                                  if (deviceId != nil) {
                                      //Hacky way of snagging uuid of user.
                                      NSString *uuid = response.response[@"entities"][0][@"uuid"];
                                      //Give user this device.
                                      [[MSDSharedClient sharedClient] connectEntities:@"users"
                                                                          connectorID:uuid
                                                                                 type:@"devices"
                                                                          connecteeID:deviceId
                                                                    completionHandler:^(ApigeeClientResponse *response){
                                                                        if (response.transactionState == kApigeeClientResponseSuccess) {
                                                                            NSLog(@"registered");
                                                                        } else {
                                                                            NSLog(@"error");
                                                                        }
                                                                    }];
                                  }
                                  [MSDSharedClient saveUsername:username andPassword:password];
                                  [self performSegueWithIdentifier:@"takePicture" sender:self];
                              } else {
                                  NSLog(@"error");
                              }
                          }];
}

@end
