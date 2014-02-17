/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "GameOfLifeLayer.h"

@interface GameOfLifeLayer (PrivateMethods)
@end

NSMutableArray* grid;
NSMutableArray* numNeighbors;
#define Y_OFF_SET 21
#define WIDTH_WINDOW 320
#define HEIGHT_WINDOW 480
#define CELL_WIDTH 20
#define WIDTH_GAME WIDTH_WINDOW
#define HEIGHT_GAME (HEIGHT_WINDOW - 60)
#define NUM_ROWS (HEIGHT_GAME / CELL_WIDTH)
#define NUM_COLUMNS (WIDTH_GAME / CELL_WIDTH)
bool done = true;
#define DELAY_IN_SECONDS 0.15
float priorX = 500;
float priorY = 500;

@implementation GameOfLifeLayer

-(id) init
{
	if ((self = [super init]))
	{
		grid = [[NSMutableArray alloc] init];
        for (int k = 0; k < NUM_ROWS; ++ k) 
        {
            NSMutableArray* subArr = [[NSMutableArray alloc] init ];
            for (int s = 0; s < NUM_COLUMNS; ++ s)
            {
                NSNumber *item = [NSNumber numberWithInt: 0];
                [subArr addObject:item];
            }
            [grid addObject:subArr];
        }
        
        numNeighbors = [[NSMutableArray alloc] init];
        for (int k = 0; k < NUM_ROWS; ++ k) 
        {
            NSMutableArray* subArr = [[NSMutableArray alloc] init];
            for (int s = 0; s < NUM_COLUMNS; ++ s)
            {
                NSNumber *item = @0;
                [subArr addObject:item];
            }
            [numNeighbors addObject:subArr];
        }
	}

	return self;
}

-(void) draw
{
    
    //this draws a rectangle
    ccColor4F rectColor = ccc4f(0.5, 0.5, 0.5, 1.0); //red, green, blue, and alpha/transparancy
    ccDrawSolidRect(ccp(0,0 + Y_OFF_SET), ccp(WIDTH_GAME, HEIGHT_GAME + Y_OFF_SET), rectColor);
    
    //this draws the row lines
    glColor4ub(100,0,255,255);
    for(int row = 0; row < HEIGHT_GAME; row += CELL_WIDTH)
    {
        ccDrawLine(ccp(0, row + Y_OFF_SET), ccp(WIDTH_GAME, row + Y_OFF_SET));
    }
    
    //this draws the column lines
    for(int col = 0; col <= WIDTH_GAME; col += CELL_WIDTH)
    {
        ccDrawLine(ccp(col, 0 + Y_OFF_SET), ccp(col, HEIGHT_GAME + Y_OFF_SET));
    }
    
    //this makes an array and displays match
    for(int row = 0; row < NUM_ROWS; row ++)
    {
        for(int col = 0; col < NUM_COLUMNS; col ++)
        {
            NSNumber* num = [[grid objectAtIndex:row] objectAtIndex: col];
            if([num integerValue] == 1)
            {
                ccColor4F cellColor = ccc4f(0.5, 0.0, 1.0, 1.0);
                ccDrawSolidRect(ccp(col * CELL_WIDTH, row * CELL_WIDTH + Y_OFF_SET), ccp(col * CELL_WIDTH + CELL_WIDTH, row * CELL_WIDTH + Y_OFF_SET + CELL_WIDTH), cellColor);
            }
        }
    }
    
    //this draws the start button
    ccColor4F startButtonColor = ccc4f(0.5, 0.0, 1.0, 1.0);
    ccDrawSolidRect(ccp(WIDTH_WINDOW / 2, HEIGHT_GAME + Y_OFF_SET), ccp(WIDTH_WINDOW, HEIGHT_WINDOW + Y_OFF_SET), startButtonColor);
    
    //this draws the clear button
    ccColor4F clearButtonColor = ccc4f(0.2, 0.0, 1.0, 1.0);
    ccDrawSolidRect(ccp(0, HEIGHT_GAME + Y_OFF_SET), ccp(WIDTH_WINDOW / 2, HEIGHT_WINDOW + Y_OFF_SET), clearButtonColor);
    
}

@end
