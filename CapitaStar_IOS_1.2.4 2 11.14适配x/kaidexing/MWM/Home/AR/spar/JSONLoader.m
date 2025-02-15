//
//  JSONLoader.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import "JSONLoader.h"

@implementation JSONLoader

+ (void)loadFromURL:(NSString *)url completionHandler:(void (^)(NSDictionary *jso, NSError *err)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
#pragma unused(progressHandler)

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                completionHandler(nil, error);
                return;
            }

            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                if (statusCode != 200) {
                    NSError *error = [NSError errorWithDomain:@"Non-200 status" code:statusCode userInfo:nil];
                    completionHandler(nil, error);
                }
            }

            NSError *err;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (err) {
                completionHandler(nil, error);
                return;
            }
            completionHandler(res, nil);
        }];

    [task resume];
}

@end
