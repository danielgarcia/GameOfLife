/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "cocos2d.h"

@interface GameOfLifeLayer : CCLayer

-(id) init;
-(void) draw;
-(void) update: (ccTime) delta;
-(void) resetArrays;
-(void) nextFrame;
-(int) prevRow:(int)row;
-(int) nextRow:(int)row;
-(int) prevCol:(int)col;
-(int) nextCol:(int)col;
-(void) countNeighbors;
-(void) updateGrid;

@end
