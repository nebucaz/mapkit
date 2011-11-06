//
//  ViewController.m
//  MapCrash
//
//  Created by Oliver Hofer on 05.11.11.
//  Copyright (c) 2011 page.gaent GmbH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
    @property (nonatomic) BOOL isOverlayAdded; 
    @property (nonatomic, retain) MKPolygon *staticPolygon;
@end

@implementation ViewController
@synthesize theMapView;
@synthesize staticPolygon;
@synthesize isOverlayAdded;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.theMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.33182,-122.03118),MKCoordinateSpanMake(0.013451,0.013733))]; 
    
    self.isOverlayAdded = NO;
    
    // create polygon with 4 points to be added to the mapview
    double lat = 37.33182;
    double lon = -122.03118;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * 4);
    
    coords[0] = CLLocationCoordinate2DMake(lat, lon);
    coords[1] = CLLocationCoordinate2DMake(lat-0.1, lon-0.1);
    coords[2] = CLLocationCoordinate2DMake(lat+0.1, lon-0.1);
    coords[3] = CLLocationCoordinate2DMake(lat, lon);
    
    self.staticPolygon = [MKPolygon polygonWithCoordinates:coords count:4];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{

    MKPolygonView *polyView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon *)overlay];
    polyView.strokeColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    polyView.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.4];
    polyView.lineWidth = 1.0;
    
    return [polyView autorelease];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    // do not add nil-poly and only add the polygon once...
    if (self.staticPolygon != nil) {
        [mapView addOverlay:(id<MKOverlay>)self.staticPolygon];
        self.isOverlayAdded = YES;
        NSLog(@"did add polygon");
    }
}


@end
