range=3;
rename("edited");

// Crop to just the area of your arena to minimize any background noise
makeRectangle(11, 42, 236, 173);
run("Crop");
//

setOption("BlackBackground", false);
run("Make Binary", "method=Otsu background=Light calculate"); // Threshold the image using Otsu's method


run("Analyze Particles...", "size=100-500 circularity=0.00-1.00 show=Masks display clear stack"); //This finds typically sized animals, and clears other objects
size=getResult("Area",0); //get the animal size from the first frame
selectWindow("edited");
close();
selectWindow("Mask of edited");
rename("edited");

if(nResults>2){ //as long as you can find an animal on each of the 3 frames
	run("Duplicate...", "title=Current duplicate range="+range);
	imageCalculator("Difference create stack", "edited","Current"); //find the difference between the current frame, and the 2 frames prior
	selectWindow("Result of edited");
	run("Clear Results");
	run("Analyze Particles...", "size=20-Infinity show=Masks clear stack"); //find all pixel movement creating objects greater than 20 pixels (which tends to be noise)
	run("Clear Results");
	run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=5 fixed interpolate draw"); // plot mean pixel value (proportional to movement)
	run("Plot Z-axis Profile");
	holder=0;
for(o=0; o<range; o++){
	value=getResult("Mean",o); //get the mean pixel value across the image
	pixels=getResult("Area",o); //get the size of the image
	threshold=(size*2)/pixels*255/8; //find your 1/8th of body threshold based on size of worm, image, and the 255 maximum pixel value
	if (value>threshold){
		holder=1; // this finds if any of the frames had movement above the threshold
	}
}
selectWindow("Mask of Result of edited");
close();
selectWindow("Mask of Result of edited-0-0");
close();
selectWindow("Result of edited");
close();
selectWindow("Current");
close();
selectWindow("edited");
close();
if (holder==1){ //with at least one moving frame, the return is an awake animal
	return "Awake";
}
else{
	return "Sleep";
}
}
else{ //if there weren't 3 images with the worm detected
	selectWindow("edited");
	close();
	return "Awake";
}
