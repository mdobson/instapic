//
//  MSDViewController.m
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "MSDViewController.h"
#import "MSDSharedClient.h"
#import <ApigeeiOSSDK/ApigeeDataClient.h>
#import <ApigeeiOSSDK/ApigeeOpenUDID.h>
#import <ApigeeiOSSDK/ApigeeActivity.h>
#import <CoreLocation/CoreLocation.h>

@interface MSDViewController ()

@end

@implementation MSDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //snipe location quickly
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.distanceFilter = kCLDistanceFilterNone;
    [self.manager startUpdatingLocation];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)selectPicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)uploadPicture:(id)sender {
    self.location = [self.manager location];
    [self.manager stopUpdatingLocation];
    ApigeeUser *user = [[MSDSharedClient sharedClient] getLoggedInUser];
    NSString *userUUID = [user getStringProperty:@"uuid"];
    NSString *picUUID = [NSString stringWithFormat:@"%i", arc4random()];
    NSString *picName = [NSString stringWithFormat:@"%@.png", picUUID];
    NSString *picPath = [NSString stringWithFormat:@"/%@/%@", picUUID, picName];
    NSString *activityContent = [NSString stringWithFormat:@"%@ uploaded a new pic!", user.username];
    
    NSDictionary *loc = @{@"latitude":[NSString stringWithFormat:@"%f",self.location.coordinate.latitude],@"longitude":[NSString stringWithFormat:@"%f",self.location.coordinate.longitude]};
    NSDictionary *data = @{@"type":@"assets", @"name":picName, @"owner":userUUID, @"path":picPath, @"location":loc};
    [[MSDSharedClient sharedClient] createEntity:data completionHandler:^(ApigeeClientResponse* response){
        if(response.transactionState == kApigeeClientResponseSuccess) {
            NSDictionary *entity = response.response[@"entities"][0];
            NSString *uuid = entity[@"uuid"];
            NSLog(@"UUID:%@", uuid);
            NSString *url = [NSString stringWithFormat:@"https://api.usergrid.com/mdobson/sandbox/assets/%@/data", uuid];
            NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
            NSURL *endpoint = [NSURL URLWithString:url];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:endpoint];
            [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
            request.HTTPMethod = @"POST";
            [request setHTTPBody:imageData];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                if (error) {
                    NSLog(@"%@", error.description);
                } else {
                    ApigeeActivity *activity = [[ApigeeActivity alloc] init];
                    [activity setActorInfo:user.username
                          actorDisplayName:user.username
                                 actorUUID:userUUID];
                    
                    [activity setBasics:@"post"
                               category:@"post"
                                content:activityContent
                                  title:@"Photo Post"];
                    if ([activity isValid]) {
                        [[MSDSharedClient sharedClient] postUserActivity:@"me"
                                                                activity:activity
                                                       completionHandler:^(ApigeeClientResponse *response){
                                                           if (response.transactionState == kApigeeClientResponseSuccess) {
                                                               UIAlertView * alert = [[UIAlertView alloc]
                                                                                      initWithTitle:@"Sucess"
                                                                                      message:@"Uploaded!"
                                                                                      delegate:nil
                                                                                      cancelButtonTitle:@"Close"
                                                                                      otherButtonTitles:nil];
                                                               [alert show];
                                                           } else {
                                                               NSLog(@"error");
                                                           }
                                                       }];
                        
                    } else {
                        NSLog(@"invalid");
                    }
                    NSLog(@"Good");
                }
            }];
        } else {
            NSLog(@"failure");
            NSLog(@"reason:%@", response.rawResponse);
        }
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
