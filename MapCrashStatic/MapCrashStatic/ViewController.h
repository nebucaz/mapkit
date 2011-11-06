//
//  ViewController.h
//  MapCrash
//
//  Created by Oliver Hofer on 05.11.11.
//  Copyright (c) 2011 page.gaent GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *theMapView;

@end
