final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
final int hogIdle = 0, hogDown = 1, hogRight = 2, hogLeft = 3;
int hogDraw = hogIdle;

int movementTimer, speed = 80;
float hogX = 320, hogY = 80; 

PImage groundhogDown, groundhogIdle, groundhogLeft, groundhogRight, life;
PImage soilA, soilB, soilC, soilD, soilE, soilF, rockA, rockB;
PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480, P2D);
  frameRate(60);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
	life = loadImage("img/life.png");
  soilA = loadImage("img/soil0.png");
  soilB = loadImage("img/soil1.png");
  soilC = loadImage("img/soil2.png");
  soilD = loadImage("img/soil3.png");
  soilE = loadImage("img/soil4.png");
  soilF = loadImage("img/soil5.png");
  rockA = loadImage("img/stone1.png");
  rockB = loadImage("img/stone2.png");
}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;

		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil 1-8
		int blockSet = 80, deepSet = 160;
    for(int i = 1; i <= 8; i++, deepSet += 80){
        for(int j = 1, sequence = 0; j <= 8; j++, sequence += blockSet){
        if(i <= 4){
          image(soilA, sequence, deepSet);   
        }
        else if(i > 4 && i <= 8){
          image(soilB, sequence, deepSet); 
       }
       if(j == i){
          image(rockA, sequence, deepSet);}
          }
    }
    //Soil 9 - 17
    deepSet = 800;
    for(int i = 1; i <= 8; i++, deepSet += 80){
        for(int j = 1, sequence = 0; j <= 8; j++, sequence += blockSet){
        if(i <= 4){
          image(soilC, sequence, deepSet);
        }
        else if(i > 4 && i <= 8){
          image(soilD, sequence, deepSet);
          }
        if(i == 1 || i == 4 || i == 5 || i == 8){
          image(rockA, blockSet * 1, deepSet);
          image(rockA, blockSet * 2, deepSet);
          image(rockA, blockSet * 5, deepSet);
          image(rockA, blockSet * 6, deepSet);
        } 
        if(i == 2 || i == 3 || i == 6 || i == 7){
          image(rockA, 0, deepSet);
          image(rockA, blockSet * 3, deepSet);
          image(rockA, blockSet * 4, deepSet);
          image(rockA, blockSet * 7, deepSet);
        } 
      }
    }
    //Soil 9 - 24
    deepSet = 1440;
    for(int i = 1; i <= 8; i++, deepSet += 80){
        for(int j = 1, sequence = 0; j <= 8; j++, sequence += blockSet){
        if(i <= 4){
          image(soilE, sequence, deepSet);
        }
        else if(i > 4 && i <= 8){
          image(soilF, sequence, deepSet);
          }
          
       }
    }
    // Locking Y layer
    
    // Player
    switch(hogDraw){
        case hogIdle:
          image(groundhogIdle, hogX, hogY);  
          movementTimer = 0;
          break;
   
        case hogDown:
          image(groundhogDown, hogX, hogY);
          hogY += speed / 15.0;
          movementTimer++;
          break;
        case hogRight:
          image(groundhogRight, hogX, hogY);
          hogX += speed / 15.0;
          movementTimer++;
          break;
        case hogLeft:
          image(groundhogLeft, hogX, hogY);
          hogX -= speed / 15.0;
          movementTimer++;
          break;
      }
    //movement timer setting
      if(movementTimer == 15){
        hogDraw = hogIdle;
        if((hogY % speed) < 30){
          hogY = hogY - hogY % speed;
        }else{
          hogY = hogY - hogY % speed + speed;
        }
        if((hogX % speed) < 30){
          hogX = hogX - hogX % speed;
        }else{
          hogX = hogX - hogX % speed + speed;
        }
        
        movementTimer = 0; //reset
      }  
      
    //border limitation
      if(hogX >= 560){
        hogX = 560;
      }  
      
		// Health UI
    
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
			}
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
	// Add your moving input code here

	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      if(hogDraw == hogIdle){
          hogDraw = hogDown;
          movementTimer = 0;
        }
      
      break;
      case 'a':
      if(hogDraw == hogIdle){
          hogDraw = hogLeft;
          movementTimer = 0;
        }
      break;
      case 'd':
        if(hogDraw == hogIdle){
            hogDraw = hogRight;
            movementTimer = 0;
        }
      break;
    }
}

void keyReleased(){}
