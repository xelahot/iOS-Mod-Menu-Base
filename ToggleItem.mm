#import "ToggleItem.h"

@implementation ToggleItem

@synthesize IsOn = _IsOn;
@synthesize Description = _Description;

- (void) setIsOn:(BOOL)pIsOn {
   _IsOn = pIsOn;
}

- (BOOL) IsOn {
   return _IsOn;
}

- (void) setDescription:(NSString *)pDescription {
   _Description = pDescription;
}

- (NSString*) Description {
   return _Description;
}

- (id)initWithTitle:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_ {
   //Set object propreties
   self.Title = title_;

   self.Description = description_;
   self.IsOn = isOn_;

   return self;
}

@end