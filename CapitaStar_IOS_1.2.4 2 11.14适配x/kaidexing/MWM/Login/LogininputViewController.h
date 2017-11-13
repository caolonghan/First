//
//  LogininputViewController.h
//  kaidexing
//
//  Created by company on 2017/8/30.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "WXApiObject.h"
//门禁接口
#define APIDOMAIN @"http://ocrm.capitaland.com.cn:8088"
//#define APIDOMAIN @"https://ocrm.capitaland.com.cn/api_proxy"
//#define APIDOMAIN @"http://cnliutao1.chinacloudapp.cn:8080"

typedef enum{
    pwd=0,
    code,
    forgetpwd
}typea;
@interface LogininputViewController : BaseViewController

@property(assign,nonatomic)typea type;
@property(strong,nonatomic)NSString *phonenum;
@property(strong,nonatomic)NSString* unionid;


@end
