//
//  ViewController.m
//  MapCrash
//
//  Created by Oliver Hofer on 05.11.11.
//  Copyright (c) 2011 page.gaent GmbH. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize theMapView;

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
    NSLog(@"regionWillChangeAnimated");
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

    NSLog(@"regionDidChangeAnimated");
    
    MKCoordinateRegion region = self.theMapView.region;
    
    double lon = region.center.longitude;
    double lat = region.center.latitude;
    
    NSString *dummyPolygon = [NSString stringWithFormat:@"POLYGON ((%f %f, %f %f, %f %f, %f %f))",
            lon,lat, lon-0.01, lat-.01, lon+0.01,lat-0.01, lon,lat]; 
    [mapView addOverlay:(id<MKOverlay>)[self parseShapeWKT:dummyPolygon]];
}


- (int) makeCoords:(NSString*) wktCoords coordsArray:(CLLocationCoordinate2D **) coordsOut {
    int read = 0;
    
    NSArray *tuples = [wktCoords componentsSeparatedByString:@","];
    NSInteger bufferSize = sizeof(CLLocationCoordinate2D) * [tuples count];
    CLLocationCoordinate2D *coords = malloc(bufferSize);
    
    for (NSString *tuple in tuples) {
        float lat, lon;
        NSScanner *scanner = [[NSScanner alloc] initWithString:tuple];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        BOOL success = [scanner scanFloat:&lon];
        if (success) {
            success = [scanner scanFloat:&lat];
            if (success) {
                CLLocationCoordinate2D c = CLLocationCoordinate2DMake(lat, lon);
                if (CLLocationCoordinate2DIsValid(c))
                    coords[read++] = c;
            }       
        }
        [scanner release];
    }
    
    *coordsOut = coords;
    return read;
}

- (MKPolygon*) parseShapeWKT:(NSString*)wkt {
    MKPolygon *newPoly = nil;

    if ([wkt rangeOfString:@"POLYGON (("].location == NSNotFound) {
        return newPoly; 
    }
    else {
        wkt = [wkt substringFromIndex:10];
        wkt = [wkt substringToIndex:[wkt length] - 2];
    }
    
    CLLocationCoordinate2D *coords = nil;
    NSUInteger coordsLen = 0;

    
    // has inner rings?
    NSArray *rings = [wkt componentsSeparatedByString:@"),("];
    
    // ignore inner rings
    if (rings != nil && [rings count] > 1) {
        wkt = [rings objectAtIndex:0];
    }
    
    coordsLen = [self makeCoords:wkt coordsArray:&coords];
  
    if (coordsLen > 0) {
        newPoly = [MKPolygon polygonWithCoordinates:coords count:coordsLen]; //interiorPolygons:innerPolys
    }
    free(coords);

    return newPoly;
}

@end
