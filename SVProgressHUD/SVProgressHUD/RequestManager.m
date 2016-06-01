//
//  RequestManager.m
//  aa
//
//  Created by 杨修涛 on 16/1/22.
//  Copyright © 2016年 杨修涛. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking.h>
//#import "NSURL+MD5.h"
#import <SVProgressHUD.h>
@implementation RequestManager


#pragma mark -
#pragma mark - AFNetworking 之 文件下载

+ (void)downLoadFileWithURL:(NSString *)URL progress:(void (^)(int64_t, int64_t))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    //远程地址
    NSURL *URLStr = [NSURL URLWithString:URL];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URLStr];
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        
        // @property int64_t completedUnitCount; 当前已经下载的大小
        // 给Progress添加监听 KVO
        
        NSMutableArray *t =[NSMutableArray arrayWithObjects:@"0",@"0", nil];
        float p1 = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        [t replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",p1]];
        
        NSLog(@"data === %f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
      [SVProgressHUD showProgress:1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount status:@"正在下载，请稍后..."];
       progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
       
        
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) { 
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        
        
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:path];
        
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        if (error) {
            failure(error);
        }else{
            success(imgFilePath);
        }
    }];

    
    [downloadTask resume];
}

#pragma mark - 
#pragma mark - AFNetworking封装之GET

+ (void)requestDataWithGET:(NSString *)URLString header:(NSDictionary *)header parameters:(id)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    //创建manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //按情况打开JSON序列化
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    //为了安全不保存 cookie
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    //超时
    manager.requestSerializer.timeoutInterval = 30;
    
    //设置Header(appkey)  需设置key
    [manager.requestSerializer setValue:[header valueForKey:@"apikey"] forHTTPHeaderField:@"apikey"];
    
    //设置type
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", nil];
    
    //判断 URL
    NSString *URL = URLString;
    //https or http
    if ([URL hasPrefix:@"https"]) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
    }
    
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
 

}


#pragma mark -
#pragma mark - AFNetworking封装之POST

+ (void)requestDataWithPOST:(NSString *)URLString header:(NSDictionary *)header parameters:(id)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    //设置manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置type
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript",@"text/html",@"text/plain", nil];
    
    //按情况打开JSON序列
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //为了安全不保存 cookie
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    //超时
    manager.requestSerializer.timeoutInterval = 20;
    
    //判断 URL
    NSString *URL = URLString;
    //https or http
    if ([URL hasPrefix:@"https"]) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
    }
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
 
}



@end
