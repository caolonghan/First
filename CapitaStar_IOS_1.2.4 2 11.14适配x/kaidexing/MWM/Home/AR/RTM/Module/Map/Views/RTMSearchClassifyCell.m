//
//  RTMSearchClassifyCell.m
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import "RTMSearchClassifyCell.h"
#import "UIImageView+WebCache.h"

@interface RTMSearchClassifyCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RTMSearchClassifyCell
- (void)setClassifyInfo:(NSDictionary *)info{
    [self.imageView setImageWithURL:[NSURL URLWithString:info[@"imageUrl"]]];
    self.titleLabel.text = info[@"name"];
}
@end
