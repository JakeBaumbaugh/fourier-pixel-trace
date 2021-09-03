let redcolor;
let prevX, prevY;
let indexPath;

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
}

function generatePath() {
    console.log("Generating path...");
    loadPixels();
    //Find first opaque pixel
    let ind1 = 0;
    while(pixels[4*ind1+3] == 0) {
        ind1++;
    }
    // Breadth-first search to populate the arrays
    let arr1 = [], arr2 = [];
    let queue1 = [ind1], queue2 = [ind1+1];
    let tempind;
    while(queue1.length > 0 || queue2.length > 0) {
        // Explore pixel on top of queue1
        tempind = queue1.pop();
        if(tempind && pixels[4*tempind+3]!=0 && !arr1.includes(tempind) && !arr2.includes(tempind)) {
            arr1.push(tempind);
            queue1.push(tempind-1);
            queue1.push(tempind-width);
            queue1.push(tempind+1);
            queue1.push(tempind+width);
        }
        // Explore pixel on top of queue2
        tempind = queue2.pop();
        if(tempind && pixels[4*tempind+3]!=0 && !arr1.includes(tempind) && !arr2.includes(tempind)) {
            arr2.push(tempind);
            queue2.push(tempind-width);
            queue2.push(tempind-1);
            queue2.push(tempind+1);
            queue2.push(tempind+width);
        }
    }
    indexPath = arr1.concat(arr2.reverse());
    console.log("Path generated.");
}

function colorPath() {
    console.log("Coloring path...");
    colorMode(HSB, 100);
    for(let i in indexPath) {
        let c = color(map(i, 0, indexPath.length, 0, 100), 100, 100);
        pixels[4*indexPath[i]] = red(c);
        pixels[4*indexPath[i]+1] = green(c);
        pixels[4*indexPath[i]+2] = blue(c);
    }
    colorMode(RGB, 255);
    updatePixels();
    console.log("Path colored.");
}