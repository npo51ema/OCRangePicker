#import <QuartzCore/QuartzCore.h>
#import "OCRangePicker.h"
#import "OCRangePickerKnobLayer.h"
#import "OCRangePickerTrackLayer.h"

@implementation OCRangePicker
  OCRangePickerTrackLayer* _trackLayer;
  OCRangePickerKnobLayer* _upperKnobLayer;
  OCRangePickerKnobLayer* _lowerKnobLayer;

  CGPoint _previousTouchPoint;
 
  float _knobWidth;
  float _useableTrackLength;

#define GENERATE_SETTER(PROPERTY, TYPE, SETTER, UPDATER) \
- (void)SETTER:(TYPE)PROPERTY { \
    if (_##PROPERTY != PROPERTY) { \
        _##PROPERTY = PROPERTY; \
        [self UPDATER]; \
    } \
}

GENERATE_SETTER(trackHighlightColour, UIColor*, setTrackHighlightColour, redrawLayers)
 
GENERATE_SETTER(trackColour, UIColor*, setTrackColour, redrawLayers)
 
GENERATE_SETTER(curvaceousness, float, setCurvaceousness, redrawLayers)
 
GENERATE_SETTER(knobColour, UIColor*, setKnobColour, redrawLayers)
 
GENERATE_SETTER(maximumValue, float, setMaximumValue, setLayerFrames)
 
GENERATE_SETTER(minimumValue, float, setMinimumValue, setLayerFrames)
 
GENERATE_SETTER(lowerValue, float, setLowerValue, setLayerFrames)
 
GENERATE_SETTER(upperValue, float, setUpperValue, setLayerFrames)
 
- (void) redrawLayers {
    [_upperKnobLayer setNeedsDisplay];
    [_lowerKnobLayer setNeedsDisplay];
    [_trackLayer setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _trackHighlightColour = [UIColor colorWithRed:0.0 green:0.45 blue:0.94 alpha:1.0];
        _trackColour = [UIColor colorWithWhite:0.9 alpha:1.0];
        _knobColour = [UIColor whiteColor];
        
        _curvaceousness = 1.0;
        
        _maximumValue = 10.0;
        _minimumValue = 0.0;
        _maximumValue = 10.0;
        _minimumValue = 0.0;
        _upperValue = 8.0;
        _lowerValue = 2.0;
        
        _trackLayer = [OCRangePickerTrackLayer layer];
        _trackLayer.slider = self;
        [self.layer addSublayer:_trackLayer];
         
        _upperKnobLayer = [OCRangePickerKnobLayer layer];
        _upperKnobLayer.slider = self;
        [self.layer addSublayer:_upperKnobLayer];
         
        _lowerKnobLayer = [OCRangePickerKnobLayer layer];
        _lowerKnobLayer.slider = self;
        [self.layer addSublayer:_lowerKnobLayer];
         
        [self setLayerFrames];
    }
    return self;
}

- (void) setLayerFrames {
    _trackLayer.frame = CGRectInset(self.bounds, 0, self.bounds.size.height / 3.5);
    [_trackLayer setNeedsDisplay];
 
    _knobWidth = self.bounds.size.height;
    _useableTrackLength = self.bounds.size.width - _knobWidth;
 
    float upperKnobCentre = [self positionForValue:_upperValue];
    _upperKnobLayer.frame = CGRectMake(upperKnobCentre - _knobWidth / 2, 0, _knobWidth, _knobWidth);
 
    float lowerKnobCentre = [self positionForValue:_lowerValue];
    _lowerKnobLayer.frame = CGRectMake(lowerKnobCentre - _knobWidth / 2, 0, _knobWidth, _knobWidth);
 
    [_upperKnobLayer setNeedsDisplay];
    [_lowerKnobLayer setNeedsDisplay];
}
 
- (float) positionForValue:(float)value {
    return _useableTrackLength * (value - _minimumValue) /
        (_maximumValue - _minimumValue) + (_knobWidth / 2);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _previousTouchPoint = [touch locationInView:self];
 
    if(CGRectContainsPoint(_lowerKnobLayer.frame, _previousTouchPoint)) {
        _lowerKnobLayer.highlighted = YES;
        [_lowerKnobLayer setNeedsDisplay];
    }
    else if(CGRectContainsPoint(_upperKnobLayer.frame, _previousTouchPoint)) {
        _upperKnobLayer.highlighted = YES;
        [_upperKnobLayer setNeedsDisplay];
    }
    return _upperKnobLayer.highlighted || _lowerKnobLayer.highlighted;
}

#define BOUND(VALUE, UPPER, LOWER)    MIN(MAX(VALUE, LOWER), UPPER)

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];

    float delta = touchPoint.x - _previousTouchPoint.x;
    float valueDelta = (_maximumValue - _minimumValue) * delta / _useableTrackLength;

    _previousTouchPoint = touchPoint;

    if (_lowerKnobLayer.highlighted) {
        _lowerValue += valueDelta;
        _lowerValue = BOUND(_lowerValue, _upperValue, _minimumValue);
    }
    if (_upperKnobLayer.highlighted) {
        _upperValue += valueDelta;
        _upperValue = BOUND(_upperValue, _maximumValue, _lowerValue);
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;

    [self setLayerFrames];

    [CATransaction commit];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _lowerKnobLayer.highlighted = _upperKnobLayer.highlighted = NO;
    [_lowerKnobLayer setNeedsDisplay];
    [_upperKnobLayer setNeedsDisplay];
}

@end

