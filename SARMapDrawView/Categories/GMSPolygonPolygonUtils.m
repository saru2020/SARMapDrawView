//
//  GMSPolygon+PolygonUtils.m
//  SARMapDrawView
//
//  Created by Saravanan on 03/05/15.
//  Copyright (c) 2015 Saravanan. All rights reserved.
//

#import "GMSPolygon+PolygonUtils.h"

@implementation GMSPolygon(PolygonUtils)

-(NSArray*)coordinates{
    NSMutableArray *coordinates = [NSMutableArray array];
    
    for (int i=0; i<self.path.count; i++) {
        CLLocationCoordinate2D coordinate = [self.path coordinateAtIndex:i];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [coordinates addObject:location];
    }
    
    return coordinates;
}

-(CGRect)bounds{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithPath:self.path];
    CGPoint topRightPoint = [self.map.projection pointForCoordinate:bounds.northEast];
    CGPoint bottomLeftPoint = [self.map.projection pointForCoordinate:bounds.southWest];
    CGFloat polygonWidth = topRightPoint.x-bottomLeftPoint.x;
    CGFloat polygonHeight = topRightPoint.x-bottomLeftPoint.x;
    CGRect polygonBounds = CGRectMake(topRightPoint.x-polygonWidth, topRightPoint.y, polygonWidth, polygonHeight);
    return polygonBounds;
}

-(CGPoint)centre{
    CGRect polygonBounds = [self bounds];
    return CGPointMake(polygonBounds.origin.x+(polygonBounds.size.width/2), polygonBounds.origin.y+(polygonBounds.size.height/2));
}

@end
