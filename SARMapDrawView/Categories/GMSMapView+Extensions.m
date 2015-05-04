//
//  GMSMapView+Extensions.m
//  SARMapDrawView
//
//  Created by Saravanan on 03/05/15.
//  Copyright (c) 2015 Saravanan. All rights reserved.
//

#import "GMSMapView+Extensions.h"
//#import "ETManager.h"

@implementation GMSMapView(Extension)

#pragma mark - Utils
-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000;
    
    //NSLog(@"%f",dist);
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    
    return [distance floatValue];
    
}

-(float)distanceFrom:(CGPoint)point1 to:(CGPoint)point2
{
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

-(GMSPolyline*)addCoordinate:(CLLocationCoordinate2D)coordinate replaceLastObject:(BOOL)replaceLast inCoordinates:(NSMutableArray*)coordinates
{
    if (replaceLast && [coordinates count] > 0)
        [coordinates removeLastObject];
    
    [coordinates addObject:[[SARCoordinate alloc] initWithCoordinate:coordinate]];
    
    
    //    [coordinates addObject:[NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)]];
    
    NSInteger numberOfPoints = [coordinates count];
    
    // if we have more than one point, then we're drawing a line segment
    
    GMSPolyline *poly = [[GMSPolyline alloc] init];
    GMSMutablePath *path = [GMSMutablePath path];
    poly.zIndex = 20;
    
    if (numberOfPoints > 2)
    {
        //        GMSPolyline *oldPolyLine = self.polyLine;
        /*
         CLLocationCoordinate2D points[numberOfPoints];
         for (NSInteger i = 0; i < numberOfPoints; i++){
         ETCoordinate *coordinateObject = coordinates[i];
         points[i] = coordinateObject.coordinate;
         //            points[i] = [coordinates[i] MKCoordinateValue];
         
         //            [path addCoordinate:coordinateObject.coordinate];
         }
         */
        
        SARCoordinate *coordinateObject = coordinates[numberOfPoints-2];
        CLLocationCoordinate2D lastCoordinate = coordinateObject.coordinate;
        
        //        Previous to the last point
        SARCoordinate *prevCoordinateObject = coordinates[numberOfPoints-3];
        CLLocationCoordinate2D prevLastCoordinate = prevCoordinateObject.coordinate;
        
        //        Adding Last Coordinate
        [path addCoordinate:prevLastCoordinate];
        [path addCoordinate:lastCoordinate];
        
        [path addCoordinate:coordinate];
        
        
        CGPoint lastPoint = [self.projection pointForCoordinate:lastCoordinate];
        CGPoint currentPoint = [self.projection pointForCoordinate:coordinate];
        
        float distance = [self distanceFrom:lastPoint to:currentPoint];
        //        NSLog(@"distance: %f", distance);
        
        //        ** Lat/Long Distance Wont Work **
        //        float distance = [self kilometersfromPlace:lastCoordinate andToPlace:coordinate];
        //        NSLog(@"Distance(Km): %f", distance);
        
        if (distance < 0.5) {
            //            Hence, we dont draw the polyline, if the distance is less than 2Km
            [coordinates removeLastObject];
            //            [self drawPolyLineForpreviousCoordinates];
            return nil;
        }
        
        
        
        poly.strokeColor = [UIColor blueColor];
        //        poly.strokeColor = [UIColor blackColor];
        
        poly.path = path;
        poly.strokeWidth = 4;
        //        poly.geodesic = YES;
        poly.map = self;
        
//        self.polyLine = poly;
//        
//        [polys addObject:poly];
//        _polys = polys;
        
        
        // note, remove old polyline _after_ adding new one, to avoid flickering effect
        
        //        if (oldPolyLine)
        //            oldPolyLine.map = nil;
        //            [self removeOverlay:oldPolyLine];
        
    }
    
    return poly;
}

-(void)drawPolyLineForPreviousCoordinates:(NSMutableArray*)coordinates{
    GMSPolyline *poly = [[GMSPolyline alloc] init];
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (int i=0; i<coordinates.count; i++) {
        SARCoordinate *coordinateObject = coordinates[i];
        //        Adding Last Coordinate
        CLLocationCoordinate2D coordinate = coordinateObject.coordinate;
        [path addCoordinate:coordinate];
        
    }
    
    poly.strokeColor = [UIColor blueColor];
    //        poly.strokeColor = [UIColor blackColor];
    
    poly.path = path;
    poly.strokeWidth = 4;
    //        poly.geodesic = YES;
    poly.map = self;
}


-(BOOL)isClosingPolygonWithCoordinate:(CLLocationCoordinate2D)coordinate inCoordinates:(NSMutableArray*)coordinates
{
    if ([coordinates count] > 2)
    {
        SARCoordinate *coordinateObject = coordinates[0];
        CLLocationCoordinate2D startCoordinate = coordinateObject.coordinate;
        
        //        CLLocationCoordinate2D startCoordinate = [coordinates[0] MKCoordinateValue];
        
        CGPoint start = [self.projection pointForCoordinate:startCoordinate];
        CGPoint end = [self.projection pointForCoordinate:coordinate];
        
        CGFloat xDiff = end.x - start.x;
        CGFloat yDiff = end.y - start.y;
        CGFloat distance = sqrtf(xDiff * xDiff + yDiff * yDiff);
        if (distance < 30.0)
        {
            //            [coordinates removeLastObject];
            return YES;
        }
    }
    
    return NO;
}



@end
