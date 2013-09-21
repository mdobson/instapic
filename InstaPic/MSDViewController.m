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

@interface MSDViewController ()

@end

@implementation MSDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    NSDictionary *data = @{@"type":@"assets", @"name":@"test.png", @"owner":@"95062f5a-ff60-11e2-b7d9-ad76f240f538", @"path":@"/test"};
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
                    NSLog(@"Good");
                }
            }];
        } else {
            NSLog(@"failure");
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
