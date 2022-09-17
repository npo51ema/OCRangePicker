#import <QuartzCore/QuartzCore.h>
 
@class OCRangePicker;
 
@interface OCRangePickerKnobLayer : CALayer
 
@property BOOL highlighted;
@property (weak) OCRangePicker* slider;
 
@end

