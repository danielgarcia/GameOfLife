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


/**
 * It draws the board and buttons
 */
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



/**
 * It updates things after an action
 * @param ccTime delta To be properly called every frame
 */
-(void) update: (ccTime) delta
{
    KKInput* input = [KKInput sharedInput];
    CGPoint pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
    
    if (input.anyTouchBeganThisFrame)
    {
        //get x and y coordinates for mouse
        int x = pos.x;
        int y = pos.y;
        if(x >= WIDTH_WINDOW / 2 && y > HEIGHT_GAME + Y_OFF_SET)
        {
            if(done == true)
            {
                done = false;
            }
            else
            {
                done = true;
            }
        }
        else if(x <= WIDTH_WINDOW / 2 && y > HEIGHT_GAME + Y_OFF_SET)
        {
            [self resetArrays];
            done = true;
        }
        else
        {
            int row = (y - Y_OFF_SET) / CELL_WIDTH;
            int col = x / CELL_WIDTH;
            
            //make corresponding position in array alive or dead
            if([[[grid objectAtIndex:row] objectAtIndex: col] integerValue] == 1)
            {
                [[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@0];
                //an abbreviation for [NSNumber numberWithInt: 0] is @0
            }
            else
            {
                [[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@1];
                //an abbreviation for [NSNumber numberWithInt: 1] is @1
            }
        }
    }
    else if (input.anyTouchEndedThisFrame)
    {
        priorX = 500;
        priorY = 500;
    }
    else if(input.touchesAvailable) //when the mouse is dragged while clicked the cells toggle on and off
    {
		{
			//get x and y coordinates for mouse
			float x = pos.x;
			float y = pos.y;
			
			if(x >= WIDTH_WINDOW / 2 && y > HEIGHT_GAME + Y_OFF_SET)
			{
			}
			else if(x <= WIDTH_WINDOW / 2 && y > HEIGHT_GAME + Y_OFF_SET)
			{
			}
			else
			{
				int row = (int)(y - Y_OFF_SET) / CELL_WIDTH;
				int col = (int)x / CELL_WIDTH;
				float y1 = (float) ((y - 21.0) / 20.0);
				float x1 = (float) (x / 20.0);
				float cellYSmall = row;
				float cellYBig = row + 1;
				float cellXSmall = col;
				float cellXBig = col + 1;
				
				if ((priorX != 500.0)
					&& ((priorX < cellXSmall && x1 > cellXSmall && (double) row <= y1 && (double) row >= y1 - 1.0)
                        || (priorX > cellXBig && x1 < cellXBig && (double) row <= y1 && (double) row >= y1 - 1.0)
                        || (priorY > cellYBig && y1 < cellYBig && (double) col <= x1 && (double) col >= x1 - 1.0)
                        || (priorY < cellYSmall && y1 > cellXSmall && (double) col <= x1 && (double) col >= x1 - 1.0))
					)
				{
                    
					//make corresponding position in array alive or dead
					if([[[grid objectAtIndex:row] objectAtIndex: col] integerValue] == 1)
					{
						[[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@0];
                        //an abbreviation for [NSNumber numberWithInt: 0] is @0
					}
					else
					{
						[[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@1];
                        //an abbreviation for [NSNumber numberWithInt: 1] is @1
					}
				}
				priorX = x1;
				priorY = y1;
			}
		}
    }
    
}



/**
 * fill array with spaces
 */
-(void) resetArrays
{
    for(int row = 0; row < NUM_ROWS; row ++)
    {
        for(int col = 0; col < NUM_COLUMNS; col ++)
        {
            //an abbreviation for [NSNumber numberWithInt: 0] is @0
            [[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@0];
        }
    }
}


/**
 * the next frame
 */
-(void) nextFrame
{
}


/**
 * if there is no row to check then it checks last row for wrap around
 * @param int row the row number
 * @return int spot to check for previous row
 */
- (int) prevRow: (int) row
{
}


/**
 * if there is no next row, the first row is checked
 * @param int row the row number
 * @return int spot to check for next row
 */
- (int) nextRow: (int) row
{
}


/**
 * if there is no column to check then it checks last column for wrap around
 * @param int col the column number
 * @return int spot to check for previous column
 */
- (int) prevCol: (int) col
{
}


/**
 * if there is no next column, the first column is checked
 * @param int col the column number
 * @return int spot to check for next column
 */
- (int) nextCol: (int) col
{
}


/**
 * count the number of neighbors each cell has
 */
-(void) countNeighbors
{
}


/**
 * Updates the Grid
 */
-(void)updateGrid
{
}

@end
