Simple Node/Express site that will show a different image a day. 

Very simple to use.

Run gulp too generate the JS/CSS files(You can do it manually if you don't want to use gulp)

A MongoDB is required for the Admin Login!(Look at config folder)

Too Set-up your admin login just go to /admin and type in whatever username/password you wan't and that will become your account.

The Admin Page image uploader works with drag and drop(anywhere on the page)

There are currently <b>4</b> controls
In the following order

Delete - Deletes the image from the upload list
Rotate Left - Rotates the image
Date Picker - Allows you to choice what day the image will be displayed
Rotate Right- Rotates the image


The image uploader supports any image format that your browser understands, but the output is always a JPEG

The output file resolution is always scaled down/up to a maximum 1000 width or height.(This will be improved on)

There is no current non drag-drop upload method, you can manually insert files into the /client/img/Images folder with a d-m-yyyy.jpg format
