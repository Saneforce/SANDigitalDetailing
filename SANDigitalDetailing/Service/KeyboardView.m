//
//  KeyboardView.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 14/12/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "KeyboardView.h"
#import "ToDyTPvwCtrl.h"

@implementation KeyboardView

static const CGFloat ANIMATION_DURATION = 0.4;
static const CGFloat LITTLE_SPACE = 25;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
CGSize keyboardSize;
CGFloat animatedDistance;
CGFloat frameHeight;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    NSArray *allSubviewsOfWindow = [self allSubviewsOfView:self.view];
    for(UIView *subview in allSubviewsOfWindow)
    {
        if([subview isKindOfClass: [UITextView class]])
        {
            ((UITextView*)subview).delegate = (id) self;
        }
        
        if([subview isKindOfClass: [UITextField class]])
        {
            ((UITextField*)subview).delegate = (id) self;
        }
    }

}
- (void)textViewDidBeginEditing:(UITextView *)textField{
    CGRect viewFrame = self.view.window.frame;
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat textFieldBottomLine = textFieldRect.origin.y + textFieldRect.size.height + LITTLE_SPACE;//
    
    CGFloat keyboardHeight = keyboardSize.height;
    
    BOOL isTextFieldHidden = textFieldBottomLine > (viewRect.size.height - keyboardHeight)? TRUE :FALSE;
    if (isTextFieldHidden) {
        animatedDistance = textFieldBottomLine - (viewRect.size.height - keyboardHeight) ;
        viewFrame.origin.y -= animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:ANIMATION_DURATION];
        //[self.view.window layoutIfNeeded];
        [self.view.window setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textfield{
    CGRect viewFrame = self.view.window.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    //[self.view.window layoutIfNeeded];
    
    [self.view.window setFrame:viewFrame];
    [UIView commitAnimations];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%f",self.view.frame.size.height);
    CGRect viewFrame = self.view.window.frame;
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat textFieldBottomLine = textFieldRect.origin.y + textFieldRect.size.height + LITTLE_SPACE;//
    
    CGFloat keyboardHeight = keyboardSize.height;
    
    BOOL isTextFieldHidden = textFieldBottomLine > (viewRect.size.height - keyboardHeight)? TRUE :FALSE;
    if (isTextFieldHidden) {
        animatedDistance = textFieldBottomLine - (viewRect.size.height - keyboardHeight) ;
        viewFrame.origin.y -= animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:ANIMATION_DURATION];
        //[self.view.window layoutIfNeeded];
        [self.view.window setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect viewFrame = self.view.window.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    //[self.view.window layoutIfNeeded];

    [self.view.window setFrame:viewFrame];
    [UIView commitAnimations];
}
- (IBAction)dismissKeyboard:(id)sender{
    [self.view endEditing:YES];
}

-(void)keyboardDidShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

- (NSArray *)allSubviewsOfView:(UIView *)view
{
    NSMutableArray *subviews = [[view subviews] mutableCopy];
    for (UIView *subview in [view subviews])
        [subviews addObjectsFromArray:[self allSubviewsOfView:subview]]; //recursive
    return subviews;
}
@end
