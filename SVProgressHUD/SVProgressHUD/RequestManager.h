//
//  RequestManager.h
//  aa
//
//  Created by 杨修涛 on 16/1/22.
//  Copyright © 2016年 杨修涛. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestManager : NSObject

//AFNetworking  封装之GET
+ (void)requestDataWithGET:(NSString *)URLString header:(NSDictionary *)header parameters:(id)parameters success:(void(^)(NSDictionary *dic))success failure:(void(^)(NSError *error))failure;


//AFNetworking  封装之POST
+ (void)requestDataWithPOST:(NSString *)URLString header:(NSDictionary *)header parameters:(id)parameters success:(void(^)(NSDictionary *dic))success failure:(void(^)(NSError *error))failure;

 

+ (void)downLoadFileWithURL:(NSString *)URL progress:(void(^)(int64_t bytesRead,int64_t totalBytesRead))progress success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;



@end
