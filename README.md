Code explanation

I have created a view controller and added collection view with custom flow layout.

Core Logic for scrolling:
When swiping left or right, finding out the cells that are present in current visible layout of collection view and scaling it around 25% with animation.

Extensions:
1. If want to add more images, simply add the image in assets and append image mane in images in ViewController class.
