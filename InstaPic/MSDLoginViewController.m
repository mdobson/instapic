//
//  MSDLoginViewController.m
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDLoginViewController.h"
#import "MSDSharedClient.h"
#import "KeychainItemWrapper.h"

@interface MSDLoginViewController ()

@end

@implementation MSDLoginViewController

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
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"me.mdob.instapic" accessGroup:nil];
    NSString *username = [wrapper objectForKey:(__bridge id) kSecAttrAccount];
    NSString *password = [wrapper objectForKey:(__bridge id) kSecValueData];
    NSLog(@"u:%@", username);
    if ( [username length] != 0 && [password length] != 0 && username != nil && password != nil) {
        [self authenticate:password username:username];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)authenticate:(NSString *)password username:(NSString *)username {
    [[MSDSharedClient sharedClient] logInUser:username
                                     password:password
                            completionHandler:^(ApigeeClientResponse*response){
                                if (response.transactionState == kApigeeClientResponseSuccess) {
                                    //This is the signing up users device.
                                    [self performSegueWithIdentifier:@"takePicture" sender:self];
                                } else {
                                    NSLog(@"error login");
                                }
                            }];
}

- (IBAction)login:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    [MSDSharedClient saveUsername:username andPassword:password];
    [self authenticate:password username:username];
}
@end
