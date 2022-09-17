#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCRangePicker : UIControl
  @property (nonatomic) float maximumValue;
  @property (nonatomic) float minimumValue;
  @property (nonatomic) float upperValue;
  @property (nonatomic) float lowerValue;

  @property (nonatomic) UIColor* trackColour;
  @property (nonatomic) UIColor* trackHighlightColour;
  @property (nonatomic) UIColor* knobColour;
  @property (nonatomic) float curvaceousness;
 
- (float) positionForValue:(float)value;
@end

NS_ASSUME_NONNULL_END
