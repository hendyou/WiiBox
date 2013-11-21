//
//  AttentionUtil.m
//  GettingAttention
//
//  Created by Hendy Ou on 13-3-9.
//  Copyright (c) 2013年 Hendy Ou. All rights reserved.
//

#import "AttentionUtil.h"

@implementation AttentionUtil

+ (UIAlertView *) createOKAlertWithTitle: (NSString *) title
                                 message: (NSString *) message
                       cancelButtonTitle: (NSString *) cancelButtonTitle
{
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle: title message: message delegate: nil cancelButtonTitle: cancelButtonTitle otherButtonTitles: nil];
    return [alertDialog autorelease];
}

+ (void)playSystemSound:(NSString *) soundFileName
{
    NSArray *components = [ soundFileName componentsSeparatedByString: @"."];
    if ([components count] > 1) {
        SystemSoundID soundID;
        NSString *soundFile = [[NSBundle mainBundle] pathForResource: [components objectAtIndex: 0] ofType: [components objectAtIndex: 1]];
        
        AudioServicesCreateSystemSoundID((CFURLRef)
                                         [NSURL fileURLWithPath: soundFile], &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

+ (void)playAlertSound:(NSString *)soundFileName
{
    NSArray *components = [ soundFileName componentsSeparatedByString: @"."];
    if ([components count] > 1) {
        SystemSoundID soundID;
        NSString *soundFile = [[NSBundle mainBundle] pathForResource: [components objectAtIndex: 0] ofType: [components objectAtIndex: 1]];
        
        AudioServicesCreateSystemSoundID((CFURLRef)
                                         [NSURL fileURLWithPath: soundFile], &soundID);
        AudioServicesPlayAlertSound(soundID);
    }
}

+ (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
