//
//  ViewController.m
//  SRAlbum
//
//  Created by 施峰磊 on 2017/4/6.
//  Copyright © 2017年 sfl. All rights reserved.
//

#import "ViewController.h"
#import "SRAlbumViewController.h"
#import <Photos/Photos.h>
#import "SRPhotoEidtViewController.h"//编辑
#import "SRAlbumHelper.h"
#import "SRVideoCaptureViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CustomImagePickerController.h"

@interface ViewController ()<UINavigationControllerDelegate, CustomImagePickerControllerDelegate, SRAlbumControllerDelegate,SRPhotoEidtViewDelegate,SRVideoCaptureViewControllerDelegate>



@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)action:(UIButton *)sender {
    SRAlbumViewController *vc = [[SRAlbumViewController alloc] init];
    vc.resourceType = 1;
    vc.albumDelegate = self;
    vc.maxItem = 3;
    vc.videoMaximumDuration = 5;
//    vc.isCanShot = YES;
    //编辑页的对象名,可以自定义
    vc.eidtClass = [SRPhotoEidtViewController class];
    //编辑页接收图片的对象名
    vc.eidtSourceName = @"imageSource";
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)vedioAction:(UIButton *)sender {
    
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    [imagePickerController.navigationBar setBarStyle:UIBarStyleBlack];
//    imagePickerController.delegate = self;
//    imagePickerController.allowsEditing = YES;
//
//    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePickerController.showsCameraControls = NO;
//    imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//    UIView *framView = [[NSBundle mainBundle] loadNibNamed:@"frameView" owner:self options:nil].firstObject;
//    framView.frame = self.view.frame;
//
//    imagePickerController.cameraOverlayView = framView;
//    [self presentViewController:imagePickerController animated:YES completion:^{
//
//    }];
    CustomImagePickerController *imagepickerCtrl = [[CustomImagePickerController alloc] init];
    
    imagepickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagepickerCtrl.customDelegate = self;
    imagepickerCtrl.showsCameraControls = NO;
    [self presentViewController:imagepickerCtrl animated:YES completion:NULL];

     
}
- (IBAction)selectMedia:(UIButton *)sender {
    SRAlbumViewController *vc = [[SRAlbumViewController alloc] init];
    vc.resourceType = 0;
    vc.albumDelegate = self;
    vc.maxItem = 1;
    vc.videoMaximumDuration = 5;
    //    //编辑页的对象名,可以自定义
    //    vc.eidtClass = [SRPhotoEidtViewController class];
    //    //编辑页接收图片的对象名
    //    vc.eidtSourceName = @"imageSource";
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - SRVideoCaptureViewControllerDelegate
/**
 TODO:拍照或者录像已经确定完成和选择
 
 @param content 照片或者视频地址
 @param isVedio 是否是视频
 */
- (void)videoCaptureViewDidFinishWithContent:(id)content isVedio:(BOOL)isVedio{
    NSLog(@"%@ %@",content,isVedio?@"视频":@"图片");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SRAlbumControllerDelegate

/**
 TODO:已经选择了视频或者照片
 
 @param content 视频或者照片
 @param isVedio 是否是视频
 @param viewController 相册
 */
- (void)srAlbumDidSeletedFinishWithContent:(id)content isVedio:(BOOL)isVedio viewController:(SRAlbumController *)viewController{
    if ([content isKindOfClass:[NSURL class]]) {
        NSLog(@"%@",[SRAlbumHelper thumbnailImageForVideo:content atTime:1]);
    }
    NSLog(@"%@",content);
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SRPhotoEidtViewDelegate
/**
 TODO:图片编辑完成
 
 @param datas 图片数组
 @param viewController 编辑页面
 */
- (void)didEidtEndWithDatas:(NSArray *)datas viewController:(SRPhotoEidtViewController *)viewController{
    for (UIImage *image in datas) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark CustomImagePickerControllerDelegate
- (void)cameraPhoto:(UIImage *)image{

    SRPhotoEidtViewController *vc = [SRPhotoEidtViewController new];
    vc.delegate = self;
    vc.imageSource = @[image];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)cancelCamera{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
     UIImageWriteToSavedPhotosAlbum(photoImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
    SRPhotoEidtViewController *vc = [SRPhotoEidtViewController new];
    vc.delegate = self;
    vc.imageSource = @[photoImage];
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
