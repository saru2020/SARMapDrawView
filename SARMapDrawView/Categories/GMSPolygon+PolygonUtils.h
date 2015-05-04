//
//  GMSPolygon+PolygonUtils.h
//  SARMapDrawView
//
//  Created by Saravanan on 03/05/15.
//  Copyright (c) 2015 Saravanan. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface GMSPolygon(PolygonUtils)

-(NSArray*)coordinates;
-(CGRect)bounds;
-(CGPoint)centre;

@end
