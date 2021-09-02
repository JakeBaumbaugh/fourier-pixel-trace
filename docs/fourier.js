let redcolor;
let prevX, prevY;

function setup() {
    redcolor = color(218, 82, 67);
    let canvas = createCanvas(720, 480);
    canvas.parent("program");
    frameRate(120);
    stroke(redcolor);
    strokeWeight(3);
}
  
function draw() {
}

function handleMouse(x, y) {
    x = floor(x);
    y = floor(y);
    line(x, y, prevX, prevY);
    prevX = x;
    prevY = y;
}

function mouseDragged() {
    handleMouse(mouseX, mouseY);
}

function mousePressed() {
    prevX = mouseX;
    prevY = mouseY;
    handleMouse(mouseX, mouseY);
}9