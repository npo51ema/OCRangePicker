#import "ViewController.h"
#import "OCRangePicker.h"

@implementation ViewController
  OCRangePicker* _rangePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger margin = 40;
    CGRect sliderFrame = CGRectMake(margin, margin, self.view.frame.size.width - margin * 2, 30);
    _rangePicker = [[OCRangePicker alloc] initWithFrame:sliderFrame];
     
    [self.view addSubview:_rangePicker];
    
    [_rangePicker addTarget:self
                         action:@selector(slideValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    [self performSelector:@selector(updateState) withObject:nil afterDelay:1.0f];
    
}

- (void)slideValueChanged:(id)control {
    NSLog(@"Slider value changed: (%.2f,%.2f)",
          _rangePicker.lowerValue, _rangePicker.upperValue);
}

- (void)updateState {
    _rangePicker.trackHighlightColour = [UIColor blackColor];
}


@end

