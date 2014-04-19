Cell[][] _cellArray;
int _cellSize = 8;
int _numx, _numy;

void setup() {
  size(1000, 600);
  //frameRate(2);
  _numx = floor(width/_cellSize);
  _numy = floor(height/_cellSize);
  restart();
}

void restart() {
  _cellArray = new Cell[_numx][_numy];
  
  for (int x = 0; x<_numx; x++) {
    for (int y = 0; y<_numy; y++) {
      Cell newCell = new Cell(x, y);
      _cellArray[x][y] = newCell;
    }
  }
  
  for (int x = 0; x<_numx; x++) {
    for (int y = 0; y <_numy; y++) {
      int above = y-1;
      int below = y+1;
      int left  = x-1;
      int right = x+1;
      
      if (above < 0) { above = _numy-1; }
      if (below == _numy) { below = 0; }
      if (left < 0) { left = _numx-1; }
      if (right == _numx) {right = 0; }
      
      _cellArray[x][y].addNeighbour(_cellArray[left][above]);
      _cellArray[x][y].addNeighbour(_cellArray[left][y]);
      _cellArray[x][y].addNeighbour(_cellArray[left][below]);
      _cellArray[x][y].addNeighbour(_cellArray[x][above]);
      _cellArray[x][y].addNeighbour(_cellArray[x][below]);
      _cellArray[x][y].addNeighbour(_cellArray[right][above]);
      _cellArray[x][y].addNeighbour(_cellArray[right][y]);
      _cellArray[x][y].addNeighbour(_cellArray[right][below]);
    }
  }
}

void draw() {
  background(200);
  
  for (int x = 0; x<_numx; x++) {
    for (int y = 0; y<_numy; y++) {
      _cellArray[x][y].calcNextState();
    }
  }
  translate(_cellSize/2, _cellSize/2);
  
  for (int x = 0; x<_numx; x++) {
    for (int y = 0; y<_numy; y++) {
      _cellArray[x][y].drawMe();
    }
  }
}

void mousePressed() {
  restart();
}


//=======================object

class Cell {
  float x, y;
  float state;
  float nextState;
  float lastState = 0;
  Cell[] neighbours;
  
  Cell(float ex, float why) {
    x = ex * _cellSize;
    y = why * _cellSize;
    nextState = ((x/width) + (y/height)) * 14;
    state = nextState;
    neighbours = new Cell[0];
  }
    
  void addNeighbour(Cell cell) {
    neighbours = (Cell[])append(neighbours, cell);
  }
    
  void calcNextState() {
    float total = 0;
    for (int i = 0; i < neighbours.length; i++) {
        total += neighbours[i].state;
    }
    float average = int(total/8);
    if (average == 255) {
        nextState = 0;
    }
    else if ( average == 0) {
        nextState = 255;
    }
    else {
      nextState = state + average;
      if (lastState > 0     ) { nextState -= lastState; }
      if (nextState > 255   ) { nextState  = 255;       }
      else if (nextState < 0) { nextState  = 0;         }
    }
    lastState = state;
  }
    
  void drawMe() {
    state = nextState;
    stroke(0);
    fill(state);
    ellipse(x, y, _cellSize, _cellSize);
  }
}



