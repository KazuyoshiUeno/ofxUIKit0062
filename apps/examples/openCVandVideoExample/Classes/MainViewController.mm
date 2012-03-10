#import "MainViewController.h"

#include "ofMain.h"

#include "ofxOpenCv.h"
ofxCvColorImage colorImg;
ofxCvGrayscaleImage grayImage;
ofxCvGrayscaleImage grayBg;
ofxCvGrayscaleImage grayDiff;
ofxCvContourFinder  countourFinder;
int threshold;
bool bLearnBackground;

#define ww 480
#define hh 360

@implementation MainViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    ofBackground(0, 0, 0);
    ofEnableAlphaBlending();
    [self ofSetFrameRate:30];
    
    vidGrabber = [[ofxUIKitVideoGrabber alloc] init];
    colorImg.allocate(ww, hh);
    grayImage.allocate(ww, hh);
    grayBg.allocate(ww, hh);
    grayDiff.allocate(ww, hh);
    threshold = 10;
    bLearnBackground = true;
}

- (void)setup
{
	ofBackground(255, 0, 0);
}

- (void)update
{
    colorImg.setFromPixels([vidGrabber gpixels], ww, hh);
    
    grayImage = colorImg;
    
    if (bLearnBackground == true)
    {
        grayBg = grayImage;
        bLearnBackground = false;
    }
	
    grayDiff.absDiff(grayBg, grayImage);
    grayDiff.threshold(threshold);
    countourFinder.findContours(grayDiff, 20, (ww*hh)/3, 10, true);
}

- (void)draw
{
    ofNoFill();
    ofSetColor(0xffffff);
	grayImage.draw(0,0);
    
    
    for (int i = 0; i < countourFinder.nBlobs; i++)
    {
        countourFinder.blobs[i].draw(0, 0);
    }
}

@end
