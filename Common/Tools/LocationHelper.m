//
//  LocationHelper.m
//  POS2iPhone
//
//  Created by  STH on 12/8/12.
//  Copyright (c) 2012 RYX. All rights reserved.
//

/**
 From Apple documentation:
 
 Configuration of your location manager object must always occur on a thread with an active run loop, such as your application’s main thread.
 **/

#import "LocationHelper.h"

@implementation LocationHelper

@synthesize locationManager = _locationManager;

static LocationHelper *instance = nil;

+ (LocationHelper *) sharedLocationHelper
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[LocationHelper alloc] init];
        }
    }
    
    return instance;
}

- (void) startLocate
{
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted) {
           
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.purpose = [NSString stringWithFormat:@"为保证交易安全，%@需要取得您的交易地点，否则无法进行交易", @"众易付"];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            self.locationManager.distanceFilter = 1000.0f;
            
            [self.locationManager startUpdatingLocation];
            //[self.locationManager startMonitoringSignificantLocationChanges];
            
        } else {
            NSLog(@"手机定位服务已打开，但是众易付没有获得定位权限.");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"为了保证交易安全，强烈建议您打开手机定位服务，并允许%@访问您的位置。",@"众易付"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } else {
        NSLog(@"手机没有打开定位服务.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"为了保证交易安全，强烈建议您打开手机定位服务，并允许%@访问您的位置。",@"众易付"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLGeocoder *geocode = [[CLGeocoder alloc] init];
    [geocode reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
//            NSLog(@"name = %@", placemark.name);
//            NSLog(@"thoroughfare = %@", placemark.thoroughfare);
//            NSLog(@"subThoroughfare = %@", placemark.subThoroughfare);
//            NSLog(@"locality = %@", placemark.locality);
//            NSLog(@"subLocality = %@", placemark.subLocality);
//            NSLog(@"administrativeArea = %@",placemark.administrativeArea);
//            NSLog(@"subAdministrativeArea = %@",placemark.subAdministrativeArea);
//            NSLog(@"Postal Code = %@", placemark.postalCode);
//            NSLog(@"ISOcountryCode = %@", placemark.ISOcountryCode);
//            NSLog(@"Country = %@", placemark.country);
//            NSLog(@"inlandWater = %@", placemark.inlandWater);
//            NSLog(@"ocean = %@", placemark.ocean);
//            NSLog(@"areasOfInterest = %@",placemark.areasOfInterest);
//            
//            NSLog(@"addressDictionary = %@",placemark.addressDictionary);
//            NSLog(@"location = %@",placemark.location);
//            NSLog(@"region = %@",placemark.region);
         
            
            APPDataCenter.userInfoDict = [[NSMutableDictionary alloc]init];
            [APPDataCenter.userInfoDict setValue:placemark.name forKey:kAddress];
            [APPDataCenter.userInfoDict setValue:[NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude] forKey:kLongitude];
            [APPDataCenter.userInfoDict setValue:[NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude] forKey:kLatitude];
            
            NSLog(@"用户位置：%@",APPDataCenter.userInfoDict);

        } else if (error == nil && [placemarks count] == 0){
            NSLog(@"No results were returned.");
            
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

// 当定位出现错误时就会调用这个方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location:=======================");
}

// 定位服务权限发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Location:----------------------%d", status);
}

@end
