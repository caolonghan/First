//
//  XLCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWMPageControl.h"

@protocol XLCycleScrollViewDelegate;
@protocol XLCycleScrollViewDatasource;

@interface XLCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    MWMPageControl *_pageControl;
    
    id<XLCycleScrollViewDelegate> _delegate;
    id<XLCycleScrollViewDatasource> _datasource;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<XLCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<XLCycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
-(void)nextPage;

@end

@protocol XLCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol XLCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex1:(NSInteger)index;

@end
