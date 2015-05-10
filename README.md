# SARMapDrawView
===============

Free Hand Drawing on Google Maps View.

**[Sample Code for the Accompanying Blog Post](http://saru2020.blogspot.com/2015/05/free-hand-drawing-on-googles-map-view.html)**<br/>
	
<br/>
<b>If you are planning to draw a polygon on the Map View, then here's how you should do it:</b>


    SARMapDrawView *mapDrawView = [[SARMapDrawView alloc]initWithFrame:self.view.bounds];
    [mapDrawView enableDrawing];
    mapDrawView.polygonDrawnBlock = ^(GMSPolygon *polygon_Drawn){
        NSLog(@"polygon_Drawn.path.encodedPath: %@", polygon_Drawn.path.encodedPath);//Encoded Path of the Polygon
	    [mapDrawView disableDrawing];
    };

<br/>
<b>Here are the Instructions that needs to be followed to integrate "SARMapDrawView": </b>
	
	(i) Copy & Paste these Folders into your project: "SARMapDrawView", "Categories" & "Models".
	(ii) Since, "SARMapDrawView" is just a subclass of UIView, just initialise and place "SARMapDrawView" onto your View Controller 
    
    	mapDrawView = [[SARMapDrawView alloc]initWithFrame:self.view.bounds];
	
	or if your using storyboard then just add an UIView to your controller and name its class to "SARMapDrawView".
	
	(iii) Now, when you are ready to draw your polygon on the map, just call "enableDrawing" method on the view, 
	now "SARMapDrawView" is in the Drawing mode, so if you just scribble or draw any shape with your finger on the map, 
	it will explicitly draw a Polygon, by joining the Starting and the Ending point of your touch and you will receive 
	the drawn Polygon(GMSPolygon) object in Block Callback ("polygonDrawnBlock") [Only if you are listening to it].
	
<br/>
	