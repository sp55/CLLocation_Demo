//
//  ViewController.m
//  CLLocation_Demo
//
//  Created by admin on 16/6/5.
//  Copyright © 2016年 AlezJi. All rights reserved.
//
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>{
    MKMapView* _mapView;
    CLLocationManager* _manager;
    
    CLGeocoder *_geoC;
}

@property(copy,nonatomic)NSString *lat;//纬度
@property(copy,nonatomic)NSString *lon;//经度

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:_mapView];
    
    _manager = [[CLLocationManager alloc] init];
    //ios8
    [_manager requestAlwaysAuthorization];
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.distanceFilter = 10;
    _manager.delegate = self;
    [_manager startUpdatingLocation];
    [_manager startUpdatingHeading];
    
    
    //地理编码
    _geoC = [[CLGeocoder alloc] init];


}

//定位方向成功
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
//    NSLog(@"%lf", newHeading.trueHeading);
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //拿到定位的位置
    CLLocation* location = [locations lastObject];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region animated:YES];
    
    
//    NSLog(@"--纬度--%f--经度--%f",location.coordinate.latitude,location.coordinate.longitude);
    self.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    self.lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];

    
    
    //停止定位
    [_manager stopUpdatingLocation];
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
}


#pragma mark - 保存
- (IBAction)saveAction:(id)sender {
    
//    NSLog(@"==纬度=%@==经度=%@",self.lat,self.lon);
    
    
//    double latitude = [self.latitudeTF.text doubleValue];
//    double longitude = [self.longitudeTF.text doubleValue];
    
    double latitude = [self.lat doubleValue];
    double longitude = [self.lon doubleValue];
    
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 反地理编码(经纬度---地址)
    [_geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            
            NSLog(@"=地址详情==%@%@%@%@\n 纬度==%f\n 经度==%f",pl.locality,pl.subLocality,pl.thoroughfare,pl.name,pl.location.coordinate.latitude,pl.location.coordinate.longitude);

//            self.addressTV.text = pl.name;
//            self.latitudeTF.text = @(pl.location.coordinate.latitude).stringValue;
//            self.longitudeTF.text = @(pl.location.coordinate.longitude).stringValue;
        }else
        {
            NSLog(@"错误");
        }
    }];
    
}

#pragma mark - 反编码
- (IBAction)regGeo:(id)sender {
    [_geoC geocodeAddressString:@"上海市灵验南路地铁站" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // CLPlacemark : 地标
        // location : 位置对象
        // addressDictionary : 地址字典
        // name : 地址详情
        // locality : 城市
        
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            
            
            NSLog(@"=地址详情==%@%@%@%@\n 纬度==%f\n 经度==%f",pl.locality,pl.subLocality,pl.thoroughfare,pl.name,pl.location.coordinate.latitude,pl.location.coordinate.longitude);
            
            //            self.addressTV.text = pl.name;
            //            self.latitudeTF.text = @(pl.location.coordinate.latitude).stringValue;
            //            self.longitudeTF.text = @(pl.location.coordinate.longitude).stringValue;
        }else
        {
            NSLog(@"错误");
        }
    }];

}

@end
