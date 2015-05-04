//
//  GMSMapView+Extensions.h
//  SARMapDrawView
//
//  Created by Saravanan on 03/05/15.
//  Copyright (c) 2015 Saravanan. All rights reserved.
//

#import "SARCoordinate.h"

@interface GMSMapView(Extension)

-(GMSPolyline*)addCoordinate:(CLLocationCoordinate2D)coordinate replaceLastObject:(BOOL)replaceLast inCoordinates:(NSMutableArray*)coordinates;
-(void)drawPolyLineForPreviousCoordinates:(NSMutableArray*)coordinates;
-(BOOL)isClosingPolygonWithCoordinate:(CLLocationCoordinate2D)coordinate inCoordinates:(NSMutableArray*)coordinates;

@end
