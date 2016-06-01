//
//  ViewController.m
//  SVProgressHUD
//
//  Created by 杨修涛 on 16/6/1.
//  Copyright © 2016年 Yangxiutao. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD.h>
#import "RequestManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SVProgressHUDBaseUse:(id)sender {
    
    
    //显示HUD
    [SVProgressHUD showWithStatus:@"AAA"]; //设置需要显示的文字
    
    /**
     *  设置HUD显示的样式
     *
     *  SVProgressHUDStyleLight : white HUD with black text
     *
     *  SVProgressHUDStyleDark : black HUD and white text
     *
     *  SVProgressHUDStyleCustom: Custome
     */
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];//设置HUD的Style
    [SVProgressHUD setForegroundColor:[UIColor redColor]];//设置HUD和文本的颜色
    [SVProgressHUD setBackgroundColor:[UIColor magentaColor]];//设置HUD的背景颜色
    
    /**
     *  设置HUD背景图层的样式
     *
     *  SVProgressHUDMaskTypeNone：默认图层样式，当HUD显示的时候，允许用户交互。
     *
     *  SVProgressHUDMaskTypeClear：当HUD显示的时候，不允许用户交互。
     *
     *  SVProgressHUDMaskTypeBlack：当HUD显示的时候，不允许用户交互，且显示黑色背景图层。
     *
     *  SVProgressHUDMaskTypeGradient：当HUD显示的时候，不允许用户交互，且显示渐变的背景图层。
     *
     *  SVProgressHUDMaskTypeCustom：当HUD显示的时候，不允许用户交互，且显示背景图层自定义的颜色。
     */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom]; //设置HUD背景图层的样式
    
    
    //取消显示HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (IBAction)SVProgressHUDStyle:(id)sender {
    
    NSArray *imgArray = @[@"http://e.hiphotos.baidu.com/image/pic/item/7e3e6709c93d70cfe7317e04fadcd100bba12bf4.jpg",
                          @"http://img.ugirls.com/uploads/cooperate/baidu/20160519menghuli.jpg",
                          @"http://a.hiphotos.baidu.com/image/pic/item/55e736d12f2eb938d3de795ad0628535e4dd6fe2.jpg",
                          @"http://c.hiphotos.baidu.com/image/pic/item/78310a55b319ebc4856784ed8126cffc1e1716a2.jpg",
                          @"http://b.hiphotos.baidu.com/image/pic/item/91529822720e0cf366e3f1bd0f46f21fbe09aa64.jpg",
                          @"http://b.hiphotos.baidu.com/image/pic/item/f603918fa0ec08faf0f7ace15cee3d6d54fbda85.jpg"];
    
    int i = arc4random()%imgArray.count;
    
    NSString *imgFilePath = imgArray[i];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];//设置HUD的Style
    [SVProgressHUD showProgress:0 status:@"开始下载，请稍后..."];
    
    [RequestManager downLoadFileWithURL:imgFilePath progress:^(int64_t bytesRead, int64_t totalBytesRead) {
        
        
        NSLog(@"viewController ==== %lld",bytesRead/totalBytesRead);
            
        
        
        
    } success:^(id response) {
//        [SVProgressHUD showImage:[UIImage imageNamed:@"success"] status:@"下载完成！"];
        [SVProgressHUD showSuccessWithStatus:@"下载完成！"];
        self.imgView.image = [UIImage imageWithContentsOfFile:response];
        NSLog(@"%@",response);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"下载失败！"];
        
        
    }];
}

@end
