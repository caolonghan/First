//
//  DataMD5.m
//  WeChatDemo
//
//  Created by 尹俊雄 on 15/7/2.
//  Copyright (c) 2015年 yjx. All rights reserved.
//

#import "DataMD5.h"
#import <CommonCrypto/CommonDigest.h>

#pragma mark - 需要配置的参数


// 开放平台登录https://open.weixin.qq.com的开发者中心获取APPID
//#define WX_APPID @"wxd21d890******"
// 开放平台登录https://open.weixin.qq.com的开发者中心获取AppSecret。
//#define WX_APPSecret @"fc32dfae9******edc5eb5f77dddd4ea5"
// 微信支付商户号
//#define MCH_ID  @"1353******02"
// 安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com
// 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
#define WX_PartnerKey @"5d79c61cf65b8de7a1101468e14a16a3"


#pragma mark - 统一下单请求参数键值

// 应用id
#define WXAPPID @"appid"
// 商户号
#define WXMCHID @"mch_id"
// 随机字符串
#define WXNONCESTR @"nonce_str"
// 签名
#define WXSIGN @"sign"
// 商品描述
#define WXBODY @"body"
// 商户订单号
#define WXOUTTRADENO @"out_trade_no"
// 总金额
#define WXTOTALFEE @"total_fee"
// 终端IP
#define WXEQUIPMENTIP @"spbill_create_ip"
// 通知地址
#define WXNOTIFYURL @"notify_url"
// 交易类型
#define WXTRADETYPE @"trade_type"
// 预支付交易会话
#define WXPREPAYID @"prepay_id"


@interface DataMD5()

@property (nonatomic,strong) NSString *appid;
@property (nonatomic,strong) NSString *mch_id;
@property (nonatomic,strong) NSString *nonce_str;
@property (nonatomic,strong) NSString *partnerkey;
@property (nonatomic,strong) NSString *body;
@property (nonatomic,strong) NSString *out_trade_no;
@property (nonatomic,strong) NSString *total_fee;
@property (nonatomic,strong) NSString *spbill_create_ip;
@property (nonatomic,strong) NSString *notify_url;
@property (nonatomic,strong) NSString *trade_type;

@end

@implementation DataMD5

#pragma makr - 懒加载

- (NSMutableDictionary *)dic
{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

#pragma mark - Config

-(instancetype)initWithAppid:(NSString *)appid_key
                      mch_id:(NSString *)mch_id_key
                   nonce_str:(NSString *)noce_str_key
                  partner_id:(NSString *)partner_id
                        body:(NSString *)body_key
               out_trade_no :(NSString *)out_trade_no_key
                   total_fee:(NSString *)total_fee_key
            spbill_create_ip:(NSString *)spbill_create_ip_key
                  notify_url:(NSString *)notify_url_key
                  trade_type:(NSString *)trade_type_key
{
    if (self = [super init]) {
        
        _appid          = appid_key;
        _mch_id         = mch_id_key;
        _nonce_str      = noce_str_key;
        _partnerkey     = partner_id;
        _body           = body_key;
        _out_trade_no   = out_trade_no_key;
        _total_fee      = total_fee_key;
        _spbill_create_ip = spbill_create_ip_key;
        _notify_url     = notify_url_key;
        _trade_type     = trade_type_key;
        
        [self.dic setValue:_appid forKey:WXAPPID];
        [self.dic setValue:_mch_id forKey:WXMCHID];
        [self.dic setValue:_nonce_str forKey:WXNONCESTR];
        [self.dic setValue:_body forKey:WXBODY];
        [self.dic setValue:_out_trade_no forKey:WXOUTTRADENO];
        [self.dic setValue:_total_fee forKey:WXTOTALFEE];
        [self.dic setValue:_spbill_create_ip forKey:WXEQUIPMENTIP];
        [self.dic setValue:_notify_url forKey:WXNOTIFYURL];
        [self.dic setValue:_trade_type forKey:WXTRADETYPE];
        
        [self createMd5Sign:self.dic];
    }
    return self;
}


//创建签名
//签名算法
//签名生成的通用步骤如下：
//第一步，设所有发送或者接收到的数据为集合M，将集合M内非空参数值的参数按照参数名ASCII码从小到大排序（字典序），使用URL键值对的格式（即key1=value1&key2=value2…）拼接成字符串stringA。
//特别注意以下重要规则：
//◆ 参数名ASCII码从小到大排序（字典序）；
//◆ 如果参数的值为空不参与签名；
//◆ 参数名区分大小写；
//◆ 验证调用返回或微信主动通知签名时，传送的sign参数不参与签名，将生成的签名与该sign值作校验。
//◆ 微信接口可能增加字段，验证签名时必须支持增加的扩展字段
//第二步，在stringA最后拼接上key得到stringSignTemp字符串，并对stringSignTemp进行MD5运算，再将得到的字符串所有字符转换为大写，得到sign值signValue。
//key设置路径：微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置

-(void)createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    
    NSArray *keys = [dict allKeys];
    
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@",_partnerkey];
    
    //MD5 获取Sign签名
    NSString *md5Sign =[self md5:contentString];
    
    //  
    [self.dic setValue:md5Sign forKey:@"sign"];
    
}


//创建发起支付时的sign签名

-(NSString*)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:WXSIGN]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    NSLog(@"%@",contentString);
    //添加商户密钥key字段
//#warning 注意此处一定要添加上商户密钥
    [contentString appendFormat:@"key=%@", WX_PartnerKey];
    NSString *result = [self md5:contentString];

    return result;
}

-(NSString*)createMD5SingForPay:(NSMutableDictionary *)signParams{
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:WXSIGN]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    NSLog(@"%@",contentString);
    //添加商户密钥key字段
//#warning 注意此处一定要添加上商户密钥
    [contentString appendFormat:@"key=%@", WX_PartnerKey];
    NSString *result = [self md5:contentString];
    
    return result;
}



// MD5加密算法
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
}

@end
