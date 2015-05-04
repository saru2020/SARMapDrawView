//
//  SARMapDrawView.m
//  SARMapDrawView
//
//  Created by Saravanan on 03/05/15.
//  Copyright (c) 2015 Saravanan. All rights reserved.
//

#import "SARMapDrawView.h"

@interface SARMapDrawView (){
    NSArray *_polys;
    NSMutableArray *polys;
    CGPoint lowestPoint;
    CGPoint leftMostPoint;
    CGPoint rightMostPoint;
    BOOL isInitiallyLoaded;//Used to draw polygons from database at its initial launch
    
    //    Zone
    NSInteger zoneId;
    NSString *zoneName;
    int selectedRegions;
    int unSelectedRegions;
}

@property(nonatomic,strong)SARMapDrawView *mapDrawView;

@end

@implementation SARMapDrawView
@synthesize mapView = mapView;
@synthesize polygons = polygons;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)initialize{
    isInitiallyLoaded = YES;
    self.coordinates = [NSMutableArray array];
    polygons = [NSArray array];
    _polys = [NSArray array];
    polys = [NSMutableArray array];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:13.08
                                                            longitude:80.27
                                                                 zoom:20];
    //    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView.camera = camera;
    mapView.delegate = self;
    mapView.mapType = kGMSTypeHybrid;
    mapView.myLocationEnabled = YES;
//    mapView.accessibilityElementsHidden = NO;
    mapView.settings.myLocationButton = YES;
    //    mapView.settings.compassButton = YES;
    
}

#pragma mark - Other Methods
-(void)changeUserInteraction{
    if (self.disableInteraction) {
        self.mapView.userInteractionEnabled = NO;
    }
    else{
        self.mapView.userInteractionEnabled = YES;
    }
}

#pragma mark - Polygon Methods
-(void)removeSelectedPolygon{
    NSMutableArray *polygonsArray = [NSMutableArray arrayWithArray:self.polygons];
    for (GMSPolygon *polygon in self.polygons){
        if (polygon == self.polygon) {
            [polygonsArray removeObject:polygon];
            break;
        }
    }
    self.polygons = polygonsArray;
}

-(void)handleCoordinate:(CLLocationCoordinate2D)coordinate{
    GMSPolyline *polyLine = [self.mapView addCoordinate:coordinate replaceLastObject:NO inCoordinates:self.coordinates];
    if (polyLine) {
        self.polyLine = polyLine;
        [polys addObject:polyLine];
        _polys = polys;
    }
    
}

-(void)drawPolygon{
    //    return;
    NSInteger numberOfPoints = [self.coordinates count];
    
    //        Removing the last drawn polygon
    //    self.polygon.map = nil;
    
    for (GMSPolyline *poly in _polys) {
        poly.map = nil;
    }
    
    
    GMSPolygon *polygon = [[GMSPolygon alloc] init];
    GMSMutablePath *path = [GMSMutablePath path];
    
    //        if (numberOfPoints > 2)
    {
        CLLocationCoordinate2D points[numberOfPoints];
        for (NSInteger i = 0; i < numberOfPoints; i++){
            SARCoordinate *coordinateObject = self.coordinates[i];
            points[i] = coordinateObject.coordinate;
            
            [path addCoordinate:coordinateObject.coordinate];
            
            //                points[i] = [self.coordinates[i] MKCoordinateValue];
        }
        
        NSLog(@"numberOfPoints: %lu", numberOfPoints);
        
        
        polygon.path = path;
        //        polygon.title = @"New York";
        polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.2f];
        polygon.strokeColor = [UIColor blueColor];
        polygon.strokeWidth = 4;
        polygon.tappable = YES;
        
        polygon.map = mapView;
        
        self.polygon = polygon;
        
        NSMutableArray *polygonsArray = [NSMutableArray arrayWithArray:polygons];
        [polygonsArray addObject:polygon];
        polygons = polygonsArray;
        
    }
    
    NSLog(@"polygons.count: %lu", polygons.count);
    
    // and if we had a previous polyline, let's remove it
    
    if (self.polyLine)
        self.polyLine.map = nil;
    
    if (self.polygonDrawnBlock) {
        self.polygonDrawnBlock(self.polygon);
    }
    
}

#pragma mark - Calculation Methods
-(void)resetPoints{
    lowestPoint = CGPointMake(0, 0);
    leftMostPoint = CGPointMake(2000, 2000);//Keeping it to the Max on the Right. 2000, since no iOS device crossed this (In Points)
    rightMostPoint = CGPointMake(0, 0);
}

-(NSArray*)coordinatesForCurrentPolygon{
    return self.polygon.coordinates;
}

-(void)calculatePoints:(BOOL)moveCamera{
    CGPoint lowestPoint_local = CGPointMake(0, 0);
    CGPoint leftMostPoint_local = CGPointMake(2000, 2000);
    CGPoint rightMostPoint_local = CGPointMake(0, 0);
    
    NSArray *coordinates = [self coordinatesForCurrentPolygon];
    if (coordinates.count > 0) {
        for (SARCoordinate *Coordinate_local in coordinates){
            CGPoint pointForCoordinate = [mapView.projection pointForCoordinate:Coordinate_local.coordinate];
            if (pointForCoordinate.y > lowestPoint_local.y) {
                lowestPoint_local = pointForCoordinate;
            }
            if (pointForCoordinate.x < leftMostPoint_local.x) {
                leftMostPoint_local = pointForCoordinate;
            }
            if (pointForCoordinate.x > rightMostPoint_local.x) {
                rightMostPoint_local = pointForCoordinate;
            }
        }
        
        lowestPoint = lowestPoint_local;
        leftMostPoint = leftMostPoint_local;
        rightMostPoint = rightMostPoint_local;
    }
    
    //    NSLog(@"leftMostPoint: %@",NSStringFromCGPoint(leftMostPoint));
    //    NSLog(@"rightMostPoint: %@",NSStringFromCGPoint(rightMostPoint));
    //    NSLog(@"lowestPoint: %@", NSStringFromCGPoint(lowestPoint));
    
    if (moveCamera) {
//        [self moveCamera];
    }
    
}

#pragma mark - Animation Methods
-(void)scrollMapUpToValue:(CGFloat)yValue{
    
    [mapView animateWithCameraUpdate:[GMSCameraUpdate scrollByX:0 Y:yValue]];
}

-(void)scrollMapDownToValue:(CGFloat)yValue{
    [mapView animateWithCameraUpdate:[GMSCameraUpdate scrollByX:0 Y:-yValue]];
}

#pragma mark - GMSMapView Delegates
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    [self calculatePoints:NO];
    
    if (self.MapViewIdleAtCameraPositionBlock) {
        self.MapViewIdleAtCameraPositionBlock(position);
    }

}

- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay{
    //    Mapping Sequences
    for (GMSPolygon *polygon in self.polygons){
        if (polygon == overlay) {
            self.polygon = polygon;//Assigning the selected polygon here
//            [self calculatePoints:YES];
//            self.polygon.strokeColor = ShapeBlueColor;

            if (self.MapViewDidTapOverlayBlock) {
                self.MapViewDidTapOverlayBlock(polygon);
            }
            
            break;
        }
    }
    
}



#pragma mark - UITouches Delegates
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //    NSLog(@"touchesBegan");
    
    [self resetPoints];
    
    if (self.disableInteraction){
        self.disableInteraction = !self.disableInteraction;
        return;
    }
    
    if (!self.isDrawingPolygon)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView.projection coordinateForPoint:location];
    
    [self handleCoordinate:coordinate];
    
    lowestPoint = location;
    leftMostPoint = location;
    rightMostPoint = location;
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //    NSLog(@"touchesMoved");
    if (!self.isDrawingPolygon) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView.projection coordinateForPoint:location];
    
    [self handleCoordinate:coordinate];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //    NSLog(@"touchesEnded");
    if (!self.isDrawingPolygon)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView.projection coordinateForPoint:location];
    
    [self handleCoordinate:coordinate];
    
    
    // detect if this coordinate is close enough to starting
    // coordinate to qualify as closing the polygon
    
    //    if ([self isClosingPolygonWithCoordinate:coordinate])
    
    NSInteger numberOfPoints = [self.coordinates count];
    NSLog(@"touchesEnded: numberOfPoints: %lu", numberOfPoints);
    
//    if (!self.isconfirmationView) {
//        [self togglePopupView];
//    }
    
    if (self.isDrawingPolygon) {
        [self drawPolygon];
        [self calculatePoints:NO];
    }

}

#pragma mark - Setters
-(void)setDisableInteraction:(BOOL)disableInteraction{
    _disableInteraction = disableInteraction;
    [self changeUserInteraction];
    if (disableInteraction == NO) {
        if (self.ViewEnabledBlock) {
            self.ViewEnabledBlock();
        }
    }
}

@end
