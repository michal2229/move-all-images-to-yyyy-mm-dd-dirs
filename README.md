# move-all-images-to-yyyy-mm-dd-dirs

Bash script to move all images from **./** dir to directories named after date of picture take (**./yyyy-mm-dd/**).

I use it for organizing my huge photos collection.  

It could be modified to save pictures in **./cameramodel/yyyy-mm-dd/** directory, which is a good idea in my opinion, bud I have done that manually before writing this script. 
Changes should not be big - apart from getting desired camera model info into variable, one should also take note about mkdir, which should be enabled to make two levels of directiories at once (camera, and deeper -  date).

It uses **jhead** tool to extract EXIF data from image.