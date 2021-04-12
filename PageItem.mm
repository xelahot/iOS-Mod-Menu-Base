#import "PageItem.h"

@implementation PageItem

@synthesize TargetPage = _TargetPage;

- (void) setTargetPage:(NSUInteger)pTargetPage {
   _TargetPage = pTargetPage;
}

- (NSUInteger) TargetPage {
   return _TargetPage;
}

- (id)initWithTitle:(NSString *)title_ targetPage:(NSUInteger)targetPage_{
   //Set object propreties
   self.Title = title_;

   self.TargetPage = targetPage_;

   return self;
}

@end