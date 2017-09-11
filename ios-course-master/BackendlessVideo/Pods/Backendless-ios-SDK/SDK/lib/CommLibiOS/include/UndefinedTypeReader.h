//
//  UndefinedTypeReader.h
//  RTMPStream
//
//  Created by Вячеслав Вдовиченко on 30.06.11.
//  Copyright 2011 The Midnight Coders, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITypeReader.h"


@interface UndefinedTypeReader : NSObject <ITypeReader> {
    
}
+(id)typeReader;
@end