attribute vec4 position;
attribute vec4 color;
varying vec4 backgroundColor;
void main(){
    gl_Position = position;
    backgroundColor = color;
}
