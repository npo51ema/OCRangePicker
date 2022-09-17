#import "OCRangePickerKnobLayer.h"
#import "OCRangePicker.h"

@implementation OCRangePickerKnobLayer
  OCRangePickerKnobLayer* _upperKnobLayer;
  OCRangePickerKnobLayer* _lowerKnobLayer;

- (void)drawInContext:(CGContextRef)ctx {
    CGRect knobFrame = CGRectInset(self.bounds, 2.0, 2.0);
 
    UIBezierPath *knobPath = [UIBezierPath bezierPathWithRoundedRect:knobFrame
                                                        cornerRadius:knobFrame.size.height * self.slider.curvaceousness / 2.0];
 
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(ctx, self.slider.knobColour.CGColor);
    CGContextAddPath(ctx, knobPath.CGPath);
    CGContextFillPath(ctx);
 
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextAddPath(ctx, knobPath.CGPath);
    CGContextStrokePath(ctx);
 

    CGRect rect = CGRectInset(knobFrame, 2.0, 2.0);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        cornerRadius:rect.size.height * self.slider.curvaceousness / 2.0];
 
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 0.0, 0.0 , 0.15,
        0.0, 0.0, 0.0, 0.05 };
 
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
                                                      locations, num_locations);
 
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
 
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, clipPath    .CGPath);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, myGradient, startPoint, endPoint, 0);
 
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
    CGContextRestoreGState(ctx);
 
    if (self.highlighted) {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.0 alpha:0.1].CGColor);
        CGContextAddPath(ctx, knobPath.CGPath);
        CGContextFillPath(ctx);
    }
}
@end

