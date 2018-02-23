//
//  CustomImagePickerController.m
//  ZBImagePickerController
//
//  Created by Kevin Zhang on 13-9-5.
//  Copyright (c) 2013年 zimbean. All rights reserved.
//

#import "CustomImagePickerController.h"
#import<QuartzCore/QuartzCore.h>
#import "frameView.h"

@interface CustomImagePickerController ()

@end

@implementation CustomImagePickerController

@synthesize customDelegate;

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
    
    self.delegate = self;
	// Do any additional setup after loading the view.
}


//切换前、后置摄像头
- (void)swapFrontAndBackCameras:(id)sender {
    if (self.cameraDevice ==UIImagePickerControllerCameraDeviceRear ) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

#pragma mark /////////////

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){

        //overlyView
//        UIView *overlyView = [[UIView alloc] initWithFrame:CGRectMake(0,  426, 320, 54)];
//        [overlyView setBackgroundColor:[UIColor redColor]];
        
        frameView *overlyView = [[NSBundle mainBundle] loadNibNamed:@"frameView" owner:self options:nil].firstObject;
        overlyView.frame = self.view.frame;
        
        [overlyView.backButton addTarget:self
                    action:@selector(closeView)
          forControlEvents:UIControlEventTouchUpInside];

        [overlyView.photoButton addTarget:self
                      action:@selector(takePicture)
            forControlEvents:UIControlEventTouchUpInside];
        
        [overlyView.flashButton addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
    
//        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        photoBtn.frame = CGRectMake(250, -5, 60, 44);
//        [photoBtn setTitle:@"ShowPhoto" forState:UIControlStateNormal];
//        [photoBtn addTarget:self
//                     action:@selector(showPhoto)
//           forControlEvents:UIControlEventTouchUpInside];
//        [overlyView addSubview:photoBtn];
        
        self.cameraOverlayView = overlyView;
    }
}

- (void)showPhoto
{
    super.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
}

- (void)closeView{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)takePicture{
    [super takePicture];
}


#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:NULL];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    if ([customDelegate respondsToSelector:@selector(cameraPhoto:)]) {
        [customDelegate cameraPhoto:image];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
