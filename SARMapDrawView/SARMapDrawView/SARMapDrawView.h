//
//  SARMapDrawView.h
//  SARMapDrawView
//
//  Created by Saravanan on 03/05/15.
//  Copyright (c) 2015 Saravanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMSMapView+Extensions.h"
#import "GMSPolygon+PolygonUtils.h"
#import "SARCoordinate.h"

typedef void (^polygonDrawn) (GMSPolygon*);
typedef void (^MapViewIdleAtCameraPosition) (GMSCameraPosition*);
typedef void (^MapViewDidTapOverlay) (GMSPolygon*);
typedef void (^ViewEnabled) ();//Used to enable user interaction and this block will get called when "disableInteraction == YES" is set, to notify all the listeners

@interface SARMapDrawView : UIView <GMSMapViewDelegate>

//@property (nonatomic, strong)ETManager *manager;

@property (nonatomic)BOOL disableInteraction;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *penButton;

@property (nonatomic)BOOL isZoneMode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zoneViewBottomConstraint;

@property (nonatomic, strong) NSMutableArray *coordinates;

@property (assign) BOOL isDrawingPolygon;

@property (nonatomic, weak) GMSPolyline *polyLine;
@property (nonatomic, weak) GMSPolygon *polygon;
@property (nonatomic, strong) NSArray *polygons;

//Blocks
@property (nonatomic, copy)polygonDrawn polygonDrawnBlock;
@property (nonatomic, copy)MapViewIdleAtCameraPosition MapViewIdleAtCameraPositionBlock;
@property (nonatomic, copy)MapViewDidTapOverlay MapViewDidTapOverlayBlock;
@property (nonatomic, copy)ViewEnabled ViewEnabledBlock;

-(void)initialize;

@end
