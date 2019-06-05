# SARMapDrawView
===============

Free Hand Drawing on Google Maps View.

**[This is kind of a Sample Code + Everything, for the Accompanying Blog Post](http://saru2020.blogspot.com/2015/05/free-hand-drawing-on-googles-map-view.html)**<br/>
	
<br/>
<b>If you are planning to draw a polygon on the Map View, then here's how you should do it:</b>


    SARMapDrawView *mapDrawView = [[SARMapDrawView alloc]initWithFrame:self.view.bounds];
    [mapDrawView enableDrawing];
    mapDrawView.polygonDrawnBlock = ^(GMSPolygon *polygon_Drawn){
	    //Encoded Path of the Polygon
        NSLog(@"polygon_Drawn.path.encodedPath: %@", polygon_Drawn.path.encodedPath);
	    [mapDrawView disableDrawing];
    };

<br/>
<b>Here are the Instructions that needs to be followed to integrate "SARMapDrawView": </b>
	
	(i) Copy & Paste these Folders into your project: "SARMapDrawView", "Categories" & "Models".
	(ii) Since, "SARMapDrawView" is just a subclass of UIView, just initialise and 
	place "SARMapDrawView" onto your View Controller 
    
    	mapDrawView = [[SARMapDrawView alloc]initWithFrame:self.view.bounds];
	
	or if your using storyboard then just add an UIView to your controller 
	and name its class name to "SARMapDrawView".
	
	(iii) Now, when you are ready to draw your polygon on the map, 
	just call "enableDrawing" method on the view, like this:
		[mapDrawView enableDrawing];
		
	Now "SARMapDrawView" is in the Drawing mode, so if you just scribble 
	or draw any shape with your finger on the map, it will explicitly draw a Polygon, 
	by joining the Starting and the Ending point of your touch start & end respectively 
	and you will receive the drawn Polygon(GMSPolygon) object in the Block 
	Callback ("polygonDrawnBlock") [Only if you are listening to it].
	
<br/>
	
		
<br/>
<br/>

## 👨🏻‍💻 Author
[1.1]: http://i.imgur.com/tXSoThF.png
[1]: http://www.twitter.com/saruhere

* Saravanan [![alt text][1.1]][1]

<a class="bmc-button" target="_blank" href="https://www.buymeacoffee.com/saru2020"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy me a coffee/beer" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;"><span style="margin-left:5px"></span></a>
