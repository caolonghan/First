//
//  ARViewController.m
//  RTMARDemo
//
//  Copyright © 2017年 智慧图. All rights reserved.
//

#import "RTMARViewController.h"
#import "RTARView.h"
#import "RTPOI.h"
#import "ShopDetailsTableViewController.h"


@interface RTMARViewController ()<RTARViewDelegate,ShopDetailsDelegate>
@property (nonatomic, strong) RTARView * arView;
@end

@implementation RTMARViewController
- (RTARView *)arView{
    if (!_arView) {
        RTPOI * poi = [[RTPOI alloc] init];
        poi.floorID = self.fid;
        poi.buildingID = self.bid;
        _arView = [[RTARView alloc] initWithBuildingID:nil floorID:nil];
        _arView.delegate = self;
        _arView.radius = 60;
        _arView.distance = 10;
        _arView.deflectionDistance = 6;
        _arView.locationPoint = self.locationPoint;
        _arView.isARNavigation = self.isARNavigation;
        [self.view addSubview:_arView];
    }
    return _arView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.arView];
    
    [self.arView start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rTARView:(RTARView *)aRView didDisappearType:(RTARType)type destinationPOI:(RTPOI *)destinationPOI{
    __block RTPOI * poi = destinationPOI;
    if (self.returnBlock&&_isARNavigation) {
        self.returnBlock(poi);
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}


- (void)userTouchPoiDetails:(RTPOI *)poi{
    ShopDetailsTableViewController * shopDetails = [[UIStoryboard storyboardWithName:@"AR" bundle:nil] instantiateViewControllerWithIdentifier:@"ShopDetailsTableViewController"];
    shopDetails.poi   = poi;
    shopDetails.delegate = self;
    [self.navigationController pushViewController:shopDetails animated:YES];
}

- (void)didStartedOfARView:(RTARView *) aRView{
    if (self.destinationPOI&&_isARNavigation) {
        [aRView navigateToPOI:self.destinationPOI];
    }
}

- (void)userTouchGoHere:(RTPOI*)poi{
    [_arView navigateToPOI:poi];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
