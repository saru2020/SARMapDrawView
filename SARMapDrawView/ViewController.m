//
//  ViewController.m
//  SARMapDrawView
//
//  Created by Saravanan on 03/05/15.
//  Copyright (c) 2015 Saravanan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mapDrawView = mapDrawView;

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak ViewController *weakSelf = self;
//    mapDrawView = [[[NSBundle mainBundle] loadNibNamed:@"ETMapDrawView" owner:self options:nil] firstObject];
//    self.view = mapDrawView;
//    mapDrawView = [[SARMapDrawView alloc]initWithFrame:self.view.bounds];
    [self.view bringSubviewToFront:self.penButton];
    mapDrawView.polygonDrawnBlock = ^(GMSPolygon *polygon_Drawn){
        NSLog(@"polygon_Drawn.path.encodedPath: %@", polygon_Drawn.path.encodedPath);//This is the Encoded String of the path of the drawn polygon. Google has an Algorithm for this. It is really usefull when you want to have the coordinates of the drawn area to be sent back & forth from&to your servers, since the size of the encodedString is very low in size when compared to taking all the coordinates you captured. Only Issue when taking the encodedString is that, Google does reduce some set of coordinates which are really nearby taken out from a particular zoom level.
        
        [weakSelf penButtonTapped:weakSelf.penButton];
    };
    mapDrawView.MapViewIdleAtCameraPositionBlock = ^(GMSCameraPosition *cameraPosition){
    };
    mapDrawView.MapViewDidTapOverlayBlock = ^(GMSPolygon *polygon_Tapped){
    };
    mapDrawView.ViewEnabledBlock = ^(){
    };
    

}

- (IBAction)penButtonTapped:(id)sender {
    if (!mapDrawView.isDrawingPolygon)
    {
        // We're starting the drawing of our polyline/polygon, so
        // let's initialize everything
        
        [self.mapDrawView enableDrawing];
        [self.penButton setSelected:YES];
    }
    else
    {
        [self.mapDrawView disableDrawing];
        [self.penButton setSelected:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
