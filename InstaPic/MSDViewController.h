//
//  MSDViewController.h
//  InstaPic
//
//  Created by Matthew Dobson on 9/21/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ApigeeiOSSDK/ApigeeClient.h>
#import <CoreLocation/CoreLocation.h>

@interface MSDViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) CLLocationManager *manager;
@property (retain, nonatomic) CLLocation *location;
- (IBAction)takePicture:(id)sender;
- (IBAction)selectPicture:(id)sender;
- (IBAction)uploadPicture:(id)sender;

@end
