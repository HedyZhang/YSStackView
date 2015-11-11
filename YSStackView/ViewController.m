//
//  ViewController.m
//  YSStackView
//
//  Created by yanshu on 15/11/10.
//  Copyright © 2015年 焱厽. All rights reserved.
//

#import "ViewController.h"
#import "YSStackView.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<YSStackViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    YSStackView *stackView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    stackView = [[YSStackView alloc] initWithFrame:CGRectMake(0, 100, 320, 300)];
    stackView.addImage = [UIImage imageNamed:@"chat_setmode_add"];
    stackView.deleteTipImage = [UIImage imageNamed:@"icon_delete.png"];
    stackView.isAllowedDeleteMember = YES;
    stackView.stackViewDelegate = self;
    stackView.limit = 4;
    [self.view addSubview:stackView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 50, 100, 30);
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(getAllPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)getAllPhoto
{
   NSArray *imageArray = [stackView getAllMember];
    NSLog(@"---%@", imageArray);
}

- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath
{
    
}
- (void)addImageClicked
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
#pragma clang diagnostic pop
    [actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    picker.allowsEditing = YES;
    switch (buttonIndex)
    {
        case 0:
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }break;
        case 1:
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } break;
        case 2:
        {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:0];
            return;
        }
        default:
            break;
    }
 
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [stackView addMember:image];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
